*-------------------------------
* On Entry:
*   X -> INSTR1
*   Y -> INSTR2
*   A -> TIMTAKE

GENERAL_POST	STX	INSTR1
				STY	INSTR2
				STA	TIMTAKE

POST_COMMAND	LDX	COMCNT
				LDA	TIMLEFT
				STA	CTIMTAB,X
				LDY	COMPNTR
				LDA	INSTR1
				STA	COMMAND,Y
				INY
				INC	COMPNTR
				LDA	INSTR2
				STA	COMMAND,Y
				INC	COMPNTR
				JSR	DOTIME3
				LDA	TIMLEFT
				SED
				SEC
				SBC	TIMTAKE
				STA	TIMLEFT
				CLD
				JSR	DOTIME3
COMND2			LDA	COMCNT
				CMP	#$0A
				BNE	GOCOMR
				LDA	INSTR1
				PHA
				LDA	INSTR2
				PHA
				JSR	MOVOVER
				PLA
				STA	INSTR2
				PLA
				STA	INSTR1
GOCOMR			JSR	COMMER
				INC	COMCNT
				RTS

DOTIME3			LDA	TIMLEFT
				LSR
				LSR
				LSR
				LSR
				STA	TEXTBUF
				LDA	TIMLEFT
				AND	#$0F
				STA	TEXTBUF+1
				LDA	#$8D
				STA	TEXTBUF+2
				LDA	#$25
				STA	XCOORD
				LDA	#$03
				STA	SHIFT
				LDA	#$4C
				STA	YCOORD
				JMP	LINE2

COMMER			LDY	COMCNT
				LDA	COMYS,Y
				STA	YPNT
				CPY	#$0A
				BCS	ISFINE
				TYA
				CLC
				ADC	#$05
				TAY
ISFINE			LDA	COMXS,Y
				STA	XPNT
COMR2			JSR	COMANDR
				LDA	XPNT
				LDY	YPNT
				JSR	LINE
				LDX	#$06
				LDY	#$02
SLIDIT			LDA	TEXTBUF,X
				STA	TEXTBUF,Y
				DEX
				DEY
				BPL	SLIDIT
				LDA	XPNT
				CLC
				ADC	#$14	
				BCS	OFLOW
				LDY	YPNT
				JMP	LINE	
OFLOW			LDA	#$05
				STA	SHIFT
				LDA	#$25
				STA	XCOORD
				JMP	LINE2

COMYS			DFB	$57,$5F,$67
				DFB	$6F,$77,$57
				DFB	$5F,$67,$6F
				DFB	$77,$57,$5F
				DFB	$67,$6F,$77
COMXS			DFB	$A8,$A8,$A8
				DFB	$A8,$A8,$CE
				DFB	$CE,$CE,$CE
				DFB	$CE,$F4,$F4
				DFB	$F4,$F4,$F4

INSTR1			DFB	$00
INSTR2			DFB	$00

COMANDR			LDA	INSTR1
				AND	#$0F
				STA	SCRATCH
				ASL
				CLC
				ADC	SCRATCH
				TAY
				LDX	#$00
WORDER			LDA	WORD3,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$03
				BNE	WORDER
				LDA	#$8D
				STA	TEXTBUF+3
				STA	TEXTBUF+6
				LDY	SCRATCH
				LDX	TYPE2,Y
				LDA	TYPES+1,X
				PHA
				LDA	TYPES,X
				PHA
				RTS

TYPES			DW	CXY-1
				DW	CXF-1
				DW	HUL-1
				DW	NTS-1
				DW	QST-1
				DW	NOT-1

CXY				LDA	INSTR1
				AND	#%00001111
				CMP	#cmdIDENTIFY
				BNE	CXYSKIP
				LDA	INSTR2
				BPL	CXYSKIP	
				JMP	NOT
CXYSKIP			LDA	INSTR2
				LSR
				LSR
				LSR
				LSR
				AND	#%00000111
				STA	TEXTBUF+4
				LDA	INSTR2
				AND	#%00001111
				CLC
				ADC	#$0A
				STA	TEXTBUF+5
				RTS

CXF				LDA	INSTR2
				AND	#$07
				STA	TEXTBUF+4
				LDA	#$10
				STA	TEXTBUF+5
				LDA	INSTR2
				AND	#$70
				CMP	#$60
				BNE	NOWOVER
				INC	TEXTBUF+5
