*-------------------------------
*
*-------------------------------

CREATE_ROBOT	LDA	ASSIGN2
				JSR	POINTIT

				LDY	#0
:LOOP1			LDA	OPENBUF,Y
				CMP	#$FF
				BNE	:SKIPA
				INY
				BNE	:LOOP1			;Always
:SKIPA			AND	#$80
				STA	HALF
				STY	SECTOR
				TYA
				ORA	HALF
				LDY	#robotcyblink
				STA	(CHARDL),Y
				TAX
				DEY					;disklocation
				LDA	(CHARDL),Y

*-------------------------------

CREATE_PART		PHA
				TXA
				PHA
				LDA	#<ROBOTBUF
				STA	CHARDL
				LDA	#>ROBOTBUF
				STA	CHARDH

				LDA	#0
				LDY	#$7F
:LOOP1			STA	(CHARDL),Y
				DEY
				BPL	:LOOP1

				LDA	#$FF
				LDY	#e1_HEAD
:LOOP2			STA	(CHARDL),Y
				INY
				CPY	#e16_UNUSED+4
				BNE	:LOOP2

				LDX	#0
:LOOP3			LDY	ROBOT_DATA,X
				INX
				LDA	ROBOT_DATA,X
				STA	(CHARDL),Y
				INX
				CPX	#DATA_END-ROBOT_DATA
				BNE	:LOOP3

				LDY	SEHEAD
				LDX	HEDAMH,Y
				LDA	HEDAML,Y
				JSR	ADD_DAMAGE
				LDY	SPHEAD
				LDX	HPDAMH,Y
				LDA	HPDAML,Y
				JSR	ADD_DAMAGE
				LDY	SEBODY
				LDX	BEDAMH,Y
				LDA	BEDAML,Y
				JSR	ADD_DAMAGE
				LDY	SPBODY
				LDX	BPDAMH,Y
				LDA	BPDAML,Y
				JSR	ADD_DAMAGE

				LDY	#e1_HEAD
				LDA	LOWREF
				ASL
				AND	#%00011000
				STA	(CHARDL),Y
				INY
				LDA	SEHEAD
				ASL
				ASL
				ASL
				ASL
				ORA	SPHEAD
				STA	(CHARDL),Y
				INY
				LDA	SEBODY
				ASL
				ASL
				ASL
				ASL
				ORA	SPBODY
				STA	(CHARDL),Y
				INY
				LDA	ECAPAC
				STA	(CHARDL),Y

				LDA	#0
				STA	COUNT
:LOOP4			JSR	POINTAT
				LDX	COUNT
				CPX	#7
				BEQ	:SKIPA
				CPX	#8
				BEQ	:SKIPA
				LDA	SLOT,X
				TAY
				LDA	(VALUEL),Y
				STA	SLOT,X
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	#$0D
				BNE	:LOOP4

				LDY	#level+1
				LDA	PLEVEL
				STA	(CHARDL),Y

				LDY	#energymax+1
				LDA	ECAPAC
				BPL	HIEN2
				AND	#$7F
				PHA
				ASL
				ASL
				ASL
				ASL
				STA	(CHARDL),Y
				DEY
				PLA
				LSR
				LSR
				LSR
				LSR
				STA	(CHARDL),Y
				BPL	NOOR5			;Always

HIEN2			DEY
				STA	(CHARDL),Y
				AND	#$0F
				CMP	#$02
				BEQ	OR5
				CMP	#$07
				BNE	NOOR5
OR5				LDA	#$05	
				INY
				STA	(CHARDL),Y
NOOR5

				LDY	#disklocation
				PLA					;disk location
				STA	(CHARDL),Y
				INY					;robotcyblink
				PLA					;cybernate's disk location
				STA	(CHARDL),Y

				SED
				LDY	#baseshielding
				LDA	SEHEAD
				CLC
				ADC	SEBODY
				STA	(CHARDL),Y
				INY
				LDA	SPHEAD
				CLC
				ADC	SPBODY
				STA	(CHARDL),Y
				CLD

				LDY	#e1_HEAD
				LDA	SLOT
				ASL
				AND	#%10000000
				EOR	#%10000000
				ORA	RANGE
				ORA	(CHARDL),Y
				STA	(CHARDL),Y

				LDY	#e3_ROBLFT
				LDA	LWEAPON	
				JSR	LRSUB
				LDY	#e5_ROBRGT
				LDA	RWEAPON
				JSR	LRSUB

				LDY	#e15_PROGRAM+1
				LDA	AUTO
				ASL
				AND	#%10000000
				EOR	#%10000000
				ORA	PLEVEL
				STA	(CHARDL),Y

				LDY	#basestrength
				LDA	UPREF
				STA	(CHARDL),Y
				INY					;baseupreflex
				STA	(CHARDL),Y
				INY					;baselwreflex
				LDA	LOWREF
				STA	(CHARDL),Y
				RTS

ROBOT_DATA		DB	status,healthy
				DB	profrace,robot*16+none
				DB	back,1
				DB	organic,1
				DB	energylev+1,$10
				DB	flaglimbo,inlimbo
				DB	miscflags,%00100000						;w/o implant, genderless
				DB	basepowercons,$42
				DB	e15_PROGRAM+0,$5A
				DB	e15_PROGRAM+2,$20
				DB	e15_PROGRAM+3,$20
