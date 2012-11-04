ULAST_LINE		=	$00
UDEST_LINE		=	$01
DLAST_LINE		=	$02
DDEST_LINE		=	$03
TEMP			=	$04				;$05
DESTINL			=	$06
DESTINH			=	$07
SCREENL			=	$08
SCREENH			=	$09
LIP_LINE		=	$0A

firstline		=	79
middleline		=	128
lastline		=	175
farleftcol		=	7
farrightcol		=	32
stepsize		=	4


OPEN_DOOR
********************************
				JSR	DOOR_HALLS
				JSR	DRAW_OPENDOOR
				LDA	PAGE
				EOR	#$60
				STA	PAGE
********************************
				LDA	#middleline-stepsize
				STA	ULAST_LINE
				LDA	#middleline+stepsize
				STA	DLAST_LINE

OPEN_LOOP		LDA	#0
				STA	TEMP+1

GO_UP			LDA	ULAST_LINE
				CMP	#firstline-stepsize
				BCC	GO_DOWN
UP_LOOP
:0				LDA	#firstline
				STA	UDEST_LINE
				LDA	ULAST_LINE
				CMP	#firstline
				BCC	:2

:1				LDX	UDEST_LINE
				LDA	LOBYTES+stepsize,X
				STA	SCREENL
				LDA	HIBYTES+stepsize,X
				ORA	PAGE
				STA	SCREENH

				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	DESTINH

				JSR	MOVE_LINE

				LDA	UDEST_LINE
				INC	UDEST_LINE
				CMP	ULAST_LINE
				BNE	:1

:2				LDX	UDEST_LINE
				TXA
				CLC
				ADC	#stepsize
				STA	TEMP
				JSR	DRAW_LINE

				LDA	ULAST_LINE
				CMP	#middleline-stepsize
				BNE	:3
				JSR	DRAW_UPR_LIP
:3
				LDA	#firstline
				STA	UDEST_LINE
				LDA	ULAST_LINE
				CMP	#firstline
				BCC	:4
				SEC
				SBC	#stepsize
				STA	ULAST_LINE
				INC	TEMP+1
:4

GO_DOWN			LDA	DLAST_LINE
				CMP	#lastline+stepsize+1
				BCS	NEXT_OPEN
DOWN_LOOP
:0				LDA	#lastline
				STA	DDEST_LINE
				LDA	DLAST_LINE
				CMP	#lastline+1
				BCS	:2

:1				LDX	DDEST_LINE
				LDA	LOBYTES-stepsize,X
				STA	SCREENL
				LDA	HIBYTES-stepsize,X
				ORA	PAGE
				STA	SCREENH

				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	DESTINH

				JSR	MOVE_LINE

				LDA	DDEST_LINE
				DEC	DDEST_LINE
				CMP	DLAST_LINE
				BNE	:1

:2				LDA	DDEST_LINE
				STA	TEMP
				INC	TEMP
				SEC
				SBC	#stepsize
				TAX
				JSR	DRAW_LINE

				LDA	DLAST_LINE
				CMP	#middleline+stepsize
				BNE	:3
				JSR	DRAW_LWR_LIP
:3
				LDA	#lastline
				STA	DDEST_LINE
				LDA	DLAST_LINE
				CMP	#lastline+1
				BCS	:4
				CLC
				ADC	#stepsize
				STA	DLAST_LINE
				INC	TEMP+1
:4

NEXT_OPEN		LDA	TEMP+1
				BEQ	:1
********************************
				BIT	$C010
:999			BIT	$C000
*BPL :999
				BIT	$C010
********************************
				JMP	OPEN_LOOP
:1				RTS

*-------------------------------

MOVE_LINE		LDY	LEFT_COLUMNS-firstline,X
				LDA	(DESTINL),Y
				EOR	(SCREENL),Y
				AND	LEFT_MASKS-firstline,X
				EOR	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				LDA	RIGHT_COLUMNS-firstline,X
				STA	TEMP
:1				LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	TEMP
				BNE	:1
				LDA	(DESTINL),Y
				EOR	(SCREENL),Y
				AND	RIGHT_MASKS-firstline,X
				EOR	(SCREENL),Y
				STA	(DESTINL),Y
				RTS

*-------------------------------

DRAW_LINE		LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
				LDY	#farleftcol
:1				LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	#farrightcol+1
				BNE	:1
				INX
				CPX	TEMP
				BNE	DRAW_LINE
				RTS

*-------------------------------

DRAW_UPR_LIP	LDA	ULAST_LINE
				SEC
				SBC	#2
				TAX
				CLC
				ADC	#4
				STA	LIP_LINE
				INC	ULAST_LINE
				LDA	#<UPPER_LIP-farleftcol
				LDY	#>UPPER_LIP-farleftcol
				BNE	DRAW_LIP		;Always

