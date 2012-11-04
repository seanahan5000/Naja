*===============================
*
*===============================

FIGHT_SCREEN	LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				LDA	#GREEN
				STA	COLOR
				LDA	#<BOX2
				STA	POINTL
				LDA	#>BOX2
				STA	POINTH
				JSR	LINEOUT
				LDA	#WHITE1
				STA	COLOR
				JSR	DO_GRID
				JSR	DRAW_ALLMONS
				JSR	DRAW_MNAMES
				LDA	#$82
				STA	SELECT
				LDA	#$02
				STA	YPNT
				JSR	HEADER
				LDY	#0
				STY	COUNT
:LOOP1			LDA	YPOINTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	COUNT
				LDY	COUNT
				CPY	GRPNUMB
				BNE	:LOOP1
				RTS


*-------------------------------
*
*-------------------------------

DO_GRID			LDA	#$53
				STA	YCOUNT
:LOOP1			LDA	#$18
				STA	XCOUNT
:LOOP2			LDA	YCOUNT
				LDX	XCOUNT
				LDY	#$00
				JSR	HPLOT
				LDA	XCOUNT
				CLC
				ADC	#$0F
				STA	XCOUNT
				CMP	#$54
				BNE	:LOOP2
:SKIPA			LDA	YCOUNT
				CLC
				ADC	#$0B
				STA	YCOUNT
				CMP	#$7F
				BEQ	:SKIPA
				CMP	#$B6
				BNE	:LOOP1

				LDA	#$00
				STA	COUNT
:LOOP3			LDA	COUNT
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				PHA
				JSR	FROM11
				PLA
				LSR
				LSR
				LSR
				LSR
				JSR	TVIEWIT
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP3

				LDA	#$8D
				STA	TEXTBUF+1
				LDA	#$4B
				STA	LINECNT
				LDA	#$14
				STA	COUNT
:LOOP4			STA	TEXTBUF
				LDA	#$00
				LDY	LINECNT
				JSR	LINE
				LDA	COUNT
				CMP	#$10
				BCC	:SKIPB
				LDA	#$32
				STA	TEXTBUF
				LDA	#$5C
				LDY	LINECNT
				DEY
				JSR	LINE
:SKIPB			LDA	LINECNT
				CLC
				ADC	#$0B
				STA	LINECNT
				DEC	COUNT
				LDA	COUNT
				CMP	#$0A
				BNE	:LOOP4

				LDA	#$01
				STA	TEXTBUF
				LDA	#$0E
				STA	LINECNT
:LOOP5			LDA	LINECNT
				LDY	#$B9
				JSR	LINE
				LDA	LINECNT
				CLC
				ADC	#$0F
				STA	LINECNT
				LDA	TEXTBUF
				INC	TEXTBUF
				CMP	#$05
				BNE	:LOOP5
				RTS


*-------------------------------
*
*-------------------------------

DRAW_ALLMONS	LDA	#0
				STA	MONS_NUMBER
:LOOP1			JSR	POINTTO
				JSR	DRAW_ALIEN
				INC	MONS_NUMBER
				LDA	MONS_NUMBER
				CMP	MONS_TOTAL
				BNE	:LOOP1
				RTS


*-------------------------------
*
*-------------------------------

DRAW_MNAMES		LDA	#$06
				STA	YCOUNT
				LDA	#4
				STA	ZCOUNT
:LOOP1			LDA	#$FF
				STA	MNAME_HOLD
				STA	XCOUNT
				LDA	#0
				STA	MONS_NUMBER
:LOOP2			JSR	GET_MONSPTR
				LDY	#monPOSITION
				LDA	(TEMP),Y
				AND	#%00001111
				CMP	YCOUNT
				BNE	:SKIPA
				LDA	(TEMP),Y
				CMP	XCOUNT
				BCS	:SKIPA
				STA	XCOUNT
				LDY	#monNUMBER
				LDA	(TEMP),Y
				TAX
				LDA	ALTYPE1,X
				AND	#%11000000
				STA	MNAME_HOLD
:SKIPA			INC	MONS_NUMBER
				LDA	MONS_NUMBER
				CMP	MONS_TOTAL
				BNE	:LOOP2
				LDX	ZCOUNT
				LDA	MNAME_HOLD
				STA	MNAME_TABLE,X
				CMP	#$FF
				BEQ	:SKIPC
				ROL
				ROL
				ROL
				CMP	#%00000011
				BNE	:SKIPB
				LDA	#$00
:SKIPB			TAY
				LDX	ZCOUNT
				LDA	YPNTS,X
				SEC
				SBC	#$36
				STA	ALIEN+2
				STA	ROBOT+2
				STA	UNKNOWN+2
				JSR	TEXTER
:SKIPC			INC	YCOUNT
				DEC	ZCOUNT
				BPL	:LOOP1
				RTS

MNAME_HOLD		DB	0

*-------------------------------

TEXTER			TYA
				ASL
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT

TEXTS			DW	UNKNOWN
				DW	ALIEN
				DW	ROBOT

UNKNOWN			PLOTAT	102;0;(UNKNOWN)+
ALIEN			PLOTAT	102;0;(ALIEN)+
ROBOT			PLOTAT	102;0;(ROBOT)+

*-------------------------------

BOX2			DB	$00,$07,$7F
				DB	$00,$07,$B7
				DB	$00,$55,$B7
				DB	$00,$55,$47
				DB	$00,$07,$47
				DB	$00,$07,$7F
				DB	$00,$55,$7F
				DB	$FE
				DB	$00,$59,$7F		;BOXA
				DB	$00,$59,$BF
				DB	$01,$05,$BF
				DB	$01,$05,$B7
				DB	$01,$15,$B7
				DB	$01,$15,$47
				DB	$00,$59,$47
				DB	$00,$59,$7F
				DB	$01,$15,$7F
				DB	$FE
				DB	$00,$CB,$48		;DIVIDE2
				DB	$00,$CB,$7E
				DB	$FF

*-------------------------------
