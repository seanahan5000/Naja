* topline
* bottomline+1
* leftcolumn, leftdata, leftmask,
*    if (1 to 7F) then (data bytes)
*    if (FF to 80) then neg # of reps of 2 byte pattern
*    0, rightdata, rightmask
*
* If leftcolumn is negative, that line has no data

UNPK_CENTER		TYA
				CLC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:0
				INC	DATA_PTR+1
:0
				LDX	TOP_LINE
:1				LDY	#1
				STY	SOURCE_INDEX
				DEY
				STY	DEST_INDEX

				LDA	(DATA_PTR),Y
				BPL	:11
				JMP	:8
:11				CLC
				ADC	LOBYTES,X
				INY
				STA	SCREENL
				LDA	HIBYTES,X
				ADC	PAGE
				STA	SCREENH

				STY	SOURCE_INDEX
				LDA	(DATA_PTR),Y
				STA	TEMP
				INY
				LDA	(DATA_PTR),Y
				INY
				STY	SOURCE_INDEX
				LDY	DEST_INDEX
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				ORA	TEMP
				STA	(SCREENL),Y
				INC	DEST_INDEX

:2				LDY	SOURCE_INDEX
				INC	SOURCE_INDEX
				LDA	(DATA_PTR),Y
				BEQ	:7
				TAX
				BMI	:4
:3				LDY	SOURCE_INDEX
				LDA	(DATA_PTR),Y
				INC	SOURCE_INDEX
				LDY	DEST_INDEX
				STA	(SCREENL),Y
				INC	DEST_INDEX
				DEX
				BNE	:3
				BEQ	:2				;Always

:4				INY
				LDA	(DATA_PTR),Y
				STA	TEMP
				INY
				LDA	(DATA_PTR),Y
				STA	TEMP+1
				INY
				STY	SOURCE_INDEX
				LDY	DEST_INDEX
:5				LDA	TEMP
				STA	(SCREENL),Y
				INY
				INX
				BEQ	:6
				LDA	TEMP+1
				STA	(SCREENL),Y
				INY
				INX
				BNE	:5
:6				STY	DEST_INDEX
				BEQ	:2				;Always

:7				INY
				LDA	(DATA_PTR),Y
				STA	TEMP
				INY
				LDA	(DATA_PTR),Y
				INY
				STY	SOURCE_INDEX
				LDY	DEST_INDEX
				STA	$C002			;read main
				AND	(SCREENL),Y
				STA	$C003			;read aux
				ORA	TEMP
				STA	(SCREENL),Y

:8				LDA	SOURCE_INDEX
				CLC
				ADC	DATA_PTR
				STA	DATA_PTR
				BCC	:9
				INC	DATA_PTR+1
:9
				INC	TOP_LINE
				LDX	TOP_LINE
				CPX	BOTTOM_LINE
				BEQ	:10
				JMP	:1
:10				JMP	DRAW_LOOP

*-------------------------------
