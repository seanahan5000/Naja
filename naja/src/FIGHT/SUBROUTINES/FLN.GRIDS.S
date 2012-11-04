*-------------------------------------------
* On Entry:
*          A: Value to store in grid
*          X: Value ANDing mask
*          Y: Position (0 to 24)
*     XCOUNT: Width of area (1 to 5)
*     YCOUNT: Height of area (1 to 5)
*   POINTL,H: Address of grid to manipulate
*-------------------------------------------

FILL_GRID		STA	TEMP+1
				STY	TEMP
				PHA
				TXA
				AND	TEMP+1
				STA	TEMP+1
				PLA
:LOOP1			LDX	XCOUNT
:LOOP2			STA	(POINTL),Y
				LDA	TEMP+1
				INY
				DEX
				BNE	:LOOP2
				LDA	TEMP
				CLC
				ADC	#5
				STA	TEMP
				TAY
				LDA	TEMP+1
				DEC	YCOUNT
				BNE	:LOOP1
				RTS


*-----------------------------------------------------
* On Entry:
*          A: Value to look for (in addition to #$FF)
*          X: Horizontal position (0 to 4)
*          Y: Position (0 to 24)
*     XCOUNT: Width of area (1 to 5)
*     YCOUNT: Height of area (1 to 5)
*   POINTL,H: Address of grid to manipulate
*
* On Exit:
*        XCOUNT: Width of area (1 to 5)
*        YCOUNT: Height of area (1 to 5)
*   Carry clear: Selected area is empty
*     Carry set: Selected area has occupant
*-----------------------------------------------------

CHECK_GRID		STA	TEMP+1
				LDA	YCOUNT
				PHA
				TXA
				CLC
				ADC	XCOUNT
				CMP	#6
				BCS	:EXIT
				STY	TEMP
:LOOP1			LDX	XCOUNT
:LOOP2			CPY	#25
				BCS	:EXIT
				LDA	(POINTL),Y
				CMP	#$FF
				BEQ	:SKIPA
				CMP	TEMP+1
				BEQ	:SKIPA
				EOR	#%01000000
				CMP	TEMP+1
				SEC
				BNE	:EXIT
:SKIPA			INY
				DEX
				BNE	:LOOP2
				LDA	TEMP
				CLC
				ADC	#5
				STA	TEMP
				TAY
				DEC	YCOUNT
				BNE	:LOOP1
				CLC
:EXIT			PLA
				STA	YCOUNT
				RTS

*-------------------------------
