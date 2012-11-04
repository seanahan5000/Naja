*===============================
*
*===============================

DRAW_HAND		TAY
				LDA	#$15
				STA	XCOORD
				LDA	#$03
				STA	SHIFT
				LDA	HANDATA,Y
				PHA
				BIT	ROBDEN_FLAG
				BVC	NOUPDWN
				LSR
				LSR
				CLC
				ADC	#$20
				TAY
				JSR	YPUTTER
				JSR	TEXTER
NOUPDWN			PLA
				AND	#$03
				CLC
				ADC	#$22
				TAY
				JSR	YPUTTER
				JMP	TEXTER

HANDATA			DB	$00,$01,$04
				DB	$05,$02,$06

YPUTTER			LDA	YPNT
				STA	UPPER+2
				STA	LOWER+2
				STA	LEFT+2
				STA	RIGHT+2
				STA	LEFRIGH+2
				LDA	XCOORD
				STA	LEFT
				STA	RIGHT
				STA	LEFRIGH
				LDA	SHIFT
				STA	LEFT+1
				STA	RIGHT+1
				STA	LEFRIGH+1
				RTS


*===============================
*
*===============================

SELECT_HAND		STA	MANDNUM
				JSR	CLRBOXZ
				JSR	DOTIME
				JSR	CANCEL_IN
				LDA	MANDNUM
				BNE	:SKIPA
				LDY	#$03
				JSR	BOXSUB
:SKIPA			LDX	MANDNUM
				LDA	POSTEX1,X
				TAY
				JSR	TEXTER
				LDX	MANDNUM
				LDA	POSTEX2,X
				BMI	:SKIPB
				TAY
				JSR	TEXTER
:SKIPB			JSR	EQUIP_DRAW
				LDA	MANDNUM
NOADJBL			PHA
				JSR	EQUIP_TYPER
				PLA
				JSR	LEGAL_HANDS
SUBRETN			JSR	CONSELT	
				LDX	#<HAND_CDEF
				LDY	#>HAND_CDEF
				JSR	FULL_GETKEY
				BCS	NOTCANC
				LDA	MANDNUM
				BNE	STOREE
				LDY	#$03
				JSR	BOXSUB
STOREE			LDA	#$0A
				STA	CONOBJ+3
				PLA
				PLA
DIDCANC			JSR	CLRBOXZ
				JSR	CANCEL_OUT
DIDC2			JSR	DOTIME
				JSR	OPTIONS
				JMP	GETOP2
NOTCANC			JMP	CLRBOXZ

HAND_CDEF		DB	$05
				DB	$00
				DW	HAND_CURSOR

POSTEX1			DB	$0E,$1F,$33
				DB	$33

POSTEX2			DB	$FF,$FF,$35
				DB	$34


*===============================
*
*===============================

EQUIP_DRAW		LDY	#$38			;Robot hands text
				BIT	ROBDEN_FLAG
				BMI	:SKIPA
				LDY	#$0C			;Normal hands text
				BVC	:SKIPA
				INY					;Denebian hands text
:SKIPA			JSR	TEXTER

				LDX	#0
				STX	COUNT
:LOOP1			LDA	HAND_YPNTS,X
				STA	YPNT
				JSR	ONE_EQLINE
				LDA	TEXTBUF
				CMP	#$8D
				BEQ	:SKIPB
				LDA	#$96
				LDY	YPNT
				JSR	LINE
				JSR	PARSTAT
				LDA	#$24
				STA	XCOORD
				LDA	#$00
				STA	SHIFT
				JSR	LINE2
:SKIPB			INC	COUNT
				LDX	COUNT
				CPX	#2
				BCC	:LOOP1
				LDA	ROBDEN_FLAG
				BEQ	:EXIT
				CPX	#4
				BCC	:LOOP1
:EXIT			RTS


*-------------------------------
* Pass hand 0 to 3 in X register
*-------------------------------

