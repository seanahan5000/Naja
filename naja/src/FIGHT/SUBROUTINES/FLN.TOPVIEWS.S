*-------------------------------
*
*-------------------------------

DRAW_ALIEN		LDY	#monPOSITION
				LDA	(MONS_PTR),Y
DRAW_ALIEN_AT	JSR	ADJUST_XYPNTS
				LDX	TVIEW_HOLDPTR
				LDY	TVIEW_HOLDPTR+1
				LDA	TVIEW_DIMENS


*-------------------------------------------------------------
* On Entry:
*         X,Y: Address of shape to be drawn
*           A: High/low nibble width/height of shape in chars
*   XPNT,YPNT: X and Y screen coordinate to draw shape at
*-------------------------------------------------------------

DRAW_TOPVIEW	STX	POINTL
				STY	POINTH
				TAY
				AND	#%00001111
				STA	HEIGHT
				TYA
				LSR
				LSR
				LSR
				LSR
				STA	WIDTH
				PHA
				LDA	XPNT
				PHA

:LOOP1			LDY	#0
				LDX	#0
:LOOP2			LDA	(POINTL),Y
				BPL	:SKIPA
				AND	#$7F
				CPX	#6
				BNE	:SKIPB
:SKIPA			INY
:SKIPB			STA	CHARTAB,X
				INX
				CPX	#7
				BNE	:LOOP2

				TYA
				CLC
				ADC	POINTL
				STA	POINTL
				BCC	:SKIPC
				INC	POINTH
:SKIPC

				LDA	YPNT
				STA	YCOORD
				LDA	XPNT
				STA	XCOORD
				JSR	TABLER
				JSR	SHFTCLC
				JSR	CHAROUT

				DEC	WIDTH
				BEQ	:SKIPD
				LDA	XPNT
				CLC
				ADC	#7
				STA	XPNT
				BNE	:LOOP1			;Always

:SKIPD			DEC	HEIGHT
				BEQ	:EXIT
				PLA
				TAX
				STX	XPNT
				LDA	YPNT
				CLC
				ADC	#7
				STA	YPNT
				PLA
				PHA
				STA	WIDTH
				TXA
				PHA
				BPL	:LOOP1			;Always

:EXIT			PLA
				PLA
				RTS

WIDTH			DB	0
HEIGHT			DB	0


*---------------------------------------------
* On Entry:
*   A: Grid position byte
*
* On Exit:
*   XPNT,YPNT: Screen coordinates of top view
*---------------------------------------------

ADJUST_XYPNTS	SEC
				SBC	#$05
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XPNT
				LDA	YPNTS,Y
				SEC
				SBC	#$37
				STA	YPNT
				LDA	TVIEW_OFFSET
				TAX
				AND	#%00001111
				CLC
				ADC	YPNT
				STA	YPNT
				TXA
				LSR
				LSR
				LSR
				LSR
				CLC
				ADC	XPNT
				STA	XPNT
				RTS

*-------------------------------
