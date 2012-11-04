*-------------------------------

DISK			JSR	HOME
				STA	TEXT
				STA	PRIMARY
				JSR	INPUT
				LDA	#$8D
				STA	$200,X
				DEX
:1				LDA	$6D0,X
				STA	$200,X
				DEX
				BPL	:1
				JSR	HOME
				JSR	$BE03
				LDA	$BE0F
				BEQ	:2
				JSR	$BE0C
:2				BIT	UNSTROB
:3				BIT	KEYBRD
				BPL	:3
				BIT	UNSTROB
				STA	GRAPHICS
				JMP	DISPATCHER

*-------------------------------
