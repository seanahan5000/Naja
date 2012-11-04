*--------------------------------------------
* On Entry:
*   CHAR_NUMBER: Character doing aiming
*       POINTTO: Called for alien to aim at
*
* On Exit:
*   X: Closest position
*--------------------------------------------

SHORTEST_DIST	LDX	TVIEW_WIDTH
				DEX
				TXA
				ASL
				ASL
				ASL
				ASL
				STA	TEMP+1
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				AND	#%11110000
				STA	TEMP
				TAX
				CLC
				ADC	TEMP+1
				STA	TEMP+1
				LDY	CHAR_NUMBER
				LDA	TEMPCHAR_XY,Y
				AND	#%11110000
				CMP	TEMP
				BCC	:SKIPA
				BEQ	:SKIPA
				LDX	TEMP+1
				CMP	TEMP+1
				BCS	:SKIPA
				TAX
:SKIPA			STX	TEMP+1
				LDX	TVIEW_HEIGHT
				DEX
				STX	TEMP
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				AND	#%00001111
				SEC
				SBC	TEMP
				ORA	TEMP+1
				TAX					;fall through

*============================================================
* On Entry:
*   X: Position 1
*   Y: Position 2
*
* On Exit:
*   A: BCD Distance factor from 0 (closest) to 10 (farthest)
*
* Uses:
*   TEMP,+1
*============================================================

PRE_DISTANCER	LDY	CHAR_NUMBER
				LDA	TEMPCHAR_XY,Y
				TAY
DISTANCER		TXA
				STX	deDISTSRC1		;&&&
				STY	deDISTSRC2		;&&&
				PHA
				AND	#%00001111
				TAX
				TYA
				PHA
				AND	#%00001111
				TAY
				JSR	:SUBA
				STA	TEMP
				PLA
				LSR
				LSR
				LSR
				LSR
				TAX
				PLA
				LSR
				LSR
				LSR
				LSR
				TAY
				JSR	:SUBA
				CLC
				ADC	TEMP
				SBC	#0				;Carry assumed clear
				CMP	#$0A
				BCC	:EXIT
				LDA	#$10
:EXIT
				STA	deDISTANCE		;&&&
				RTS

:SUBA			STY	TEMP+1
				TXA
				SEC
				SBC	TEMP+1
				BCS	:SKIPA
				STX	TEMP+1
				TYA
				SEC
				SBC	TEMP+1
:SKIPA			RTS


*--------------------------------------------
* On Entry:
*             X: Position to aim at
*   CHAR_NUMBER: Character doing aiming
*       POINTIT: Called for aiming character
*
*   I = IQcurrent
*   U = UPREFLEXcurrent
* AIM = DISTANCE - ((I + U) / 20 - 1)) MAX 0
*--------------------------------------------

AIM_RATING		JSR	PRE_DISTANCER
				PHA

				LDY	#upreflex
				LDA	(CHARDL),Y
				TAX
				LDY	#intelligence
				LDA	(CHARDL),Y
				TAY
				JSR	AVERAGE_OF_2
				LSR
				LSR
				LSR
				LSR
				SED
				BEQ	:SKIPA
				SEC
				SBC	#1
:SKIPA			STA	TEMP
				PLA
				SEC
				SBC	TEMP
				CLD
				BCS	:EXIT
				LDA	#0
:EXIT
				STA	deAIMRATE		;&&&
				RTS

*-------------------------------