ONE_EQLINE		LDY	CONVERT_TABLE,X
				BMI	:EXIT
				LDX	#0
:LOOP1			LDA	(CHARDL),Y
				STA	ETABLE,X
				INY
				INX
				CPX	#4
				BNE	:LOOP1
				LDA	ETABLE
				CMP	#$FF
				BEQ	:EXIT
				JMP	EQUIP1
:EXIT			LDA	#$8D
				STA	TEXTBUF
				RTS


*-------------------------------
* ROBDEN_FLAG:
*   AB000000
*     A = Robot if set
*     B = Denebian if set
*-------------------------------

SET_HANDFLAGS	LDA	#$00
				STA	ROBDEN_FLAG
				LDY	#profrace
				LDA	(CHARDL),Y
				PHP
				AND	#%00001111
				CMP	#deneb
				BEQ	:SKIPA
				CLC
:SKIPA			ROR	ROBDEN_FLAG
				PLP
				CMP	#robot
				ROR	ROBDEN_FLAG
				RTS

ROBDEN_FLAG		DB	0


*-------------------------------
* Make table to convert between
*   the way the character's
*   equipment is now and how it
*   will be in battle.
*-------------------------------

MAKE_CONVERT	LDX	#3
:LOOP1			TXA
				ASL
				ASL
				ADC	#e3_UPLFT		;Carry assumed clear
				STA	CONVERT_TABLE,X
				DEX
				BPL	:LOOP1

				LDA	COMCNT
				BNE	NOTFIRST
				RTS
NOTFIRST		LDA	PLANNER
				ASL
				ASL
				ASL
				ASL
				ASL
				TAX
:LOOP2			LDA	COMMAND,X
				STA	TEMP
				INX
				INX
				STX	TEMP+1
				ROL
				ROL
				ROL
				AND	#%00000011
				TAY
				LDA	TEMP
				AND	#%00001111
				CMP	#cmdUSE
				BEQ	:SKIPC
				CMP	#cmdTHROW
				BEQ	:SKIPA
				CMP	#cmdEXCHANGE
				BNE	:SKIPB
				LDA	TEMP
				LSR
				LSR
				LSR
				LSR
				AND	#%00000011
				TAX
				LDA	CONVERT_TABLE,Y
				PHA
				LDA	CONVERT_TABLE,X
				STA	CONVERT_TABLE,Y
				PLA
				STA	CONVERT_TABLE,X
				JMP	:SKIPB

:SKIPC			STY	TEMP
				LDA	CONVERT_TABLE,Y
				TAY
				LDA	(CHARDL),Y
				CMP	#$63
				BNE	:SKIPB
				INY
				LDA	(CHARDL),Y
				LDY	TEMP
				CMP	#$01
				BEQ	:SKIPD
				CMP	#$09
				BEQ	:SKIPD
				BNE	:SKIPB			;Always

:SKIPA			LDA	TEMP
				AND	#%00010000
				BNE	:SKIPB			;Boomerang can be re-thrown
:SKIPD			LDA	CONVERT_TABLE,Y
				ORA	#$80
				STA	CONVERT_TABLE,Y
:SKIPB			LDX	TEMP+1
				CPX	COMPNTR
				BNE	:LOOP2
				RTS

CONVERT_TABLE	DB	0,0,0,0


*-------------------------------
*
*-------------------------------

EQUIP_TYPER		ASL
				TAY
				LDA	TYPES_TABLE,Y
				STA	:MOD1+1
				LDA	TYPES_TABLE+1,Y
				STA	:MOD1+2
				LDX	#0
				STX	COUNT
:LOOP1			LDY	CONVERT_TABLE,X
				STY	COUNTER
				LDX	#0
				TYA
				BMI	:SKIPA
				LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:SKIPA
				LDX	#7				;unusable
:MOD1			JSR	$FFFF			;Modified
				CPX	#7				;unusable
				BEQ	:SKIPA
				LDY	COUNTER
				INY
				INY
				INY
				LDA	(CHARDL),Y
				PHA
				LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				TAY
				PLA
				AND	PROUSAB,Y
				BNE	:SKIPA
				LDX	#7				;unusable
