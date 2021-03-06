
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/NDOS.VARS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/MHALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS

LINENUM			EQU	$00
BEGCOLM			EQU	$C1
START2			EQU	$C1
STARTS			EQU	$C1
POINT			EQU	$C1
LINE2x			EQU	$C2
COLUMN			EQU	$C2
COLUMN2			EQU	$C2	
LINECNT			EQU	$C2
TOPLINE			EQU	$C2
LINE4			EQU	$C4
COLUMN4			EQU	$C4	
DATACOL			EQU	$C4
NUMBER			EQU	$C4
LINUM2			EQU	$C4
PARTNUM			EQU	$C4
PICNUM			EQU	$C4
SCRATCH			EQU	$C5
GAP				EQU	$C5
LINUM4			EQU	$C5
STARTER			EQU	$C6
CYCLE			EQU	$C7
ARMDATL			EQU	$08
LNCDATL			EQU	$08
DATAL			EQU	$08
MOONL			EQU	$08
ARMDATH			EQU	$09
LNCDATH			EQU	$09
DATAH			EQU	$09
MOONH			EQU	$09
SPCOUNT			EQU	$CA
DATAPNT			EQU	$CA
ROW				EQU	$CB
LENGTH			EQU	$CC
HOWLONG			EQU	$CC
PITCH			EQU	$0D	
PARTL			EQU	$0D
PARTH			EQU	$0E
BEGLINE			EQU	$B2	
PBEGLIN			EQU	$B2	
ENDLINE			EQU	$B3	
MBEGLIN			EQU	$B3	
BEGROW			EQU	$B4	
ROWNUM			EQU	$B4	
ENDROW			EQU	$B5	
AWAIT1			EQU	$B6	
AWAIT2			EQU	$B7	
DUMMY1			EQU	$FF
SHIPARM			EQU	$FFFF			;DUMMY
DUMMY2			EQU	$FFFF
BUBBLES			EQU	$FFFF

; constants
BEGROWG			EQU	$00
BEGROWS			EQU	$10
ENDROWG			EQU	$0F
ENDROWS			EQU	$27
BEGLING			EQU	$35
BEGLINS			EQU	$51
ENDLING			EQU	$54
ENDLINS			EQU	$62
BEGROWA			EQU	$22	
ENDROWA			EQU	$28	
BEGLINA			EQU	$55
ENDLINA			EQU	$62
SOFBROW			EQU	$10
SOFEROW			EQU	$26	
TOPLIN			EQU	$93
BOTLINE			EQU	$BB
BROWPR			EQU	$0D
BROWES			EQU	$10
BROWEN			EQU	$13
BROWTS			EQU	$16
EROWPR			EQU	$0F
EROWES			EQU	$12
EROWEN			EQU	$15
EROWTS			EQU	$18
APITCH1			EQU	$10	
APITCH2			EQU	$01

;
; Draw star field
;
				BIT	KEYBRD
				BPL	NOKEY7
				JMP	MESSAGE
NOKEY7			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				STA	SCNDARY
STARER			LDA	#$00
				STA	LINENUM
MORSTAR			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	#$27
MORELIN			JSR	RNDMIZE
				LDA	RANDOM1
				CMP	#$07
				BCS	TOOBIG
				TAX
				LDA	STARS,X
				TAX
				BIT	RANDOM1+1
				BPL	GREVIO
				TXA
				ORA	#$80
				JMP	STOREIT
GREVIO			TYA
				PHA
				AND	#$01
				TAY
				LDA	MASK,Y
				STA	SCRATCH
				TXA
				AND	SCRATCH
				BEQ	OKAY
				PLA
				TAY
				JMP	TOOBIG
OKAY			PLA
				TAY
				TXA
STOREIT			STA	(SCREENL),Y
TOOBIG			DEY
				BPL	MORELIN
				LDA	LINENUM
				INC	LINENUM
				CMP	#$BF
				BNE	MORSTAR
STAREND			LDA	#$00
				STA	POINT
MORSM2			LDY	POINT
				LDA	SPOTS,Y
				STA	LINENUM	
				LDA	#$00
				STA	LINECNT
				INY
				LDA	SPOTS,Y
				TAY	
MORSMAL			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDX	LINECNT
				LDA	SMALL1,X
				STA	(SCREENL),Y
				INC	LINENUM
				LDA	LINECNT
				INC	LINECNT
				CMP	#$02
				BNE	MORSMAL
				INC	POINT	
				LDA	POINT		
				INC	POINT	
				CMP	#$0B
				BNE	MORSM2
				LDA	#$12
				STA	LINENUM
				LDA	#$00
				STA	POINT
MORBIG2			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	#$1A
MORBIG1			LDX	POINT
				LDA	BIG1,X
				STA	(SCREENL),Y
				INC	POINT
				INY
				CPY	#$1C
				BNE	MORBIG1
				LDA	LINENUM
				INC	LINENUM
				CMP	#$1E
				BNE	MORBIG2
				STA	PRIMARY
				LDA	#<SPACESHIP
				STA	TBLPNTL
				LDA	#>SPACESHIP
				STA	TBLPNTH
				JSR	EXPANDR
				LDA	#$20
				STA	MOVEA+1
				LDA	#$26
				STA	MOVMOR1+1
				LDA	#$0D	
				STA	MOVMOR2+1
				LDA	#$5C
				STA	LINE2x
				LDA	#$00
				STA	LINE4
				LDA	#$14
				STA	BEGROW
				LDA	#$22
				STA	ENDROW
				LDA	#$6A
				STA	ENDLINE
				JSR	STARMOV
				LDA	#$3B
				STA	LINE2x
				LDA	#$00
				STA	LINE4
				LDA	#$00
				STA	BEGROW
				LDA	#$08
				STA	ENDROW
				LDA	#$56
				STA	ENDLINE
				JSR	STARMOV
				LDA	#$3B
				STA	NXTSTEP+1	
				LDA	#$0D	
				STA	MOVMOR1+1
				LDA	#$26
				STA	MOVMOR2+1
