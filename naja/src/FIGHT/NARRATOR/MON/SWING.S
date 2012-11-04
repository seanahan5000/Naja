MON_SWING		JSR	VERBS_AT

				_CheatSwing
				BEQ	:1
				JSR	SWING_SUB
				BCC	EMPTY_MSWING
				LDY	#monCRNTCMD+1
				STA	(MONS_PTR),Y
:1
				LDY	#monSWINGS
				LDA	(MONS_PTR),Y
				BEQ	:2
				CMP	#$FF			;$FF = unlimited supply of swings
				BEQ	:2
				SEC
				SBC	#1
				STA	(MONS_PTR),Y
:2
				LDY	#monCRNTCMD+1
				LDA	(MONS_PTR),Y
				AND	#%00000111
				TAY
				LDA	MASTER_CGRID-1,Y
				BPL	FULL_MSWING

EMPTY_MSWING	JSR	RNDMIZE
				AND	#%00000011
				TAX
				LDY	:WORDS,X
				LDX	#0
				JSR	WORD1_PRDRET
				JMP	DELDEDCLRMCOM

:WORDS			DB	xNothing,xThinAir,xNobody,xAnEmptySquar

FULL_MSWING		STA	CHAR_NUMBER
				PHA
				JSR	POINTIT
				PLA
				JSR	COMCALC			;Get COMPNTR for character

				LDY	#aSwingDamage
				LDA	(ALIEN_PTR),Y
				STA	PH_DAMAGEH
				INY
				LDA	(ALIEN_PTR),Y
				STA	PH_DAMAGEL
				LDA	#0
				STA	EL_DAMAGEH
				STA	EL_DAMAGEL
				JSR	GET_CDAM_TOTL

				JSR	HIT_YESNO
				BCC	SMISSES
				JMP	MSWING_HITS

SMISSES			JSR	RNDMIZE
				BMI	SMISS2

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<cname> BUT IT ISN'T QUICK"
* "ENOUGH.  <cname> | DODGES | THE"
*                   | DUCKS  |
*                   | EVADES |
*                   | AVOIDS |
* "ATTACK AND IS NOT | DAMAGED |."
*                    | INJURED |
*                    | HARMED  |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SMISS1			LDX	#0
				LDY	#20				;S>20 CharsName.But.It.Isnt.Quick.RET
				JSR	SENTENCE_PRD	;    Enough
				JSR	CHAR_NAME
				INX
				LDA	RANDOM1
				AND	#%00000011
				CLC
				ADC	#xDodges
				TAY
				JSR	WORD1_INC
				LDY	#22				;S>22 The.RET.Attack.And.Is.Not
				JSR	SENTENCE_INC
				STX	TEMP
:2				JSR	RNDMIZE
				AND	#%00000011
				BEQ	:2
				CLC
				ADC	#xDamaged-1
				TAY
				LDX	TEMP
				JSR	WORD1_PRDRET
				JMP	DELDEDCLRMCOM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<cname> BUT | MISSES       |."
*              | MISSES BADLY |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SMISS2			LDX	#0
				LDY	#xCharsName
				LDA	#xBut
				JSR	WORD2_INC
				LDY	#xMisses
				BIT	RANDOM1
				BVC	:1
				JSR	WORD1_INC
				LDY	#xBadly
:1				JSR	WORD1_PRDRET
				JMP	DELDEDCLRMCOM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<cname> BUT THE BLOW IS SO"
* "WEAK THAT IS CAUSES NO DAMAGE."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
MSWING_HITS		LDX	#0
				LDA	TOTAL_DAMAGEH
				ORA	TOTAL_DAMAGEL
				BNE	MSWING_DAMAGE
				LDY	#19				;S>19 CName.But.The.Blow.Is.So.RET
				JSR	SENTENCE_PRET	;     Weak.That.It.Causes.No.Damage
				JMP	DELDEDCLRMCOM

MSWING_DAMAGE	LDY	#xCharsName
				LDA	#xAnd
				JSR	WORD2_INC
				STX	TEMP
				JSR	RNDMIZE
				AND	#%00000011
				PHA
				TAX
				LDY	:WORDS,X
				LDX	TEMP
				JSR	WORD1
				PLA
				LSR
				BEQ	:1
				INX
				LDY	#xFor
				JSR	WORD1
:1				JSR	RETURN
				LDY	#x9999
				LDA	#xDamage
				JSR	WORD2_PRDRET
				JSR	BLINK_CHAR
				JSR	DAMAGE_CHAR
				JMP	DELDEDCLRMCOM

:WORDS			DB	xCauses,xInflicts,xConnects,xHits

*-------------------------------

VERBS_AT		JSR	CLEAR_TLINE1
				JSR	MONS_NAME
				INX
				TXA
				PHA
				LDA	#0
				STA	TEMP
				LDX	#2
				LDY	#aSwingWords+2
:1				LDA	(ALIEN_PTR),Y
				AND	:MASKS,X
				STA	BUFFER_14,X
				ORA	TEMP
				STA	TEMP
				DEY
				DEX
				BPL	:1
				LDY	#xSwings
				LDA	TEMP
				BEQ	:4
:2				JSR	RNDMIZE
				AND	#%00000011
				BEQ	:2
				TAY
				DEY
:3				JSR	RNDMIZE
				AND	#%00000111
				STA	TEMP
				TAX
				LDA	BUFFER_14,Y
				BEQ	:2
				AND	BITMASKS,X
				BEQ	:3
				TYA
				ASL
				ASL
				ASL
				ORA	TEMP			;Carry assumed clear
				TAY
:4				PLA
				TAX
				LDA	#xAt
				JMP	WORD2_RET

:MASKS			DB	%11111111
				DB	%11111111
				DB	%11110000


*-----------------------------------------------------------
*   BASE = 40.00 (% odds of hitting when all else is equal)
*   DIFF = UPREFalien - UPREFcharacter
*   ODDS = ((( BASE + DIFF ) MAX 0 ) MIN 99 )
*-----------------------------------------------------------

HIT_YESNO		SED
				LDA	#$40
				CLC
				LDY	#monUPREF
				ADC	(MONS_PTR),Y
				STA	TEMP
				LDA	#0
				ADC	#0
				STA	TEMP+1
				SEC
				LDY	#upreflex
				LDA	TEMP
				SBC	(CHARDL),Y
				STA	TEMP
				LDA	TEMP+1
				SBC	#0
				STA	TEMP+1
				CLD
				BCC	:1
				SEC
				LDA	TEMP+1
				BNE	:1
				LDY	TEMP
				JMP	FINAL_ODDS
:1				RTS
