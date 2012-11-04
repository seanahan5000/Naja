*-----------------------------------
* Zero out highest and lowest bytes
*   of BASE and call MULTIPLY_BASE
*-----------------------------------

FRST_MULTIPLY	LDA	#0
				STA	BASE+0
				STA	BASE+3

*---------------------------------------------------
* On Entry:
*   BASE: Four byte multiplicand (High to Low)
*          (XXXX.XXXX)
*      Y: Ones and tens digits of multiplier
*      X: Tenths and hundreths digits of multiplier
*
* On Exit:
*   BASE: Result of multiplication (High to Low)
*      X: BASE+2
*      Y: BASE+1
*
* Uses:
*   TEMP,+1
*---------------------------------------------------

MULTIPLY_BASE	STX	TEMP
				STY	TEMP+1
				STX	deMPLIER+1		;&&&
				STY	deMPLIER		;&&&

				LDX	#3
:LOOP1			LDA	BASE,X
				STA	MBUFFER,X
				STA	deMBUFFER,X		;&&&
				LDA	#0
				STA	BASE,X
				DEX
				BPL	:LOOP1
				STA	MCARRY

				LDX	#3
:LOOP2			ASL	MBUFFER+3
				ROL	MBUFFER+2
				ROL	MBUFFER+1
				ROL	MBUFFER+0
				ROL	MCARRY
				DEX
				BPL	:LOOP2

				LDA	TEMP+1
				JSR	:SUBA
				LDA	TEMP
:SUBA			PHA
				LSR
				LSR
				LSR
				LSR
				JSR	:SUBB
				PLA
				AND	#%00001111
:SUBB			TAX
				BEQ	:SKIPB

:LOOP3			LDY	#3
				SED
				CLC
:LOOP4			LDA	BASE,Y
				ADC	MBUFFER,Y
				STA	BASE,Y
				DEY
				BPL	:LOOP4
				BCC	:SKIPA
				LDA	#$99
				STA	BASE+0
				STA	BASE+1
				STA	BASE+2
				STA	BASE+3
:SKIPA			CLD
				DEX
				BNE	:LOOP3

:SKIPB			LDX	#3
:LOOP5			LSR	MCARRY
				ROR	MBUFFER+0
				ROR	MBUFFER+1
				ROR	MBUFFER+2
				ROR	MBUFFER+3
				DEX
				BPL	:LOOP5
				LDX	BASE+2
				LDY	BASE+1
				STX	deMBASE+2		;&&&
				STY	deMBASE+1		;&&&
				LDA	BASE+0			;&&&
				STA	deMBASE+0		;&&&
				LDA	BASE+3			;&&&
				STA	deMBASE+3		;&&&
				RTS

MCARRY			DB	0				;Must be next to MBUFFER
MBUFFER			DB	0,0,0,0			;DO SOMETHING WITH THIS!!!


*----------------------------------
* Perform a (min 99) on the result
*   of the multiply
*----------------------------------

LAST_MULTIPLY	JSR	MULTIPLY_BASE
				LDA	BASE+0
				BEQ	:EXIT
				LDY	#$99
				STY	BASE+1
:EXIT			RTS


*------------------------------
* On Entry:
*   X: BCD number from 0 to 99
*   Y: BCD number from 0 to 99
*
* On Exit:
*   A: ((X + Y) / 2) MIN 99
*
* Uses:
*   TEMP,+1
*------------------------------

AVERAGE_OF_2	STY	TEMP
				TXA
				SED
				CLC
				ADC	TEMP
				STA	TEMP
				LDA	#0
				BCC	:SKIPA
				LDA	#$50
:SKIPA			STA	TEMP+1
:LOOP1			LDA	TEMP
				SEC
				SBC	#2
				STA	TEMP
				BCC	:SKIPB
				LDA	TEMP+1
				ADC	#1
				STA	TEMP+1
				BCC	:LOOP1
				LDA	#$99
				STA	TEMP+1
:SKIPB			CLD
				LDA	TEMP+1
				RTS


*--------------------------------------------
* On Entry:
*   Y: Chances in 99 of something being true
*
* On Exit:
*   Carry clear: False
*     Carry set: True
*
* Uses:
*   TEMP
*--------------------------------------------

FINAL_ODDS		TYA
				CLC
				BEQ	:EXIT
				PHA
				JSR	RND_0_TO_99
				STA	TEMP
				PLA
				SEC
				SBC	TEMP
:EXIT			RTS

*-------------------------------------------
* On Entry:
*   A: Chances in 3 of something being true
*
* On Exit:
*   Carry clear: False
*     Carry set: True
*-------------------------------------------

ODDS_0123		TAY
:1				JSR	RNDMIZE
				AND	#%00000011
				BEQ	:1
				STA	TEMP
				TYA
				CMP	TEMP
				RTS


*-------------------------------
* On Exit:
*   A: BCD number from 0 to 99
*
* Uses:
*   TEMP
*-------------------------------

RND_0_TO_99		LDA	#0
				JSR	:SUBA
				ASL
				ASL
				ASL
				ASL
:SUBA			STA	TEMP
:LOOP1			JSR	RNDMIZE
				AND	#%00001111
				CMP	#$0A
				BCS	:LOOP1
				ORA	TEMP
				RTS

*-------------------------------------
* On Entry:
*   A: Maximum value
*
* On Exit:
*   A: Number from 0 to maximum value
*
* Preserves X register
*-------------------------------------

RND_DIGIT_0		STA	TEMP
				STX	TEMP+1
:1				JSR	RNDMIZE
				AND	#%00001111
				CMP	TEMP
				BCC	:2
				BNE	:1
:2				LDX	TEMP+1
				RTS

*-------------------------------

BASE			DB	0,0,0,0			;MOVE THIS SOON (ZPAGE??)