;
; Slide space ship in three passes.
;
SLOOP			BIT	KEYBRD
				BPL	NOKEY10
				JMP	GOMESS1
NOKEY10			JSR	SLIDEIN
				LDA	#$80	
				STA	$223A
				STA	$263A
				STA	$3AB8
				STA	$3EB8
				LDA	#$3B	
				STA	LINE2x	
				LDA	#$00	
				STA	LINE4	
				JSR	STARMOV
				LDA	NXTSTEP+1	
				INC	NXTSTEP+1	
				CMP	#$3D
				BNE	SLOOP
				JMP	ARMIN
;
; Draw one pass of space ship slide.
;
SLIDEIN			LDA	#$01
				STA	START2
NXTSTEP			LDA	#$3B
				STA	LINENUM
NEXTROW			LDA	START2
				STA	COLUMN2
				LDA	#$27
				STA	COLUMN4
				LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
NEXTCOL			LDY	COLUMN4
				LDA	(SCREENL),Y
				CMP	#$80
				BEQ	NOSTORE	
				LDY	COLUMN2
				STA	(DESTINL),Y
NOSTORE			LDA	CLICK
				DEC	COLUMN4	
				DEC	COLUMN2	
				LDA	COLUMN2	
				BPL	NEXTCOL	
				LDA	LINENUM
				INC	LINENUM
				INC	LINENUM
				INC	LINENUM
				CMP	#$8C	
				BCC	NEXTROW
				LDA	START2
				INC	START2
				INC	START2
				CMP	#$27
				BNE	NXTSTEP
				RTS

STARS			DFB	$01,$02,$04
				DFB	$08,$10,$20
				DFB	$40	
MASK			DFB	$55,$2A
SMALL1			DFB	$08,$1C,$08
SPOTS			DFB	$B1,$17,$1A
				DFB	$07,$2F,$1D
				DFB	$BA,$19,$97
				DFB	$06,$5B,$0C
BIG1			DFB	$00,$01,$00	
				DFB	$01,$00,$01
				DFB	$40,$03,$40
				DFB	$03,$60,$07
				DFB	$7A,$5F,$60
				DFB	$07,$40,$03
				DFB	$40,$03,$00
				DFB	$01,$00,$01
				DFB	$00,$01
;
; Move data from page 1 to 2
;
STARMOV			LDX	LINE2x
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
MOVEA			ORA	#$20
				STA	SCREENH
				LDX	LINE4
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				LDY	BEGROW
MOVMOR1			LDA	(SCREENL),Y
MOVMOR2			STA	(DESTINL),Y
				CPY	ENDROW
				BEQ	ROWDONE
				INY
				JMP	MOVMOR1
ROWDONE			LDA	LINE2x
				INC	LINE2x
				INC	LINE4
				CMP	ENDLINE
				BNE	STARMOV	
				RTS
;
; Slide ship arm over then down
;
ARMIN			LDA	#$00
				JSR	WAIT
				LDA	#APITCH1
				STA	AWAIT1
				LDA	#APITCH2
				STA	AWAIT2
				LDA	#$1C	
				STA	STARTS	
TIMEA			LDA	#$5C	
				STA	LINENUM
				LDA	STARTS
				LSR	A
				BCS	EVENCOL
				LDA	#<ARM_ODD
				STA	ARMDATL
				LDA	#>ARM_ODD
				STA	ARMDATH
				JMP	NOTHROW
EVENCOL			LDA	#<ARM_EVEN
				STA	ARMDATL
				LDA	#>ARM_EVEN
				STA	ARMDATH
NOTHROW			LDA	#$13	
				STA	DATACOL
				LDA	STARTS	
				STA	COLUMN
				LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
MOROFRW			LDY	DATACOL
				LDA	(ARMDATL),Y
				LDY	COLUMN
				CPY	#$23
				BCC	NOWORRY
				CPX	#$62	
				BCS	NOWORRY
				ORA	(SCREENL),Y
NOWORRY			STA	(SCREENL),Y
				DEC	AWAIT1
				BNE	DO2
				LDA	CLICK
				LDA	#APITCH1
				STA	AWAIT1
DO2				DEC	AWAIT2
				BNE	NODO
				LDA	CLICK
				LDA	#APITCH2
				STA	AWAIT2
NODO			DEC	DATACOL	
				LDA	COLUMN	
				DEC	COLUMN	
				CMP	#$14	
				BNE	MOROFRW
				LDA	ARMDATL
				CLC
				ADC	#$14	
				STA	ARMDATL
				BCC	NOCARRY	
				INC	ARMDATH
NOCARRY			LDA	LINENUM
				INC	LINENUM
				CMP	#$6B	
				BNE	NOTHROW
				LDA	#$D0	
				JSR	WAIT
				LDA	STARTS	
				INC	STARTS	
				CMP	#$25	
				BEQ	NOTIME	
				JMP	TIMEA
NOTIME			BIT	KEYBRD
				BPL	:SKIPA
				JMP	GOMESS1
:SKIPA			LDA	#$40
				STA	MOVEA+1
				LDA	#$0D	
				STA	MOVMOR1+1
				LDA	#$26
				STA	MOVMOR2+1
				LDA	#$5C
				STA	LINE2x
				LDA	#$00
				STA	LINE4
				LDA	#$14
				STA	BEGROW
				LDA	#$22
				STA	ENDROW
				LDA	#$6A
				STA	ENDLINE
				JSR	STARMOV
				LDA	#$20
				STA	MOVEA+1
				LDA	#$26
				STA	MOVMOR1+1
				LDA	#$0D	
				STA	MOVMOR2+1
				LDA	#$6C	
				STA	LINE2x
				LDA	#$6C	
				STA	LINE4
				LDA	#$14
				STA	BEGROW
				LDA	#$26
				STA	ENDROW
				LDA	#$87
				STA	ENDLINE
				JSR	STARMOV
				LDA	#$5C	
				STA	BEGLINE
