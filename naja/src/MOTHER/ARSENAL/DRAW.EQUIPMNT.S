DRAW_EQUIPMNT	LDA	DISPLAY
				CMP	#$01
				BNE	WANTNO1
				JSR	CLEAR1
				JMP	WANTNO2
WANTNO1			JSR	CLEAR2
WANTNO2			LDA	#BLUE
				STA	COLOR
				LDY	#$04
				JSR	LINER
				LDY	#$01
				JSR	TEXTER
				JSR	DONPE
				LDA	#GREEN
				STA	COLOR
				LDY	#$05
				JSR	LINER
				LDY	#$00
				JSR	TEXTER
				LDA	WANTED1
				CLC
				ADC	#$09
				TAY
				JSR	TEXTER
				LDA	WANTED1
				SEC
				SBC	#$0A
				CMP	#$01
				BNE	SINGLES
				LDY	#$00
DO4				TYA
				STA	TABLE4,Y
				INY
				CPY	#$03
				BNE	DO4
				LDA	#$0F
				STA	TABLE4+3
				BNE	MULTI			;Always

SINGLES			TAY
				LDA	GROUPER,Y
				STA	TABLE4
				LDA	#$0F
				STA	TABLE4+1
MULTI			LDA	#$00
				JSR	CNTDRAW
				JSR	DOBOXES
				LDY	LEAVLIN
				LDA	LINTABL,Y
				STA	TEXT2A+2
				STA	TEXT2B+2
				TAY
				LDX	#$67
				JSR	SHOW_CREDIT
				LDY	#$02
				JSR	TEXTER
				LDA	#$9C
				STA	XPNT
				LDA	TEXT2A+2
				STA	YPNT
				LDA	#1
				JSR	SPCHARS
				LDA	#$2C
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+1
				LDA	#$A3
				LDY	YCOORD
				JSR	LINE
				JSR	ISHERE
				LDA	#$FF
				JSR	CNTDRAW
				RTS					;TEMP

CNTDRAW			STA	DRAWFLG
				LDA	#$00
				STA	TABLCNT
				LDA	#$0E
				STA	LINUMB
				LDA	#$00
				STA	CTABCNT
				LDA	#$00
				STA	LINECNT
NXTGRP			LDY	TABLCNT
				LDA	LINECNT
				STA	TABLE2,Y
				TAX
				LDA	TABLE4,Y
				CMP	#$0F
				BNE	NOTLEAV
				LDA	TABLE2,Y
				CMP	TABLE2-1,Y
				BNE	NOT3
				LDA	LINUMB
				SEC
				SBC	#$02
				STA	LINUMB
NOT3			STX	LEAVLIN
				LDY	LINECNT
				LDA	LINUMB
				STA	LINTABL,Y
				RTS
NOTLEAV			JSR	COUNTUP
				LDA	TABLCNT
				INC	TABLCNT
				CMP	#$03
				BNE	NXTGRP
				RTS

COUNTUP			LDY	TABLCNT
				LDA	TABLE4,Y
				TAY
				ASL
				TAX
				LDA	STCKOFF,X
				STA	DATPNTL
				LDA	STCKOFF+1,X
				STA	DATPNTH
				LDA	MAXPER,Y
				STA	NUMBIN
				LDY	#$00
NEXTLP			LDA	(DATPNTL),Y
				BMI	NOTHERE
				BIT	DRAWFLG
				BVC	NOTDRAW
				JSR	DRAWEQP
NOTDRAW			LDX	LINECNT
				LDA	LINUMB
				STA	LINTABL,X
				CLC
				ADC	#$08
				STA	LINUMB
				INC	LINECNT
NOTHERE			INY
				CPY	NUMBIN
				BCC	NEXTLP
				LDA	LINUMB
				CLC
				ADC	#$02
				STA	LINUMB
				RTS

MAXPER			DB	$05,$04,$02
				DB	$07,$06,$05
				DB	$04,$0E,$06
				DB	$03,$0C

