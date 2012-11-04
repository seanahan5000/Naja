MON_SHOOT		LDA	#0				;Normal blaster
				STA	SHOT_TYPE
				JSR	MSHOOT_GRID
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				SEC
				SBC	TVIEW_HEIGHT
				SBC	#4
				JSR	FROM11B
				STY	TEMP
				LDY	#aBlastSource
				LDA	(ALIEN_PTR),Y
				LDY	TEMP
				PHA
				ROL
				ROL
				ROL
				AND	#%00000011
				STA	TEMP
				PLA
				AND	#%00111111
				CLC
				ADC	XPNTS,X
				TAX
				LDA	YPNTS,Y
				SEC
				SBC	TEMP
				SEC
				SBC	#$2D
				LDY	#0
				JSR	HPOSN
				LDY	#aBlastDamage
				LDA	(ALIEN_PTR),Y
				STA	EL_DAMAGEH
				INY
				LDA	(ALIEN_PTR),Y
				STA	EL_DAMAGEL
				LDA	#0
				STA	PH_DAMAGEH
				STA	PH_DAMAGEL
				LDY	#monLASTCMD+1
				LDA	(MONS_PTR),Y
				STA	YPNT
				_AimAccuracy_
				JSR	AIM_DESTSUB
				SEC					;Ricochets are allowed
				JSR	TRACE_SHOT

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<monster> | FIRES A BLAST |"
*            | FIRES A SHOT  |
*            | BLASTS A SHOT |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	#xMonsName
				JSR	BLAST_A_SHOT
				JSR	RETURN

				LDA	RICOCHETS
				BEQ	MSHOT_MISSES
				BIT	ABSORBED
				BEQ	MSHOT_RICOCHT

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "THAT IS ABSORBED BY THE WALLS"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#35				;S>35 That.Is.Absorbed.By.The.Wall
				JSR	SENTENCE
				LDA	#$1D
				STA	TEXTBUF,X
				INX
				JSR	PERIOD_RETURN
				JMP	MSHOT_DONE

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "THAT RICOCHETS OFF THE WALL|   |"
*                             | S |"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MSHOT_RICOCHT	LDY	#10				;S>10 That.Ricochets.Off.The.Wall
				JSR	SENTENCE
				LDY	RICOCHETS
				DEY
				BEQ	:1
				LDA	#$1D
				STA	TEXTBUF,X
:1				JSR	RETURN

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "BUT IT | MISSES       | EVERYBODY."
*         | WHIZZES PAST |
*         | FLIES PAST   |
*         | BUZZES PAST  |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MSHOT_MISSES	LDA	SQUARE_HIT
				BNE	MSHOT_BLOCKED
				LDY	#xBut
				LDA	#xIt
				JSR	WORD2_INC
				JSR	WHIZ_SUB
				LDY	#xEverybody
				JSR	WORD1_PRDRET
				JMP	MSHOT_DONE

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "BUT IT'S BLOCKED AND HITS THE"
* "<monster> FOR 9999           "
* "DAMAGE.                      "
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MSHOT_BLOCKED	LDA	BLOCKED
				BEQ	MSHOT_HITS
				LDA	MONS_NUMBER
				PHA
				JSR	FIND_MONS
				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	GET_MDAM_TOTL
				LDY	#9				;S>9 But.Its.Blocked.And.Hits.The.RET
				JSR	SENTENCE_PRET	;    MonsName.For.9999.RET.Damage
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				LDA	ATOTAL1,X
				PHA
				TXA
				PHA
				JSR	BLINK_MONS
				JSR	DAMAGE_MONS
				PLA
				TAX
				PLA
				STA	ATOTAL1,X
				PLA
				STA	MONS_NUMBER
				JSR	POINTTO
				JMP	MSHOT_DONE

MSHOT_HITS		JSR	FIND_CHAR
				STA	CHAR_NUMBER
				JSR	POINTIT
				JSR	GET_CDAM_TOTL
				LDY	#34				;S>34 And.Hits.CharName
				JSR	SENTENCE_INC
				LDA	TOTAL_DAMAGEL
				ORA	TOTAL_DAMAGEH
				BEQ	MSHOT_WEAK

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "AND HITS <character> FOR"
* "9999 DAMAGE.            "
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#36				;S>36 For.RET.9999.Damage
				JSR	SENTENCE_PRET
				JSR	BLINK_CHAR
				JSR	DAMAGE_CHAR
				JMP	MSHOT_DONE

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "AND HITS <character> BUT IT IS"
* "SO WEAK THAT IS CAUSES NO     "
* "DAMAGE.                       "
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MSHOT_WEAK		LDY	#33				;S>33 But.It.Is.RET
				JSR	SENTENCE_PRET	;     So.Weak.That.It.Causes.No.RET
									;     Damage

MSHOT_DONE		JSR	DELAYER
				JSR	DRAW_IF_DEAD
				JSR	EOR_SHOT
				JSR	CLRBOX
				LDY	#monCRNTCMD+1
				LDA	(MONS_PTR),Y
				SEC
				SED
				SBC	#1
				CLD
				STA	(MONS_PTR),Y
				LDY	#monSHOTS
				LDA	(MONS_PTR),Y
				CMP	#$FF
				BEQ	:1
				SEC
				SBC	#1
				STA	(MONS_PTR),Y
				BEQ	:2
:1				LDY	#monCRNTCMD+1
				LDA	(MONS_PTR),Y
				BEQ	:2
				JSR	HALF_UP
				LDY	#monCMDCOUNT
				STA	(MONS_PTR),Y
				JMP	NOTIME
:2				JMP	MCOM

*-------------------------------
*
*-------------------------------

MSHOOT_GRID		JSR	CSBOT2
				LDA	#$40
				STA	PAGE
				LDA	#WHITE1
				STA	COLOR
				LDY	#0
				JSR	LINER

				LDA	MONS_NUMBER
				PHA
				LDA	#0
				STA	COUNT
:1				LDX	COUNT
				LDA	PECKS,X
				BMI	:2
				BEQ	:3
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				BEQ	:2
				_BlocksShots_
				JSR	ODDS_0123
				BCC	:2
				JSR	DRAW_ALIEN
:2				INC	COUNT
				BNE	:1				;Always
:3				PLA					;Set pointers back to
				STA	MONS_NUMBER		;  current monster
				JSR	POINTTO

				LDA	#0
				STA	COUNT
:4				JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#dead
				BEQ	:5
				_AimAccuracy_
				ASL
				ASL
				ASL
				ASL
				STA	TEMP
				LDA	#$90
				SEC
				SED
				SBC	TEMP
				CLD
				TAY
				JSR	FINAL_ODDS
				BCC	:5
				LDY	#upreflex
				LDA	(CHARDL),Y
				JSR	MUCHT
				LDA	COUNT
				JSR	OVALSUB
:5				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:4
				JMP	COPY_SHOTGRID

*-------------------------------
