scrnHEAD		=	0
scrnBODY		=	1
scrnWEAPONL		=	2
scrnWEAPONR		=	3
scrnENERGY		=	4
scrnMOVEMENT	=	5
scrnPROGRAM		=	6

LINENUM			=	ZBLOCK_80+0
SCRATCH			=	ZBLOCK_80+1
COUNTER			=	ZBLOCK_80+2
VALUEL			=	ZBLOCK_80+3
VALUEH			=	ZBLOCK_80+4
POINTER			=	ZBLOCK_80+5
LCOLUMN			=	ZBLOCK_80+6

RCOLUMN			=	ZBLOCK_88+0
CDPNTL			=	ZBLOCK_88+1
CDPNTH			=	ZBLOCK_88+2
CURHOLD			=	ZBLOCK_88+3
*
*
PARTALL			=	ZBLOCK_88+6		;00 = First pass after complete buy
									;D0 = Adjust after complete buy
									;E0 = Too expensive after complete buy
									;EE = REPLACEing area
XHOLD			=	ZBLOCK_88+7

MINIMUM			=	ZBLOCK_A0+0
MAXIMUM			=	ZBLOCK_A0+1
NUMTYPE			=	ZBLOCK_A0+2
PICK			=	ZBLOCK_A0+3
ON1				=	ZBLOCK_A0+4
ON2				=	ZBLOCK_A0+5
SCRPICK			=	ZBLOCK_A0+6
ASSIGN2			=	ZBLOCK_A0+7

DEBTOR			=	ZBLOCK_A8+0
*
THE_ROBOT		=	ZBLOCK_A8+2
SAMFLAG			=	ZBLOCK_A8+3
MINLOW			=	ZBLOCK_A8+4
MINUPR			=	ZBLOCK_A8+5
LIMIT			=	ZBLOCK_A8+6
EXPFLAG			=	ZBLOCK_A8+7

				LDA	#$40
				STA	PAGE
				LDA	#GREEN
				STA	COLOR
				LDY	#$08
				JSR	LINER
				LDY	#$04
				JSR	TEXTER
				LDA	#0
				STA	MAXTEXT
				LDA	KEYBRD
				BPL	NOKEY
				BIT	UNSTROB
				CMP	#$9B
				BNE	NOESC
				JMP	LEAVEB
NOKEY			JSR	INPUT2
NOESC			LDA	#$20
				STA	PAGE
				LDY	#$09
				JSR	LINER
				LDY	#$05
				JSR	TEXTER
				STA	PRIMARY
				JSR	INPUT2
				LDA	TEXTBUF
				CMP	#$8D
				BEQ	ISRET
				JSR	CHAROUT
				LDA	TEXTBUF
				CMP	#$9B
				BNE	ISRET
				JMP	LEAVEA
ISRET			LDA	#$20
				STA	PAGE
				LDA	#$FF
				STA	ON1
				STA	ON2
				LDA	#$00
				STA	PICK
OPTIONS			JSR	PPEOR
				LDX	PICK
				LDA	ON1,X	
				CMP	#$10
				BEQ	OPTCOM
				JSR	ALLICON
				JSR	CLRBOTM
				LDA	#BLUE
				STA	COLOR
				LDY	#$15	
				JSR	LINER
				JSR	COUNT_CYBS
				BCS	OPTION2
				LDY	#$30
				JSR	TEXTER
				JSR	VIEWER
				BIT	UNSTROB
OPTKEY			LDA	KEYBRD
				BPL	OPTKEY
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	OPTKEY
				JMP	LEAVE
OPTION2			LDY	#$01
				JSR	TEXTER
OPTCOM			JSR	COUNT_ROBOTS
				JSR	COUNT_CYBS
				LDA	#4
				JSR	SET_LEGALS
				LDA	ROBOT_COUNT
				BNE	AREROBS
				LDA	#$FF
				STA	LEGALS
				STA	LEGALS+2	
AREROBS			LDA	CYB_COUNT
				BNE	STOPPER
				LDA	#$FF	
				STA	LEGALS+1
STOPPER			NOP
				JSR	VIEWER
				BIT	UNSTROB
				LDY	#3
				STY	CURSOR
