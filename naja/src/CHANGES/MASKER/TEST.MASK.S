CLEAR2			LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#39
				LDA	#0
:2				STA	(SCREENL),Y
				DEY
				BPL	:2
				INX
				CPX	#192
				BNE	:1
				RTS


TEST_MASK		LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#39
:2				LDA	(SCREENL),Y
				STA	BUFFER,Y
				LDA	PATTERN,Y
				STA	(SCREENL),Y
				LDA	BUFFER,Y
				EOR	(SCREENL),Y
				AND	(DESTINL),Y
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
				DEY
				BPL	:2
				INX
				CPX	#192
				BNE	:1
				RTS

PATTERN
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
				HEX	2A552A552A552A55
