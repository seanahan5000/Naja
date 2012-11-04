*----------------------------------------------------------
* On Entry:
*   PH_DAMAGEL,H: Raw physical damage to inflict on char
*   EL_DAMAGEL,H: Raw electrical damage to inflict on char
*        POINTIT: Called for char to inflict damage upon
*
* On Exit:
*   TOTAL_DAMAGEL,H: Total damage to be inflicted on char
*----------------------------------------------------------

GET_CDAM_TOTL	LDY	#Eshielding
				LDA	(CHARDL),Y
				LDX	EL_DAMAGEL
				LDY	EL_DAMAGEH
				JSR	LESS_PERCENT
				STX	TOTAL_DAMAGEL
				STY	TOTAL_DAMAGEH

				LDY	#Pshielding
				LDA	(CHARDL),Y
				JMP	DAM_TOTL_COM


*----------------------------------------------------------
* On Entry:
*   PH_DAMAGEL,H: Raw physical damage to inflict on alien
*   EL_DAMAGEL,H: Raw electrical damage to inflict on alien
*        POINTTO: Called for alien to inflict damage upon
*
* On Exit:
*   TOTAL_DAMAGEL,H: Total damage to be inflicted on alien
*----------------------------------------------------------

GET_MDAM_TOTL	LDY	#monELSHIELD
				LDA	(MONS_PTR),Y
				LDX	EL_DAMAGEL
				LDY	EL_DAMAGEH
				JSR	LESS_PERCENT
				LDA	#susELECTRICAL
				JSR	SUSEPTABILITY
				STX	TOTAL_DAMAGEL
				STY	TOTAL_DAMAGEH

				LDY	#monPHSHIELD
				LDA	(MONS_PTR),Y
DAM_TOTL_COM	LDX	PH_DAMAGEL
				LDY	PH_DAMAGEH
				JSR	LESS_PERCENT
				LDA	#susPHYSICAL
				JSR	SUSEPTABILITY
				CLC
				SED
				TXA
				ADC	TOTAL_DAMAGEL
				STA	TOTAL_DAMAGEL
				TYA
				ADC	TOTAL_DAMAGEH
				STA	TOTAL_DAMAGEH
				CLD
				BCC	:EXIT
				LDA	#$99
				STA	TOTAL_DAMAGEL
				STA	TOTAL_DAMAGEH
:EXIT			RTS


*-------------------------------
*
*-------------------------------

SUSEPTABILITY	STX	TEMP
				STY	TEMP+1
				JSR	GET_SUSEPT
				LDX	TEMP
				LDY	TEMP+1
				LSR
				BCS	:SKIPA
				BNE	:EXIT
				LDX	#0
				LDY	#0
				RTS
:SKIPA			PHP
				STX	:MOD1+1
				STY	:MOD2+1
				LDA	#$50
				JSR	PERCENT_OF
				PLP
				BEQ	:EXIT
				SED
				CLC
				TXA
:MOD1			ADC	#$FF			;Modified
				TAX
				TYA
:MOD2			ADC	#$FF			;Modified
				TAY
				CLD
				BCC	:EXIT
				LDX	#$99
				LDY	#$99
:EXIT			RTS


*-------------------------------
*
*-------------------------------

GET_SUSEPT		TAY					;Must not use TEMP,+1
				AND	#%00000011
				TAX
				TYA
				LSR
				LSR
				CLC
				ADC	#aSusepts
				TAY
				LDA	(ALIEN_PTR),Y
				AND	:MASKS,X
:LOOP1			CPX	#3
				BEQ	:EXIT
				LSR
				LSR
				INX
				BNE	:LOOP1			;Always
:EXIT			RTS

:MASKS			DB	%11000000,%00110000,%00001100,%00000011

*-------------------------------

GET_SIZE_2		LDY	#aSusepts+1
				LDA	(ALIEN_PTR),Y
				AND	#%00000011
				ASL
				TAX
				RTS

*-------------------------------
