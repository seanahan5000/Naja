FIGHT_LOADER	=	$7800
EQUIP_FINDER	=	$9800

LINENUM			EQU	$00
LRFLAG			EQU	$04
SCRATCH			EQU	$06
PITCH			EQU	$0B
LENGTH			EQU	$0C
JUMPL			EQU	$0D
JUMPH			EQU	$0E
ALINE			EQU	$12
BLINE			EQU	$13
A_COUNT			EQU	$14
BEGLINE			EQU	$14
DATAPNT			EQU	$15
B_COUNT			EQU	$15
ENDLINE			EQU	$15
FLAG12			EQU	$20				;MOVE THESE LATER !!!
ELSLECT			EQU	$21				;MOVE THESE LATER !!!
PROGON			EQU	$4079
PICKON			EQU	$407A

north			=	%00000000
south			=	%01000000
west			=	%10000000
east			=	%11000000


PCHECK			LDA	#$01			;left/right
				BNE	PCOMMON			;Always
PCHECK2			LDA	#$02			;forward
				BNE	PCOMMON			;Always
PCHECK3			LDA	#$03
PCOMMON			STA	FLAG12			;through door/face change
				LDA	#$00
				STA	HALL_UPDATED

				LDY	FACE
				DEY
				TYA
				ASL
				TAY
				LDA	FACERS,Y
				STA	POINTL
				LDA	FACERS+1,Y
				STA	POINTH
				LDX	DIRECTN
				TXA
				AND	#$80
				STA	SCRATCH
				TXA
				ROR
				ROR
				ROR
				AND	#$40
				ORA	SCRATCH
				STA	SCRATCH

:LOOP1			LDY	#$00
				LDA	(POINTL),Y
				TAX
				AND	#$1F
				CMP	XPOS
				BCC	:SKIPA
				BNE	NO_SPECIAL
				INY
				LDA	(POINTL),Y
				CMP	YPOS
				BCC	:SKIPA
				BNE	NO_SPECIAL
				TXA
				AND	#$20
				BNE	FOUND_SPECIAL
				TXA
				AND	#$E0
				CMP	SCRATCH
				BEQ	FOUND_SPECIAL
:SKIPA			LDA	POINTL
				CLC
				ADC	#$03
				STA	POINTL
				BCC	:LOOP1
				INC	POINTH
				BNE	:LOOP1			;Always

FOUND_SPECIAL	LDX	FILE_VECTOR
				LDY	FILE_VECTOR+1
				JSR	SET_FILE_TABL
				LDY	#$02
				LDA	(POINTL),Y
				ASL
				TAY
				LDA	JUMPS,Y
				STA	JUMPL
				INY
				LDA	JUMPS,Y
				STA	JUMPH
				JMP	(JUMPL)

NO_SPECIAL		LDA	#$00
				STA	PICHERE
				LDA	ENCODDS
				CMP	#$EE
				BNE	:SKIPA
				LDA	#$5F			;TEMP***????
				STA	ENCODDS
:SKIPA

TAKE_ENERGY		LDA	#$00
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#dead
				BEQ	:SKIPA
				CMP	#broken
				BEQ	:SKIPA
				JSR	DRAINER_FRACT
				BPL	:SKIPA
				JSR	OUT_OF_ENERGY
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

TAKE_DAMAGE		LDA	#$00
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#inflictnums
				LDA	(CHARDL),Y
				BEQ	:SKIPD
				LDY	#inflictcount
				LDA	(CHARDL),Y
				SEC
				SBC	#$01
				STA	(CHARDL),Y
				BEQ	:SKIPE
				BCS	:SKIPB
:SKIPE			LDY	#inflictnums
				LDA	(CHARDL),Y
				SEC
				SBC	#$01
				STA	(CHARDL),Y
				LDY	#inflictdelay
				LDA	(CHARDL),Y
				DEY					;inflictcount
				STA	(CHARDL),Y
				LDY	#status
				LDA	(CHARDL),Y
				STA	:MOD1+1
				LDY	#inflictamount
				LDA	(CHARDL),Y
				TAX					;low
				LDY	#$00			;high
				SEC
				JSR	INFLICTER
				BCC	:SKIPA
:MOD1			LDA	#$FF			;Modified
				LDY	#status
				STA	(CHARDL),Y
				LDA	#$FF
				JMP	OC_COM1
:SKIPA			BVC	:SKIPC
				JSR	GONE_CRITICAL
:SKIPC			LDY	#inflictnums
				LDA	(CHARDL),Y
				BNE	:SKIPB
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				CMP	#healthy
				BEQ	:SKIPD
				LDX	#GREEN
				LDA	#$02
				JSR	OC_COM2
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%11000000
				STA	(CHARDL),Y
				JSR	CALC_STATS
				JMP	:SKIPD
:SKIPB			JSR	CONTAGIOUS
:SKIPD			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

