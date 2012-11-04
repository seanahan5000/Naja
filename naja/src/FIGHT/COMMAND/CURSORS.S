*-------------------------------
*
*-------------------------------

FULL_GETKEY		JSR	INIT_CURSOR
				JSR	SET_INTERCEPT
				JMP	GETKEY


*-------------------------------
*
*-------------------------------

SET_INTERCEPT	LDX	#<:LOOK_FOR_C
				LDY	#>:LOOK_FOR_C
				STX	INTERCEPT+1
				STY	INTERCEPT+2
				RTS
:LOOK_FOR_C		CMP	#$C3
				BEQ	:EXIT
				SEC
				RTS
:EXIT			CLC
				RTS


*-------------------------------
* Used by ENERGY to select upper
*   left of energy strike zone.
*-------------------------------

GET_UL_EZONE	LDA	#$29
				STA	CURSOR
				LDX	#<EZONE_CURSOR
				LDY	#>EZONE_CURSOR
				JSR	SET_GCURSOR
				LDA	#$00			;Don't allow wrap-around
				STA	EZONE_FLAG
				LDX	#$1A
				LDY	#$56
				BNE	GET_GRIDCURS	;Always

*-------------------------------
* Used by ENERGY to select lower
*   right of energy strike zone.
*   (It assumes GET_UL_EZONE was
*   called first.)
*-------------------------------

GET_LR_EZONE	LDA	#$FF
				STA	EZONE_FLAG
				LDA	#$00
				LDX	CURSOR
				STX	MARGIN
				LDY	#$56
				BNE	GET_GRIDCURS	;Always

*-------------------------------
* Used by AIM, THROW and IDENTIFY
*   to select destination square
*   for those commands.
*-------------------------------

GET_AIM			LDA	#$38
				STA	CURSOR
				LDX	#<BOX_CURSOR
				LDY	#>BOX_CURSOR
				JSR	SET_GCURSOR
				LDA	#$FF			;Allow wrap-around
				LDX	#$1A
				LDY	#$56

*-------------------------------
* Common entry point for all grid
*   cursor routines.
*-------------------------------

GET_GRIDCURS	STA	WRAP_FLAG
				STX	LIMIT_UL
				STY	LIMIT_LR
				JSR	DRAW_GRIDCURS
				BIT	UNSTROB
				JMP	GRID_LOOP

*------------------------------------------
* Actual grid movement routine.
*   On exit:
*      If carry set, <Space> was pressed
*      If carry clear, 'C'ancel was pressed
*------------------------------------------

GRID_BLINK		LDA	#$10
				JSR	WAIT
				LDA	#$F0
				JSR	WAIT2
				BMI	GRID_KEY
				JSR	DRAW_GRIDCURS
				LDA	#$00
				JSR	WAIT2
				JSR	DRAW_GRIDCURS
GRID_LOOP		LDA	KEYBRD
				BPL	GRID_BLINK
GRID_KEY		BIT	UNSTROB
				JSR	CHECK_LEFT
				BEQ	GRID_LEFT
				JSR	CHECK_RIGHT
				BEQ	GRID_RIGHT
				JSR	CHECK_UP
				BEQ	GRID_UP
				JSR	CHECK_DOWN
				BEQ	GRID_DOWN
				JSR	CHECK_ENTER
				BEQ	:EXIT
				CMP	#"C"
				BNE	GRID_LOOP
				CLC
:EXIT			RTS

GRID_LEFT		LDX	#$F0
				LDA	CURSOR
				EOR	LIMIT_UL
				AND	#%11110000
				BNE	GRID_COMMON1
				BIT	WRAP_FLAG
				BPL	GRID_LOOP
				LDA	CURSOR
				EOR	LIMIT_LR
				AND	#%00001111
				EOR	LIMIT_LR
				BNE	GRID_COMMON2	;Always

GRID_RIGHT		LDX	#$10
				LDA	CURSOR
				EOR	LIMIT_LR
				AND	#%11110000
				BNE	GRID_COMMON1
				BIT	WRAP_FLAG
				BPL	GRID_LOOP
				LDA	CURSOR
				EOR	LIMIT_UL
				AND	#%00001111
				EOR	LIMIT_UL
				BNE	GRID_COMMON2	;Always

