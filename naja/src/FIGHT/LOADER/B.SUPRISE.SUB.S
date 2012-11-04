*================================================
* 1 in 4 chance of any suprising
* SCRATCH = (android intelligence-20)/2+SRANGE *
*   1.5 if vibration sensor
*   1.3 if organic or robotic detector
*   but not both
* Percent odds of character being suprised =
*   monsters ability to do so - SCRATCH
* Percent odds of monster being suprised =
*   monsters ability to be + SCRATCH
*================================================
**********************************
*** IF EITHER ODD IS 0 THEN DON'T
***   DO THE CALCULATIONS
**********************************

*** UNHOOKED RIGHT NOW --- SEEMS TO HANG !!!

SUPRISE_SUB		JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00000011
*BEQ :SKIPA
				RTS
:SKIPA			JSR	OTHER_ODDS
				STA	SCRATCH
				LDA	RANDOM1
				BMI	CHAR_FIRST
				JSR	MON_SUPRISE
				BCS	CHR_EXIT
CHR_SUPRISE		LDA	FORCE_SUPRISE
				AND	#Xchrsprd
				BNE	:SKIPA
				LDA	OPTIONS1
				AND	#Xchrsprd
				CLC
				BEQ	CHR_EXIT
				LDX	#$01
				JSR	BASE_ODDS
				LDA	SCRATCH
				SEC
				SED
				SBC	ODDS
				CLD
				STA	ODDS
				BCC	CHR_EXIT
				JSR	ODDER
				BCC	CHR_EXIT
:SKIPA			LDA	SUPRISED_FLAG
				ORA	#%01000000
				STA	SUPRISED_FLAG
				SEC
CHR_EXIT		RTS

CHAR_FIRST		JSR	CHR_SUPRISE
				BCS	MON_EXIT
MON_SUPRISE		LDA	FORCE_SUPRISE
				AND	#Xmonsprd
				BNE	:SKIPA
				LDA	OPTIONS1
				AND	#Xmonsprd
				CLC
				BEQ	MON_EXIT
				LDX	#$00
				JSR	BASE_ODDS
				LDA	SCRATCH
				CLC
				SED
				ADC	ODDS
				CLD
				STA	ODDS
				BCS	:SKIPA
				JSR	ODDER
				BCC	MON_EXIT
:SKIPA			LDA	SUPRISED_FLAG
				ORA	#%10000000
				STA	SUPRISED_FLAG
				SEC
MON_EXIT		RTS

BASE_ODDS		LDA	#0
				STA	ALIEN_NUMBER
				TAX
:LOOP1			LDY	ALIEN1,X
				INY
				BEQ	:SKIPA
				PHA
				LDA	ALIEN_NUMBER
				JSR	POINTALN
				PLA
				LDY	#aSuprised		;CHECK THIS = #$18 ???
				CMP	(ALIEN_PTR),Y
				BCC	:SKIPA
				LDA	(ALIEN_PTR),Y
:SKIPA			INC	ALIEN_NUMBER
				LDX	ALIEN_NUMBER
				CPX	#3
				BNE	:LOOP1
				RTS

OTHER_ODDS		JSR	RESET_CHLIST
				LDA	#android*16
				JSR	CSCAN_PROF
				BCS	GOT_ANDROID
NO_CHANCE		LDA	#$00
				RTS
GOT_ANDROID		TXA
				JSR	POINTIT
				LDY	#intelligence
				LDA	(CHARDL),Y
				SED
				SEC
				SBC	#$20			;Starts at 25 for all androids
				CLD
				BCC	NO_CHANCE
				TAX
				LDY	#0
				LDA	#$50
				JSR	PERCENT_OF
				TXA
				SED
				CLC
				ADC	SRANGE
				CLD
				BCC	:SKIPA
				LDA	#$99
:SKIPA			PHA

				LDY	#e14_FEET
				LDA	(CHARDL),Y
				CMP	#$42			;Scanners
				BNE	:SKIPB
				INY
				LDA	(CHARDL),Y
				CMP	#$05			;Vibration Sensor
				BNE	:SKIPB
				LDA	#$50			;Improves chances by 50%
				BNE	IMPROVE			;Always

:SKIPB			LDY	#e3_UPLFT
:LOOP1			LDA	(CHARDL),Y
				INY
				CMP	#$42			;Scanners
				BNE	:SKIPD
				LDA	(CHARDL),Y
				CMP	#$02			;Organic Detector
				BNE	:SKIPC
				BIT	ALTYPE1
				BMI	:SKIPD
				BPL	IMPROVE_30		;Always
:SKIPC			CMP	#$03
				BNE	:SKIPD
				BIT	ALTYPE1
				BMI	IMPROVE_30		;Always
:SKIPD			INY
				INY
				INY
				CPY	#e6_LWRGT+4
				BNE	:LOOP1
				PLA
				RTS

IMPROVE_30		LDA	#$30			;Improve chances by 30%
IMPROVE			TAY
				PLA
				PHA
				TAX
				TYA
				LDY	#0
				JSR	PERCENT_OF
				STX	TEMP
				PLA
				SED
				CLC
				ADC	TEMP
				CLD
				BCC	:SKIPA
				LDA	#$99
:SKIPA			RTS

ODDER			JSR	RAND09
				ASL
				ASL
				ASL
				ASL
				STA	SCRATCH
				JSR	RAND09
				ORA	SCRATCH
				CMP	ODDS
				BCC	:SKIPA
				BEQ	:SKIPA
				CLC
				RTS
:SKIPA			SEC
				RTS

RAND09			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$0F
				CMP	#$0A
				BCS	RAND09
				RTS