LOOPINX			LDA	#$01
				STA	SPCOUNT
				LDA	#$01
				STA	BEGCOLM
				LDX	BEGLINE
				STX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
				LDY	#$13	
MOVMORE			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	#$26	
				BNE	MOVMORE
				LDA	#$00
				STA	LINECNT
				LDA	#<ARM_EVEN
				STA	NOTYET+1
				STA	YET2+1
				STA	YET3+1
				STA	YET4+1
				STA	YET5+1
				STA	YET6+1
				LDA	#>ARM_EVEN
				STA	NOTYET+2
				STA	YET2+2
				STA	YET3+2
				STA	YET4+2
				STA	YET5+2
				STA	YET6+2
				LDX	#$02
				INC	LINENUM
LOOPIN0			LDY	LINENUM
				LDA	LOBYTES,Y
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,Y
				ORA	#$20
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
				LDA	LINENUM
				CMP	#$77
				BCC	NODIAG
				CMP	#$85
				BCC	STILL
				LDX	#$00
YET5			LDA	SHIPARM,X
				LDY	#$12
				STA	(DESTINL),Y
				INX
YET6			LDA	SHIPARM,X
				INY
				STA	(DESTINL),Y
				LDX	#$02
				JMP	NODIAG
STILL			LDX	BEGCOLM
				BNE	YET4	
				LDX	#$01
YET3			LDA	SHIPARM,X
				LDY	#$13	
				STA	(DESTINL),Y
				LDX	BEGCOLM
YET4			LDA	SHIPARM,X
				LDY	SPCOUNT
				AND	MASKS,Y
				PHA
				TXA
				CLC
				ADC	#$12
				TAY
				PLA
				ORA	(SCREENL),Y
				STA	(DESTINL),Y
				LDX	#$02
NODIAG			LDY	#$14
LOOPIN1			CPY	#$23
				BCC	NOTYET
				LDA	LINECNT
				CMP	#$05
				BCS	NOTYET
YET2			LDA	SHIPARM,X	
				ORA	(SCREENL),Y
				AND	#$7F
				JMP	SAMTING
NOTYET			LDA	SHIPARM,X
				CMP	#$80
				BNE	SAMTING
				LDA	(SCREENL),Y
SAMTING			STA	(DESTINL),Y
				LDA	CLICK
				LDA	CLICK
				INY
				INX
				CPY	#$26
				BNE	LOOPIN1
				LDX	#$02	
				LDA	NOTYET+1
				CLC
				ADC	#$14
				STA	NOTYET+1
				STA	YET2+1
				STA	YET3+1
				STA	YET4+1
				STA	YET5+1
				STA	YET6+1
				BCC	NOTCARY
				INC	NOTYET+2
				INC	YET2+2
				INC	YET3+2
				INC	YET4+2
				INC	YET5+2
				INC	YET6+2
NOTCARY			LDA	LINENUM
				CMP	#$77
				BCC	NOSPEC
				LDA	SPCOUNT
				INC	SPCOUNT
				CMP	#$07	
				BNE	NOSPEC
				LDA	#$01
				STA	SPCOUNT
				DEC	BEGCOLM
NOSPEC			INC	LINENUM
				LDA	LINECNT
				INC	LINECNT
				CMP	#$0F	
				BEQ	NOLOOP0
				JMP	LOOPIN0
NOLOOP0			LDA	#$80	
				JSR	WAIT	
				INC	BEGLINE
				LDA	BEGLINE
				CMP	#$78	
				BEQ	LAUNCHR	
				JMP	LOOPINX

MASKS			DFB	$00,$40,$60	
				DFB	$70,$78,$7C	
				DFB	$7E,$7F	

LAUNCHR			BIT	KEYBRD
				BPL	NOKEY11
				JMP	GOMESS1
NOKEY11			LDA	#$00
				JSR	WAIT
				JSR	WAIT
				JSR	WAIT
				LDA	#$14	
				STA	STARTS
LAUNCHA			LDA	#$60
				STA	LINENUM
				LDA	STARTS
				LSR	A
				BCC	EVNCOL
				LDA	#<LAUNCH_ODD
				STA	LNCDATL
				LDA	#>LAUNCH_ODD
				STA	LNCDATH
				JMP	GOROW	
EVNCOL			LDA	#<LAUNCH_EVEN
				STA	LNCDATL
				LDA	#>LAUNCH_EVEN
				STA	LNCDATH
GOROW			LDA	#$06
				STA	DATACOL
				LDA	STARTS
				STA	COLUMN
				LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
GOROW2			LDY	DATACOL
				LDA	(LNCDATL),Y
				LDY	COLUMN
				CMP	#$80
				BNE	SKIPPER
				LDA	SCREENH
				TAX
				EOR	#$60	
				STA	SCREENH
				LDA	(SCREENL),Y
				STX	SCREENH
SKIPPER			STA	(SCREENL),Y
				DEC	DATACOL
				LDA	COLUMN
				DEC	COLUMN
				CMP	#$14
				BNE	GOROW2
				LDA	LNCDATL
				CLC
				ADC	#$07
				STA	LNCDATL
				BCC	NOTCARR
				INC	LNCDATH
NOTCARR			LDA	LINENUM
				INC	LINENUM
				CMP	#$75
				BNE	GOROW

				LDA	#$A0	
				JSR	WAIT	
				LDA	STARTS
				INC	STARTS
				CMP	#$1A
				BNE	LAUNCHA

				LDA	#$00
				JSR	WAIT
				JSR	WAIT
				LDA	#$40	
				STA	PAGE
				LDA	#$80
				STA	$0330
				JSR	CLEAR2
				LDA	#$17	
				STA	BEGROW
				LDA	#$1A	
				STA	ENDROW
				LDA	#$64
				STA	TOPLINE
				LDA	#$75
				STA	ENDLINE
				LDA	#$20
				STA	PAGE
				LDA	#$C6
				STA	HERE2A
				STA	HERE2
				JSR	CLOOP
				LDA	#$E6
				STA	HERE2A
				STA	SCNDARY
				JSR	CLEAR1
				LDA	#$78
				STA	$0330
				DEC	TOPLINE
				DEC	ENDLINE

				LDX	ENDLINE
				INX
				INX
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#$27
				LDA	#$80