GRID_UP			LDX	#$01
				LDA	CURSOR
				EOR	LIMIT_UL
				AND	#%00001111
				BNE	GRID_COMMON1
				BIT	WRAP_FLAG
				BPL	GRID_LOOP
				LDA	CURSOR
				EOR	LIMIT_LR
				AND	#%11110000
				EOR	LIMIT_LR
				BNE	GRID_COMMON2	;Always

GRID_DOWN		LDX	#$FF
				LDA	CURSOR
				EOR	LIMIT_LR
				AND	#%00001111
				BNE	GRID_COMMON1
				BIT	WRAP_FLAG
				BPL	GRID_COMMON3
				LDA	CURSOR
				EOR	LIMIT_UL
				AND	#%11110000
				EOR	LIMIT_UL
				BNE	GRID_COMMON2	;Always
GRID_COMMON1	TXA
				CLC
				ADC	CURSOR
GRID_COMMON2	PHA
				JSR	DRAW_GRIDCURS
				PLA
				STA	CURSOR
				JSR	DRAW_GRIDCURS
GRID_COMMON3	JMP	GRID_LOOP

*-------------------------------
*
*-------------------------------

SET_GCURSOR		STX	DRAW_GRIDCURS+1
				STY	DRAW_GRIDCURS+2
				RTS

DRAW_GRIDCURS	JMP	$FFFF

WRAP_FLAG		DB	0
LIMIT_UL		DB	0
LIMIT_LR		DB	0


*-------------------------------
*
*-------------------------------

EZONE_CURSOR	LDA	CURSOR
				SEC
				SBC	#$05
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XPNT
				LDA	YPNTS,Y
				SEC
				SBC	#$37	
				STA	YPNT
				LDA	XPNT
				PHA
				DEC	XPNT
				BIT	EZONE_FLAG
				BPL	:SKIPA
				LDA	XPNT
				CLC
				ADC	#$0F
				STA	XPNT
:SKIPA			LDA	#0
				LDX	#<EZONE_SHAPES
				LDY	#>EZONE_SHAPES
				JSR	DRAW_SHAPES
				LDA	YPNT
				PHA
				CLC
				ADC	#$05
				STA	YPNT
				LDA	#0
				JSR	REDRAW_SHAPES
				PLA
				STA	YPNT	
				DEC	YPNT
				PLA
				STA	XPNT
				BIT	EZONE_FLAG
				BPL	:SKIPB
				LDA	YPNT	
				CLC
				ADC	#$0B
				STA	YPNT	
:SKIPB			LDA	#1
				JSR	REDRAW_SHAPES
				LDA	XPNT
				CLC
				ADC	#$07
				STA	XPNT
				LDA	#1
				JMP	REDRAW_SHAPES

EZONE_FLAG		DB	0

EZONE_SHAPES	DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000000
				DB	%00000000

				DB	%01111111
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000


*-------------------------------
*
*-------------------------------

BOX_CURSOR		LDA	#$7E
				STA	LLCORNR+5	
				LDA	CURSOR
				SEC
				SBC	#$05	
				TAX
				AND	#$0F
				CMP	#$01
				BNE	:SKIPA
				INC	LLCORNR+5
:SKIPA			TXA
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XPNT
				LDA	YPNTS,Y
				SEC
				SBC	#$37
				STA	YPNT
				LDA	#0
				STA	COUNT
				DEC	XPNT
				LDA	XPNT
				PHA
				DEC	YPNT
				DEC	YPNT
:LOOP1			LDA	COUNT
				LDX	#<BOX_SHAPES
				LDY	#>BOX_SHAPES
				JSR	DRAW_SHAPES
				INC	COUNT
				LDA	COUNT
				CMP	#3
				BEQ	:SKIPB
				CMP	#6
				BEQ	:EXIT
				LDA	XPNT
				CLC
				ADC	#$07
				STA	XPNT
				BNE	:LOOP1			;Always
:SKIPB			PLA
				STA	XPNT
				LDA	YPNT
				CLC
				ADC	#$07
				STA	YPNT
				BNE	:LOOP1			;Always
:EXIT			RTS

