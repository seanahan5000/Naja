DOSTATS			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				LDA	CURSOR
				STA	LEFT1
				LDA	#GREEN
				STA	COLOR
				LDY	#$00	
				JSR	LINER
				LDY	#$0D
				LDA	(CHARDL),Y
				AND	#$F0
				STA	CRFLAG
				BPL	CHRPROF
				LDA	#<ROBOTP
				STA	TBLPNTL
				LDA	#>ROBOTP
				STA	TBLPNTH
				JSR	BANK_2
				JSR	EXPANDR
				JSR	BANK_1
				JSR	RSTUFER
				JSR	RINFOUT
				JMP	RCCOM

CRFLAG			DFB	$00

CHRPROF			LDA	#<CHARP
				STA	TBLPNTL
				LDA	#>CHARP
				STA	TBLPNTH
				JSR	BANK_2
				JSR	EXPANDR
				JSR	BANK_1
				JSR	STUFOUT
				JSR	PUTGNRL
RCCOM			LDY	#$10	
				JSR	TEXTER2
				STA	SCNDARY
				LDA	#$06
RDOPTN			ORA	#$80
				STA	ICURPOS
				LDX	#<:ISTAT_DEF
				LDY	#>:ISTAT_DEF
				JSR	INIT_CURSOR
				JMP	GO_COM

*-------------------------------
:ISTAT_DEF		DB	$06
ICURPOS			DB	$80
				DW	:ISTAT_CURS
				DW	:ISTAT_JUMPS

:ISTAT_JUMPS	DW	MOVESUB
				DW	DROPSUB
				DW	GETUSER
				DW	EXAMINE
				DW	GETRANS
				DW	SEESTAT
				DW	GOCAMP

:ISTAT_CURS		JSR	XY_SUB
				JMP	ARROWER
*-------------------------------

GETUSER			LDA	SHELL
				BNE	CAN_USE
				LDA	#GREEN
				JSR	USE_SUB
				BIT	UNSTROB
:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	:LOOP1
				LDA	#BLACK1
				JSR	USE_SUB
GO_SKIP			JSR	IMARKER
				DEC	CURSOR
GO_COM			JSR	DOWN2
				JSR	IMARKER
				JMP	DESTINATION
CAN_USE			LDY	#status
				LDA	(CHARDL),Y
				CMP	#dead
				BEQ	GO_SKIP
				JMP	USER
USE_SUB			STA	COLOR
				LDY	#$09
				JSR	LINER
				LDY	#$14
				JMP	TEXTER

GETRANS			LDY	#$0D
				LDA	(CHARDL),Y
				AND	#$F0
				CMP	#$30
				BNE	NOJUICY
				JMP	TRANSFR

NOJUICY			JSR	IMARKER
				LDA	#$03
				JMP	RDOPTN

GOCAMP			LDA	#$02
				JMP	CAMP

MARKSUB			LDA	YPOINTS,Y
				STA	YPNT
				LDA	#$06
				STA	XPNT
				LDA	#$04
				JMP	SPCHARS

IMARKER			JSR	XY_SUB
				INX
				INX
				INX
				STX	XPNT
				STY	YPNT
				LDA	#$04
				JMP	SPCHARS

XY_SUB			LDX	CURSOR
				LDY	:YPNTS,X
				LDA	#$B9
				CPX	#4
				BCC	:EXIT
				LDA	#$A7
:EXIT			TAX
				RTS
:YPNTS			DFB	$7D,$86,$8F
				DFB	$98,$A2,$AB
				DFB	$B5

SWITCHD			LDX	#$00
				LDY	#$50	
SWITD2			LDA	#$E6
				BNE	SWITCOM
SWITCHU			LDX	#$50	
				LDY	#$00
SWITU2			LDA	#$C6
SWITCOM			PHA
				LDA	#$00
				STA	YMOD+1
				PLA
				JSR	STATCOM
				LDA	#$17
				STA	YMOD+1
				RTS

STAT12A			LDX	#$00	
				LDY	#$BF	
				BNE	STATCOM_UP		;Always
STAT21A			LDX	#$BF	
				LDY	#$00	
				BEQ	STATCOM_DWN		;Always
STAT121			LDX	#$32	
				LDY	#$B4	
STATCOM_UP		LDA	#$E6
				BNE	STATCOM			;Always
STAT212			LDX	#$B4	
				LDY	#$32	
STATCOM_DWN		LDA	#$C6
STATCOM			STX	LINENUM
				STY	ENDLINE
				STA	UPDWN
STATUD			LDX	LINENUM
				JSR	GET_SWAP
YMOD			LDY	#$17
STILROW			LDA	(SCREENL),Y
				TAX
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				TXA
				STA	(DESTINL),Y
				INY
				CPY	#$28
				BNE	STILROW
				LDA	LINENUM
UPDWN			INC	LINENUM
				CMP	ENDLINE
				BNE	STATUD
				RTS
