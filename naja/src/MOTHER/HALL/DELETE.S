DELETE								;LDA PICHERE
									;CMP #2
									;BEQ :SKIPA
				JSR	TO_PRIMARY
				LDA	#$40
				STA	PAGE
				JSR	CLEAR2	
				JSR	NOSCAN
				LDY	#$02
				JSR	PICKER
				LDY	#$0C			;"Shuttle now loading"
				JSR	TEXTER
:SKIPA			STA	SCNDARY
				JSR	MOVE_NOISE
				LDX	#6
				LDA	#0
:LOOP1			STA	CNTABLE,X
				DEX
				BPL	:LOOP1
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1	
				LDA	GRPNUMB
				BNE	NOT1
				LDA	#$20
				STA	PAGE
				LDA	#VIOLET
				STA	COLOR
				LDY	#$12
				JSR	LINER
				LDY	#$0D			;Directions to group assembly
				JSR	TEXTER
				LDA	#$8D
				STA	GOLOOPA+1
				JSR	GOSLIDE
				BIT	UNSTROB
KEYIN2			LDA	KEYBRD
				BPL	KEYIN2
				BIT	UNSTROB
				JSR	CPARER2
				BNE	KEYIN2
				PHA
				LDA	#$01
				STA	VARY+1
				JSR	GOSLIDE
				LDA	#$72
				STA	GOLOOPA+1
				LDA	#$30
				STA	VARY+1
*JSR CLEAR1
				PLA
				JMP	GOTDIRECTN

NOT1			LDA	#$20
				STA	PAGE
				JSR	GROUP_DO
				LDY	#$06			;"Leave"
				JSR	TEXTER
				JSR	GOSLIDE
				JSR	ASK_IN
				LDA	#$40
				STA	PAGE
RESTART			LDA	#$FF
				STA	DEL_CDEF+1
REPEAT			JSR	RESET_CHLIST
				LDX	#<NOT_IN_LIMBO
				LDY	#>NOT_IN_LIMBO
				JSR	CSCAN_COMMON
				LDA	#0
				STA	LEGALS+7
				INC	DEL_CDEF+1
				LDX	#<DEL_CDEF
				LDY	#>DEL_CDEF
				JSR	INIT_CURSOR
				JSR	GETKEY
				LDA	CURSOR
				STA	DEL_CDEF+1
				CMP	#$07
				BEQ	DELETE_OUT

TEST1			JSR	POINTIT
				JSR	VITAL_TEST
				BCS	REPEAT
				LDA	ROBOT_FLAG
				BMI	TEST2
				JSR	POINTIT
				JSR	VITAL_TEST
				BCS	REPEAT
				LDA	CURSOR
				JSR	POINTIT

TEST2			LDA	ROBOT_FLAG
				ASL
				BPL	TEST3
				LSR
				AND	#%00111111
				JSR	POINTIT
				LDX	#<ROBNAME13
				LDY	#>ROBNAME13
				JSR	FLUSH_NAME
				LDA	#$13			;Robot must be with you
				JSR	WARNING
				JMP	REPEAT

TEST3			LDY	CURSOR
				LDA	CNTABLE,Y
				BNE	PASSES
				JSR	HAS_EQUIPMENT
				BCS	PASSES
				LDA	ROBOT_FLAG
				BMI	PASSES
				JSR	POINTIT
				JSR	HAS_EQUIPMENT

PASSES			LDY	CURSOR
				JSR	SMARKIT
				LDY	ROBOT_FLAG
				BMI	REPEAT
				JSR	SMARKIT
				JMP	REPEAT

DELETE_OUT		LDX	#$06
:LOOP1			LDA	CNTABLE,X
				BNE	:SKIPA
				DEX
				BPL	:LOOP1
				BMI	NOTAONE			;Always
:SKIPA			LDY	#$0E			;"Who is returning..."
				JSR	TEXTER
				LDY	#$14			;"Are you sure?..."
				JSR	TEXTER
:LOOP2			LDA	KEYBRD
				BPL	:LOOP2
				BIT	UNSTROB
				CMP	#"A"			;A>CCEPT
				BEQ	WILLACC
				CMP	#"R"			;R>EDO
				BNE	:LOOP2
				LDY	#$14			;"Are you sure?..."
				JSR	TEXTER
				LDY	#$0E			;"Who is returning..."
				JSR	TEXTER
				JMP	RESTART

WILLACC			LDA	GRPNUMB
				STA	YCOUNT
				DEC	YCOUNT