:SKIPA			TXA
				LDX	COUNT
				STA	HANDTAB,X
:SKIPB			INC	COUNT
				LDX	COUNT
				CPX	#4
				BNE	:LOOP1
				RTS

TYPES_TABLE		DW	SWING_TYPES
				DW	SHOOT_TYPES
				DW	THROW_TYPES
				DW	USE_TYPES

*-------------------------------
* 0 - empty
* 1 - dagger
* 2 - sword
* 3 - whip
* 4 - rifle
* 5 - robo-dagger/sword
* 6 - hand attachment
* 7 - unusable

SWING_TYPES		AND	#$1F
				LDX	#4				;rifle
				CMP	#$0D
				BEQ	:EXIT
				INX					;5 - robo-dagger/sword
				CMP	#$18
				BEQ	:EXIT
				INX					;6 - hand attachment
				CMP	#$19
				BEQ	:EXIT
				INX					;7 - unusable
				CMP	#$08
				BNE	:EXIT
				INY
				LDA	(CHARDL),Y
				LSR
				LSR
				AND	#%00000011
				TAX
				INX
:EXIT			RTS


*-------------------------------
* 0 - empty
* 1 - pistol/rifle (one hand)
* 2 - daser/memory eraser (one hand)
* 3 - disintegrator (two hands)
* 4 - rifle/cannon (two hands)
* 5 - robo-blaster
* 6 - hand attachment
* 7 - unusable

SHOOT_TYPES		LDX	#1				;pistol/rifle (one hand)
				AND	#%00011111
				CMP	#$0C
				BEQ	:EXIT
				LDX	#4				;rifle/cannon (two hand)
				CMP	#$0E
				BEQ	:EXIT
				CMP	#$0D
				BNE	:SKIPA
				INY
				INY
				LDA	(CHARDL),Y
				AND	#eq_hands12
				BNE	:EXIT
				LDX	#1
				BNE	:EXIT			;Always
:SKIPA			INX					;robo-blaster
				CMP	#$1C
				BEQ	:EXIT
				INX					;hand attachment
				CMP	#$19
				BEQ	:EXIT
				CMP	#$0F
				BNE	:SKIPC
				INY
				LDA	(CHARDL),Y
				LDX	#2				;daser/memory eraser (one hand)
				CMP	#$05			;daser
				BEQ	:EXIT
				CMP	#$08			;memory eraser
				BEQ	:EXIT
				INX					;disintegrator
				CMP	#$04
				BEQ	:EXIT
:SKIPC			LDX	#7				;unusable
:EXIT			RTS


*-------------------------------
* 0 - empty
* 1 - throwable
* 7 - unusable

THROW_TYPES		AND	#$5F
				CMP	#$4F
				BNE	:EXIT
				LDX	#1				;throwable
				INY
				LDA	(CHARDL),Y
				AND	#%00001110
				BEQ	:EXIT			;gyro boomerang
				CMP	#$06			;immobilizer, sonic grenade
				BEQ	:EXIT
				LDX	#7				;unusable
:EXIT			RTS

*-------------------------------
* 0 - empty
* 1 - usable
* 7 - unusable

USE_TYPES		AND	#eq_usable
				BEQ	:EXIT
				LDX	#1				;usable
:EXIT			RTS


*===============================
*
*===============================

LEGAL_HANDS		PHA
				JSR	SET_LEGALS
				LDA	HANDTAB
				STA	AREA1
				LDA	HANDTAB+1
				STA	AREA2
				PLA
				PHA
				TAY
				JSR	HAND_CHECK
				LDA	AREAX
				STA	LEGALS
				LDA	AREAY
				STA	LEGALS+1
				LDA	AREAZ
				STA	LEGALS+4
				BIT	ROBDEN_FLAG
				BMI	:SKIPA
				BVC	:EXIT
