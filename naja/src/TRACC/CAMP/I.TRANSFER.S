TRANSFR			LDA	LEFT1
				STA	RIGHT1
				JSR	BIGBOXR
				LDY	#$13
				JSR	TEXTER2
				LDY	RIGHT1	
				LDA	#$FF
				STA	LEGALS,Y
				JSR	MARKSUB
				LDA	#$00
				STA	GCURPOS
				LDA	RIGHT1	
				BNE	JUICIS1
				INC	GCURPOS
JUICIS1			JSR	PRE_ARROW
				JSR	GETKEY
				LDA	CURSOR
				CMP	#$07
				BNE	NOCANC2
				LDY	#$13
				JSR	TEXTER2
				LDA	#BLACK1	
				STA	COLOR
				LDY	#$03	
				JSR	LINER
				JSR	SWITCHU
TRANS_OUT		LDA	RIGHT1
				STA	LEFT1
				JSR	POINTIT
				LDA	#$04
				STA	CURSOR
				JSR	IMARKER
				LDA	#$03
				JMP	RDOPTN
NOCANC2			LDA	CURSOR
				STA	LEFT1	
				LDY	#$13
				JSR	TEXTER2
				LDA	#BLACK1	
				STA	COLOR
				LDY	#$03	
				JSR	LINER
				JSR	BOXCLR
				LDX	#$50
				LDY	#$32
				JSR	SWITU2
				LDA	#BLACK1
				STA	COLOR
				LDY	#$07	
				JSR	LINER
				LDA	#GREEN
				STA	COLOR
				LDY	#$08	
				JSR	LINER
				LDA	#$0E	
				STA	YPNT
				LDA	LEFT1
				JSR	STATLIN
				LDY	#$1E	
				JSR	TEXTER2
				LDA	#$04
				STA	CURSOR
				LDA	#$26
				STA	YPNT
				LDA	RIGHT1
				JSR	STATLIN
				LDY	#$1F	
				JSR	TEXTER2
				LDX	#$05
				LDA	#$0A
CLRSCNS			STA	ENRSCN1,X
				STA	ENRSCN2,X
				STA	ENERSCN,X
				STA	SCNBUFF,X
				DEX
				BPL	CLRSCNS
				LDA	LEFT1
				JSR	POINTIT
				LDY	#$26
				LDX	#$02
NLOOP1			LDA	(CHARDL),Y
				STA	ENRNEW1,X
				DEY
				DEX
				BPL	NLOOP1
				LDA	RIGHT1
				JSR	POINTIT
				LDY	#$26
				LDX	#$02
NLOOP2			LDA	(CHARDL),Y
				STA	ENRNEW2,X
				DEY
				DEX
				BPL	NLOOP2
				LDA	#$20
				STA	PAGE
				LDA	#$A0
				STA	YPNT
				JSR	FLIP1
				JSR	TUPPER
				JSR	FLIP1
				JSR	FLIP2
				JSR	TUPPER
				JSR	FLIP2
				LDA	#$40
				STA	PAGE
				JSR	ZCURSIT
ZBLINK			LDA	#$10
				JSR	WAIT
				LDA	#$F0
				JSR	WAIT2
				BMI	ZGOTKEY
				JSR	ZCURSIT
				LDA	#$00
				JSR	WAIT2
				JSR	ZCURSIT
ZKEYA			BIT	KEYBRD
				BPL	ZBLINK
ZKEY			LDA	KEYBRD
				BPL	ZKEY
ZGOTKEY			BIT	UNSTROB
				JSR	CHECK_LEFT
				BEQ	ZLEFT
				JSR	CHECK_RIGHT
				BEQ	ZRIGHT
				JSR	CHECK_UP
				BEQ	ZUP
				JSR	CHECK_DOWN
				BEQ	GOZDOWN
				CMP	#$C3
				BEQ	ZCANCEL	
				JSR	CHECK_ENTER
				BNE	ZKEY
				LDA	LEFT1
				JSR	POINTIT
				LDY	#$26
				LDX	#$02
ZFLOOP1			LDA	ENRNUM1,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	ZFLOOP1
				JSR	CALC_ALL
				LDA	RIGHT1
				JSR	POINTIT
				LDY	#$26
				LDX	#$02
ZFLOOP2			LDA	ENRNUM2,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	ZFLOOP2
				JSR	CALC_ALL
