NARR_BRAINJAM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<charname> SENDS OUT BRAIN"
* "JAMMING WAVES THAT VIBRATE"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#68				;S>68 CharsName.Sends.Out.Brain.RET
				JSR	SENTENCE_RET	;     Jamming.Waves.That.Vibrate

				LDA	ABSORBED
				BEQ	JAM_NOABS
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "INTO THE WALL."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#69				;S>69 Into.The.Wall
				JMP	SENTENCE_PRET	;RTS

JAM_NOABS		LDA	SQUARE_HIT
				BNE	JAM_SOMEONE
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "PAST THE | ATTACKERS |."
*           | ATTACKER  |
*           | REMAINS   |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#xPast
				LDA	#xThe
				JSR	WORD2_INC
				JSR	ATTAREM
				JMP	PERIOD_RETURN	;RTS

JAM_SOMEONE		BIT	BLOCKED
				BPL	NO_BLOCKJAM
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "INTO <charname> BUT HAVE NO"
* "EFFECT."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				JSR	FIND_CHAR
				STA	CHAR_NUMBER
				JSR	POINTIT
				LDX	#0
				LDY	#70				;S>70 Into.CharsName.But.Have.No.RET
				JSR	SENTENCE_PRET	;     Effect
				LDA	CHAR_NUMBER
				JMP	POINTIT			;RTS

NO_BLOCKJAM		JSR	FIND_MONS
				STA	MONS_NUMBER
				JSR	POINTTO
				CLC
				JSR	GET_INTENSITY
				LDA	#confused
				JSR	STATUS_MONS
				BCC	:1

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "INTO THE <monsname>."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				RTS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "INTO THE <monsname> BUT"
* "HAVE NO EFFECT."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:1				LDY	#71				;S>71 Into.The.MonsName.But.RET
				JMP	SENTENCE_PRET	;     Have.No.Effect

GET_INTENSITY	PHP
				LDA	#0
				STA	TEMP
				STA	TEMP+1
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				PLP
				ROR
				EOR	ALTYPE1,X
				BMI	:3
				LDY	#aJammed
				LDX	#4
				CLC
:1				LDA	(ALIEN_PTR),Y
				BEQ	:3
				SED
				ADC	TEMP
				STA	TEMP
				CLD
				BCC	:2
				INC	TEMP+1
:2				DEX
				BNE	:1
:3				RTS
