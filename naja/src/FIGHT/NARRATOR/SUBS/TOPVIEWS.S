*-------------------------------
*
*-------------------------------

DRAW_IF_DEAD	LDA	DEAD_FLAG
				LSR
				BCC	:EXIT
				AND	#%00000001
				PHA
				LDA	DEAD_XY
				JSR	FROM11B
				LDA	XPNTS,X
				TAX
				LDA	YPNTS,Y
				TAY
				PLA
				JSR	DRAW_MISC_AT
:EXIT			RTS


*----------------------------------------
* On Entry:
*    X,Y: Position in screen coordinates
*      A: Image number
*             0 = Horizontal dead guy
*             1 = Vertical dead guy
*----------------------------------------

DRAW_MISC_AT	STX	XPNT
				STY	YPNT
DRAW_MISC		TAY
				LDA	:DIMENS,Y
				PHA
				LDX	:ADR_LOW,Y
				LDA	:ADR_HIGH,Y
				TAY
				PLA
				JMP	DRAW_TOPVIEW

:ADR_LOW		DB	<HDEAD
				DB	<VDEAD
:ADR_HIGH		DB	>HDEAD
				DB	>VDEAD
:DIMENS			DB	$42,$23

HDEAD			DB	$00,$70,$78
				DB	$5C,$0E,$00
				DB	$40
				DB	$00,$40,$73
				DB	$0F,$7E,$7C
				DB	$7F
				DB	$06,$1F,$7C
				DB	$7E,$FF
				DB	$00,$00,$00
				DB	$1D,$3F,$1F
				DB	$01
				DB	$7C,$1F,$80
				DB	$03,$80
				DB	$7E,$40,$80
				DB	$67,$3F,$1C
				DB	$80

VDEAD			DB	$00,$00,$00
				DB	$60,$38,$30
				DB	$60
				DB	$00,$30,$33
				DB	$19,$18,$9C
				DB	$60,$40,$50
				DB	$58,$4C,$6E
				DB	$7C
				DB	$0F,$0F,$0F
				DB	$87
				DB	$78,$60,$40
				DB	$40,$60,$40
				DB	$00
				DB	$0F,$0F,$1D
				DB	$3B,$33,$19
				DB	$0C


*-------------------------------
*
*-------------------------------

DRAW_IMAGENS	LDA	#$00
				STA	XCOUNT
				STA	YCOUNT
				STA	COUNT
:LOOP1			LDX	COUNT
				LDA	MASTER_CGRID,X
				BPL	:SKIPA
				AND	#$7F
				CMP	#$7F
				BEQ	:SKIPA
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				ORA	#$80
				LDX	XCOUNT
				LDY	YCOUNT
				JSR	TVIEWIT
:SKIPA			INC	XCOUNT
				LDA	XCOUNT
				CMP	#5
				BNE	:SKIPB
				LDA	#0
				STA	XCOUNT
				INC	YCOUNT
:SKIPB			INC	COUNT
				LDA	COUNT
				CMP	#25
				BNE	:LOOP1
				RTS

*-------------------------------

BLINK_MONS		JSR	:SUBA
				BIT	KEYBRD
				BMI	:EXIT
:SUBA			JSR	:SUBB
:SUBB			JSR	DRAW_ALIEN
				LDA	#$C0
				JSR	WAIT2
:EXIT			RTS

BLINK_CHAR		JSR	:SUBA
				BIT	KEYBRD
				BMI	:EXIT
:SUBA			JSR	:SUBB
:SUBB			JSR	DRAW_CHAR
				JSR	DRAW_NAME
				LDA	#$C0
				JSR	WAIT2
:EXIT			RTS

DRAW_CHAR		LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				PHA
				LDX	CHAR_NUMBER
				LDA	TEMPCHAR_XY,X
				JSR	FROM11B
				PLA
				JMP	TVIEWIT

DRAW_NAME		JSR	PROFNAM
				LDA	#$10
				LDX	CHAR_NUMBER
				LDY	YPOINTS,X
				JMP	LINE
