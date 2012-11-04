*-------------------------------

GET_NORMBOX		LDX	#3
:1				LDA	MAX_RECT,X
				STA	pTOPLINE,X
				STA	minTOP,X
				DEX
				BPL	:1
				BMI	GET_BOUNDS		;Always

GET_MINBOX		JSR	MINIMUM_AREA
				LDX	#3
:1				LDA	pTOPLINE,X
				STA	minTOP,X
				LDA	MAX_RECT,X
				STA	pTOPLINE,X
				DEX
				BPL	:1

GET_BOUNDS		LDA	#%00000001
				STA	VBYTE
				LDX	minTOP
				CPX	#191
				BNE	:2
				LDX	pTOPLINE
:2				LDY	minLEFT
				CPY	#39
				BNE	:3
				LDY	pLEFTCOL
:3				JSR	MOVE_CROSS
				BCC	:EXIT
				STX	pTOPLINE
				STY	pLEFTCOL

				LDA	#%01000000
				STA	VBYTE
				LDX	minBOTTOM
				BEQ	:4
				CPX	pTOPLINE
				BCS	:5
:4				LDX	pBOTLINE
:5				LDY	minRIGHT
				BEQ	:6
				CPY	pLEFTCOL
				BCS	:7
:6				LDY	pRIGHTCOL
:7				JSR	MOVE_CROSS
				BCC	:9
				STX	pBOTLINE
				STY	pRIGHTCOL

				JSR	CROSS_BOX		;TEMP???
				SEC
				RTS

:9				LDA	#%00000001
				STA	VBYTE
				LDX	pTOPLINE
				LDY	pLEFTCOL
				JSR	CROSS_HAIR
:EXIT			RTS

MAX_RECT		DB	0,0,191,39

*-------------------------------

MOVE_CROSS		STX	LINE
				STY	COLUMN
				JSR	CROSS_HAIR
				BIT	UNSTROB
M_LOOP			LDA	KEYBRD
				BPL	M_LOOP
				BIT	UNSTROB
				CMP	#"J"
				BEQ	M_LEFT
				CMP	#"K"
				BEQ	M_RIGHT
				CMP	#" "
				BEQ	M_ENTER
				CMP	#"I"
				BEQ	M_UP
				CMP	#"A"
				BEQ	M_UP
				CMP	#"M"
				BEQ	M_DOWN
				CMP	#"Z"
				BEQ	M_DOWN
				CMP	#$9B			;Escape
				BNE	M_LOOP
				LDX	LINE
				LDY	COLUMN
				JSR	CROSS_HAIR
				CLC
M_ENTER			LDX	LINE
				LDY	COLUMN
				RTS

M_LEFT			LDY	COLUMN
				CPY	pLEFTCOL
				BEQ	M_LOOP
				JSR	DRAW_VLINE
				DEC	COLUMN
				LDY	COLUMN
				JSR	DRAW_VLINE
				JMP	M_LOOP

M_RIGHT			LDY	COLUMN
				CPY	pRIGHTCOL
				BEQ	M_LOOP
				JSR	DRAW_VLINE
				INC	COLUMN
				LDY	COLUMN
				JSR	DRAW_VLINE
				JMP	M_LOOP

M_UP			LDX	LINE
				CPX	pTOPLINE
				BEQ	M_LOOP
				JSR	DRAW_HLINE
				DEC	LINE
				BIT	OPEN_APPLE
				BPL	:3
				LDA	LINE
				SEC
				SBC	#6
				BCC	:1
				CMP	pTOPLINE
				BCS	:2
:1				LDA	pTOPLINE
:2				STA	LINE
:3				LDX	LINE
				JSR	DRAW_HLINE
				JMP	M_LOOP

M_DOWN			LDX	LINE
				CPX	pBOTLINE
				BEQ	:3
				JSR	DRAW_HLINE
				INC	LINE
				BIT	OPEN_APPLE
				BPL	:2
				LDA	LINE
				CLC
				ADC	#6
				CMP	pBOTLINE
				BCC	:1
				LDA	pBOTLINE
:1				STA	LINE
:2				LDX	LINE
				JSR	DRAW_HLINE
:3				JMP	M_LOOP

LINE			DB	0
COLUMN			DB	0

*-------------------------------

CROSS_BOX		LDA	#%00000001
				STA	VBYTE
				LDX	pTOPLINE
				LDY	pLEFTCOL
				JSR	CROSS_HAIR
				LDA	#%01000000
				STA	VBYTE
				LDX	pBOTLINE
				LDY	pRIGHTCOL
				JMP	CROSS_HAIR

*-------------------------------

CROSS_HAIR		TXA
				PHA
				JSR	DRAW_VLINE
				PLA
				TAX
				JMP	DRAW_HLINE

*-------------------------------

DRAW_VLINE		LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
:2				LDA	VBYTE
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
				INX
				CPX	#192
				BNE	:1
				RTS

VBYTE			DB	0

*-------------------------------

DRAW_HLINE		LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	#39
:1				LDA	#$7F
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
				DEY
				BPL	:1
				RTS

*-------------------------------

minTOP			DB	0
minLEFT			DB	0
minBOTTOM		DB	0
minRIGHT		DB	0

*-------------------------------