NOWOVER			LDA	INSTR2
				AND	#$18
				LSR
				LSR
				LSR
				CMP	#$01
				BEQ	CXOUT
				CMP	#$03
				BEQ	CXOUT
				CMP	#$02
				BNE	MINUSON
				INC	TEXTBUF+4
				BNE	CXOUT
MINUSON			DEC	TEXTBUF+4
CXOUT			RTS

HUL				LDA	#$1F
				STA	TEXTBUF+4
				LDA	#$16
				STA	TEXTBUF+5
				BIT	INSTR1
				BPL	NOTLOW
				LDA	#$16
				STA	TEXTBUF+4
NOTLOW			BIT	INSTR1
				BVC	HULOUT
				LDA	#$1C
				STA	TEXTBUF+5
HULOUT			RTS

NTS				LDA	INSTR2
NTS2			LSR
				LSR
				LSR
				LSR
				STA	TEXTBUF+4
				LDA	INSTR2
				AND	#$0F
				STA	TEXTBUF+5
				RTS

QST				NOP
NOT				LDA	#$0A
				STA	TEXTBUF+4
				STA	TEXTBUF+5
				RTS

TYPE2			DFB	$02,$06,$08
				DFB	$00,$04,$04
				DFB	$00,$00,$00
				DFB	$04,$06,$0A
				DFB	$0A

MOVOVER			LDA	#$40
				STA	PAGE
				LDA	#$80
				STA	PRESTOP+1
				LDX	#$48	
				JSR	CLROOP2
				LDA	#$BF
				STA	PRESTOP+1
				LDA	#GREEN
				STA	COLOR
				LDY	#$02
				JSR	LINER
				LDY	#$03	
				JSR	LINER
MOVBACK			LDY	#$00
				JSR	TEXTER
				JSR	DOTIME3
				LDA	COMCNT
				PHA
				LDA	COMPNTR
				PHA
				DEC	COMCNT
				DEC	COMPNTR
				DEC	COMPNTR
				DEC	COMPNTR	
MVLOOP			LDY	COMPNTR
				LDA	COMMAND,Y
				STA	INSTR2
				DEC	COMPNTR
				DEY
				LDA	COMMAND,Y
				STA	INSTR1
				DEC	COMPNTR
				LDY	COMCNT
				LDA	COMYS,Y
				STA	YPNT
				LDA	COMXS,Y
				STA	XPNT
MOVMOD			JSR	COMR2
				DEC	COMCNT
				BPL	MVLOOP
				JSR	SWAP
				LDA	#$20
				STA	PAGE
				PLA
				STA	COMPNTR
				PLA
				STA	COMCNT
				RTS

WORD3			USR	(SWN)-
				USR	(SHT)-
				USR	(ENR)-
				USR	(THW)-
				USR	(USE)-
				USR	(XXX)-
				USR	(AIM)-
				USR	(MOV)-
				USR	(IDN)-
				USR	(EXC)-
				USR	(PAR)-
				USR	(RUN)-
				USR	(TES)-

DOTIME2			LDX	OPTSPOT
				LDY	TIME_TYPES,X
				LDA	TIMES,Y
				STA	CURTIME
DOTIME			LDA	CURTIME	
				LSR
				LSR
				LSR
				LSR
				STA	TEXTBUF
				LDA	CURTIME
				AND	#$0F
				STA	TEXTBUF+1
				LDA	#$8D
				STA	TEXTBUF+2
				LDA	#$25
				STA	XCOORD
				LDA	#$06
				STA	SHIFT
				LDA	#$B9
				STA	YCOORD	
				JMP	LINE2

TIME_TYPES		DB	timeSWING
				DB	timeAimSHOOT
				DB	timeAimENERGY
				DB	timeTHROW
				DB	timeUSE
				DB	upupTime		;Was ADJUST
				DB	timeAIM

				DB	timeMOVE
				DB	timeIDENTIFY
				DB	timeEXCHANGE
				DB	timePARRY
				DB	allTime			;timeRUN
				DB	allTime			;timeTESSERACT
				DB	noTime

				DB	noTime
				DB	noTime
				DB	noTime
				DB	noTime
				DB	noTime
				DB	noTime
				DB	noTime

