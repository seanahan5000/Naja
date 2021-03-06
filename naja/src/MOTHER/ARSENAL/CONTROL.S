LINENUM			=	$00
COUNTER			=	$01
FACTOR			=	$02
SCRATCH			=	$06
BEGLINE			=	$0A
ENDLINE			=	$0B

WANTED1			=	ZBLOCK_A0+0
ON1				=	ZBLOCK_A0+1
ON2				=	ZBLOCK_A0+2
DISPLAY			=	ZBLOCK_A0+3
CURRENT			=	ZBLOCK_A0+4
CURSPNT			=	ZBLOCK_A0+5
MAXCURS			=	ZBLOCK_A0+6
CHUNK			=	ZBLOCK_A0+7

WHOPIC			=	ZBLOCK_A8+0
WHOSPIC			=	ZBLOCK_A8+1
LEAVLIN			=	ZBLOCK_A8+2
DSPLACE			=	LEAVLIN
CTABCNT			=	ZBLOCK_A8+3
SOURCE			=	ZBLOCK_A8+4
BRNCURS			=	ZBLOCK_A8+5		;+6,+7
CLSCURS			=	BRNCURS+1
YNOCURS			=	BRNCURS+2

LINUMB			=	ZBLOCK_80+0
LINECNT			=	ZBLOCK_80+1
DATPNTL			=	ZBLOCK_80+2
DATPNTH			=	ZBLOCK_80+3
NUMBIN			=	ZBLOCK_80+4
TABLCNT			=	ZBLOCK_80+5
DRAWFLG			=	ZBLOCK_80+6
ELECT			=	ZBLOCK_80+7

PHYSIC			=	ZBLOCK_88+0		;+1
MASK			=	ZBLOCK_80+2
APOINTER		=	ZBLOCK_80+3
THELEGL			=	ZBLOCK_80+4
*
*
*

				LDA	#$9C			;Must use $9C
				STA	SSTOREH
				LDX	#<charTrack+$0A
				LDY	#>charTrack+$0A
				LDA	#1
				JSR	FLOAD
				LDX	#67
TOPLOOP			LDA	$9C8B,X
				STA	PISTSTK,X
				DEX
				BPL	TOPLOOP

				BIT	UNSTROB
				LDA	#$01
				STA	DISPLAY
				LDA	#$00
				STA	ON1
				STA	ON2
				STA	CURRENT
				STA	SOURCE
				STA	STCKDIF
				LDA	#$01
				STA	DISPLAY
				STA	WANTED1
				JSR	CLEAR2
				LDA	#$40
				STA	PAGE
				LDA	#GREEN
				STA	COLOR
				LDY	#$00
				JSR	LINER
				LDA	#$02
				STA	YPNT
				LDA	#$42
				STA	SELECT
				JSR	HEADER
				LDA	#$00
				STA	COUNT
STLOOP			LDY	COUNT
				LDA	AYPOINTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	STLOOP
				JSR	DRAW_SCREEN
				LDA	#$0A
				STA	ON1
MAIN_LOOP		LDA	WANTED1
				CMP	#$05
				BCC	:SKIPA
				CMP	#$09
				BCS	:SKIPA
				JSR	MARKIT
:SKIPA			LDA	WANTED1
				CMP	#$02
				BNE	:SKIPB
				JSR	RESET_CHRLIST
				LDA	#0
				STA	LEGALS+7
:SKIPB			LDY	DISPLAY
				DEY
				LDA	WANTED1
				CMP	#$02
				BNE	:SKIPC
				LDA	#$00
:SKIPC			STA	ON1,Y
				LDY	WANTED1
				DEY
				LDA	MAXOPTS,Y
				STA	MAXCURS
				LDA	WANTED1
				CMP	CURRENT
				BCC	ATBOTM
				LDA	#$00
				STA	CURSOR
				BEQ	GOTMAX
ATBOTM			LDA	MAXCURS
				STA	CURSOR
				DEC	CURSOR
GOTMAX			LDA	WANTED1
				STA	CURRENT
				CMP	#$01
				BNE	NOTMAIN
				LDA	SOURCE
				STA	CURSOR
NOTMAIN			LDA	WANTED1
				CMP	#$04
				BCS	NOMAIN
				CMP	#$02
				BCC	NOMAIN
MAINER			LDY	CURSOR
				LDA	LEGALS,Y
				BEQ	NOMAIN
				INC	CURSOR
				BNE	MAINER
NOMAIN			JSR	CURSITA
ABLINK			LDA	#$10
				JSR	WAIT
				LDA	#$F0
				JSR	WAIT2
				BMI	AKEYGOT
				JSR	CURSITA
				LDA	#$00
				JSR	WAIT2
				JSR	CURSITA