FIND_ENCOUNTR
				BIT	$C061				;TEMP *** left-option/alt
				BMI	:FORCE_ENCOUNTER	;TEMP ***
				BIT	$C062				;TEMP *** right-option/alt
				BMI	:FORCE_EQUIPMENT	;TEMP ***

				JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$7F
				CMP	ENCODDS
				BCS FIND_ENCOUNTR
				CMP #$01
				BNE :FIND_EQUIPMNT

:FORCE_ENCOUNTER
				JSR	PICK_HALLTYPE
			do ORIGINAL
			else
				LDA	DISK_SIDE
				EOR	#%00000110
				STA	DISK_SIDE
			fin
				JSR	SET_FGHTFILES
				LDX	#fLoader1
				JSR	SLOADER_FILE
				JMP	FIGHT_LOADER

:FIND_EQUIPMNT
				JSR	RNDMIZE			;Can't find equipment if
				LDA RANDOM1 		;   the random number isn't right...
				AND	#$3F			;????????
				CMP	#$13			;temp?
				BNE NORMAL_MOVE

:FORCE_EQUIPMENT
				LDA	BUFFER+4		;   or they're facing a wall...
				CMP	#$FF
				BEQ	NORMAL_MOVE

				LDX	FLAG12			;   or if they just turned
				DEX					;   left, right or around...
				BEQ	NORMAL_MOVE

				JSR	RESET_CHRLIST	;   or if they have no room
				JSR	CSCAN_PUTABLE	;   for equipment.
				BCC	NORMAL_MOVE

				JSR	PICK_HALLTYPE
				JSR	SET_CAMPFILES
				LDX	#cFindment
				JSR	SLOAD_FILE
				JMP	EQUIP_FINDER

NORMAL_MOVE		LDA	HALL_UPDATED
				BEQ	:EXIT
				LDA	#$FF
:EXIT			RTS

CONTAGIOUS		LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				CMP	#illD
				BNE	:EXIT
				JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$1F
				BNE	:EXIT
				LDA	COUNT
				PHA
				LDY	#inflictdelay
				LDA	(CHARDL),Y
				STA	:MOD1+1
				INY					;inflictamount
				LDA	(CHARDL),Y
				STA	:MOD2+1
				JSR	RESET_CHLIST
				LDX	#<NOSTATS
				LDY	#>NOSTATS
				JSR	CSCAN_COMMON
				TAY
				BEQ	:SKIPA
				TXA
				JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				ORA	#illD
				STA	(CHARDL),Y
				LDY	#inflictcount
:MOD1			LDA	#$FF			;MOD
				STA	(CHARDL),Y
				INY					;inflictdelay
				STA	(CHARDL),Y
:MOD2			LDA	#$FF			;MOD
				INY					;inflictamount
				STA	(CHARDL),Y
				INY
				LDA	#illDlength		;number of inflictions of illD
				STA	(CHARDL),Y
				JSR	CALC_STATS
				LDA	#$03
				JSR	OC_COM1
:SKIPA			PLA
				STA	COUNT
:EXIT			RTS

NOSTATS			LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				RTS


DRAINER_FRACT	LDY	#powerconsumpt
				LDA	(CHARDL),Y
				STA	TEMP+1
				INY
				LDA	(CHARDL),Y
				STA	TEMP

				LDX	#3
				LDA	#$00
:LOOP1			ASL	TEMP
				ROL	TEMP+1
				ROL
				DEX
				BPL	:LOOP1
				PHA

				LDY	#powerfraction+1
				LDA	(CHARDL),Y
				SEC
				SED
				SBC	TEMP
				STA	(CHARDL),Y
				DEY
				LDA	(CHARDL),Y
				SBC	TEMP+1
				STA	(CHARDL),Y
				CLD

				PLA
				TAX
				BCS	:SKIPA
				INX
				CPX	#$0A
				BNE	:SKIPA
				LDX	#$10
:SKIPA			LDY	#0
				SEC
				JMP	DRAIN_DIRECT2

PICK_HALLTYPE	LDA	HALL_UPDATED
				BNE	:EXIT
				DEC	HALL_UPDATED
				LDA	FLAG12
				CMP	#$02
				BNE	:SKIPA
				JMP	SCANONE
:SKIPA			JSR	HGR
				JMP	NOSCAN
:EXIT			RTS

HALL_UPDATED	DB	$00


GONE_CRITICAL	LDA	#$00
				BEQ	OC_COM1			;Always

				ERR	*-$A24C
OUT_OF_ENERGY	LDA	#$01
OC_COM1			LDX	#RED
OC_COM2			STX	MESSAGE_COLOR
				TAX
				LDA	COUNT
				PHA
				TXA
				PHA
				LDX	#<MESSAGE_BOX
				LDY	#>MESSAGE_BOX
				JSR	INIT_BOX
				JSR	PICK_HALLTYPE
				LDA	#$40
				STA	PAGE
				JSR	CLEAR_OUTSIDE
				JSR	DRAW_BOX
				PLA
				BPL	:SKIPA
				PLA
				JMP	DYIN_VECTOR