:SKIPA			LDA	HANDTAB+2
				STA	AREA1
				LDA	HANDTAB+3
				STA	AREA2
				PLA
				PHA
				TAY
				JSR	HAND_CHECK
				LDA	AREAX
				STA	LEGALS+2
				LDA	AREAY
				STA	LEGALS+3
				LDA	AREAZ
				STA	LEGALS+5
:EXIT			PLA
				RTS


*-------------------------------
*
*-------------------------------

HAND_CHECK		LDA	#0
				STA	AREAX
				STA	AREAY
				STA	AREAZ
				LDX	#$FF
				TYA
				BNE	SHOOT_CHECK

*-------------------------------

SWING_CHECK		BIT	ROBDEN_FLAG
				BMI	ROBOT_SWING

CHAR_SWING		LDY	#1
:LOOP1			LDA	AREA1,Y
				CMP	#5				;rifle+1
				BCC	:SKIPA
				TXA
				STA	AREAX,Y
				STX	AREAZ
:SKIPA			DEY
				BPL	:LOOP1
				LDA	AREAZ
				BNE	:EXIT
				LDA	AREA1
				ORA	AREA2
				BEQ	:SKIPB
				LDA	AREA1
				BNE	:EXIT
				LDA	AREA2
				BNE	:EXIT
:SKIPB			STX	AREAZ
:EXIT			RTS

ROBOT_SWING		STX	AREAZ
				LDA	AREA1
				CMP	#5				;robo-dagger
				BEQ	:SKIPA
				STX	AREAX
				CMP	#6				;hand attachment
				BNE	:SKIPA
				LDA	AREA2
				CMP	#5				;rifle+1
				BCS	:SKIPA
				CMP	#3				;whip
				BNE	:EXIT
:SKIPA			STX	AREAY
:EXIT			RTS

*-------------------------------

SHOOT_CHECK		DEY
				BNE	THROW_CHECK
				BIT	ROBDEN_FLAG
				BMI	ROBOT_SHOOT

CHAR_SHOOT		LDY	#0
				LDA	AREA1
				BNE	:SKIPA
				LDA	AREA2
				BNE	:SKIPC
				STX	AREAX
				STX	AREAY
				STX	AREAZ
				RTS

:SKIPA			INY
				LDA	AREA2
				BEQ	:SKIPC
				STX	AREAZ
:LOOP1			LDA	AREA1,Y
				CMP	#3				;disintegrator
				BCC	:SKIPB
				TXA
				STA	AREAX,Y
:SKIPB			DEY
				BPL	:LOOP1
				RTS

:SKIPC			TXA
				STA	AREAX,Y
				TYA
				EOR	#1
				TAY
				LDA	AREA1,Y
				CMP	#3				;disintegrator
				BCC	:EXIT
				PHA
				TXA
				STA	AREAX,Y
				PLA
				CMP	#5				;robo-blaster
				BCC	:EXIT
				STX	AREAZ
:EXIT			RTS


ROBOT_SHOOT		STX	AREAZ
				LDA	AREA1
				CMP	#6				;hand attachment
				BNE	:SKIPA
				LDY	AREA2
				CPY	#1				;pistol/rifle (one hand)
				BEQ	:SKIPB
:SKIPA			STX	AREAY
				CMP	#5				;robo-blaster
				BEQ	:EXIT
:SKIPB			STX	AREAX
:EXIT			RTS

*-------------------------------

THROW_CHECK
USE_CHECK		STX	AREAZ
				LDY	#1
:LOOP1			LDA	AREA1,Y
				CMP	#1				;throwable/usable object
				BEQ	:SKIPA
				TXA
				STA	AREAX,Y
:SKIPA			DEY
				BPL	:LOOP1
				RTS

*-------------------------------

HANDTAB			DB	0,0,0,0

AREA1			DB	0
AREA2			DB	0
AREAX			DB	0
AREAY			DB	0
AREAZ			DB	0

*-------------------------------
