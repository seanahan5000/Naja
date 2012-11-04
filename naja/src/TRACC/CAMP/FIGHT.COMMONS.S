SET_FGHTFILES	LDX	#<FIGHT_FILES
				LDY	#>FIGHT_FILES
				JMP	SET_FILE_TABL


********************************
*
********************************

FROM11			LDY	#$1E
				LDA	(CHARDL),Y
FROM11B			PHA
				LSR
				LSR
				LSR
				LSR
				TAX
				DEX
				PLA
				AND	#$0F
				STA	TEMP
				LDA	#$05
				SEC
				SBC	TEMP
				TAY
				RTS


				DS	36				;**** FREE SPACE


********************************
*
********************************

FLUSH_DAMAGE	JSR	:SUB1			;Y HIGH, X LOW
				LDY	#$00
:LOOP1			LDA	(POINTL),Y
				BNE	:SKIPA
				LDA	#$EE
				STA	(POINTL),Y
:SKIPA			INY
				CPY	#$03
				BNE	:LOOP1
				RTS
:SUB1			TYA
				LDY	#$00
				JSR	:SUB0
				TXA
:SUB0			PHA
				LSR
				LSR
				LSR
				LSR
				STA	(POINTL),Y
				PLA
				AND	#$0F
				INY
				STA	(POINTL),Y
				INY
				RTS


********************************
*
********************************

TVIEWIT			STA	TEMP
				LDA	XPNTS,X
				STA	XCOORD
				LDA	YPNTS,Y
				STA	YCOORD
				JSR	SHFTCLC
				JSR	TABLER
				LDA	TEMP
				AND	#$7F
				TAY
				LDA	TCHROFF,Y
				PHA
				JSR	TCHRLOD
				INC	XCOORD
				PLA
				CLC
				ADC	#$07
				JSR	TCHRLOD
				DEC	XCOORD
				LDA	YCOORD
				CLC
				ADC	#$07
				STA	YCOORD
				JSR	TABLER
				LDA	TEMP
				AND	#$7F
				TAY
				LDA	PRBPICK,Y
				PHA
				LSR
				LSR
				LSR
				LSR
				ASL
				JSR	BCHRLOD
				INC	XCOORD
				PLA
				AND	#$0F
				ASL
				JSR	BCHRLOD
				RTS
TCHRLOD			TAY
				LDX	#$00
MORTCHR			LDA	TCHARS,Y
				STA	CHARTAB,X
				TXA
				LSR
				BCC	NIMAGE1
				BIT	TEMP
				BPL	NIMAGE1
				LDA	#$00
				STA	CHARTAB,X
NIMAGE1			INY
				INX
				CPX	#$07
				BNE	MORTCHR
				JSR	CHAROUT
				RTS
BCHRLOD			TAY
				LDX	#$00
MORBCHR			LDA	PRBOTM,Y
				CPX	#$02
				BCC	NOTA0
				LDA	#$00
NOTA0			STA	CHARTAB,X
				TXA
				LSR
				BCS	NIMAGE2
				BIT	TEMP
				BPL	NIMAGE2
				LDA	#$00
				STA	CHARTAB,X
NIMAGE2			INY
				INX
				CPX	#$07
				BNE	MORBCHR
				JSR	CHAROUT
				RTS

XPNTS			DB	$0A,$19,$28
				DB	$37,$46
YPNTS			DB	$80,$8B,$96
				DB	$A1,$AC
TCHROFF			DB	$00,$0E,$1C
				DB	$2A,$38,$46
				DB	$54,$62,$70
TCHARS			DB	$32,$73,$7B
				DB	$1B,$6F,$6F
				DB	$6E
				DB	$26,$67,$6F
				DB	$6C,$7B,$7B
				DB	$3B
				DB	$30,$70,$18
				DB	$6C,$6F,$6F
				DB	$6F
				DB	$06,$07,$0C
				DB	$1B,$7B,$7B
				DB	$7B
				DB	$30,$77,$73
				DB	$7B,$3F,$1F
				DB	$1E
				DB	$06,$77,$67
				DB	$6F,$7E,$7C
				DB	$3C
				DB	$30,$70,$78
				DB	$1C,$6F,$2F
				DB	$6F
				DB	$06,$67,$6F
				DB	$6C,$7B,$7A
				DB	$3B
				DB	$30,$70,$38
				DB	$5C,$6F,$77
				DB	$4F
				DB	$06,$07,$0E
				DB	$1D,$7B,$77
				DB	$79
				DB	$32,$73,$7B
				DB	$1B,$6F,$2F
				DB	$6E
				DB	$26,$67,$6F
				DB	$6C,$7B,$7A
				DB	$3B
				DB	$30,$77,$3B
				DB	$5B,$6F,$77
				DB	$4E
				DB	$06,$77,$6E
				DB	$6D,$7B,$77
				DB	$39
				DB	$30,$73,$7B
				DB	$7B,$3F,$1F
				DB	$1E
				DB	$06,$67,$6F
				DB	$6F,$7E,$7C
				DB	$3C
				DB	$38,$78,$08
				DB	$6F,$69,$69
				DB	$6F
				DB	$0E,$0F,$08
				DB	$7B,$4B,$4B
				DB	$7B
PRBPICK			DB	$01,$67,$89
				DB	$01,$23,$01
				DB	$23,$AB,$45
PRBOTM			DB	$18,$70
				DB	$0C,$07
				DB	$3C,$70
				DB	$1E,$07
				DB	$08,$78
				DB	$08,$0F
				DB	$0C,$78
				DB	$18,$0F
				DB	$38,$60
				DB	$0E,$03
				DB	$38,$70
				DB	$0E,$07


FIGHT_FILES
				DB	$78				;fLoader1
				DW	$0120
				DB	4

				DB	$60				;fLoader2
				DW	$0124
				DB	11

				DB	$63				;fCommand
				DW	$0150
				DB	$3D

				DB	$63				;fNarrate
				DW	$01A0
				DB	$4D

				DB	$90				;fAwarder
				DW	$0200
				DB	$10				;(THIS MAY CHANGE)

				DB	$80				;fDeadGroup
				DW	$0210
				DB	$10

				DB	$63				;fReNarrate
				DW	$01A0
				DB	$3D				;Whatever fCommand is

				DS	4*3				;FREE SPACE****