:LOOP0			STA	(SCREENL),Y
				DEY
				BPL	:LOOP0

				LDA	#$00
				SEC
:LOOP1			PHA
:LOOP2			BIT	$C057
				BMI	:SKIPA
				SBC	#$01
				BNE	:LOOP2
				PLA
				SBC	#$01
				BNE	:LOOP1
				BEQ	:SKIPB			;Always
:SKIPA			PLA
:SKIPB

NOTLAST			LDA	#$40
				STA	PAGE
				LDA	#$00
				STA	BEGROW
				LDA	#$03
				STA	ENDROW
				JSR	CDRAW
				LDA	#$20
				STA	PAGE
				JSR	CDRAW2
				JSR	CLOOP2	
				BIT	KEYBRD
				BPL	NOKEY1
				STA	PRIMARY
				JMP	MESSAGE
NOKEY1			LDA	ENDLINE
				SEC
				SBC	#$08	
				STA	ENDLINE
				LDA	TOPLINE
				CMP	#$43
				BEQ	CDONE
				SEC
				SBC	#$08	
				STA	TOPLINE
				CMP	#$43
				BNE	NOTLAST
				LDA	#$0D	
				STA	CPNT+1
				JMP	NOTLAST
CDONE			LDA	#$27
				STA	CPNT+1
				LDA	#$00
				JSR	WAIT
				JMP	GFADE
CLOOP			LDA	#$1F	
				STA	PITCH
				LDA	#$00
				STA	POINT
CLOOPA			JSR	CDRAW
				LDA	BEGROW
				CMP	#$27
				BEQ	CEXIT
				INC	BEGROW
				INC	ENDROW
				LDA	#$30	
				STA	LENGTH
				JSR	NOISE
				JSR	CDRAW
				LDA	#$30	
				JSR	WAIT	
				JMP	CLOOPA	
CEXIT			RTS

CLOOP2			STA	PRIMARY
				LDA	#$3F	
				JSR	WAIT
				LDY	#$0A	
GOWAIT			PHA
				PLA
				DEY
				BPL	GOWAIT
				NOP
				NOP
				LDA	#$40
				STA	PAGE
				JSR	CDRAW
				INC	BEGROW
				INC	ENDROW
				JSR	CDRAW2
				STA	SCNDARY
				LDA	#$3C	
				JSR	WAIT
				LDA	#$20
				STA	PAGE
				JSR	CDRAW
				LDA	BEGROW
CPNT			CMP	#$27
				BEQ	CEXIT2
				INC	BEGROW
				INC	ENDROW
				JSR	CDRAW2
				JMP	CLOOP2
CEXIT2			RTS

CDRAW2			INC	BEGROW	
				INC	ENDROW
				JSR	CDRAW
				DEC	BEGROW
				DEC	ENDROW	
				RTS
;
; Draw the flying letter "C"
;
CDRAW			LDA	TOPLINE
				STA	LINENUM
				LDA	#$00
				STA	POINT
CMORE0			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	BEGROW
CMORE1			LDX	POINT
				LDA	CDATA,X
				CPY	#$28
				BCS	OFFIT
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
OFFIT			INC	POINT
				CPY	ENDROW
				BEQ	ROWOVER
				INY
				JMP	CMORE1
ROWOVER			LDA	LINENUM
				INC	LINENUM
				CMP	ENDLINE
				BNE	CMORE0
				RTS

GFADE			LDA	#BEGROWG
				STA	BEGROW
				LDA	#ENDROWG	
				STA	ENDROW
				LDA	#BEGLING
				STA	BEGLINE
				LDA	#ENDLING
				STA	ENDLINE
				LDA	#<GRAPHIC
				STA	LOOPNT1+1
				LDA	#>GRAPHIC
				STA	SPOT1+1
				LDA	#$04
				STA	HERE+1
				LDA	#$EA
				STA	HERE2
				STA	HERE2+1
				JSR	FADEIN
				BIT	KEYBRD
				BPL	NOKEY2
				STA	PRIMARY
				JMP	MESSAGE
NOKEY2			LDA	#$00
				JSR	WAIT
				LDA	#BEGROWA
				STA	BEGROW
				LDA	#ENDROWA
				STA	ENDROW
				LDA	#BEGLINA
				STA	BEGLINE
				LDA	#ENDLINA
				STA	ENDLINE
ESOVER1			LDA	#$00
				STA	DATAPNT
				LDA	BEGLINE
				STA	LINENUM
ESOVER2			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	BEGROW
ESOVER3			LDX	DATAPNT
				LDA	ES,X
				STA	(SCREENL),Y
				INY
				INC	DATAPNT
				CPY	ENDROW
				BNE	ESOVER3
				LDA	LINENUM
				INC	LINENUM
				CMP	ENDLINE
				BNE	ESOVER2
				BIT	KEYBRD
				BPL	NOKEY3
				STA	PRIMARY
				JMP	MESSAGE
NOKEY3			LDA	#$60
				JSR	WAIT
				LDA	BEGROW
				DEC	BEGROW
				DEC	ENDROW
				CMP	#$0D
				BNE	ESOVER1
				LDA	#$00
				JSR	WAIT
				LDA	#BEGROWS
				STA	BEGROW
				LDA	#ENDROWS
				STA	ENDROW
				LDA	#BEGLINS
				STA	BEGLINE
				LDA	#ENDLINS
				STA	ENDLINE
				LDA	#<SIMULATIONS	
				STA	LOOPNT1+1
				LDA	#>SIMULATIONS
				STA	SPOT1+1
				LDA	#$06
				STA	HERE+1
				LDA	#$E6
				STA	HERE2
				LDA	#PITCH
				STA	HERE2+1
				JSR	FADEIN
				BIT	KEYBRD
				BPL	NOKEY4
				STA	PRIMARY
				JMP	MESSAGE
