*-------------------------------
*
*-------------------------------

WHIZ_SUB		TXA
				PHA
:LOOP1			JSR	RNDMIZE
				AND	#$03
				LDX	ATALLY
				BNE	:SKIPA
				CMP	#$01
				BCC	:LOOP1
:SKIPA			CLC
				ADC	#xMisses
				TAY
				PLA
				TAX
				JSR	WORD1_INC
				LDA	RANDOM1
				AND	#$03
				BEQ	:EXIT
				LDY	#xPast
				JSR	WORD1_INC
:EXIT			RTS


*-------------------------------
*
*-------------------------------

ATTAREM			LDY	#xRemains
				LDA	ATALLY
				BEQ	REMAIN
				LDY	#xAttacker
REMAIN			JSR	WORD1
				LDA	ATALLY
				CMP	#$02
				BCC	:EXIT
				LDA	#$1D
				STA	TEXTBUF,X
				INX
:EXIT			RTS


*-------------------------------
*
*-------------------------------

FIND_CHAR		LDA	SQUARE_HIT
				AND	#$0F
				STA	TEMP
				LDA	#$05
				SEC
				SBC	TEMP
				TAY
				LDA	TIMES5,Y
				STA	TEMP
				LDA	SQUARE_HIT
				LSR
				LSR
				LSR
				LSR
				CLC
				ADC	TEMP
				TAY
				DEY
				LDA	MASTER_CGRID,Y
				RTS


*--------------------------------------------
* On Exit:
*     Carry Set: Monster in that square
*   Carry clear: Monster NOT in that square
*             A: Monster number if one there
*--------------------------------------------

FIND_MONS		LDA	SQUARE_HIT
				JSR	MON_INDEXER
				LDA	MASTER_MGRID,Y
				CMP	#$FF
				CLC
				BEQ	:EXIT
				AND	#%00111111
				SEC
:EXIT			RTS


*-------------------------------
*
*-------------------------------

KILL_DESTROY	STX	TEMP
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				LDY	#xDestroyed
				LDA	ALTYPE1,X
				BMI	:SKIPA
				JSR	RNDMIZE
				AND	#$01
				CLC
				ADC	#xKilled
				TAY
:SKIPA			LDX	TEMP
				JMP	WORD1

*-------------------------------
* FIRES A BLAST
* FIRES A SHOT
* BLASTS A SHOT
*-------------------------------

BLAST_A_SHOT	PHA
				JSR	RNDMIZE
				JSR	CLEAR_TLINE1
				PLA
				TAY
				LDA	RANDOM1
				AND	#$02
				CLC
				ADC	#xFire
				JSR	WORD2
				LDA	#$1D
				STA	TEXTBUF,X
				INX
				INX
				LDY	#xShot
				LDA	RANDOM1
				LSR
				BCS	:SKIPA
				LSR
				BCS	:SKIPA
				DEY
:SKIPA			TYA
				LDY	#xA
				JMP	WORD2

*-------------------------------
