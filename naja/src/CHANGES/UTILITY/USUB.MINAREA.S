MINIMUM_AREA	LDX	#0
:1				JSR	TEST_LINE
				BNE	:2
				INX
				CPX	#192
				BNE	:1
				DEX
:2				STX	pTOPLINE

				LDX	#191
:3				JSR	TEST_LINE
				BNE	:4
				DEX
				CPX	#-1
				BNE	:3
				INX
:4				STX	pBOTLINE

				LDY	#0
:5				JSR	TEST_COLUMN
				BNE	:6
				INY
				CPY	#40
				BNE	:5
				DEY
:6				STY	pLEFTCOL

				LDY	#39
:7				JSR	TEST_COLUMN
				BNE	:8
				DEY
				BPL	:7
				INY
:8				STY	pRIGHTCOL
				RTS


TEST_LINE		LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	#39
:1				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:2
				DEY
				BPL	:1
				INY
:2				RTS

TEST_COLUMN		LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:2
				INX
				CPX	#192
				BNE	:1
:2				RTS