NOKEY4			JMP	SOFTUP
;
; Fade in a word ("Graphic" or "Simulation")
;
FADEIN			LDA	#$00
				STA	STARTER
				STA	CYCLE
				STA	POINT
				LDA	#$01	
				STA	PITCH
LOOPNT1			LDA	#DUMMY1
				STA	DATAL
SPOT1			LDA	#DUMMY1
				STA	DATAH
				LDA	BEGLINE
				STA	LINENUM
LOOPNT2			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDA	BEGROW
				STA	ROW
LOOPNT3			LDY	#$00
				LDA	(DATAL),Y
				LDX	CYCLE
				AND	GSMASKS,X
				LDY	ROW
				ORA	(SCREENL),Y
				STA	(SCREENL),Y
				INC	DATAL
				BNE	NOCARYD
				INC	DATAH
NOCARYD			LDA	CYCLE
				INC	CYCLE
				CMP	#$06
				BNE	NOMOD
				LDA	#$00
				STA	CYCLE
NOMOD			LDA	ROW
				INC	ROW
				CMP	ENDROW
				BNE	LOOPNT3
HERE			LDA	#$04
				STA	LENGTH
				JSR	NOISE
				LDA	LINENUM
				INC	LINENUM
				CMP	ENDLINE
				BNE	LOOPNT2
				INC	STARTER
				LDA	STARTER
				STA	CYCLE
				CMP	#$07
				BNE	LOOPNT1	
				RTS

GSMASKS			DFB	$81,$90,$84
				DFB	$C0,$82,$A0
				DFB	$88
;
; Scroll up "Software, Inc."
;
SOFTUP			LDA	#SOFBROW
				STA	BEGROW
				LDA	#SOFEROW
				STA	ENDROW
				LDA	#<SOFTWARE_INC
				STA	MODPNT+1
				LDA	#>SOFTWARE_INC
				STA	MODPNT+2
				LDA	#$00
				STA	DATAPNT
				LDA	#$BE
				STA	BEGLINE
				LDA	#$BF
				STA	ENDLINE
MORE1			LDX	#$BF
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	BEGROW	
MORE2			LDX	DATAPNT
MODPNT			LDA	DUMMY2,X
				STA	(SCREENL),Y
				INY
				INC	DATAPNT
				BNE	CARRYNO	
				INC	MODPNT+2	
CARRYNO			CPY	ENDROW	
				BNE	MORE2
				LDA	MODPNT+2	
				BEQ	NOYET
				LDA	DATAPNT
				CMP	#$34
				BEQ	DATAON2	
NOYET			DEC	BEGLINE
				JSR	SCROLL
				JMP	MORE1
DATAON			DEC	ENDLINE	
DATAON2			DEC	BEGLINE
				JSR	SCROLL
				LDA	BEGLINE
				CMP	#$69	
				BNE	DATAON
;
; Delay and prep for bringing in "Presents..."
;
				BIT	KEYBRD
				BPL	NOKEY5
				STA	PRIMARY
				JMP	MESSAGE
NOKEY5			LDA	#$EA
				STA	PRLETTR
				STA	ESLETTR
				STA	ENLETTR
				STA	TSLETTR
				LDA	#$04
				STA	GAPPER
				STA	GAPPER+1
				STA	GAPPER+2
				STA	GAPPER+3
				LDA	#$01
				STA	ESDELAY
				LDA	#$02
				STA	ENDELAY
				LDA	#$03
				STA	TSDELAY
				LDA	#$00
				LDX	#$04
:LOOP1			JSR	WAIT
				DEX
				BNE	:LOOP1
				JMP	PRESNTS
;
; Scroll loop used to bring in "Software, Inc."
;
SCROLL			LDX	BEGLINE
LOOPA			LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				INX
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	BEGROW	
LOOPB			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	ENDROW	
				BNE	LOOPB
				CPX	ENDLINE
				BNE	LOOPA
				RTS
;
; Squish in "Presents..."
;
PRESNTS			JSR	PRLETTR
				JSR	ESLETTR
				JSR	ENLETTR
				JSR	TSLETTR
				LDA	#$B0
				JSR	WAIT
				JMP	PRESNTS
;
; Squish in "Pr"
;
PRLETTR			NOP
				LDA	#BROWPR
				STA	BEGROW
				LDA	#EROWPR
				STA	ENDROW
				LDA	#$00
				STA	DATAPNT
				LDA	GAPPER
				STA	GAP
				JSR	SQUISHR
				LDA	GAPPER
				CMP	#$04
				BEQ	FIRST1P
				DEC	GAPPER
				INC	GAP
				LDA	#$00
				STA	DATAPNT
				JSR	SQUISHR
				LDA	GAPPER
				BNE	EXITPR
				LDA	#$60
				STA	PRLETTR
				JMP	EXITPR
FIRST1P			DEC	GAPPER
EXITPR			RTS
;
; Squish in "es"
;
ESLETTR			NOP
				LDA	ESDELAY
				BEQ	ESGO
				DEC	ESDELAY
				JMP	EXITES
ESGO			LDA	#BROWES
				STA	BEGROW
				LDA	#EROWES
				STA	ENDROW
				LDA	#$1B
				STA	DATAPNT
				LDA	GAPPER+1
				STA	GAP
				JSR	SQUISHR
				LDA	GAPPER+1
				CMP	#$04
				BEQ	FIRST1S
				DEC	GAPPER+1
				INC	GAP
				LDA	#$1B
				STA	DATAPNT
				JSR	SQUISHR
				LDA	GAPPER+1
				BNE	EXITES
				LDA	#$60
				STA	ESLETTR
				JMP	EXITES
