*-------------------------------
*
*-------------------------------

IMMOBILIZER		PHA
				JSR	CLEAR_TLINE1
				LDY	#62				;S>62 CharsName.Throws.An.RET
				JSR	SENTENCE_INC	;     Immobilizer.That
				PLA
				ASL
				BCS	:1

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS AN"
* "IMMOBLIZER THAT FAILS TO"
* "ACTIVATE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#63				;S>63 Fails.To.RET.Activate.
				JSR	SENTENCE_PRET
				JMP	TAKE_N_BREAK

:1				LDY	EQUIP_OFFSET
				LDX	#3
				LDA	#$FF			;Remove immobilizer
:2				STA	(CHARDL),Y
				INY
				DEX
				BPL	:2
				JSR	GET_CMD_XY
				JSR	FIND_MONS
				BCS	IMMOB_HIT

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS AN"
* "IMMOBLIZER THAT ENVELOPS"
* "AN EMPTY SQUARE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
NO_IMMOB_HIT	LDX	#17
				LDY	#64				;S>64 Envelops.RET
				JSR	SENTENCE_PRET	;     AnEmptySquare
				JMP	TAKDELCLRCCOM

IMMOB_HIT		STA	MONS_NUMBER
				JSR	POINTTO
				LDX	#17
				LDY	#65				;S>65 Envelops.RET.The.MonsName
				JSR	SENTENCE
				LDY	#aImmobilized
				LDA	(ALIEN_PTR),Y
				BNE	IMMOB_AFFS

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharsName> THROWS AN"
* "IMMOBILIZER THAT ENVELOPS"
* "THE <MonsName> BUT DOES"
* "NOT SEEM TO IMMOBILIZE IT."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				INX
				LDY	#66				;S>66 But.Does.RET
				JSR	SENTENCE_PRET	;     Not.Seem.To.Immobilize.It.
				JMP	TAKDELCLRCCOM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS AN"
* "IMMOBILIZER THAT ENVELOPS"
* "THE <MonsName>."
*
* "<monsname> IS IMMOBILE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
IMMOB_AFFS		PHA
				JSR	PERIOD_RETURN
				PLA
				SED
				STA	TEMP
				CLC
				ADC	TEMP
				STA	TEMP
				TAY
				LDA	#0
				ADC	#0
				STA	TEMP+1
				TYA
				CLC
				ADC	TEMP
				STA	TEMP
				LDA	TEMP+1
				ADC	TEMP+1
				STA	TEMP+1
				CLD
				LDA	#immobile
				JSR	STATUS_MONS
				JMP	TAKDELCLRCCOM

*-------------------------------
*
*-------------------------------

IMMOB_BLINK		LDA	#$40
				STA	PAGE
				JSR	CSBOT2
				JSR	DRAW_ALIEN

				LDX	#$47
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDA	#GREEN
				STA	TEMP
				LDY	#$0C
:2				LDA	(SCREENL),Y
				AND	TEMP
				STA	(SCREENL),Y
				LDA	TEMP
				EOR	#$7F
				STA	TEMP
				DEY
				BPL	:2
				INX
				CPX	#$80
				BNE	:1

				LDA	#$20
				STA	PAGE
				JSR	EOR_SHOT
				LDA	#$C0
				JSR	WAIT2
				JSR	:SUBA
				JSR	:SUBA
				JMP	EOR_SHOT

:SUBA			BIT	KEYBRD
				BMI	:EXIT
				JSR	:SUBB
:SUBB			JSR	DRAW_ALIEN
				LDA	#$C0
				JSR	WAIT2
:EXIT			RTS