LTLOOP			LDA	OPTYPNT,Y
				STA	LINTABL,Y
				DEY
				BPL	LTLOOP
				LDA	#$48
				STA	XHOLD
				JSR	KDOWN2
				JSR	RCURSIT
				LDX	PICK
				LDA	#$10
				STA	ON1,X	
				LDA	CURSOR
				ASL
				TAY
				LDA	JUMPS+1,Y
				PHA
				LDA	JUMPS,Y
				PHA
				RTS

JUMPS			DW	REPLACE-1
				DW	COMPLETE_BUY-1
				DW	COMPLETE_SELL-1
				DW	LEAVE-1

*-------------------------------

WHOSE_CREDITS	JSR	PACSUB
				LDA	#GREEN
				STA	COLOR
				LDY	#$0A
				JSR	LINER
				LDY	#$02
				JSR	TEXTER
				LDY	#$06
				JSR	TEXTER
				JSR	TOTAL_SUB
				JSR	VIEWER
				LDY	#8
				STY	CURSOR
LTLOOPX			LDA	YPOINT2,Y
				STA	LINTABL,Y
				DEY
				BPL	LTLOOPX
				LDA	#$03
				STA	XHOLD
				JSR	KDOWN2
				JSR	RCURSIT
				LDX	PICK
				LDA	ON1,X	
				ORA	#$0F
				STA	ON1,X	
				LDA	CURSOR
				STA	DEBTOR
				CMP	#$08
				BNE	WCOUT
				JMP	OPTIONS
WCOUT			CMP	#$07			;Also called as a subroutine
				BEQ	WEXIT
				JSR	POINTIT
				LDY	#credits+3
				LDX	#3
WCLOOPA			LDA	(CHARDL),Y
				STA	TOTAL_CREDITS,X
				DEY
				DEX
				BPL	WCLOOPA
WEXIT			RTS

*-------------------------------

TAKE_RTOTNUM	JSR	:SUBA
				JSR	POOL_TO_TOTAL
				LDA	DEBTOR
				JMP	WCOUT
:SUBA			LDA	DEBTOR
				CMP	#7
				BEQ	:SKIPA
				JSR	POINTIT
				LDX	#<RTOTNUM
				LDY	#>RTOTNUM
				SEC
				JMP	CHAR_SPEND
:SKIPA			JMP	GROUP_SPEND		;Carry assumed set

*-------------------------------

DRAW_SCREEN		STA	SCRPICK
				JSR	CLRTOP
				LDA	PARTALL
				CMP	#$EE
				BNE	NOTRADN
				LDY	#$32
				JSR	TEXTER
NOTRADN			LDA	PARTALL
				BNE	NOROBTM
				LDX	PICK
				LDA	ON1,X
				ORA	#$0F
				STA	ON1,X
				JSR	ROBSTAT
NOROBTM			LDX	SCRPICK
				LDY	LINETABLE1,X
				LDA	#GREEN
				STA	COLOR
				JSR	LINER
				LDX	SCRPICK
				LDY	ICONTABLE1,X
				LDX	#$FF
				JSR	ICONS
				LDX	SCRPICK
				LDY	TEXTTABLE1,X
				JSR	TEXTER
				LDA	SCRPICK
				AND	#%11111110
				CMP	#scrnWEAPONL
				BNE	NOT6C	
				LDA	#VIOLET
				STA	COLOR
				LDY	#$0F
				JSR	LINER
NOT6C			LDA	#RED
				STA	COLOR
				LDY	#$0B
				JSR	LINER
				LDY	#$15
				JSR	TEXTER
				LDY	#$0E
				JSR	TEXTER
				LDA	PARTALL
				BNE	PASKIP1
				LDY	#$25
				JSR	TEXTER
PASKIP1			LDX	SCRPICK
				LDY	TEXTTABLE2,X
				JSR	TEXTER
				JSR	CRSUB

				LDA	SCRPICK
				TAY
				SEC
				SBC	#scrnWEAPONL
				BCC	NOSCRT
				CMP	#2
				BCS	NOSCRT
				PHA
				ADC	#7				;Carry assumed clear
				TAX
				LDY	#5				;Empty hand slot
				JSR	VALUSUB
				LDX	#3
				PLA
				CLC
				ADC	#1
				ASL
				ASL
				TAY