ERALOOP			LDY	YCOUNT
				LDA	CNTABLE,Y
				BEQ	NOERAS
				INC	YCOUNT
				JSR	ERASER
				DEC	YCOUNT
NOERAS			DEC	YCOUNT
				BPL	ERALOOP
				JSR	ASK_OUT
				JSR	WRITE_OPEN
				JMP	DELCOM
NOTAONE			JSR	ASK_OUT
DELCOM			JSR	GOSLIDE
KEYLOOP			LDA	KEYBRD
				BPL	KEYLOOP
				JSR	CPARER2
				BEQ	GOBACK3
				BIT	UNSTROB
				JMP	KEYLOOP
GOBACK3								;LDA #$20
									;STA PAGE
									;JSR CLEAR1
				LDA	#$FF
				RTS	

*-------------------------------

VITAL_TEST		JSR	RESET_EQLIST
				JSR	ESCAN_FULSLOT
				LDX	#<ECALL_NODROP
				LDY	#>ECALL_NODROP
				JSR	ESCAN_COMMON
				BCC	:EXIT
* Carry assumed set
				LDA	#$11			;vital equipment
				JSR	WARNING2
				SEC
:EXIT			RTS

ECALL_NODROP	INY
				INY
				LDA	(CHARDL),Y
				AND	#eq_vital
				EOR	#eq_vital
				RTS

*-------------------------------

HAS_EQUIPMENT	LDY	#status
				LDA	(CHARDL),Y
				CLC
				EOR	#intracc
				BEQ	:EXIT
				EOR	#lost!intracc	;! means EOR
				BEQ	:EXIT
				JSR	RESET_EQLIST
				LDY	#profrace
				LDA	(CHARDL),Y
				BPL	:SKIPA
				LDA	#$FF
				STA	EQUIP_LIST+program
:SKIPA			JSR	ESCAN_FULSLOT
				BCC	:EXIT
* Carry assumed set
				LDA	#$10			;equipment more useful to others
				JSR	WARNING2
				SEC
:EXIT			RTS

*-------------------------------

NOT_IN_LIMBO	LDX	#0
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#inlimbo
				BNE	:SKIPA
				DEX
:SKIPA			TXA
				RTS

*-------------------------------------------------
* It can be assumed that any undropable equipment
*   has removed from the character by now.
*-------------------------------------------------

ERASER			LDA	YCOUNT
				SEC
				SBC	#$01
				JSR	POINTIT
				LDY	#status			;Update LOST_CHAR count
				LDA	(CHARDL),Y
				AND	#%00111111
				CMP	#intracc
				BNE	:SKIPC
				DEC	LOST_CHARS
:SKIPC			LDY	#disklocation
				LDA	(CHARDL),Y
				PHA
				AND	#$7F
				TAX
				PLA
				AND	#$80
				BNE	:SKIPA
				LDA	#$0F
				BNE	:SKIPB
:SKIPA			LDA	#$F0
:SKIPB			AND	OPENBUF,X
				STA	OPENBUF,X

				LDA	GRPNUMB
				DEC	GRPNUMB
				CMP	YCOUNT
				BEQ	:EXIT
				LDA	YCOUNT	
				STA	COUNT
:LOOP1			LDX	COUNT
				DEX
				TXA
				JSR	POINTIT
				LDA	CHARDL
				STA	TEMP
				LDA	CHARDH
				STA	TEMP+1
				LDA	COUNT
				JSR	POINTIT
				LDY	#$7F
:LOOP2			LDA	(CHARDL),Y
				STA	(TEMP),Y
				DEY
				BPL	:LOOP2
				LDA	COUNT
				INC	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
:EXIT			RTS

*-------------------------------
DEL_CDEF		DB	$07
				DB	$FF				;Modified
				DW	DCURSIT
DCURSIT			LDA	CURSOR
				LDX	#$80
				CMP	#7
				BEQ	:SKIPA
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#cybernate*16
				BNE	:SKIPA
				LDY	#robotcyblink
				LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:SKIPA
				STA	TEMP
				LDA	#0
				STA	COUNT
:LOOP1			TAX
				JSR	POINTIT
				LDY	#disklocation
				LDA	(CHARDL),Y
				CMP	TEMP
				BEQ	:SKIPA
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				LDX	#$C0
:SKIPA			STX	ROBOT_FLAG
DCURSIT2		LDX	CURSOR
				JSR	:SUBA
				LDX	ROBOT_FLAG
				BMI	:EXIT
:SUBA			LDY	GYPNTS,X
				LDX	#3
				JSR	ARROWER
