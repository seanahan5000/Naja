
				LDX	#<DS_DATA
				LDY	#>DS_DATA
				JSR	SET_TLP_DATA

				JSR	HGR
				JSR	NOSCAN
				LDA	DOORED
				BEQ	DOORER
				JMP	NODOORD
DOORER			JSR	MOVETO2
				LDA	#RED
				STA	COLOR
				LDY	#0
				JSR	LINER
				LDY	#0
				JSR	PICKER
				LDA	#$00
				STA	COUNT
ROLOOP			JSR	POINTIT
				LDY	#$0D
				LDA	(CHARDL),Y
				AND	#$F0
				CMP	#$10
				BEQ	GOTROID
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	ROLOOP
				BEQ	NOASK
GOTROID			JSR	QUESTIN
				LDA	#$00
				STA	MAXTEXT
				JSR	INPUT2
REKEYER			LDA	TEXTBUF
				CMP	#$D9
				BEQ	DYES
				CMP	#$CE
				BEQ	DNO
				CMP	#$8D
				BNE	NORETTN
				JSR	CHAROUT
NORETTN			JSR	RECALL
				JMP	REKEYER
DYES			LDA	#$40
				STA	PAGE
				LDA	#$FF
				STA	DOORED
				LDY	#0
				JSR	TEXTER
				LDY	#0
				JSR	LINER
				STA	SCNDARY
				LDA	#$20
				STA	PAGE
				JSR	MOVETO1
				STA	PRIMARY
				JMP	NOASK

DNO				JSR	CHAROUT
				JSR	QUESTIN
				JMP	NOASK
NODOORD			LDA	#RED
				STA	COLOR
				LDY	#0
				JSR	LINER
				LDY	#0
				JSR	TEXTER
NOASK			PLA
				PLA
NOKEY			LDA	KEYBRD
				BPL	NOKEY
				JSR	CPARER1
				BEQ	GORD
				BIT	UNSTROB
				JMP	NOKEY
GORD			JMP	RDKEY					; TODO: should RTS instead of jumping

TOWORD			USR(_TO)

QUESTIN			LDY	#1
				JSR	TEXTER
				LDY	#$09
ANLOOP			LDA	(CHARDL),Y
				STA	TEXTBUF,Y
				DEY
				BPL	ANLOOP
				LDY	#$09
SPLOOP			LDA	TEXTBUF,Y
				CMP	#$0A
				BNE	GOTASP
				DEY
				BPL	SPLOOP
GOTASP			INY
				LDX	#$00
TOLOOP			LDA	TOWORD,X
				STA	TEXTBUF,Y
				INY
				INX
				CPX	#$04
				BNE	TOLOOP
				JSR	LINE2
				LDY	#2
				JMP	TEXTER

DS_DATA			DW	DS_TEXTS
				DW	DS_LINES
				DW	DS_PICTS

DS_TEXTS		DW	:TEXT0
				DW	:TEXT1
				DW	:TEXT2