BOX_SHAPES		DB	%00000000
				DB	%01111110
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001

				DB	%00000000
				DB	%01111111
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000

				DB	%00000000
				DB	%00000001
				DB	%00000010
				DB	%00000010
				DB	%00000010
				DB	%00000010
				DB	%00000010

LLCORNR			DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%01111110
				DB	%00000000

				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%01111111
				DB	%00000000

				DB	%00000010
				DB	%00000010
				DB	%00000010
				DB	%00000010
				DB	%00000010
				DB	%00000001
				DB	%00000000


*-------------------------------
*
*-------------------------------

CHAR_CURSOR1	LDY	CURSOR
				JSR	CHAR_SQUARE
CHAR_CURSOR2	LDY	CURSOR
				JSR	CHAR_POINT
				LDA	CURSOR
				JSR	POINTIT
				JSR	FROM11
				JSR	GROUP_CURSOR1
				LDA	PLANNER
				JMP	POINTIT

CHAR_SQUARE		LDA	YPOINTS,Y
				STA	YPNT
				LDA	#$05
				STA	XPNT
				LDA	#4
				JMP	SPCHARS

CHAR_POINT		LDA	YPOINTS,Y
				STA	YPNT
				LDA	#$0A
				STA	XPNT
				LDA	#0
				LDX	#<CHAR_SHAPES
				LDY	#>CHAR_SHAPES
				JMP	DRAW_SHAPES

CHAR_SHAPES		DB	%00000000
				DB	%00000000
				DB	%00000011
				DB	%00001111
				DB	%00000011
				DB	%00000000
				DB	%00000000


*-------------------------------
*
*-------------------------------

GROUP_CURSOR1	LDA	XPNTS,X
				STA	XPNT
				DEC	XPNT
				LDA	YPNTS,Y
				CLC
				ADC	#$08
				STA	YPNT
				LDA	#$00
				STA	COUNT
NEXTOF3			LDA	COUNT
				LDX	#<GROUP_SHAPES1
				LDY	#>GROUP_SHAPES1
				JSR	DRAW_SHAPES
				LDA	XPNT
				CLC
				ADC	#$07
				STA	XPNT
				LDA	COUNT
				INC	COUNT
				CMP	#$02
				BNE	NEXTOF3
				RTS

GROUP_SHAPES1	DB	%00000011
				DB	%00000111
				DB	%01111110
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000

				DB	%00000000
				DB	%01000000
				DB	%01111111
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000

				DB	%00000011
				DB	%00000011
				DB	%00000001
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000


*-------------------------------
*
*-------------------------------

GROUP_CURSOR2	LDY	CURSOR
				LDA	CURCORD,Y
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XPNT
				LDA	YPNTS,Y
				STA	YPNT
				LDA	#0
				LDX	#<GROUP_SHAPES2
				LDY	#>GROUP_SHAPES2
				JSR	DRAW_SHAPES
				LDA	XPNT
				PHA
				CLC
				ADC	#$07	
				STA	XPNT
				LDA	#0
				JSR	REDRAW_SHAPES
				LDY	XPNT
				PLA
				STA	XPNT
				TYA
				PHA
				LDA	YPNT
				CLC
				ADC	#$07
				STA	YPNT
				LDA	#1
				JSR	REDRAW_SHAPES
				PLA
				STA	XPNT
				LDA	#2
				JMP	REDRAW_SHAPES

GROUP_SHAPES2	DB	%01111111
				DB	%01111111
				DB	%01111111
				DB	%01111111
				DB	%01111111
				DB	%01111111
				DB	%01111111

				DB	%01111111
				DB	%01111110
				DB	%01111100
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000

				DB	%01111111
				DB	%00111111
				DB	%00011111
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000


*-------------------------------
*
*-------------------------------

HAND_CURSOR		LDY	CURSOR
				CPY	#$04
				BCC	:SKIPB
				BNE	:SKIPA
				LDY	#$00
				JSR	:SKIPB
				LDY	#$01
				BNE	:SKIPB			;Always
:SKIPA			LDY	#$02
				JSR	:SKIPB
				LDY	#$03
:SKIPB			LDA	HAND_YPNTS,Y
				STA	YPNT
				LDA	#$8E
				STA	XPNT
				LDA	#2
				JMP	SPCHARS

HAND_YPNTS		DB	$92,$9A,$A2,$AA