OPTIONS			JSR	TIMTABL
				JSR	CAN_CANT
				LDA	#$72
				STA	COLUMN
				LDA	#$81
				STA	LINECNT
				LDA	#$00
				STA	COUNT
NOTHOPT			LDY	COUNT
				LDA	OPT_LEGALS,Y
				BMI	DOSKWAR
				LDX	OFFSET,Y
				LDY	#$00
MOROPT			LDA	OPT0,X
				STA	TEXTBUF,Y
				INX
				INY
				CMP	#$8D
				BNE	MOROPT
				LDA	COLUMN
				LDY	LINECNT
				JSR	LINE
				JMP	NODO
DOSKWAR			LDA	COUNT
				CMP	#$06	
				BEQ	NODO
				CMP	#$0D	
				BEQ	NODO
				LDA	LINECNT	
				STA	YPNT
				LDA	COLUMN	
				STA	XPNT
				LDA	#0
				LDX	#<MARKER_SHAPE
				LDY	#>MARKER_SHAPE
				JSR	DRAW_SHAPES
NODO			INC	COUNT
				LDA	LINECNT
				CLC
				ADC	#$09
				STA	LINECNT
				LDA	COUNT
				CMP	#$07
				BNE	NOTCOL2
				LDA	#$AD
				STA	COLUMN
				BNE	ISCOL23			;Always
NOTCOL2			CMP	#$0E
				BNE	NOTCOL3
				LDA	#$F4
				STA	COLUMN
ISCOL23			LDA	#$81
				STA	LINECNT
				BNE	NOTHOPT			;Always
NOTCOL3			CMP	#$14
				BNE	NOTHOPT
				RTS

MARKER_SHAPE	DB	%00000000
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00111111
				DB	%00000000

CAN_CANT		JSR	SET_HANDFLAGS
				JSR	MAKE_CONVERT
				LDX	#20
				LDA	#0
:LOOP1			STA	OPT_LEGALS,X
				DEX
				BPL	:LOOP1
				STX	OPT_LEGALS+5
				STX	OPT_LEGALS+6
				STX	OPT_LEGALS+12
				STX	OPT_LEGALS+13
				STX	OPT_LEGALS+20
				INX
:LOOP2			LDY	TIME_TYPES,X
				CPY	#noTime
				BEQ	:SKIPB
				LDA	COMCNT
				CMP	#15
				BEQ	:SKIPA
				LDA	TIMLEFT
				SED
				SEC
				SBC	TIMES,Y
				CLD
				BCS	:SKIPB
:SKIPA			LDA	#$FF
				STA	OPT_LEGALS,X
:SKIPB			INX
				CPX	#21
				BNE	:LOOP2

*-------------------------------
* IDENTIFY
*-------------------------------
CSKIP0			LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#android*$10
				BNE	:SKIPA
				JSR	RESET_EQLIST
				JSR	ESCAN_HANDBCK
				LDX	#back6
				LDA	#$FF
:LOOP1			STA	EQUIP_LIST,X
				DEX
				BPL	:LOOP1
				JSR	ESCAN_FULSLOT
				LDX	#<FIND_IDSCAN
				LDY	#>FIND_IDSCAN
				JSR	ESCAN_COMMON
				STY	WHERE_IDSCAN
				BCS	CSKIP1
:SKIPA			LDX	#$FF
				STX	OPT_LEGALS+cmdIDENTIFY
*-------------------------------
* RUN
*-------------------------------
CSKIP1			LDX	#$FF
				LDA	TIMLEFT
				CMP	TIMES+timeRUN
				BCS	CSKIP3
				STX	OPT_LEGALS+cmdRUN
*-------------------------------
* BACK1
*-------------------------------
CSKIP3			LDA	COMCNT
				BNE	CSKIP4
				STX	OPT_LEGALS+cmdBACK1
*-------------------------------
* OTHER
*-------------------------------
CSKIP4			LDA	PLANNER
				BEQ	CSKIP4B	
				LDX	#$00
CSLOOP4			TXA
				JSR	POINTIT
				JSR	BAD_STATUS
				BNE	CSKIP5
:SKIPA			INX
				CPX	PLANNER
				BNE	CSLOOP4
