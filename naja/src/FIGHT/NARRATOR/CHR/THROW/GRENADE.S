*-------------------------------
*
*-------------------------------

GRENADE			ASL
				BCS	:SKIPA

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS A SONIC"
* "GRENADE THAT FAILS TO EXPLODE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

				JSR	CLEAR_TLINE1
				LDY	#45				;S>45 CharsName.Throws.A.Sonic.RET
				JSR	SENTENCE_INC	;     Grenade.That
				LDY	#46				;S>46 Fails.To.RET.Detonate.
				JSR	SENTENCE_PRET
				JMP	TAKE_N_BREAK

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<CharName> THROWS A SONIC"
* "GRENADE THAT EXPLODES"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:SKIPA			LDY	EQUIP_OFFSET
				LDX	#3
				LDA	#$FF			;Remove grenade
:LOOP1			STA	(CHARDL),Y
				INY
				DEX
				BPL	:LOOP1
				JSR	GET_CMD_XY
				JSR	CLEAR_TLINE1
				LDY	#45				;S>45 CharsName.Throws.A.Sonic.RET
				JSR	SENTENCE_INC	;     Grenade.That
				LDY	#xExplodes
				JSR	WORD1_RET
				DEC	TLINE
				JSR	DO_EXPLOSION
				JSR	CLEAR_TEXT
				JSR	FIND_MONS
				BCS	GREN_HIT

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ..."BUT"
* "NO ONE IS AFFECTED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NO_GREN_HIT		LDX	#22
				LDY	#49				;S>49 But.RET.No.One.Is.Affected
				JSR	SENTENCE_PRET
				JMP	TAKDELCLRCCOM

*-------------------------------

GREN_HIT		STA	MONS_NUMBER
				JSR	POINTTO
*** Check for PUDDLE CREATURES here

				LDY	#monPHSHIELD
				LDA	(MONS_PTR),Y
				LDX	ENERGY_L
				LDY	ENERGY_H
				JSR	LESS_PERCENT
				LDA	#susGRENADE
				JSR	SUSEPTABILITY
				STX	TOTAL_DAMAGEL
				STY	TOTAL_DAMAGEH
				TXA
				BNE	GREN_AFFS
				TYA
				BEQ	NO_GREN_AFF

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ..."AND"
* "HITS THE <monsName> FOR"
* "9999 DAMAGE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

GREN_AFFS		LDX	#22
				LDY	#47				;S>47 And.RET.Hits.The.MName.For.RET
				JSR	SENTENCE_PRET	;     9999.Damage
				JSR	BLINK_MONS
				JSR	DAMAGE_MONS
				JMP	TAKDELCLRCCOM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ..."BUT THE"
* "<MonsName> IS UNAFFECTED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

NO_GREN_AFF		LDX	#22
				LDY	#48				;S>48 But.The.RET.MName.Is
				JSR	SENTENCE_INC
				LDA	#$1F			;"U"
				STA	TEXTBUF,X
				INX
				LDA	#$18			;"N"
				STA	TEXTBUF,X
				INX
				LDY	#xAffected
				JSR	WORD1_PRDRET
				JMP	TAKDELCLRCCOM

*-------------------------------