ZCANCEL			LDY	#$1F	
				JSR	TEXTER2
				LDX	#$31
				LDY	#$00
				JSR	SWITU2
				JMP	TRANS_OUT
GOZDOWN			JMP	ZDOWN
ZLEFT			LDA	CURSOR
				BEQ	ZLEFT1
				JSR	ZCURSIT
				DEC	CURSOR
				JSR	ZCURSIT
ZLEFT1			JMP	ZKEY
ZRIGHT			LDA	CURSOR
				CMP	#$04
				BEQ	ZRIGHT1
				JSR	ZCURSIT
				INC	CURSOR
				JSR	ZCURSIT
ZRIGHT1			JMP	ZKEY
ZUP				JSR	AMOSUB
				JSR	FLIP1
				LDA	LEFT1
				JSR	POINTIT
				JSR	ADDSUB
				TXA
				PHA
				JSR	FLIP1
				PLA
				BNE	BADUP
				JSR	FLIP2
				JSR	SUBSUB
				TXA
				PHA
				JSR	FLIP2
				PLA
				BNE	BADUP
				JSR	TUPDATE
BADUP			JMP	ZKEY
ZDOWN			JSR	AMOSUB
				JSR	FLIP1
				JSR	SUBSUB
				TXA
				PHA
				JSR	FLIP1
				PLA
				BNE	BADOWN
				JSR	FLIP2
				LDA	RIGHT1
				JSR	POINTIT
				JSR	ADDSUB
				TXA
				PHA
				JSR	FLIP2
				PLA
				BNE	BADOWN
				JSR	TUPDATE
BADOWN			JMP	ZKEY
PLUSMIN			DFB	$0C,$0C,$3F
				DFB	$0C,$0C,$00
				DFB	$3F
BIGBOXR			JSR	CLEAR1
				LDA	#$20
				STA	PAGE
				LDA	#GREEN
				STA	COLOR
				LDY	#$02	
				JSR	LINER
				LDA	#$42
				STA	SELECT
				LDA	#$02
				STA	YPNT
				JSR	HEADER
				LDY	#$12
				JSR	TEXTER2
				LDA	#$00
				STA	COUNT
ACYCLE			LDY	COUNT
				LDA	YPOINTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	ACYCLE
				LDA	#$40
				STA	PAGE
				JSR	SWITCHD
				LDY	#$03	
				JSR	LINER
				LDX	#$09	
				LDA	#$FF
LGLOOP2			STA	LEGALS,X
				DEX
				BMI	LEGED2
				CPX	GRPNUMB
				BCS	LGLOOP2
				LDA	#$00
				BEQ	LGLOOP2
LEGED2			LDA	#$00
				STA	LEGALS+7
				RTS
ZCURSIT			LDY	#$05
				LDA	#$00
ZLOOP1			STA	TEXTBUF,Y
				DEY
				BPL	ZLOOP1
				LDY	CURSOR
				LDA	#$01
				STA	TEXTBUF,Y
				LDA	#$8D
				STA	TEXTBUF+6
				LDA	#$BF	
				STA	XPNT
				LDX	#$00
ZLOOP2			LDA	TEXTBUF,X
				BNE	ZSKIP1
				LDA	#$0A
				STA	TEXTBUF,X
				LDA	XPNT
				CLC
				ADC	#$06
				STA	XPNT
				INX
				BNE	ZLOOP2
ZSKIP1			LDA	#$1A	
				STA	YPNT	
				LDX	#<PLUSMIN
				LDY	#>PLUSMIN
				LDA	#0
				JSR	DRAW_SHAPES
				LDA	#$C6	
				LDY	#$1A	
				JMP	LINE
AMOSUB			LDX	#$03
				LDA	#$00
ALOOP1			STA	AMOUNT,X
				DEX
				BPL	ALOOP1
				LDY	#$10
				LDA	CURSOR
				LSR	A
				TAX
				BCC	TENONE
				LDY	#$01
TENONE			TYA
				STA	AMOUNT,X
				RTS
FLIP1			LDA	#<ENRNUM1
				BNE	FLIPS
FLIP2			LDA	#<ENRNUM2
FLIPS			STA	FLOOP1+1
				STA	FLOOP2+1
				LDX	#$0B	
FLOOP1			LDA	ENRNUM1,X
				TAY
				LDA	ENERNUM,X
FLOOP2			STA	ENRNUM1,X
				TYA
				STA	ENERNUM,X
				DEX
				BPL	FLOOP1
				RTS