DATA_END

ADD_DAMAGE		LDY	#damagemax+1
				CLC
				SED
				ADC	(CHARDL),Y
				STA	(CHARDL),Y
				DEY
				TXA
				ADC	(CHARDL),Y
				STA	(CHARDL),Y
				CLD
				RTS

LRSUB			ASL
				TAX
				LDA	ROBWEPS,X
				STA	(CHARDL),Y
				INY
				LDA	ROBWEPS+1,X
				STA	(CHARDL),Y
				BMI	:EXIT
				INY
				LDA	#$00
				STA	(CHARDL),Y
				INY
				LDA	#$20
				STA	(CHARDL),Y
:EXIT			RTS

ROBWEPS			DB	$58,$00
				DB	$58,$04
				DB	$5C,$00
				DB	$5C,$01
				DB	$5C,$02
				DB	$FF,$FF
				DB	$59,$00

HEDAMH			DB	$00,$00,$00,$01
HEDAML			DB	$05,$30,$80,$50

HPDAMH			DB	$00,$00,$01
HPDAML			DB	$10,$75,$50

BEDAMH			DB	$00,$00,$01
				DB	$03,$04,$06
				DB	$08,$10
BEDAML			DB	$30,$80,$80
				DB	$25,$75,$25
				DB	$00,$00

BPDAMH			DB	$00,$00,$01
				DB	$02,$03,$04
				DB	$05,$07,$08
				DB	$10
BPDAML			DB	$30,$70,$20
				DB	$00,$00,$25
				DB	$50,$00,$50
				DB	$00

*-------------------------------
*
*-------------------------------

SAVE_ROBOT		JSR	PACSUB
				LDA	#BLUE
				STA	COLOR
				LDY	#$06
				JSR	LINER

				LDA	ASSIGN2
				JSR	POINTIT
				LDY	#2
:LOOP1			LDA	(CHARDL),Y
				STA	ROBOT_NAME+6,Y
				DEY
				BPL	:LOOP1
				LDA	#1
				STA	ROBOT_NAME+9
				LDY	#$1E
				JSR	TEXTER

				LDX	PICK
				LDA	#$1F
				STA	ON1,X
				JSR	VIEWER
				LDA	PICK
				BEQ	NOVIEW2
				JSR	MOVETO1
				STA	PRIMARY
NOVIEW2			LDA	#$20
				STA	PAGE
				LDX	#0
				STX	PICK
				DEX
				STX	ON2

				JSR	CREATE_ROBOT
				LDA	#>LOADBUF
				STA	SSTOREH
				JSR	DRIVE_ON
COMPA			LDA	#$00
				STA	COUNTER
CMPLOOP			LDY	COUNTER
				LDA	OPENBUF,Y
				BEQ	TWOBAD
				PHA
				TYA
				ORA	#<charTrack
				TAX
				LDY	#>charTrack
				LDA	#1
				JSR	FLOADER
				PLA
				PHA
				LDY	#$09
				AND	#$F0
				BEQ	NOFIRST
				JSR	COMPARE
				CPX	#$FF
				BEQ	FAILER
NOFIRST			PLA
				PHA
				AND	#$0F
				BEQ	NOSEC
				LDY	#$89
				JSR	COMPARE
				CPX	#$FF
				BEQ	FAILER
NOSEC			PLA
TWOBAD			LDA	COUNTER
				INC	COUNTER
				CMP	#$0A
				BNE	CMPLOOP
				BEQ	UNIQUE_NAME		;Always
FAILER			PLA
				JSR	NUMBSUB
				INC	ROBOT_NAME+9
				JSR	NUMBSUB
				JMP	COMPA

UNIQUE_NAME		JSR	DRIVE_OFF
				LDY	#9
:LOOP1			LDA	ROBOT_NAME,Y
				STA	(CHARDL),Y
				DEY
				BPL	:LOOP1

				LDX	#wNewChar
				JSR	CALL_WRITERS

				LDA	#$0F
				LDX	HALF
				BMI	:SKIPA
				LDA	#$F0
:SKIPA			LDY	SECTOR
				ORA	OPENBUF,Y
				STA	OPENBUF,Y
				LDX	#wOpen
				JSR	CALL_WRITERS

				LDX	#wGroup
				JSR	CALL_WRITERS

				LDX	PICK
				LDA	#$0F
				ORA	ON1,X
				STA	ON1,X
				LDA	#$60
				STA	STOPPER
				JSR	OPTIONS
				LDA	#$EA
				STA	STOPPER
				JSR	PPEOR
				LDY	#$1F
				JSR	TEXTER
				JSR	PPEOR
				BIT	UNSTROB
WAITER			LDA	KEYBRD
				BPL	WAITER
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	WAITER
				JMP	STOPPER

*-------------------------------

COMPARE			LDX	#9
:LOOP1			LDA	LOADBUF,Y
				CMP	ROBOT_NAME,X
				BNE	:EXIT
				DEY
				DEX
				BPL	:LOOP1
:EXIT			RTS

*-------------------------------

NUMBSUB			LDA	ROBOT_NAME+9
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+1
				LDA	#$C2
				LDY	#$87
				JMP	LINE

*-------------------------------

SECTOR			DB	0
HALF			DB	0
