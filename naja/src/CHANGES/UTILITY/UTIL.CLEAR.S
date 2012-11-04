*-------------------------------

CLEAR			JSR	PRE_TEXT
				JSR	WHICH_SCREEN
				BCC	:3
				STA	NOMIXED
				JSR	SHOW_PAGE
				LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	#39
				LDA	#0
:2				STA	(SCREENL),Y
				DEY
				BPL	:2
				INX
				CPX	#192
				BNE	:1
:3				STA	NOMIXED
				JMP	DISPATCHER

*-------------------------------