:EXIT			RTS
*-------------------------------

*-------------------------------------
* $00-$06 Group position of robot
* $80 Char has no robot
* $C0 Char has robot but not in group
*-------------------------------------

ROBOT_FLAG		DB	0

*-------------------------------

GOSLIDE			LDA	#$00
				STA	LEFTCOL
				LDA	#$27
				STA	RITECOL
GOLOOPA			LDA	#$72	
				STA	LINENUM
GOLOOPB			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
				TXA
				LSR
				BCS	TOLEFT
				LDY	LEFTCOL
				JMP	GOCOMN
TOLEFT			LDY	RITECOL
GOCOMN			LDA	(SCREENL),Y
				PHA
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				PLA
				STA	(DESTINL),Y
				LDA	LINENUM
				INC	LINENUM
				CMP	#$BF
				BNE	GOLOOPB
VARY			LDA	#$30	
				JSR	WAIT
				INC	LEFTCOL
				DEC	RITECOL
				BPL	GOLOOPA
				RTS

GROUP_DO		LDA	#GREEN
				STA	COLOR
				LDY	#$11
				JSR	LINER
				LDA	#$42
				STA	SELECT
				LDA	#$75
				STA	YPNT
				JSR	HEADER
				LDY	#0
				STY	YCOUNT
:LOOP1			LDA	GYPNTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	YCOUNT
				LDY	YCOUNT
				CPY	GRPNUMB
				BNE	:LOOP1
				RTS

ASK_IN			LDA	#$20
				STA	PAGE
				JSR	CLRTOP
				LDA	#RED
				STA	COLOR
				LDY	#$13
				JSR	LINER
				LDY	#$0E			;"Who is returning..."
				JSR	TEXTER
				LDA	#$40
				STA	PAGE
ASK_OUT			LDA	#$00
				STA	BEGROW
				LDA	#$12
				STA	ENDROW
				LDX	#$0B	
				LDA	#$21	
				STA	ENDLINE
				JMP	SWAP

*-------------------------------

WARNING			CLC
WARNING2		PHA
				PHP
				JSR	DCURSIT2
				JSR	ASK_OUT
				LDA	#$20
				STA	PAGE
				JSR	CLRTOP
				LDA	#VIOLET
				STA	COLOR
				LDY	#$14
				JSR	LINER
				LDY	#$12			;<Space>
				JSR	TEXTER
				PLP
				BCC	:SKIPA
				LDY	#$0F			;"You are carrying..."
				JSR	TEXTER
:SKIPA			PLA
				TAY
				JSR	TEXTER
				JSR	SWAPPER
				BIT	UNSTROB
SPWAIT			LDA	KEYBRD
				BPL	SPWAIT
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	SPWAIT
				JSR	SWAPPER
				JSR	ASK_IN
				JMP	DCURSIT2

*-------------------------------

SWAPPER			LDX	#$00
				STX	BEGROW
				LDA	#$27
				STA	ENDROW
				LDA	#$1F
				STA	ENDLINE
SWAP			INC	ENDROW
				INC	ENDLINE
:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	BEGROW
:LOOP2			LDA	(SCREENL),Y
				PHA
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				PLA
				STA	(DESTINL),Y
				INY
				CPY	ENDROW
				BNE	:LOOP2
				INX
				CPX	ENDLINE
				BNE	:LOOP1
				RTS

GYPNTS			DB	$7F,$87,$8F
				DB	$97,$9F,$A7
				DB	$AF,$B9

SMARKIT			LDA	CNTABLE,Y
				EOR	#$FF
				STA	CNTABLE,Y
				LDA	GYPNTS,Y
				STA	YPNT
				LDA	#$03
				STA	XPNT
				JSR	:SUBA
				LDA	#$09
				STA	XPNT
:SUBA			LDA	#0
				LDX	#<:SHAPE
				LDY	#>:SHAPE
				JMP	DRAW_SHAPES

:SHAPE			DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111


CLRTOP			LDX	#$00
				STX	BEGROW
				LDA	#$27
				STA	ENDROW
				LDA	#$30
				STA	ENDLINE
BLACKEN			INC	ENDROW
BLACKN2			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	BEGROW
				LDA	#$00
MORCLR			STA	(SCREENL),Y
				INY
				CPY	ENDROW
				BNE	MORCLR
				INX
				CPX	ENDLINE
				BNE	BLACKN2
				RTS

CNTABLE			DB	$00,$00,$00		;MAKE THIS A DUMMY
				DB	$00,$00,$00
				DB	$00