PUTGNRL			LDY	#$0F	
				JSR	TEXTER2
				LDX	#$00
				LDY	#$00
				JSR	NAMEIT
				LDA	#$CC
				LDY	#$04
				JSR	LINE
				LDY	#$0D
				LDA	(CHARDL),Y
				PHA
				AND	#$0F
				TAX
				LDA	RACEOFF,X
				TAX
				LDY	#$00
MORACE			LDA	RACEDAT,X
				STA	TEXTBUF,Y
				INX
				INY
				CMP	#$8D
				BNE	MORACE
				LDA	#$CC
				LDY	#$0D
				JSR	LINE
				PLA
				JSR	CPROF
				LDA	#$CC
				LDY	#$16
				JSR	LINE
				JSR	CLEVEL	
				LDA	#$CC
				LDY	#$1F
				JSR	LINE
				LDY	#$0E
				LDX	#$00
MOREXPR			LDA	(CHARDL),Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$04
				BNE	MOREXPR
				JSR	PREPARE
				LDA	#$CC
				LDY	#$28
				JMP	LINE
CPROF			LSR	A
				LSR	A
				LSR	A
				LSR	A
				TAX
				LDA	PROFOFF,X
				TAX
				LDY	#$00
MORPROF			LDA	PROFDAT,X
				STA	TEXTBUF,Y
				INX
				INY
				CMP	#$8D
				BNE	MORPROF
				RTS
CLEVEL			LDY	#$0B
				LDX	#$00
MORLEVL			LDA	(CHARDL),Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$02
				BNE	MORLEVL
				JSR	PREPARE
				RTS
PREPARE			STX	SCRATCH
				TXA
				DEX
				ASL	A
				TAY
				LDA	#$8D
				STA	TEXTBUF,Y	
				DEY
				STY	SCRATCH
PPARE			LDA	TEXTBUF,X
				JSR	SPLIT
				LDA	FEEDERL
				STA	TEXTBUF,Y
				DEY
				LDA	FEEDERH
				STA	TEXTBUF,Y
				DEY
				DEX
				BPL	PPARE
				LDX	#$00	
PPLOOP			LDA	TEXTBUF,X
				BNE	NOMORE0
				CPX	SCRATCH
				BEQ	NOMORE0
				LDA	#$EE
				STA	TEXTBUF,X
				INX
				BNE	PPLOOP
NOMORE0			RTS
DRAWITC			LDA	#$CC
				LDY	COUNT
				JSR	LINE
DRAWC2			LDA	COUNT
				CLC
				ADC	#$09
				STA	COUNT
				RTS
EMNTSUB			STA	YPNT
				LDX	#$00
EMLOOP			LDA	(CHARDL),Y
				STA	ETABLE,X
				INY
				INX
				CPX	#$04
				BNE	EMLOOP
				JSR	EQUIP1
				LDA	#$42
				LDY	YPNT
				JMP	LINE

STUFOUT			LDY	#$14
				JSR	TEXTER2
				LDA	#$00
				STA	COUNT
STLOOPX			LDA	COUNT
				JSR	EQUIPR
				LDY	COUNT
				LDA	EPLINES,Y
				TAY
				LDA	#$42
				JSR	LINE
				INC	COUNT
				LDA	COUNT
				CMP	#$0E
				BNE	STLOOPX
				LDY	#$1D
				LDA	(CHARDL),Y
				STA	TEXTBUF
				STA	COUNT
				DEC	COUNT	
				LDA	#$2F
				STA	TEXTBUF+1
				LDA	#$8D
				STA	TEXTBUF+2
STLOOPY			LDY	COUNT
				LDA	EPLINES+6,Y
				TAY
				LDA	#$2C	
				JSR	LINE
				DEC	TEXTBUF
				DEC	COUNT
				BPL	STLOOPY
				LDY	#$0D
				LDA	(CHARDL),Y
				AND	#$0F
				CMP	#$04
				BEQ	ISDENB
				LDY	#$16
				JMP	TEXTER2
ISDENB			LDY	#$15
				JMP	TEXTER2
EPLINES			DFB	$09,$11,$6B
				DFB	$73,$7B,$83
				DFB	$2A,$32,$3A
				DFB	$42,$4A,$52
				DFB	$9C,$B5
LEFT1			DFB	$00
RIGHT1			DFB	$00

LINER
				JSR	BANK_2
				TYA
				ASL	A
				TAY
				LDA	LINES2,Y
				STA	POINTL
				LDA	LINES2+1,Y
				STA	POINTH
				JSR	LINEOUT
				JMP	BANK_1

TEXTER2
				JSR	BANK_2
				TYA
				ASL	A
				TAY
				LDA	TEXTS2,Y
				STA	POINTL
				LDA	TEXTS2+1,Y
				STA	POINTH
				JSR	TEXTOUT
				JMP	BANK_1
