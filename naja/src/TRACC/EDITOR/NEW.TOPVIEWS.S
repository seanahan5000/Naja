*-------------------------------

GRID_DRAW		LDA	#gridY
				STA	COUNTY
				LDA	#WHITE1
				STA	COLOR
VLOOP			LDA	#$C8
				STA	COUNTX
HLOOP			LDA	COUNTY
				LDX	COUNTX
				LDY	#$00
				CPX	#$80
				BCS	GODOT
				INY
GODOT			JSR	HPLOT
				LDA	COUNTX
				CLC
				ADC	#$0F
				STA	COUNTX
				CMP	#$22
				BNE	HLOOP
				LDA	COUNTY
				CLC
				ADC	#$0B
				STA	COUNTY
				CMP	#gridY+66
				BNE	VLOOP
				RTS

*-------------------------------

TV_DRAW			JSR	POINTAT_TV
				LDA	TV_DIMENS
				CMP	#$E0
				BCC	:1
				RTS
:1				LDA	#$C9
				STA	XPNT
				LDA	#gridY+1
				STA	YPNT
				LDA	DATPNTL
				STA	MODPNT+1
				LDA	DATPNTH
				STA	MODPNT+2
				LDA	TV_DIMENS
				BNE	:SKIPA
				LDA	#$11
:SKIPA			STA	COUNTER
				PHA
				LDA	TV_OFFSET
				PHA
				AND	#$0F
				CLC
				ADC	YPNT
				STA	YPNT
				PLA
				LSR
				LSR
				LSR
				LSR
				CLC
				ADC	XPNT
				STA	XPNT
				PHA
				LDX	#$00
				STX	POINTL
CLOOPY2			LDY	#$00
CLOOPX2			LDX	POINTL
MODPNT			LDA	$FFFF,X			;Modified
				BPL	INCX
				AND	#$7F
				CPY	#$06
				BNE	NOINCX
INCX			INC	POINTL
NOINCX			STA	CHARTAB,Y
				INY
				CPY	#$07
				BNE	CLOOPX2
				LDA	YPNT
				STA	YCOORD
				LDA	XPNT
				STA	XCOORD
				JSR	TABLER
				JSR	SHFTCLC
				JSR	CHAROUT
				LDA	COUNTER
				SEC
				SBC	#$10
				STA	COUNTER
				AND	#$F0
				BEQ	ROWED
				LDA	XPNT
				CLC
				ADC	#$07
				STA	XPNT
				BNE	CLOOPY2
ROWED			PLA
				TAX
				STX	XPNT
				LDA	YPNT
				CLC
				ADC	#$07
				STA	YPNT
				PLA
				SEC
				SBC	#$01
				STA	COUNTER
				AND	#$0F
				BEQ	CHOUT
				LDA	COUNTER
				PHA
				TXA
				PHA
				JMP	CLOOPY2
CHOUT			LDA	#$8D
				STA	XPNT
				RTS

*-------------------------------