FIRST1S			DEC	GAPPER+1
EXITES			RTS
;
; Squish in "en"
;
ENLETTR			NOP
				LDA	ENDELAY
				BEQ	ENGO
				DEC	ENDELAY
				JMP	EXITEN
ENGO			LDA	#BROWEN
				STA	BEGROW	
				LDA	#EROWEN
				STA	ENDROW
				LDA	#$36
				STA	DATAPNT
				LDA	GAPPER+2
				STA	GAP
				JSR	SQUISHR
				LDA	GAPPER+2
				CMP	#$04
				BEQ	FIRST1E
				DEC	GAPPER+2
				INC	GAP
				LDA	#$36
				STA	DATAPNT
				JSR	SQUISHR
				LDA	GAPPER+2
				BNE	EXITEN
				LDA	#$60
				STA	ENLETTR
				JMP	EXITEN
FIRST1E			DEC	GAPPER+2
EXITEN			RTS
;
; Squish in "ts"
;
TSLETTR			NOP	
				LDA	TSDELAY
				BEQ	TSGO
				DEC	TSDELAY
				JMP	EXITTS
TSGO			LDA	#BROWTS
				STA	BEGROW
				LDA	#EROWTS
				STA	ENDROW
				LDA	#$51
				STA	DATAPNT
				LDA	GAPPER+3
				STA	GAP
				JSR	SQUISHR
				LDA	GAPPER+3
				CMP	#$04
				BEQ	FIRST1T
				DEC	GAPPER+3
				INC	GAP
				LDA	#$51
				STA	DATAPNT
				JSR	SQUISHR
				LDA	GAPPER+3
				BNE	EXITTS
				PLA
				PLA
				JMP	DOTS	
FIRST1T			DEC	GAPPER+3
EXITTS			RTS

GAPPER			DFB	$04,$04,$04
				DFB	$04
ESDELAY			DFB	$01
ENDELAY			DFB	$02
TSDELAY			DFB	$03

;
; Common routine to squish letters of "Presents"
;
SQUISHR			LDA	#$05
				SEC
				SBC	GAP
				ASL	A
				ASL	A
				PHA
				CLC
				ADC	#TOPLIN	
				STA	LINENUM
				PLA
				STA	ENDLINE
				LDA	#BOTLINE
				SEC
				SBC	ENDLINE
				STA	ENDLINE
SQUISH			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL	
				LDA	HIBYTES,X
				ORA	#$40	
				STA	SCREENH
				LDY	BEGROW
:LOOP1			LDX	DATAPNT
				LDA	PRESENT,X
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
				INC	$CA
				CPY	ENDROW
				BEQ	:ROWOVER
				INY
				JMP	:LOOP1
:ROWOVER		LDA	LINENUM
				CMP	ENDLINE
				BEQ	SQUISHD
				CLC
				ADC	GAP
				STA	LINENUM
				JMP	SQUISH
SQUISHD			RTS

;
; Draw the "..." on Presents
;
DOTS			LDA	#$AB	
				PHA
DOTS2			TAX
				LDA	LOBYTES,X
				STA	SCREENL	
				LDA	HIBYTES,X
				ORA	#$40	
				STA	SCREENH
				LDX	#$00
				LDY	#$19
MORDOTS			LDA	DOTSTAB,X
				STA	(SCREENL),Y
				INX
				INY
				CPX	#$03
				BNE	MORDOTS
				PLA
				CMP	#$AB
				BNE	DOTOUT
				LDA	#$AC
				PHA
				JMP	DOTS2
DOTOUT			JMP	GOPLAN

DOTSTAB			DFB	$0E,$47,$03

;
; White noise generator used during
;	"Graphic" and "Simulations" fades.
;
NOISE			LDY	POINT	
				LDA	$6000,Y
				LDX	#$08
:SHIFT			LSR	A
				BNE	:NEXTBIT
				STA	CLICK
:NEXTBIT		DEX
				BNE	:SHIFT
				LDX	PITCH
:DELAY			DEX
				BNE	:DELAY
				INC	POINT	
				DEC	LENGTH
				BNE	NOISE	
HERE2A			INC	PITCH
HERE2			INC	PITCH
				RTS

GOPLAN			LDY	#$06	
				LDA	#$00
MOPAUSE			BIT	KEYBRD
				BPL	NOKEY6
				STA	PRIMARY
				JMP	MESSAGE
NOKEY6			JSR	WAIT
				DEY
				BPL	MOPAUSE
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				LDA	#$60
				STA	STAREND
				JSR	STARER
				LDA	#$A9
				STA	STAREND
				STA	PRIMARY
				JSR	MOVETO2
				LDA	#$33
				STA	PBEGLIN
				LDA	#$47	
				STA	MBEGLIN
				JSR	PLANIT
				JSR	MOONIT
MORUPIT			LDA	#$00
				STA	NUMBER
LOOPER5			LDA	#$A0
				JSR	WAIT
				DEC	MBEGLIN
				JSR	MOONIT
				INC	NUMBER
				LDA	NUMBER
				CMP	#$03	
				BNE	LOOPER5
				LDA	#$A0
				JSR	WAIT
				DEC	MBEGLIN
				DEC	PBEGLIN
				JSR	MOONIT
				JSR	PLANIT
				BIT	KEYBRD
				BPL	NOKEY9
				JMP	GOMESS1
NOKEY9			LDA	PBEGLIN
				CMP	#$24
				BNE	MORUPIT
				JMP	SCAPEIN

;
; Scroll in ringed planet.
;
PLANIT			LDA	#$00
				STA	LINECNT
				STA	POINT
				LDA	PBEGLIN
				STA	LINENUM
PLOOPER			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH	
				EOR	#$60
				STA	DESTINH	
				LDY	#$0F
PLOOP			LDX	POINT
				LDA	PLANET,X
				CMP	#$80
				BNE	NOTRANS
				LDA	(SCREENL),Y