XXLOOP			DEY
				LDA	CAT7,Y
				STA	CATT,X
				DEX
				BPL	XXLOOP
				JMP	INITSUB
NOSCRT			LDX	BEGCATS,Y
				LDA	#VIOLET
				STA	COLOR
				JSR	LINER2
				JSR	CATTOTL
				JSR	INITSUB
				LDY	#3
				LDA	#0
PVLOOPA			STA	POINTLV,Y
				DEY
				BPL	PVLOOPA	
				LDY	SCRPICK
				LDA	NUMCATS,Y
				STA	SCRATCH
				LDA	#$00
				STA	POINTER
PBLOOP			JSR	BIGSUB
				INC	POINTER
				LDA	POINTER
				CMP	SCRATCH
				BNE	PBLOOP
				LDA	SCRPICK
				CMP	#scrnENERGY
				BNE	SCROUT
				JSR	TRICKY
				JSR	TRICKY
TRICKY			INC	XHOLD
				INC	XHOLD
				LDA	#$00
				JSR	BLETTER
SCROUT			RTS

LINETABLE1		DB	$0C,$0D,$0E,$0E
				DB	$0C,$0D,$0E
ICONTABLE1		DB	$00,$01,$02
				DB	$02,$03,$04,$05
TEXTTABLE1		DB	$07,$08,$09
				DB	$09,$0A,$0B
				DB	$0C
TEXTTABLE2		DB	$0F,$10,$11
				DB	$11,$12,$13
				DB	$14

*-------------------------------

CRSUB			LDA	#$D6
				STA	XPNT
				LDA	#$04
				STA	YPNT
				JMP	TOTAL_CREDOUT

DELABLE			LDX	SCRPICK
				LDY	:DELTEXTS,X
				BEQ	:1
				JSR	TEXTER
:1				RTS
:DELTEXTS		DB	$28,$29,0,0
				DB	$2B,$2C,$2D

INITSUB			LDA	#$00
				STA	EXPFLAG
				LDX	#$03
				CLC
STLOOPA			LDA	CATT,X
				SED
				ADC	RTOTNUM,X
				CLD
				STA	RTOTNEW,X
				DEX
				BPL	STLOOPA
				LDX	#$03
				SEC
STLOOPB			LDA	CATT,X
				SED
				SBC	ETRDNUM,X
				CLD
				STA	EVALNEW,X
				DEX
				BPL	STLOOPB	
				LDX	#$07
				LDA	#$0A
STLOOPC			STA	EVALSCN,X
				DEX
				BPL	STLOOPC
				LDX	#$03
				LDA	#$00
STLOOPD			STA	EVALNUM,X
				DEX
				BPL	STLOOPD
				JSR	TRADSUB
				LDA	PARTALL
				CMP	#$EE
				BNE	STSKIPD
				JSR	TRSUBY
				LDA	#$00
				STA	EXPFLAG
STSKIPD			LDA	EXPFLAG
				BEQ	STSKIPE
				LDY	#$31
				JSR	TEXTER
STSKIPE			LDX	#$03
STLOOPE			LDA	RTOTNUM,X
				STA	RTOTAL,X
				DEX
				BPL	STLOOPE
				JSR	RTSUB
				JMP	UPDATER

TRADSUB			LDA	PARTALL
				CMP	#$EE
				BNE	TRADOUT
				LDX	#$03
				SEC
TRLOOPX			LDA	EVALNEW,X	
				SED
				SBC	TRADEIN,X
				CLD
				STA	RTOTNEW,X
				DEX
				BPL	TRLOOPX
				BCS	TRADUM	
				JSR	TRSUBY
TRADUM			LDX	#$03
				SEC
TRLOOPW			LDA	TOTAL_CREDITS,X
				SED
				SBC	RTOTNEW,X
				CLD
				DEX
				BPL	TRLOOPW
				LDA	#$00
				BCS	TRADO1	
				LDA	#$EE
TRADO1			STA	EXPFLAG
				LDY	#$00
				LDA	SCRPICK
				AND	#%11111110
				CMP	#scrnWEAPONL
				BNE	TRSKIPW
				LDX	SCRPICK
				LDA	LWEAPON-scrnWEAPONL,X
				CMP	CURSOR
				BNE	TRADO2
				DEY
				BNE	TRADO2			;Always
