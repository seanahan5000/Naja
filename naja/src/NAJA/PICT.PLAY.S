*===============================
*
*===============================

PLAY_PICT		STX	PICT_ADR
				STY	PICT_ADR+1
:LOOP1			LDY	#0
				LDA	(PICT_ADR),Y
				INY
				ASL
				TAX
				LDA	OPCODES,X
				STA	:MOD1+1
				LDA	OPCODES+1,X
				STA	:MOD1+2
:MOD1			JSR	$FFFF			;Modified
				TYA
				CLC
				ADC	PICT_ADR
				STA	PICT_ADR
				BNE	:LOOP1
				INC	PICT_ADR+1
				BNE	:LOOP1			;Always

OPCODES			DW	Use1
				DW	Use2
				DW	Text
				DW	Line
				DW	Graphic
				DW	Call
				DW	Paint
				DW	Show1
				DW	Show2
				DW	Stop

*-------------------------------

Use1			LDA	#$20
				STA	PAGE
				RTS

*-------------------------------

Use2			LDA	#$40
				STA	PAGE
				RTS

*-------------------------------
*  color (byte)
*  address of standard line definition
*-------------------------------

Line			LDA	(PICT_ADR),Y
				STA	COLOR
				INY
				LDA	(PICT_ADR),Y
				STA	POINTL
				INY
				LDA	(PICT_ADR),Y
				STA	POINTH
				JSR	LINEOUT
				LDY	#4
				RTS

*-------------------------------
*  address of standard packed image
*-------------------------------

Graphic			LDA	(PICT_ADR),Y
				STA	TBLPNTL
				INY
				LDA	(PICT_ADR),Y
				STA	TBLPNTH
				JSR	EXPANDR
				LDY	#3
				RTS

*-------------------------------
* Address to call (low/high)
*-------------------------------

Call			LDA	(PICT_ADR),Y
				STA	:MOD1+1
				INY
				LDA	(PICT_ADR),Y
				STA	:MOD1+2
:MOD1			JSR	$FFFF			;Modified
				LDY	#3
				RTS

*-------------------------------

Show1			STA	PRIMARY
				RTS

*-------------------------------

Show2			STA	SCNDARY
				RTS

*-------------------------------

Stop			PLA
				PLA
				RTS

*-------------------------------
*  color (byte) {only handles black and white}
*  starting column (byte)
*  starting line (byte)
*  ending column (byte)
*  ending line (byte)
*-------------------------------

Paint			LDA	(PICT_ADR),Y
				STA	COLOR
				INY
				LDA	(PICT_ADR),Y
				STA	:MOD1+1			;starting column
				INY
				LDA	(PICT_ADR),Y
				TAX
				INY
				LDA	(PICT_ADR),Y
				STA	:MOD2+1			;ending column
				INY
				LDA	(PICT_ADR),Y
				STA	:MOD3			;ending line

:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
:MOD1			LDY	#$FF			;starting column
				LDA	COLOR
:LOOP2			STA	(SCREENL),Y
:MOD2			CPY	#$FF			;ending column
				INY
				BCC	:LOOP2
:MOD3			CPX	#$FF			;ending line
				INX
				BCC	:LOOP1
				LDY	#6
				RTS

*-------------------------------
*  starting X (byte/shift)
*  starting Y (byte)
*  chars/line (byte)
*  leading (byte)
*  text data
*-------------------------------

Text			LDA	(PICT_ADR),Y
				STA	HOLD_X-1,Y
				INY
				CPY	#6
				BNE	Text

				LDA	HOLD_Y
				STA	YCOORD

:LOOP1			LDA	HOLD_X
				STA	XCOORD
				LDA	HOLD_SHIFT
				STA	SHIFT

				LDY	#0
:LOOP2			LDA	(PICT_ADR),Y
				CMP	#$FF
				BEQ	:EXIT
				INY
				CMP	#$0A
				BEQ	:LOOP2

:SKIPA			LDX	#0
:LOOP3			STA	TEXTBUF,X
				INX
				CMP	#$8D
				BEQ	:LINE_DONE
				CPX	CHARS_LINE
				BEQ	:LOOP4			;word-wrap needed
				LDA	(PICT_ADR),Y
				INY
				BNE	:LOOP3			;Always

:LOOP4			DEY
				DEX
				LDA	(PICT_ADR),Y
				CMP	#$0A
				BNE	:LOOP4
				LDA	#$8D
				STA	TEXTBUF,X
				INY

:SKIPB			TYA
				CLC
				ADC	PICT_ADR
				STA	PICT_ADR
				BNE	:SKIPC
				INC	PICT_ADR+1
:SKIPC			JSR	LINE2
				LDA	YCOORD
				CLC
				ADC	LEADING
				STA	YCOORD
				BNE	:LOOP1			;Always

:EXIT			INY
				RTS

HOLD_X			DB	0
HOLD_SHIFT		DB	0
HOLD_Y			DB	0
CHARS_LINE		DB	0
LEADING			DB	0

*-------------------------------