DRAWEQP			LDX	TABLCNT
				LDA	TABLE4,X
				ASL
				TAX
				LDA	CODEOFF,X
				STA	TEMP
				LDA	CODEOFF+1,X
				STA	TEMP+1
				TYA
				PHA
				LDA	CTABCNT
				INC	CTABCNT
				ASL
				TAY
				TXA
				STA	CURTABL,Y
				INY
				PLA
				PHA
				STA	CURTABL,Y
				ASL
				ASL
				TAY
				LDX	#$00
MOVEQP			LDA	(TEMP),Y
				STA	ETABLE,X
				INY
				INX
				CPX	#$04
				BNE	MOVEQP
				JSR	EQUIP1
				LDY	LINECNT
				LDA	LINTABL,Y
				STA	YPNT
				TAY
				LDA	#$0D
				JSR	LINE
				PLA
				JSR	STOCKER
				PHA
				JSR	TEXTER
				LDX	TABLCNT
				LDA	TABLE4,X
				ASL
				TAX
				LDA	PRICOFF,X
				STA	TEMP
				LDA	PRICOFF+1,X
				STA	TEMP+1
				PLA
				PHA
				STA	POINTL
				ASL
				CLC
				ADC	POINTL
				TAY
				LDX	#$01
TOBUFF			LDA	(TEMP),Y
				STA	THE_PRICE,X
				INY
				INX
				CPX	#$04
				BNE	TOBUFF
				LDA	#$00
				STA	THE_PRICE
				LDX	#<THE_PRICE
				LDY	#>THE_PRICE
				LDA	#$67
				STA	XPNT
				JSR	CREDIT_OUT
				JSR	ENERGY2
				LDA	#$0A
				JSR	CUTUP
				LDA	#$C5
				LDY	YPNT
				JSR	LINE
				PLA
				TAY
				RTS

STOCKER			PHA
				LDY	LINECNT
				LDA	LINTABL,Y
				STA	MANY+2
				STA	SOME+2
				STA	LOW+2
				STA	OUT+2
				PLA
				PHA
				TAY
				LDA	(DATPNTL),Y
				LDY	#$1E
				CMP	#$08
				BCS	HIENUFF
				INY
				CMP	#$03
				BCS	HIENUFF
				INY
				CMP	#$01
				BCS	HIENUFF
				INY
HIENUFF			PLA
				RTS

DOBOXES			LDA	#$01
				STA	COUNT
DOLOOP1			LDY	COUNT
				LDA	TABLE2,Y
				TAX
				LDA	LINTABL,X
				SEC
				SBC	#$02
				STA	GDLINE1+2
				STA	GDLINE2+2
				LDA	#GREEN
				STA	COLOR
				LDY	#$06
				JSR	LINER
				LDY	COUNT
				INC	COUNT
				LDA	TABLE2,Y
				CMP	LEAVLIN
				BNE	DOLOOP1
				TAY
				LDA	LINTABL,Y
				CLC
				ADC	#$08
				STA	GMBOX1+2
				STA	GMBOX2+2
				LDY	#$07
				JMP	LINER

DONPE			LDA	WHOPIC
				JSR	POINTIT
				LDY	#$09
NAMLOOP			LDA	(CHARDL),Y
				STA	TEXTBUF,Y
				DEY
				BPL	NAMLOOP
				LDA	#$8D
				STA	TEXTBUF+10
				LDA	#$4C
				LDY	#$A5
				JSR	LINE
				LDY	#$0D
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				TAX
				LDA	PROFOFF,X
				TAY
				CPX	#$09
				BNE	PRFCOLM
				LDY	#$5A
PRFCOLM			LDX	#$00
MORPRF			LDA	PROFDAT,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$09
				BNE	MORPRF
				LDA	#$8D
				STA	TEXTBUF,X
				LDA	#$4C
				LDY	#$AE
				JSR	LINE
				JSR	POWROUT
				LDX	#0
:LOOP1			LDA	TEXTBUF,X
				CMP	#$0A
				BNE	:SKIPA
				LDA	#$EE
				STA	TEXTBUF,X
				INX
				CPX	#5
				BNE	:LOOP1
:SKIPA			LDA	#$4C
				LDY	#$B7
				JMP	LINE