TRSKIPW			LDX	SCRPICK
				LDA	NUMCATS,X
				TAX
				DEX
TRLOOPV			LDA	POINTLV,X
				CMP	DUPNTLV,X
				BNE	TRADO2
				DEX
				BPL	TRLOOPV
				JSR	TRSUBY
				STA	EXPFLAG
				DEY	
TRADO2			STY	SAMFLAG
TRADOUT			RTS

TRSUBY			LDX	#$03
				LDA	#$00
TRLOOPY			STA	RTOTNEW,X
				DEX
				BPL	TRLOOPY
				RTS

TOTAL_SUB		JSR	RESET_CHLIST
				LDA	#$6E
				STA	XPNT
				LDY	#0
				STY	COUNT
:LOOP1			LDA	YPOINT2,Y
				STA	YPNT
				TYA
				JSR	POINTIT
				JSR	PROFNAM
				LDA	#$10
				LDY	YPNT
				JSR	LINE
				LDY	#profrace
				LDA	(CHARDL),Y
				BMI	:SKIPA
				JSR	CHAR_CREDOUT
:SKIPA			INC	COUNT
				LDY	COUNT
				CPY	GRPNUMB
				BNE	:LOOP1
				LDA	YPOINT2+7
				STA	YPNT
				JSR	POOL_TO_TOTAL
				JSR	TOTAL_CREDOUT
				LDA	#$00
				STA	LEGALS+7
				STA	LEGALS+8
				RTS

ALLICON			LDX	PICK
				LDA	ON1,X	
				AND	#$F0
				CMP	#$10
				BNE	DOICONS
				JMP	CLRMIDL
DOICONS			TXA
				EOR	#$01
				TAX
				LDA	ON1,X
				AND	#$F0
				CMP	#$10
				BNE	DOICON3
				CPX	#$01
				BEQ	DOICON2
				JSR	MT2TOP
				JMP	CLRMIDL
DOICON2			JSR	MT1TOP
				JMP	CLRMIDL
DOICON3			JSR	CLRTOP
				LDA	#GREEN
				STA	COLOR
				LDA	#$05
				STA	COUNT
GLOOP			LDY	COUNT
				JSR	LINER
				DEC	COUNT
				BPL	GLOOP
				LDY	#$00
				JSR	TEXTER
				LDA	#$05
				STA	COUNT
ILOOP			LDY	COUNT
				LDX	#$00
				JSR	ICONS
				DEC	COUNT
				BPL	ILOOP
				LDX	PICK
				LDA	ON1,X
				AND	#$0F
				ORA	#$10
				STA	ON1,X
				RTS

ICONS			TYA
				ASL
				TAY
				LDA	PICKS,Y
				STA	TBLPNTL
				LDA	PICKS+1,Y
				STA	TBLPNTH
				CPX	#$00
				BEQ	GOEXP
				LDA	ICOFFS,Y
				STA	POINTL
				LDA	ICOFFS+1,Y
				STA	SCRATCH
				LDY	#$00
EXLOOP			JSR	EXSUB
				TXA
				PHA
				INY
				CPY	#$04
				BEQ	EXDONE
				CPY	#$02
				BNE	EXLOOP
				LDA	POINTL
				STA	SCRATCH
				JMP	EXLOOP
EXDONE			LDA	TBLPNTL
				PHA
				LDA	TBLPNTH
				PHA
				JSR	EXPANDR
				PLA
				STA	TBLPNTH
				PLA
				STA	TBLPNTL
				LDY	#$03
PLOOP			PLA
				STA	(TBLPNTL),Y
				DEY
				BPL	PLOOP
				RTS

EXSUB			LDA	(TBLPNTL),Y
				TAX
				SEC
				SBC	SCRATCH
				STA	(TBLPNTL),Y
				RTS

GOEXP			JMP	EXPANDR

ICOFFS			DB	$04,$00
				DB	$0E,$00
				DB	$18,$00
				DB	$04,$2B
				DB	$0E,$2B
				DB	$18,$2B

PICKS			DW	ICON0
				DW	ICON1
				DW	ICON2
				DW	ICON3
				DW	ICON4
				DW	ICON5

DRAW_GROUP		LDX	PICK
				LDA	ON1,X	
				AND	#$0F
				CMP	#$02
				BNE	DOGRP
				JMP	CLRMIDL