ARKEY			BIT	KEYBRD
				BPL	ABLINK
AKEYGOT			LDA	KEYBRD
				BIT	UNSTROB
				CMP	#$9B
				BEQ	GETOUT
				JSR	CHECK_UP
				BEQ	GOUP1
				JSR	CHECK_DOWN
				BEQ	GODOWN1
				JSR	CHECK_ENTER
				BEQ	ENTERIT
				BIT	UNSTROB
				JMP	ARKEY
GETOUT			JMP	ARSOUT
GOUP1			JSR	CURSITA
GOUP1A			LDA	CURSOR
				BNE	NOTATOP
				LDA	MAXCURS
				STA	CURSOR
				DEC	CURSOR
				JMP	UPCOM
NOTATOP			DEC	CURSOR
UPCOM			LDA	CURRENT
				CMP	#$04
				BCS	NOTHER
				CMP	#$02
				BCC	NOTHER
				LDY	CURSOR
				LDA	LEGALS,Y
				BNE	GOUP1A
NOTHER			JSR	CURSITA
				BIT	UNSTROB
				JMP	ARKEY
GODOWN1			JSR	CURSITA
GODWN1B			INC	CURSOR
				LDA	CURSOR
				CMP	MAXCURS
				BNE	NOTBOT
				LDA	#$00
				STA	CURSOR
NOTBOT			LDA	CURRENT
				CMP	#$04
				BCS	NOTHER1
				CMP	#$02
				BCC	NOTHER1
				LDY	CURSOR
				LDA	LEGALS,Y
				BNE	GODWN1B
NOTHER1			JSR	CURSITA
				JMP	ARKEY

ENTERIT			JSR	CURSITA
				LDA	WANTED1
				CMP	#$05
				BCC	NOMARKS
				CMP	#$09
				BCS	NOMARKS
				JSR	MARKIT
NOMARKS			LDA	CURRENT
				CMP	#$01
				BNE	NOTA22
				LDX	CURSOR
				STX	SOURCE
NOTA22			CMP	#$04
				BCS	USUAL
				LDY	CURSOR
				CMP	#$02
				BNE	NOTWHO
				STY	WHOPIC
				BEQ	USUAL			;Always
NOTWHO			CMP	#$03
				BNE	USUAL
				STY	WHOSPIC
				CPY	#$07
				BEQ	USETOTL
				TYA
				JSR	POINTIT
				LDY	#credits+3
				LDX	#3
:LOOP1			LDA	(CHARDL),Y
				STA	TOTAL_CREDITS,X
				DEY
				DEX
				BPL	:LOOP1
				BMI	USUAL			;Always
USETOTL			JSR	POOL_TO_TOTAL
USUAL			LDY	CURRENT
				DEY
				LDA	DESTOFF,Y
				CLC
				ADC	CURSOR
				TAX
				LDA	DESTDAT,X
				CMP	#$FE
				BNE	NOTODD1
				LDA	#$05
				LDX	SOURCE
				BEQ	NOTODD1
				LDA	#$04
NOTODD1			STA	WANTED1
				JSR	DRAW_SCREEN
				LDA	WANTED1
				CMP	#$0F
				BCS	:SKIPA
				CMP	#$0A
				BCC	:SKIPC
				CMP	#$0D
				BCS	:SKIPB
:SKIPA			JMP	BUY_EQUIPMNT
:SKIPB			JMP	BUY_ARMHELM
:SKIPC			JMP	MAIN_LOOP

MARKIT			LDA	#$06
				STA	XPNT
				LDY	WHOPIC
				LDA	AYPOINTS,Y
				STA	YPNT
				LDA	#4
				JMP	SPCHARS

DESTOFF			DB	0,DEST2-DESTDAT,DEST3-DESTDAT
				DB	DEST4-DESTDAT,DEST5-DESTDAT,DEST6-DESTDAT
				DB	DEST7-DESTDAT,DEST8-DESTDAT

DESTDAT			DB	$02,$02,$02
				DB	$02,$00
DEST2			DB	$03,$03,$03
				DB	$03,$03,$03
				DB	$03,$01
DEST3			DB	$FE,$FE,$FE
				DB	$FE,$FE,$FE
				DB	$FE,$FE,$01
DEST4			DB	$09,$09,$09
				DB	$09,$09,$09
				DB	$09,$01
DEST5			DB	$06,$07,$08
				DB	$01
DEST6			DB	$0A,$0B,$0C
				DB	$05
DEST7			DB	$0D,$0F,$0E
				DB	$10,$11,$05
DEST8			DB	$12,$13,$14
				DB	$05
