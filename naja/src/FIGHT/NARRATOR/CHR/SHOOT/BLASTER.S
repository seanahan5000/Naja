NARR_CBLASTER

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<name> | FIRES A BLAST | WITH"
*         | FIRES A SHOT  |
*         | BLASTS A SHOT |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	#xCharsName
				JSR	BLAST_A_SHOT
				INX
				LDY	#xWith
				JSR	WORD1_RET
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "|A | <weapon> THAT"
*  |AN|
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#xAn
				JSR	WORD1_INC
				JSR	EQUIP2
				LDA	#$0A
				STA	TEXTBUF,X
				INX
				LDA	TEXTBUF+3
				LDY	#1
				JSR	VOWEL_CHECK
				LDY	#xThat
				JSR	WORD1_RET

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If ABSORBED then
*
* "IS ABSORBED BY THE WALLS."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				BIT	ABSORBED
				BPL	NO_ABSORBS

				LDY	#xIs
				JSR	WORD1_INC
				LDY	#6				;S>6 Absorbed.By.The.Wall
				JSR	SENTENCE
				LDA	#$1D
				STA	TEXTBUF,X
				INX
				JMP	PERIOD_RETURN	;RTS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If RICOCHETS and not ABSORBED then
*
* "RICOCHETS OFF THE |WALL | AND"
*                    |WALLS|
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
NO_ABSORBS		LDA	RICOCHETS
				BEQ	NO_RICOCHETS

				LDY	#4				;S>4 Ricochets.Off.The.Wall
				JSR	SENTENCE
				LDA	RICOCHETS
				CMP	#$01
				BEQ	ONE_WALL
				LDA	#$1D
				STA	TEXTBUF,X
				INX
ONE_WALL		INX
				LDY	#xAnd
				JSR	WORD1_RET

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If not SQUARE_HIT then
*
* "|MISSES      | THE |ATTACKER. |"
*  |WHIZZES PAST|     |ATTACKERS.|
*  |FLIES PAST  |     |REMAINS.  |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
NO_RICOCHETS	LDA	SQUARE_HIT
				BNE	SOMEONE_HIT

				LDX	#0
				JSR	WHIZ_SUB
				LDY	#xThe
				JSR	WORD1_INC
				JSR	ATTAREM
				JMP	PERIOD_RETURN	;RTS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If BLOCKED then
*
* "IS BLOCKED.  <name> IS HIT"
* "FOR |<damage>| DAMAGE."
*      | NO     |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SOMEONE_HIT		BIT	BLOCKED
				BPL	NO_BLOCKS

				LDA	CHAR_NUMBER
				PHA
				JSR	FIND_CHAR
				STA	CHAR_NUMBER
				JSR	POINTIT
				JSR	GET_CDAM_TOTL
				LDX	#0
				LDY	#xIs
				LDA	#xBlocked
				JSR	WORD2
				JSR	PERIOD
				LDY	#32				;S>32 <charname>.Is.Hit.RET
				JSR	SENTENCE_PRET	;     For.9999.Damage
				JSR	BLINK_CHAR
				JSR	DAMAGE_CHAR
				JSR	DELAYER
				PLA
				STA	CHAR_NUMBER
				JMP	POINTIT			;RTS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If HITS then
*
* "HITS THE <monster>"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
NO_BLOCKS		JSR	FIND_MONS
				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	GET_MDAM_TOTL
				LDX	#0
				LDY	#31				;S>31 Hits.The.<MonsName>
				JSR	SENTENCE_INC

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* IF ABSORBED then
*
* "                         BUT"
* "IT IS SO WEAK THAT IT CAUSES"
* "NO DAMAGE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	TOTAL_DAMAGEL
				ORA	TOTAL_DAMAGEH
				BNE	:SKIPA
				LDY	#30				;S>30 But.RET
				JMP	SENTENCE_PRET	;     It.Is.So.Weak.That.It.Causes.RET
									;     No.Damage

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* If CAUSING DAMAGE then
*
* "                         FOR"
* "9999 DAMAGE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:SKIPA			LDY	#36				;S>36 For.RET.9999.Damage
				JSR	SENTENCE_PRET
				JSR	BLINK_MONS
				LDA	#0
				LDY	SHOT_TYPE
				DEY
				BNE	:1
				LDA	#$FF
:1				JMP	DISDAM_MONS		;RTS