NOTRANS			STA	(DESTINL),Y
				INC	POINT
				INY
				CPY	#$14
				BNE	PLOOP
				INC	LINENUM
				LDA	LINECNT
				INC	LINECNT
				CMP	#$27
				BNE	PLOOPER
				RTS

;
; Scroll in "moon"
;
MOONIT			LDA	#$00
				STA	LINECNT
				LDA	MBEGLIN
				STA	LINENUM
				LDA	#<MOON
				STA	MOONL
				LDA	#>MOON
				STA	MOONH
MLOOPER			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDA	#$00
				STA	POINT
				LDA	#$17
				STA	ROWNUM
MLOOP			LDY	POINT
				LDA	(MOONL),Y
				LDY	ROWNUM
				CMP	#$80
				BNE	NOTRNSP
				LDA	(SCREENL),Y
NOTRNSP			STA	(DESTINL),Y
				INC	POINT
				LDA	ROWNUM
				INC	ROWNUM
				CMP	#$1E
				BNE	MLOOP
				INC	LINENUM
				LDA	LINECNT
				INC	LINECNT
				CMP	#$2D
				BEQ	MEXIT
				LDA	MOONL
				CLC
				ADC	POINT
				STA	MOONL
				BCC	MLOOPER
				INC	MOONH
				JMP	MLOOPER
MEXIT			RTS

;
; Scroll in landscape
;
SCAPEIN			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				LDA	#<LANDSCAPE
				STA	TBLPNTL
				LDA	#>LANDSCAPE
				STA	TBLPNTH
				JSR	EXPANDR
				LDA	#$BF	
				STA	BEGLINE
INLOOP0			LDA	#$00
				STA	LINECNT
				LDA	BEGLINE
				STA	LINUM2
				LDA	#$4D
				STA	LINUM4
INLOOP1			LDX	LINUM2
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				LDX	LINUM4
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#$27
INLOOP2			LDA	(SCREENL),Y
				LDX	LINECNT
				CPX	#$22
				BCS	DONT1
				CMP	#$80
				BEQ	DONT2
DONT1			STA	(DESTINL),Y
DONT2			DEY
				BPL	INLOOP2
				INC	LINUM4
				INC	LINECNT
				LDA	LINUM2
				INC	LINUM2
				CMP	#$BF
				BNE	INLOOP1
				BIT	KEYBRD
				BPL	NOKEY8
				JMP	GOMESS1
NOKEY8			LDA	BEGLINE
				DEC	BEGLINE
				CMP	#$4D
				BNE	INLOOP0
;
; Delay and then fade in "NAJA"
;
				LDA	#$00
				JSR	WAIT
				JSR	WAIT
				JSR	WAIT
				LDA	#$00	
				STA	PARTNUM
MORPART			LDY	PARTNUM
				LDA	LINEBEG,Y
				STA	BEGLINE
				LDA	LINEEND,Y
				STA	ENDLINE
				LDA	ROWBEG,Y
				STA	BEGROW
				LDA	ROWEND,Y
				STA	ENDROW
				TYA
				ASL	A
				TAY
				LDA	STARTIN,Y
				STA	DATAL
				INY
				LDA	STARTIN,Y
				STA	DATAH
				LDA	#$D0	
				JSR	WAIT
				JSR	FADENAJ
				LDA	PARTNUM
				INC	PARTNUM
				CMP	#$04
				BNE	MORPART
				JMP	BUBBLER

LINEBEG			DFB	$55,$56,$6C
				DFB	$55,$89
LINEEND			DFB	$8B,$8D,$9B
				DFB	$93,$93
ROWBEG			DFB	$02,$08,$09
				DFB	$0E,$01
ROWEND			DFB	$0B,$0F,$11
				DFB	$17,$0D
STARTIN			DW	NAJA_N
				DW	NAJA_A1
				DW	NAJA_J
				DW	NAJA_A2
				DW	NAJA_UNDER

;
; Subroutine used to fade each letter of "NAJA"
;
FADENAJ			LDA	#$00
				STA	STARTER
FADPNT0			LDA	BEGLINE
				STA	LINENUM
				LDA	DATAL
				STA	PARTL
				LDA	DATAH
				STA	PARTH
				LDA	STARTER
				STA	CYCLE
FADPNT1			LDA	#$00
				STA	POINT
				LDA	BEGROW
				STA	ROW
				LDY	LINENUM
				LDA	LOBYTES,Y
				STA	SCREENL
				LDA	HIBYTES,Y
				ORA	#$20
				STA	SCREENH
FADPNT2			LDY	POINT
				LDA	(PARTL),Y
				BEQ	DONTDO
				LDX	CYCLE
				AND	ISOMASK,X	
				STA	SCRATCH
				LDY	ROW
				LDA	(SCREENL),Y
				AND	SLTMASK,X	
				ORA	SCRATCH
				STA	(SCREENL),Y
DONTDO			LDA	CLICK
				INC	POINT
				LDA	CYCLE
				INC	CYCLE
				CMP	#$06
				BNE	NOENDCY
				LDA	#$00
				STA	CYCLE
NOENDCY			LDA	ROW
				INC	ROW
				CMP	ENDROW
				BNE	FADPNT2
				LDA	PARTL
				CLC
				ADC	POINT
				STA	PARTL
				LDA	PARTH
				ADC	#$00	
				STA	PARTH
				LDA	LINENUM
				INC	LINENUM
				CMP	ENDLINE
				BNE	FADPNT1
				LDA	STARTER
				INC	STARTER
				CMP	#$06
				BNE	FADPNT0
				RTS

ISOMASK			DFB	$C0,$84,$90
				DFB	$81,$A0,$82
				DFB	$88
SLTMASK			DFB	$BF,$FB,$EF
				DFB	$FE,$DF,$FD
				DFB	$F7