CSKIP4B			LDX	#$FF
				STX	OPT_LEGALS+cmdOTHER
*-------------------------------
* ENERGY
*-------------------------------
CSKIP5			LDA	PLANNER
				JSR	POINTIT
				JSR	PICKECT	
				CMP	#$FF	
				BEQ	CANT5
				LDA	COMCNT
				CMP	#14
				BCS	CANT5
				LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#juicer*$10
				BEQ	CSKIP6	
				CMP	#$70
				BEQ	CSKIP6	
CANT5			LDX	#$FF
				STX	OPT_LEGALS+cmdENERGY
*-------------------------------
* SHOOT
*-------------------------------
CSKIP6			LDA	#$01
				JSR	EQUIP_TYPER
				LDA	#$01
				JSR	LEGAL_HANDS
				JSR	ANDUP
				BNE	:SKIPA
				LDA	COMCNT
				CMP	#14
				BCC	CSKIP7
:SKIPA			LDX	#$FF
				STX	OPT_LEGALS+cmdSHOOT
*-------------------------------
* SWING
*-------------------------------
CSKIP7			LDX	PLANNER
				LDA	XYSPOTS,X
				AND	#$0F
				CMP	#$05
				BNE	NOFRON7	
				LDA	#$00
				JSR	EQUIP_TYPER
				LDA	#$00
				JSR	LEGAL_HANDS
				JSR	ANDUP
				BEQ	CSKIP9
NOFRON7			LDX	#$FF
				STX	OPT_LEGALS+cmdSWING
*-------------------------------
* THROW
*-------------------------------
CSKIP9			LDA	#$02
				JSR	EQUIP_TYPER
				LDA	#$02
				JSR	LEGAL_HANDS
				JSR	ANDUP
				BEQ	CSKIP10
				LDX	#$FF
				STX	OPT_LEGALS+cmdTHROW
*-------------------------------
* USE
*-------------------------------
CSKIP10			LDA	#$03
				JSR	EQUIP_TYPER
				LDA	#$03
				JSR	LEGAL_HANDS
				JSR	ANDUP
				BEQ	CSKIP11	
				LDX	#$FF
				STX	OPT_LEGALS+cmdUSE
*-------------------------------
* EXCHANGE
*-------------------------------
CSKIP11			LDX	#$FF
				LDY	#profrace
				LDA	(CHARDL),Y
				BPL	CSKIP12	
				STX	OPT_LEGALS+cmdEXCHANGE
*-------------------------------
* REDO
*-------------------------------
CSKIP12			LDA	COMCNT
				BNE	CANSOUT	
				STX	OPT_LEGALS+cmdREDO
CANSOUT			RTS
*-------------------------------


FIND_IDSCAN		LDA	(CHARDL),Y
				CMP	#$42			;SCANNERS
				BNE	:EXIT
				INY
				LDA	(CHARDL),Y
*            CMP  #$00            ;I.D. SCANNER
:EXIT			RTS


TIMTABL			LDA	PLANNER
				JSR	POINTIT
				LDY	#upreflex
				JSR	MUCH_TIME
				STA	TIMES+upTime
				LDY	#lwreflex
				JSR	MUCH_TIME
				STA	TIMES+loloTime
				PHA
				SED
				CLC
				ADC	TIMES+loloTime
				STA	TIMES+loloTime
				LDA	TIMES+upTime
				CLC
				ADC	TIMES+upTime
				STA	TIMES+upupTime
				PLA					;loloTime
				CLC
				ADC	TIMES+upTime
				STA	TIMES+uploTime
				CLD
				LDA	TIMLEFT
				STA	TIMES+allTime
				LDA	#$AA
				STA	TIMES+noTime
				LDA	#$01
				STA	TIMES+oneTime
				RTS

MUCH_TIME		LDA	(CHARDL),Y
				LDY	#$00
:LOOP1			CMP	MAXCUTS,Y
				BCC	:SKIPA
				BEQ	:SKIPA
				INY
				BNE	:LOOP1
:SKIPA			LDA	TMUNITS,Y
				RTS

MAXCUTS			DB	$16,$33,$50,$66,$82,$99
TMUNITS			DB	$36,$18,$12,$09,$07,$06
