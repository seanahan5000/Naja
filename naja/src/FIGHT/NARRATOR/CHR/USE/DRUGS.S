DRUGS			LDA	ETABLE+1
				CMP	#$09			;Reflex
				ROR	DRUG_TYPE

				LDY	EQUIP_OFFSET
				LDA	#$FF
				LDX	#3
:LOOP1			STA	(CHARDL),Y
				INY
				DEX
				BPL	:LOOP1

				JSR	CLEAR_TLINE1
				JSR	CHAR_NAME
				INX
				LDY	#xSniffs
				LDA	DRUG_TYPE
				ASL
				ADC	#xMuscle
				JSR	WORD2_PRDRET

				LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				CMP	#fast
				BEQ	OVER_DOSE
				CMP	#strong
				BEQ	OVER_DOSE
				LDY	#baseintellig
				LDA	(CHARDL),Y
				SEC
				SED
				SBC	#$05			;Brain damage amount
				CLD
				BCS	:SKIPA
				LDA	#0
:SKIPA			STA	(CHARDL),Y
				BEQ	OVER_DOSE
				BCS	GETS_HIGH

OVER_DOSE		LDA	#$99
				STA	TOTAL_DAMAGEL
				STA	TOTAL_DAMAGEH
				JSR	CDAMAGE_SUB
				LDA	#6
				JSR	CLEAR_TLINE
				LDX	#3
				LDA	#$29			;Asterisk
				STA	TEXTBUF
				STA	TEXTBUF+1
				STA	TEXTBUF+2
				JSR	CHAR_NAME
				INX
				LDY	#xDies
				LDA	#xInstantly
				JSR	WORD2_PRDRET
				JSR	DELAYER
				JSR	CLRBOX
				JSR	DRAW_IF_DEAD
				JMP	CCOM

GETS_HIGH		LDA	#fast
				BIT	DRUG_TYPE
				BMI	:SKIPA
				LDA	#strong
:SKIPA			LDY	#status			;Cures primary status !!
				EOR	(CHARDL),Y
				AND	#%00111111
				EOR	(CHARDL),Y
				STA	(CHARDL),Y
				LDA	CHAR_NUMBER
				ASL
				TAX
				LDA	#$02			;Time unit duration of drug affect
				STA	DURATION_TABL,X
				LDA	#$16			;Duration (low)
				STA	DURATION_TABL+1,X
				JSR	CALC_ALL
				JMP	DEL_CLR_CCOM

DRUG_TYPE		DB	0