;
; Delay and then animate green bubbles.
;
BUBBLER			LDA	#$00
				JSR	WAIT
				JSR	WAIT
				JSR	WAIT
				LDA	#$00
				STA	PICNUM
				STA	HOWLONG
AGAIN			LDA	PICNUM
				ASL	A
				TAX	
				LDA	BDELAY,X	
				DEC	BDELAY,X	
				CMP	#$00	
				BEQ	ISTIME
				JMP	NOTTIME
ISTIME			INX	
				LDA	BDELAY,X	
				DEC	BDELAY,X	
				CMP	#$00
				BEQ	ISTIME2	
				JMP	NOTTIME
ISTIME2			TXA
				TAY
				DEY
				LDX	PICNUM
				LDA	CYCOUNT,X
				ASL	A
				TAX
				LDA	DELNUM,X
				STA	BDELAY,Y
				INY
				INX
				LDA	DELNUM,X
				STA	BDELAY,Y
				LDY	PICNUM
				LDA	CYCOUNT,Y
				STA	CYCLE
				LDA	BROWTAB,Y
				STA	BEGROW
				LDA	EROWTAB,Y
				STA	ENDROW
				LDA	BLINTAB,Y
				STA	BEGLINE
				LDA	ELINTAB,Y
				STA	ENDLINE
				JSR	BUBLOUT
				LDA	#$03
				CMP	CYCOUNT
				BNE	NOTINC
				LDA	#$01
				CMP	CYCOUNT+1
				BNE	NOTINC
				LDA	#$02
				CMP	CYCOUNT+2
				BNE	NOTINC
				LDA	#$04
				CMP	CYCOUNT+3
				BNE	NOTINC
				INC	HOWLONG
				LDA	HOWLONG
				CMP	#$06	
				BNE	NOTINC
				LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				STA	SCNDARY
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				LDA	#$40
				STA	PAGE
				JMP	STARER
NOTINC			LDX	PICNUM
				LDA	CYCOUNT,X	
				INC	CYCOUNT,X	
				CMP	#$08
				BNE	NOTTIME
				LDA	#$00
				STA	CYCOUNT,X	
NOTTIME			LDA	PICNUM
				INC	PICNUM
				CMP	#$03
				BEQ	NEVGAIN
				JMP	AGAIN
NEVGAIN			LDA	#$00
				STA	PICNUM
				BIT	KEYBRD
				BPL	GONGAIN
GOMESS1			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				STA	SCNDARY
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				STA	PRIMARY
				JMP	MESSAGE	
GONGAIN			JMP	AGAIN

;
; Animate one bubble.
;
BUBLOUT			LDA	#$00
				STA	POINT
				LDA	CYCLE
				ASL	A
				TAY
				LDA	PICPNT,Y
				STA	BMODPNT+1
				INY
				LDA	PICPNT,Y
				STA	BMODPNT+2
				LDA	BEGLINE
				STA	LINENUM
BUBLR			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	BEGROW
MORBUBL			LDX	POINT
BMODPNT			LDA	BUBBLES,X
				CMP	#$80
				BEQ	STORENO	
				STA	(SCREENL),Y
STORENO			INC	POINT
				INY
				CPY	ENDROW
				BNE	MORBUBL
				LDA	LINENUM
				INC	LINENUM
				CMP	ENDLINE
				BNE	BUBLR
				LDA	CYCLE
				CMP	#$05
				BNE	BUBEXIT
				JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$03
				ADC	#$02	
				STA	MPNT2+1
				LDY	#$20
MORPOP			LDA	CLICK
MPNT2			LDA	#$FF
				JSR	WAIT
				DEY
				BNE	MORPOP
BUBEXIT			RTS

BROWTAB			DFB	$12,$1A,$18
				DFB	$1E
EROWTAB			DFB	$17,$1F,$1D	
				DFB	$23	
BLINTAB			DFB	$B0,$B0,$A0
				DFB	$98
ELINTAB			DFB	$BE,$BE,$AE
				DFB	$A6
BDELAY			DFB	$B9,$04,$C0	
				DFB	$0D,$C5,$09	
				DFB	$C4,$05	
CYCOUNT			DFB	$03,$01,$02	
				DFB	$04
;
; bubble pointers
;
PICPNT			DW	BUBBLE_0
				DW	BUBBLE_1
				DW	BUBBLE_2
				DW	BUBBLE_3
				DW	BUBBLE_4
				DW	BUBBLE_5
				DW	BUBBLE_6
				DW	BUBBLE_7
				DW	BUBBLE_8

DELNUM			DFB	$00,$18,$00	
				DFB	$0A,$00,$0A	
				DFB	$00,$0A,$00	
				DFB	$03,$00,$02	
				DFB	$00,$02,$00	
				DFB	$02,$00,$02	
COVER			DFB	$0F,$09,$07
				DFB	$0A,$07,$02

DECOVER			LDY	#$05	
UNCOVER			LDA	$FA,Y
				AND	#$0F
; don't update serial number because it's not initialized
;				STA	SERIAL,Y
				DEY
				BPL	UNCOVER
				RTS

;
; Put up message text and signatures.
;
MESSAGE			LDA	#$40	
				STA	PAGE
				JSR	CLEAR2
				JSR	DECOVER
				LDA	#<MESSAGE_TEXT
				STA	POINTL
				LDA	#>MESSAGE_TEXT
				STA	POINTH
				JSR	TEXTOUT
				JSR	DECOVER
				LDA	#<SIGNATURES
				STA	TBLPNTL
				LDA	#>SIGNATURES
				STA	TBLPNTH
				JSR	EXPANDR
				STA	SCNDARY
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				BIT	UNSTROB
REREAD			INC	RANDOM1+1
				INC	RANDOM1+3
				BNE	GOCHECK
				INC	RANDOM1+2
				INC	RANDOM1+4
GOCHECK			BIT	KEYBRD
				BPL	REREAD
				BIT	UNSTROB
				STA	PRIMARY
				JMP	FINISH_BOOT