DOGRP			TXA
				EOR	#$01
				TAX
				LDA	ON1,X
				AND	#$0F
				CMP	#$02
				BNE	DOGRP3
				JMP	MTBOTM_CLRMID
DOGRP3			JSR	CLRBOTM
				LDA	#GREEN
				STA	COLOR
				LDY	#$07
				JSR	LINER
				LDA	#$42
				STA	SELECT
				LDA	#$75
				STA	YPNT
				JSR	HEADER
				LDY	#$02
				JSR	TEXTER
				LDA	#$00
				STA	COUNT
STLOOP			TAY
				LDA	RYPOINTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	STLOOP
				LDX	PICK
				LDA	ON1,X
				AND	#$F0
				ORA	#$02
				STA	ON1,X
				RTS

ROBSTAT			LDX	PICK
				LDA	ON1,X	
				AND	#$0F
				CMP	#$03
				BEQ	NOCANC
				CMP	#$04
				BNE	NORHERE
				JMP	CLRMIDL
NOCANC			JSR	CANCIN
				JMP	CLRMIDL
NORHERE			TXA
				EOR	#$01
				TAX
				LDA	ON1,X
				AND	#$0F
				CMP	#$04
				BNE	DOROBS2
				JMP	MTBOTM_CLRMID
DOROBS2			JSR	CLRBOTM
				LDA	#BLUE
				STA	COLOR
				LDY	#$06
				JSR	LINER
				JSR	CANCIN
				LDY	#$16
				JMP	TEXTER

MTBOTM_CLRMID	CPX	#$01
				BEQ	:SKIPA
				JSR	MT2BOTM
				JMP	CLRMIDL
:SKIPA			JSR	MT1BOTM
				JMP	CLRMIDL

ROSTAT2			JSR	CLRBOTM
				LDA	#BLUE
				STA	COLOR
				LDY	#$06
				JSR	LINER
				JSR	CANCIN
				LDY	#$16
				JSR	TEXTER
				LDY	#$24
				JSR	TEXTER
				JSR	REVERSE
				LDA	PLEVEL
				PHA
				LDA	#$00
				STA	SCRPICK
ROLOOP2			CMP	#scrnWEAPONL
				BNE	:1
				LDX	LWEAPON
				LDY	#$8E
				BNE	:2				;Always
:1				CMP	#scrnWEAPONR
				BNE	ROSKIP1
				LDX	RWEAPON
				LDY	#$97
:2				STY	YPNT
				TXA
				JSR	WEASUB
				JMP	ROSKIP2
ROSKIP1			JSR	TOPLEVL
				LDA	SCRPICK
				CMP	#scrnPROGRAM
				BNE	ROSKIP4
				LDY	#e15_PROGRAM+1
				LDA	(CHARDL),Y
				STA	PLEVEL
ROSKIP4			LDA	#$00
				STA	POINTER
				LDY	SCRPICK
				LDA	NUMCATS,Y
				STA	MAXMOD3+1
ROLOOP1			JSR	UPDBOX
				LDA	SCRPICK
				CMP	#scrnPROGRAM
				BEQ	ROSKIP2
				INC	POINTER
				LDA	POINTER
MAXMOD3			CMP	#$FF
				BNE	ROLOOP1
ROSKIP2			LDA	SCRPICK
				CMP	#scrnMOVEMENT
				BNE	ROSKIP3
				LDA	LOWREF
				LSR
				LSR
				CLC
				ADC	#$18
				PHA
				TAY
				JSR	TEXTER
				LDA	#$FF
				JSR	PLUGUP
				PLA
				TAY
				JSR	TEXTER
				LDA	#$14
				JSR	PLUGUP
ROSKIP3			INC	SCRPICK
				LDA	SCRPICK
				CMP	#scrnPROGRAM+1
				BEQ	NOROL2	
				JMP	ROLOOP2
NOROL2			PLA
				STA	PLEVEL
				RTS

PLUGUP			STA	STOP18
				STA	STOP19
				STA	STOP1A
				STA	STOP1B
				RTS

BTRANS			LDX	PICK
				BNE	BTSKIP
				JMP	MT1BOTM
BTSKIP			JMP	MT2BOTM