TUPDATE			JSR	FLIP1
				LDA	#$0E
				STA	YPNT
				JSR	TUPPER
				JSR	FLIP1
				JSR	FLIP2
				LDA	#$26
				STA	YPNT
				JSR	TUPPER
				JMP	FLIP2
TUPPER			LDX	#$00
				LDY	#$00
MORTOT			LDA	ENERNEW,Y
				PHA
				LSR	A
				LSR	A
				LSR	A
				LSR	A
				STA	SCNBUFF,X
				INX
				PLA
				AND	#$0F
				STA	SCNBUFF,X
				INX
				INY
				CPX	#$06
				BNE	MORTOT
				LDX	#$00
SPRTOT			LDA	SCNBUFF,X
				BNE	TSPACED
				LDA	#$0A
				STA	SCNBUFF,X
				INX
				CPX	#$05
				BNE	SPRTOT
TSPACED			LDX	#$05
ASERASE			LDA	ENERSCN,X
				CMP	SCNBUFF,X
				BNE	NOSAME1
				LDA	#$0A
NOSAME1			STA	TEXTBUF,X
				DEX
				BPL	ASERASE
				JSR	ETLINER
				LDX	#$05
ASDRAW			LDA	SCNBUFF,X
				CMP	ENERSCN,X
				BNE	NOSAME2
				LDA	#$0A
NOSAME2			STA	TEXTBUF,X
				DEX
				BPL	ASDRAW
				JSR	ETLINER
				LDX	#$05
MVLOOPA			LDA	SCNBUFF,X
				STA	ENERSCN,X
				CPX	#$03
				BCS	MVLOOPB
				LDA	ENERNEW,X
				STA	ENERNUM,X
MVLOOPB			DEX
				BPL	MVLOOPA	
				RTS
ETLINER			LDA	#$8D
				STA	TEXTBUF+6
				LDA	#$C6	
				LDY	YPNT	
				JMP	LINE
ADDSUB			LDX	#$02
				CLC
ADLOOP1			LDA	ENERNUM,X
				SED
				ADC	AMOUNT,X
				CLD
				STA	SCNBUFF,X
				DEX
				BPL	ADLOOP1
				BCS	BADADD
				LDA	#$00
				STA	SCRATCH
				LDY	#$29
				LDX	#$02
				SEC
SBLOOP1			LDA	SCNBUFF,X
				SED
				SBC	(CHARDL),Y
				CLD
				ORA	SCRATCH
				STA	SCRATCH
				DEY
				DEX
				BPL	SBLOOP1
				BCC	NOTBAD1	
				LDA	SCRATCH
				BNE	BADADD
NOTBAD1			LDX	#$02
TRLOOP1			LDA	SCNBUFF,X
				STA	ENERNEW,X
				DEX
				BPL	TRLOOP1
				INX
BADADD			RTS
SUBSUB			LDX	#$02
				SEC
SBLOOP2			LDA	ENERNUM,X
				SED
				SBC	AMOUNT,X
				CLD
				STA	SCNBUFF,X
				DEX
				BPL	SBLOOP2
				BCC	BADSUB
				LDA	SCNBUFF
				ORA	SCNBUFF+1
				ORA	SCNBUFF+2
				BEQ	BADSUB
				LDX	#$02
TRLOOP2			LDA	SCNBUFF,X
				STA	ENERNEW,X
				DEX
				BPL	TRLOOP2
				INX
BADSUB			RTS
BOXCLR			LDX	#$0B	
BXLOOP1			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#$27
				LDA	(SCREENL),Y
				AND	#$F0
				STA	(SCREENL),Y
BXLOOP2			DEY
				BEQ	BXSKIP
				LDA	#$00
				STA	(SCREENL),Y
				BEQ	BXLOOP2
BXSKIP			LDA	(SCREENL),Y
				AND	#$83
				STA	(SCREENL),Y
				INX
				CPX	#$4F
				BNE	BXLOOP1
				RTS

				DUMMY	$BB00
AMOUNT			DS	4

ENRNUM1			DS	3
ENRNEW1			DS	3
ENRSCN1			DS	6

ENRNUM2			DS	3
ENRNEW2			DS	3
ENRSCN2			DS	6

ENERNUM			DS	3
ENERNEW			DS	3
ENERSCN			DS	6

SCNBUFF			DS	6
				DEND
