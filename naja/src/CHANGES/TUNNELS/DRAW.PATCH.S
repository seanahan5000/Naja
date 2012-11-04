* topline
* bottomline+1
* leftcolumn
* width-1
* data < L to R, T to B >

DRAW_PATCH		LDA	(DATA_PTR),Y
				STA	LEFT_COLUMN
				INY
				LDA	(DATA_PTR),Y
				STA	WIDTH
				LDX	TOP_LINE
				DEX
				TYA
				BNE	:4				;Always

:2				LDA	LOBYTES,X
				CLC
				ADC	LEFT_COLUMN
				STA	SCREENL
				LDA	HIBYTES,X
				ADC	PAGE
				STA	SCREENH

				LDY	WIDTH
:3				LDA	(DATA_PTR),Y
				STA	(SCREENL),Y
				DEY
				BPL	:3

				LDA	WIDTH
:4				SEC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:5
				INC	DATA_PTR+1
:5
				INX
				CPX	BOTTOM_LINE
				BNE	:2
				JMP	DRAW_LOOP
