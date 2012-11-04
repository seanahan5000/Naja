* topline
* bottomline+1
* leftcolumn-3, width-1, leftmask, dataA,
*    data<L to R>, rightmask, dataB
*
* If width-1 is negative, that line has no data

DRAW_CENTER		TYA
				CLC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:1
				INC	DATA_PTR+1
:1				LDX	TOP_LINE

:3				LDY	#0
				LDA	PAGE			;TEMP***
				PHA					;TEMP***
				LDA	(DATA_PTR),Y
				BPL	:XXX			;TEMP***
				DEC	PAGE			;TEMP***
:XXX								;TEMP***
				CLC
				ADC	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ADC	PAGE
				STA	SCREENH
				PLA					;TEMP***
				STA	PAGE			;TEMP***
				INY
				LDA	(DATA_PTR),Y
				INY
				TAX
				BMI	:6
				LDA	(DATA_PTR),Y
				INY
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				ORA	(DATA_PTR),Y
				STA	(SCREENL),Y
				INY
				DEX
				BMI	:6
				BEQ	:5
:4				LDA	(DATA_PTR),Y
				STA	(SCREENL),Y
				INY
				DEX
				BNE	:4
:5				LDA	(DATA_PTR),Y
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				INY
				ORA	(DATA_PTR),Y
				DEY
				STA	(SCREENL),Y
				INY
				INY
:6				TYA
				CLC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:7
				INC	DATA_PTR+1
:7				INC	TOP_LINE
				LDX	TOP_LINE
				CPX	BOTTOM_LINE
				BNE	:3
				JMP	DRAW_LOOP
