*===============================
*
*===============================

CHR_IDENTIFY	JSR	FIND_SCANNER
				BCC	:EXIT			;Exit if ID Scanner not found
				JSR	ENERUSE
				CLC
				LDX	#<ENERGY_USAGE
				LDY	#>ENERGY_USAGE
				JSR	DRAINER_MAIN
				BCC	:EXIT			;Exit if not enough energy
				LDA	ENERGY_USAGE+2
				STA	ENERGY_L
				LDA	ENERGY_USAGE+1
				STA	ENERGY_H

				JSR	PICK_A_SQUARE
				LDX	COMPNTR
				LDA	COMMAND+1,X
				BMI	:SKIPA
				JSR	MON_INDEXER
:SKIPA			CLC
				LDA	MASTER_MGRID,Y
				BMI	SCAN_AREA		;Empty square
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
				BMI	:EXIT			;Already identified
				JSR	ID_ODDS
				STY	deIDODDS		;&&&
				JSR	FINAL_ODDS
				LDX	COMPNTR
				LDA	COMMAND+1,X
				BPL	SCAN_SQUARE
				BMI	SCAN_AREA		;Always
:EXIT			JMP	CCOM

SCAN_AREA		BCS	SCAN_SQUARE
				JSR	CLEAR_TLINE1
				LDY	#40				;S>40 CharsName.Scans.The
				JSR	SENTENCE_INC
				JSR	ATTAREM
				JSR	RETURN
				LDY	#41				;S>41 But.Fails.To.Identify.RET
				JSR	SENTENCE_PRET	;     Anything
				JMP	TAKDELCLRCCOM

SCAN_SQUARE		PHP
				JSR	CLEAR_TLINE1
				LDY	#42				;S>42 CharsName.Scans.The.MonsName
				JSR	SENTENCE_RET
				PLP
				BCS	:SKIPA
				LDY	#43				;S>43 But.Fails.To.Identify.It
				JSR	SENTENCE_PRET
				JMP	TAKDELCLRCCOM
:SKIPA			LDY	#44				;S>44 And.Identifies.It.As.Being.An
				JSR	SENTENCE
				LDY	#aName
				LDA	(ALIEN_PTR),Y
				CMP	#$26			;"
				BNE	:SKIPC
				INY
				LDA	(ALIEN_PTR),Y
:SKIPC			PHA
				TXA
				TAY
				DEY
				PLA
				JSR	VOWEL_CHECK
				JSR	RETURN
				LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
				ORA	#%10000000
				STA	(MONS_PTR),Y
				LDY	#xMonsName
				JSR	WORD1_PRDRET
				JSR	UPDATE_MNAMES
				JMP	TAKDELCLRCCOM


*-------------------------------
*
*-------------------------------

PICK_A_SQUARE	LDY	#24
				LDA	#$FF
:LOOP1			AND	MASTER_MGRID,Y
				DEY
				BPL	:LOOP1
				INY
				CMP	#$FF
				BEQ	:EXIT
:LOOP2			JSR	RNDMIZE
				AND	#%00011111
				CMP	#25
				BCS	:LOOP2
				TAY
				LDA	MASTER_MGRID,Y
				BMI	:LOOP2
				ASL
				BPL	:LOOP2
:EXIT			RTS


*===============================
*
*===============================

PRE_IDENTIFY	JSR	RESET_CHLIST	;Done at start of each round
				LDX	#<CCALL_CANID
				LDY	#>CCALL_CANID
				JSR	CSCAN_COMMON
				BCC	:EXIT
				TXA
				STA	CHAR_NUMBER
				JSR	POINTIT
				LDY	#0
				STY	SCOUNTR
:LOOP1			LDA	MASTER_MGRID,Y
				BMI	:SKIPA
				ASL
				BPL	:SKIPA
				LSR
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	ID_ODDS
				STY	deIDODDS		;&&&
				CPY	#$90
				BCC	:SKIPA
				LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
				BMI	:SKIPA
				ORA	#%10000000
				STA	(MONS_PTR),Y
				JSR	UPDATE_MNAMES
:SKIPA			INC	SCOUNTR
				LDY	SCOUNTR
				CPY	#25
				BNE	:LOOP1
:EXIT			RTS

CCALL_CANID		JSR	CAN_ID_SUB
				LDA	#0
				ROR
				EOR	#%10000000
				RTS

CAN_ID_SUB		LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#android*16
				BNE	:SKIPA
				LDY	#status
				LDA	(CHARDL),Y
				BMI	:SKIPA
				CMP	#dead
				BEQ	:SKIPA
*** CHECK FOR OTHER STATUSES LATER
				JSR	FIND_SCANNER
				BCS	:EXIT
:SKIPA			CLC
:EXIT			RTS


*----------------------------------------------
* On Exit:
*   Carry clear: Scanner NOT found
*     Carry set: Scanner WAS found
*             Y: Char data position of scanner
*----------------------------------------------

FIND_SCANNER	JSR	RESET_EQLIST
				LDX	#back6			;use ESCAN_HANDS when available
				LDA	#$FF
:LOOP1			STA	EQUIP_LIST,X
				DEX
				BPL	:LOOP1
				LDX	#<ECALL_IDSCAN
				LDY	#>ECALL_IDSCAN
				JMP	ESCAN_COMMON

ECALL_IDSCAN	LDA	(CHARDL),Y
				CMP	#$42			;scanners
				BNE	:EXIT
				INY
				LDA	(CHARDL),Y
*             CMP  #$00            ;I.D scanner
:EXIT			RTS


*-------------------------------------------------------------
* On Exit:
*         X,Y: ODDS final result
*   BASE+2,+1: ODDS final result
*
*  BASE = IQcurrent
*  SIZE = 0.80  [ Tiny   (0) ]
*       = 0.90  [ Small  (1) ]
*       = 1.00  [ Normal (2) ]
*       = 1.10  [ Big    (3) ]
*  DIST = 1.30 - ( DISTANCE / 10 )
*  TIME = 1.00 + ( 2 * ((ROUND + 1) MIN 5) / 10 )
*  ODDS = BASE * SIZE * DIST * TIME
*-------------------------------------------------------------

ID_ODDS			LDY	#intelligence	;Get BASE
				LDA	(CHARDL),Y
				STA	BASE+1
				LDA	#0
				STA	BASE+2

				JSR	GET_SIZE_2		;Get SIZE
				LDY	ID_SIZES,X
				LDA	ID_SIZES+1,X
				TAX
				JSR	FRST_MULTIPLY

				JSR	SHORTEST_DIST	;Calculate DIST
				STA	TEMP+1
				LDA	#0
				LDX	#4
:LOOP1			LSR	TEMP+1
				ROR
				DEX
				BNE	:LOOP1
				STA	TEMP
				SED
				LDA	#$30
				SEC
				SBC	TEMP
				TAX
				LDA	#$01
				SBC	TEMP+1
				TAY
				CLD
				JSR	MULTIPLY_BASE

				LDX	ROUND			;Calculate TIME
				INX
				CPX	#6
				BCC	:SKIPB
				LDX	#5
:SKIPB			TXA
				ASL
				ASL
				ASL
				ASL
				STA	TEMP
				SED
				CLC
				ADC	TEMP
				TAX
				CLD
				LDY	#$01
				BCC	:SKIPC
				INY
:SKIPC			JMP	LAST_MULTIPLY

ID_SIZES		HEX	0080			;tiny
				HEX	0090			;small
				HEX	0100			;normal
				HEX	0110			;big