:TEXT0			DB	$09,$04,$34
				USR(THIS_MARKS_THE_BORDER_OF)

				DB	$0A,$06,$3D
				USR(EMPEROR_RUUIK'S_ROYAL)

				DB	$11,$03,$46
				USR(DOMAIN)+

:TEXT1			DB	$09,$01,$7E
				USR(DO_YOU_WANT_)+

:TEXT2			DB	$09,$01,$86
				USR(TRANSLATE_THE_WRITING?_)+

DS_LINES		DW	:OLINE

:OLINE			DB	$00,$39,$2F
				DB	$00,$DB,$2F
				DB	$00,$DB,$51
				DB	$00,$39,$51
				DB	$00,$39,$30
				DB	$00,$D9,$30
				DB	$00,$D9,$50
				DB	$00,$3B,$50
				DB	$00,$3B,$30
				DB	$FF

DS_PICTS		DW	:WRITPIC

:WRITPIC		DB	$34,$4B,$0A
				DB	$1D,$FE,$09
				DB	$00,$FE,$06
				DB	$0F,$FE,$14
				DB	$00,$18,$18
				DB	$FE,$05,$00
				DB	$FE,$06,$1E
				DB	$FE,$09,$00
				DB	$3C,$3C,$30
				DB	$30,$0C,$0C
				DB	$00,$00,$00
				DB	$3C,$3C,$00
				DB	$00,$0C,$0C
				DB	$FE,$09,$00
				DB	$19,$19,$60
				DB	$60,$79,$79
				DB	$00,$00,$00
				DB	$01,$01,$79
				DB	$79,$01,$01
				DB	$FE,$09,$00
				DB	$40,$40,$03
				DB	$03,$70,$70
				DB	$00,$00,$00
				DB	$73,$73,$70
				DB	$70,$73,$73
				DB	$FE,$09,$00
				DB	$01,$01,$66
				DB	$66,$07,$07
				DB	$00,$00,$00
				DB	$67,$67,$FE
				DB	$04,$61,$FE
				DB	$09,$00,$4F
				DB	$4F,$0F,$0F
				DB	$4F,$4F,$00
				DB	$00,$00,$4C
				DB	$4C,$4F,$4F
				DB	$4C,$4C,$FE
				DB	$06,$01,$00
				DB	$00,$00,$06
				DB	$06,$1E,$1E
				DB	$06,$06,$00
				DB	$00,$00,$1E
				DB	$1E,$06,$06
				DB	$1E,$1E,$FE
				DB	$04,$43,$4C
				DB	$4C,$FE,$05
				DB	$00,$0C,$0C
				DB	$3C,$3C,$FE
				DB	$05,$00,$3C
				DB	$3C,$00,$00
				DB	$1E,$1E,$18
				DB	$18,$06,$06
				DB	$00,$00,$00
				DB	$18,$18,$78
				DB	$78,$79,$79
				DB	$00,$00,$00
				DB	$79,$79,$61
				DB	$61,$79,$79
				DB	$FE,$06,$0C
				DB	$00,$00,$00
				DB	$33,$33,$30
				DB	$30,$43,$43
				DB	$00,$00,$00
				DB	$70,$70,$73
				DB	$73,$70,$70
				DB	$01,$01,$79
				DB	$79,$01,$01
				DB	$00,$00,$00
				DB	$06,$06,$01
				DB	$01,$66,$66
				DB	$00,$00,$00
				DB	$61,$61,$FE
				DB	$04,$67,$40
				DB	$40,$70,$70
				DB	$40,$40,$00
				DB	$00,$00,$0F
				DB	$0F,$43,$43
				DB	$0F,$0F,$00
				DB	$00,$00,$4F
				DB	$4F,$43,$43
				DB	$4F,$4F,$FE
				DB	$09,$00,$FE
				DB	$06,$1E,$00
				DB	$00,$00,$1E
				DB	$1E,$18,$18
				DB	$06,$06,$FE
				DB	$09,$00,$3C
				DB	$3C,$0C,$0C
				DB	$3C,$3C,$00
				DB	$00,$00,$FE
				DB	$06,$0C,$FE
				DB	$09,$00,$01
				DB	$01,$79,$79
				DB	$FE,$05,$00
				DB	$78,$78,$79
				DB	$79,$78,$78
				DB	$FE,$09,$00
				DB	$43,$43,$70
				DB	$70,$30,$30
				DB	$00,$00,$00
				DB	$30,$30,$70
				DB	$70,$33,$33
				DB	$FE,$09,$00
				DB	$FE,$04,$67
				DB	$60,$60,$00
				DB	$00,$00,$61
				DB	$61,$67,$67
				DB	$06,$06,$FE
				DB	$09,$00,$FE
				DB	$04,$43,$03
				DB	$03,$00,$00
				DB	$00,$FE,$04
				DB	$4C,$0F,$0F
				DB	$FE,$09,$00
				DB	$1E,$1E,$FE
				DB	$04,$06,$FE
				DB	$09,$00
