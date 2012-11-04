* topline
* bottomline+1
* leftcolumn
* width+1, data<L to R>, rightmask
*
* If width+1 = 0, that line has no data

DRAW_LEFT		LDA	(DATA_PTR),Y
				STA	LEFT_COLUMN
				TYA
				SEC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:1
				INC	DATA_PTR+1
:1				LDX	TOP_LINE

				LDA	LEFT_COLUMN
				SEC
				SBC	#1
				STA	OFFSET
				LDA	PAGE
				SBC	#0
				STA	OFFSET+1

				LDY	#0
:3				LDA	LOBYTES,X
				CLC
				ADC	OFFSET
				STA	SCREENL
				LDA	HIBYTES,X
				ADC	OFFSET+1
				STA	SCREENH

				LDA	(DATA_PTR),Y
				BEQ	:5
				TAY
				LDA	(DATA_PTR),Y
				DEY
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				ORA	(DATA_PTR),Y
				STA	(SCREENL),Y
				DEY
				BEQ	:5
:4				LDA	(DATA_PTR),Y
				STA	(SCREENL),Y
				DEY
				BNE	:4
:5				LDA	(DATA_PTR),Y
				SEC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:6
				INC	DATA_PTR+1
:6
				INX
				CPX	BOTTOM_LINE
				BNE	:3
				JMP	DRAW_LOOP