:SKIPA			PHA
				LDX	#<CRITICAL_TEXT+3
				LDY	#>CRITICAL_TEXT+3
				JSR	FLUSH_NAME
				LDX	#9
:LOOP1			LDA	CRITICAL_TEXT+3,X
				STA	RUNDOWN_TEXT+3,X
				STA	CURED_TEXT+3,X
				STA	CONTAG_TEXT+3,X
				DEX
				BPL	:LOOP1
				PLA
				PHA
				TAY
				JSR	TEXTER
				PLA
				CMP	#$02
				BNE	:SKIPB
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				JSR	STATUSR2
				JSR	LINE2
				LDA	#$2D
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+1
				JSR	LINE2
:SKIPB			JSR	SWAP_BOX
				JSR	SPACE_KEY
				JSR	SWAP_BOX
				LDA	#$20
				STA	PAGE
				PLA
				STA	COUNT
				RTS

MESSAGE_BOX		DDB	53
				DB	34
				DDB	227
				DB	54
MESSAGE_COLOR	DB	RED
				DB	wspace


BLKLINE			DB	$00,$45,$65
				DB	$00,$D2,$65
				DB	$FF
EBOX			DB	$00,$4F,$41
				DB	$00,$4F,$89
				DB	$00,$C7,$89
				DB	$00,$D3,$65
				DB	$00,$C7,$41
				DB	$00,$C7,$89
				DB	$FE
				DB	$00,$C8,$89
				DB	$00,$C8,$41
				DB	$00,$50,$41
				DB	$00,$44,$65
				DB	$00,$50,$89
				DB	$00,$50,$41
				DB	$FF

BLKLIN2			DB	$00,$66,$74
				DB	$00,$AE,$74
				DB	$FF
EBOX2			DB	$00,$6D,$86
				DB	$00,$6D,$62
				DB	$00,$65,$74
				DB	$00,$6D,$86
				DB	$00,$A7,$86
				DB	$00,$AF,$74
				DB	$00,$A7,$62
				DB	$00,$A7,$86
				DB	$FE
				DB	$00,$6D,$62
				DB	$00,$A7,$62
				DB	$FF


CRITICAL_TEXT	PLOTAT	64;37;(XXXXXXXXXX_IS_IN_CRITICAL)
				PLOTAT	64;45;(CONDITION.)+

RUNDOWN_TEXT	PLOTAT	64;37;(XXXXXXXXXX_HAS_RUN_OUT_OF)
				PLOTAT	64;45;(ENERGY.)+

CURED_TEXT		PLOTAT	64;37;(XXXXXXXXXX_IS_NO_LONGER)
				PLOTAT	64;45;()+

CONTAG_TEXT		PLOTAT	64;37;(XXXXXXXXXX_IS_BEGINNING)
				PLOTAT	64;45;(TO_FEEL_ILL.)+

				DS	\,$EE

			do ORIGINAL
			else
				DO	SHELLNUM-1
				DO	SHELLNUM-3
				DEND
				ORG	$A400
				FIN
				FIN
			fin

ENCODDS			DB	$1F				;$EE LATER ;$01 FOR NO ENCOUNTERS

PICHERE			DB	$00

FACERS			DW	FACE1
				DW	FACE2
				DW	FACE3
				DW	FACE4
				DW	FACE5
				DW	FACE6
				DW	FACE7

				ERR	*-$A410
SHELL_INFO
			do	ORIGINAL

				DO	SHELLNUM-1
				ELSE
				DW	SHELL17
				DB	5
				DB	175				;5*(17*2+1)
				FIN

				DO	SHELLNUM-2
				ELSE
				DW	SHELL15
				DB	4
				DB	124				;4*(15*2+1)
				FIN

				DO	SHELLNUM-3
				ELSE
				DW	SHELL13
				DB	4
				DB	108				;4*(13*2+1)
				FIN

				DO	SHELLNUM-4
				ELSE
				DW	SHELL11
				DB	3
				DB	69				;3*(11*2+1)
				FIN

				DO	SHELLNUM-5
				ELSE
				DW	SHELL9
				DB	3
				DB	57				;3*(9*2+1)
				FIN

			else

				DO	SHELLNUM-1
				ELSE
				DW	SHELL15
				DB	4
				DB	124				;4*(15*2+1)
				FIN

				DO	SHELLNUM-2
				ELSE
				DW	SHELL13
				DB	4
				DB	108				;4*(13*2+1)
				FIN

				DO	SHELLNUM-3
				ELSE
				DW	SHELL11
				DB	3
				DB	69				;3*(11*2+1)
				FIN

				DO	SHELLNUM-4
				ELSE
				DW	SHELL9
				DB	3
				DB	57				;3*(9*2+1)
				FIN

			fin

TEXTER			TYA
				ASL
				TAY
				LDA	TEXTS,Y
				STA	POINTL	
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT

FILE_VECTOR		DW	FILE_TABLE

JUMPS
