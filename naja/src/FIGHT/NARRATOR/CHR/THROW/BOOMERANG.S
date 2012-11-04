*-------------------------------
*
*-------------------------------

BOOMERANG		ASL
				BCS	:SKIPA

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS A GYRO"
* "BOOMERANG THAT CRASHES"
* "TO THE FLOOR."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

				JSR	CLEAR_TLINE1
				LDY	#53				;S>53 CName.Throws.A.Gyro.RET
				JSR	SENTENCE_PRET	;     Boomerang.That.Crashes.RET
				JMP	TAKE_N_BREAK	;     To.The.Floor

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharsName> THROWS A GYRO"
* "BOOMERANG THAT ARCS TOWARD THE"
* "<attackers> BUT MISSES."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:SKIPA			JSR	GET_CMD_XY
				LDX	#0
				STX	HANDS_USED		;Force one handed swing
				INX
				STX	SWING_TYPE		;Force vertical swing
				STX	SWING_DIRECTN	;Force center square
				JSR	CLEAR_TLINE1
				LDY	#50				;S>50 CName.Throws.A.Gyro.RET
				JSR	SENTENCE_RET	;     Boomerang.That.Arcs.Toward.The
				JSR	FIND_MONS
				BCC	BOOMER_MISS

				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	CHECK_SWING		;Use swing odds routines
				BCS	BOOMER_HIT
				LDX	#0
				LDY	#xMonsName
				JSR	WORD1_INC
				JMP	BCOM1

BOOMER_MISS		LDX	#0
				JSR	ATTAREM
				INX
BCOM1			LDY	#xBut
				LDA	#xMisses
				JSR	WORD2_PRDRET
				JMP	BOOMER_RETS

BOOMER_HIT		JSR	CALC_SWINGDAM	;Use swing damage routine
				LDX	#0
				LDY	#51				;S>51 MName.And.Hits.It.RET
				JSR	SENTENCE_PRET	;     For.9999.Damage
				JSR	BLINK_MONS
				JSR	DAMAGE_MONS
BOOMER_RETS		JSR	DELAYER
				JSR	CLRBOX
				JSR	CLEAR_TLINE1
				LDY	#52				;S>52 The.Gyro.Boomerang.Returns
				JSR	SENTENCE_PRET
				JMP	TAKDELCLRCCOM
