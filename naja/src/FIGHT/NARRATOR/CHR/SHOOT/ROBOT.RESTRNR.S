NARR_ROBOTRES

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharsName> TRANSMITS A ROBOT"
* "RESTRAINING MESSAGE THAT"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#12				;S>12 Charsname.Transmits.A.Robot.RET
				JSR	SENTENCE_RET	;     Restraining.Message.That

				LDA	SQUARE_HIT
				BEQ	:1
				BIT	BLOCKED
				BPL	RR_HITS
				JSR	FIND_CHAR
				JSR	POINTIT
				LDX	#0
				LDY	#13				;S>13 Is.Intercepted.By.Cname.RET
				JSR	SENTENCE_PRET	;     But.Has.No.Effect
				LDA	CHAR_NUMBER
				JMP	POINTIT
:1				LDY	#14				;S>14 Is.Absorbed.By.The.Wall
				BIT	ABSORBED
				BMI	:2
				LDY	#15				;S>15 Is.Not.Received.By.Anyone
:2				JMP	SENTENCE_PRET

RR_HITS			JSR	FIND_MONS
				STA	MONS_NUMBER
				JSR	POINTTO
				LDX	#0
				LDY	#16				;S>16 Reaches.The.Monsname
				JSR	SENTENCE_RET
				SEC
				JSR	GET_INTENSITY
				LDA	#stunned
				JSR	STATUS_MONS
				BCC	:1
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "AND IS OBEYED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				RTS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "BUT IS IGNORED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:1				LDY	#17				;S>17 But.Is.Ignored
				JMP	SENTENCE_PRET
