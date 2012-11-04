*** It is assumed that healings in inappropriate
***   directions have already been taken care of
***   outside of this routine.

*-------------------------------
*
*-------------------------------

HEALING			LDX	COMPNTR
				LDA	COMMAND+1,X
				STA	HEAL_AMOUNT
				LDA	COMMAND,X
				LSR
				LSR
				LSR
				LSR
				AND	#%00000011
				TAX
				LDA	HEAL_DIRECTNS,X
				CLC
				LDX	CHAR_NUMBER
				ADC	TEMPCHAR_XY,X
				JSR	CHAR_INDEXER
				LDA	MASTER_CGRID,Y
				BPL	HAVE_PATIENT
NO_HEALING		LDA	CHAR_NUMBER		;No patient in destination square
				JSR	POINTIT
				JMP	CCOM

HAVE_PATIENT	STA	PATIENT
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				EOR	HEAL_TYPE
				BMI	NO_HEALING		;Wrong healing type

				LDY	#damagelev
				LDA	(CHARDL),Y
				BNE	:SKIPA
				INY
				LDA	(CHARDL),Y
				CMP	HEAL_AMOUNT
				BCS	:SKIPA
				STA	HEAL_AMOUNT
:SKIPA			LDA	CHAR_NUMBER
				JSR	POINTIT
				LDA	HEAL_AMOUNT
				BNE	MAY_HEAL
				JMP	NO_HEALING

MAY_HEAL		LDA	HEAL_AMOUNT		;Hits to heal * energy per point
				LDX	ENERGY_USAGE+2	;   MUST be <= to 9999
				LDY	ENERGY_USAGE+1
				JSR	MULTIPLY_12
				LDX	#<PRODUCT_3
				LDY	#>PRODUCT_3
				CLC
				JSR	DRAINER_MAIN
				BCS	DOES_HEAL
				LDA	HEAL_AMOUNT
				SED
				SEC
				SBC	#$01
				CLD
				STA	HEAL_AMOUNT
				BCC	NO_HEALING		;No energy (just in case !!!)
				BCS	MAY_HEAL		;Always

DOES_HEAL		LDA	PRODUCT_3+2
				STA	ENERGY_L
				LDA	PRODUCT_3+1
				STA	ENERGY_H
				LDA	#0
				STA	TOTAL_DAMAGEH
				LDA	HEAL_AMOUNT
				STA	TOTAL_DAMAGEL
				JSR	CLEAR_TLINE1
				LDY	#xCharsName
				LDA	HEAL_TYPE
				ASL
				LDA	#0
				ADC	#xHeals
				JSR	WORD2_INC

				LDY	#x9999
				LDA	#xOf
				JSR	WORD2_RET
				LDA	PATIENT
				JSR	POINTIT
				JSR	CHAR_NAME
				JSR	APOSTROPHE_S
				LDY	#xDamage
				JSR	WORD1_PRDRET

				JSR	DAMAGR2
				LDY	PATIENT
				LDA	YPOINTS,Y
				STA	YPNT
				TAY
				LDA	#$8A
				JSR	LINE

				LDY	#damagelev+1	;Heal the damage
				SEC
				SED
				LDA	(CHARDL),Y
				SBC	HEAL_AMOUNT
				STA	(CHARDL),Y
				DEY
				LDA	(CHARDL),Y
				SBC	#$00
				STA	(CHARDL),Y

				LDY	#damagemax+1	;Check if character is
				LDA	(CHARDL),Y		;   no longer critical
				SEC
				LDY	#damagelev+1
				SBC	(CHARDL),Y
				TAX
				LDY	#damagemax
				LDA	(CHARDL),Y
				LDY	#damagelev
				SBC	(CHARDL),Y
				BNE	:SKIPA
				TXA
				CMP	#critical_amnt+1
				BCC	:SKIPB
:SKIPA			LDY	#status
				LDA	(CHARDL),Y
				AND	#$FF-critical
				STA	(CHARDL),Y
:SKIPB			CLD
				JSR	DAMAGR2
				LDY	YPNT
				LDA	#$8A
				JSR	LINE
				LDA	CHAR_NUMBER
				JSR	POINTIT
				JMP	TAKDELCLRCCOM

PATIENT			DB	0
HEAL_AMOUNT		DB	0
HEAL_TYPE		DB	0
HEAL_DIRECTNS	DB	$01,$10,$00,$F0
