* topline
* bottomline+1
* leftcolumn-2, leftmask, data<L to R>
*
* If leftcolumn-2 is negative, that line has no data

DRAW_RIGHT		LDA	(DATA_PTR),Y
				STA	RIGHT_COLUMN
				TYA
				SEC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:1
				INC	DATA_PTR+1
:1				LDX	TOP_LINE

:3				LDY	#0
				LDA	LOBYTES,X
				CLC
				ADC	(DATA_PTR),Y
				STA	SCREENL
				LDA	HIBYTES,X
				ADC	PAGE
				STA	SCREENH
				LDA	RIGHT_COLUMN
				CLC
				SBC	(DATA_PTR),Y
				INY
				TAX
				BMI	:5
				LDA	(DATA_PTR),Y
				INY
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				ORA	(DATA_PTR),Y
				STA	(SCREENL),Y
				INY
				DEX
				BEQ	:5
:4				LDA	(DATA_PTR),Y
				STA	(SCREENL),Y
				INY
				DEX
				BNE	:4
:5				TYA
				CLC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:6
				INC	DATA_PTR+1

:6				INC	TOP_LINE
				LDX	TOP_LINE
				CPX	BOTTOM_LINE
				BNE	:3
				JMP	DRAW_LOOP