DRAW_LWR_LIP	LDA	DLAST_LINE
				SEC
				SBC	#3
				TAX
				CLC
				ADC	#4
				STA	LIP_LINE
				LDA	DLAST_LINE
				SEC
				SBC	#3
				STA	DLAST_LINE
				LDA	#<LOWER_LIP-farleftcol
				LDY	#>LOWER_LIP-farleftcol

DRAW_LIP		STA	SCREENL
				STY	SCREENH
:1				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	DESTINH
				JSR	MOVE_LINE
				LDA	SCREENL
				CLC
				ADC	#farrightcol-farleftcol+1
				STA	SCREENL
				BCC	:2
				INC	SCREENH
:2				INX
				CPX	LIP_LINE
				BNE	:1
				RTS

UPPER_LIP		HEX	D4AAA5A9CAD294A5C9AAC5FFFFFFFFA8
				HEX	D5A4A9CAD294A5A9D58A
				HEX	8080A0818AD08085A8AA9580808080AA
				HEX	9585A8C08294A0818080
				HEX	808080D5AAD5AAD58AA8D5AAD5AAD5AA
				HEX	85D4AAD5AAD5AA808080
LOWER_LIP		HEX	80808080808080808080808080808080
				HEX	80808080808080808080
				HEX	A8D5C2AAD5AAD5AA85D4AAD5AAD5AAD5
				HEX	8AA8D5AAD5AAD5D0AA85
				HEX	8080D0AAA9D5AAAA9585A8C082D08085
				HEX	A8AA95D5AAA5D5828080
				HEX	D4AAD5AAFAFFBFA9D5A4A9CAD2D294A5
				HEX	C9AAA5FFFF97D5AAD58A

*-------------------------------

LEFT_COLUMNS	DB	$0C,$0C,$0C
				DB	$0C,$0C,$0C
				DB	$0C,$0C,$0C
				DB	$0B,$0B,$0B
				DB	$0B,$0B,$0B
				DB	$0B,$0B,$0B
				DB	$0B,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$09,$09,$09
				DB	$09,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$07
				DB	$07,$07,$09
				DB	$09,$09,$09
				DB	$0A,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$0A,$0A,$0A
				DB	$0B,$0B,$0B
				DB	$0B,$0B,$0B
				DB	$0B,$0B,$0B
				DB	$0C,$0C,$0C
				DB	$0C,$0C,$0C
				DB	$0C

LEFT_MASKS		DB	$9F,$8F,$8F
				DB	$87,$83,$83
				DB	$81,$80,$80
				DB	$BF,$9F,$9F
				DB	$8F,$87,$87
				DB	$83,$81,$81
				DB	$80,$BF,$BF
				DB	$9F,$8F,$8F
				DB	$87,$83,$83
				DB	$81,$80,$80
				DB	$BF,$9F,$9F
				DB	$87,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$81,$81,$81
				DB	$87,$9F,$9F
				DB	$80,$80,$80
				DB	$83,$83,$83
				DB	$8F,$8F,$8F
				DB	$BF,$BF,$BF
				DB	$81,$81,$81
				DB	$87,$87,$87
				DB	$9F,$9F,$9F
				DB	$80,$80,$80
				DB	$83,$83,$83
				DB	$8F

RIGHT_COLUMNS	DB	$1B,$1B,$1B
				DB	$1B,$1B,$1B
				DB	$1B,$1B,$1B
				DB	$1B,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1D,$1D,$1D
				DB	$1D,$1D,$1D
				DB	$1D,$1D,$1D
				DB	$1D,$1E,$1E
				DB	$1E,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$20
				DB	$20,$20,$1E
				DB	$1E,$1E,$1E
				DB	$1D,$1D,$1D
				DB	$1D,$1D,$1D
				DB	$1D,$1D,$1D
				DB	$1C,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1C,$1C,$1C
				DB	$1B,$1B,$1B
				DB	$1B,$1B,$1B
				DB	$1B

RIGHT_MASKS		DB	$FE,$FC,$FC
				DB	$F8,$F0,$F0
				DB	$E0,$C0,$C0
				DB	$80,$FE,$FE
				DB	$FC,$F8,$F8
				DB	$F0,$E0,$E0
				DB	$C0,$80,$80
				DB	$FE,$FC,$FC
				DB	$F8,$F0,$F0
				DB	$E0,$C0,$C0
				DB	$80,$FE,$FE
				DB	$F8,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$E0,$E0,$E0
				DB	$F8,$FE,$FE
				DB	$C0,$C0,$C0
				DB	$F0,$F0,$F0
				DB	$FC,$FC,$FC
				DB	$80,$80,$80
				DB	$E0,$E0,$E0
				DB	$F8,$F8,$F8
				DB	$FE,$FE,$FE
				DB	$C0,$C0,$C0
				DB	$F0,$F0,$F0
				DB	$FC
