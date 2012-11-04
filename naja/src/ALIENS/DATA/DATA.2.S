SNOWJOB			USR	("SUBZERO"_______)-	;A.1
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$10			;tview dimens, offset
				DB	$03,$30,$0B
				DB	$0C,$60,$72
				DB	$18,$00,$40
				DB	$78,$4E,$37
				DB	$4C,$38,$18
				DB	$23,$07,$1C
				DB	$1B,$3D,$76
				DB	$6C,$33,$0C
				DB	$1B,$01,$0E
				DB	$2C,$4D,$22
				DB	$0C,$80,$60
				DB	$03,$40,$80
				DB	$63,$60,$0D
				DB	$80,$10,$68
				DB	$80
				DB	$FF				;tview end mark

REPAIR			USR	(REPAIR_UNIT_1000)-	;B.2
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$45,$11			;tview dimens, offset
				DB	$7F,$03,$FB
				DB	$7F,$4C,$4D
				DB	$4D,$4D,$4D
				DB	$0D,$01,$7D
				DB	$55,$01,$7D
				DB	$01,$7C,$00
				DB	$00,$01,$00
				DB	$07,$86,$FB
				DB	$6D,$0D,$0D
				DB	$7D,$06,$7E
				DB	$06,$7B,$76
				DB	$6D,$6D,$0C
				DB	$6D,$3C,$06
				DB	$06,$06,$06
				DB	$06,$05,$03
				DB	$FB,$6D,$6D
				DB	$6D,$0D,$7D
				DB	$63,$2F,$39
				DB	$4D,$79,$07
				DB	$FE,$03,$03
				DB	$07,$0C,$1A
				DB	$36,$66
				DB	$7B,$1B,$6B
				DB	$33,$5F,$60
				DB	$56,$6F,$60
				DB	$6F,$78,$77
				DB	$0C,$47,$7E
				DB	$7E,$7E,$00
				DB	$7E,$00,$55
				DB	$06,$06,$06
				DB	$06,$07,$00
				DB	$01,$3C,$80
				DB	$03,$03,$03
				DB	$80,$7F,$80
				DB	$80
				DB	$FF				;tview end mark

TWISTER			USR	("TWISTER"_______)-	;C.3
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$40,$81,$02
				DB	$AA,$2A,$00
				DB	$00,$00,$00
				DB	$22,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$36,$CC,$2A,$4A,$CC,$39
				DB	$DD,$01,$03,$0F,$FF

				DB	$22,$00			;tview dimens, offset
				DB	$04,$08,$50
				DB	$70,$1C,$77
				DB	$70
				DB	$11,$09,$05
				DB	$07,$77,$1C
				DB	$07
				DB	$50,$48,$44
				DB	$80
				DB	$05,$08,$10
				DB	$80
				DB	$FF				;tview end mark

PLATFORM		USR	(BETA_CENTAURIAN_)-	;D.4
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$02
				DB	$AA,$16,$00
				DB	$00,$00,$00
				DB	$43,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$E7,$CC,$EA,$DD,$01,$02
				DB	$FF

				DB	$43,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$40,$60,$30
				DB	$58
				DB	$00,$70,$1E
				DB	$63,$7C,$1F
				DB	$6F
				DB	$00,$0F,$78
				DB	$47,$3F,$78
				DB	$77
				DB	$00,$00,$00
				DB	$03,$06,$0D
				DB	$1B
				DB	$58,$6C,$6C
				DB	$6C,$6C,$6C
				DB	$58
				DB	$33,$5D,$5E
				DB	$5E,$36,$76
				DB	$65
				DB	$4C,$3B,$7B
				DB	$7A,$6C,$6F
				DB	$26
				DB	$1B,$37,$36
				DB	$36,$36,$36
				DB	$1B
				DB	$58,$30,$60
				DB	$40,$80
				DB	$1B,$7F,$7C
				DB	$63,$1E,$70
				DB	$00
				DB	$59,$7F,$3F
				DB	$47,$78,$0F
				DB	$00
				DB	$1B,$0D,$06
				DB	$03,$80
				DB	$FF				;tview end mark

SIXARMED		USR	("HEXICLAW"______)-	;E.5
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$C9,$A4,$01
				DB	$AA,$2E,$00
				DB	$00,$00,$00
				DB	$42,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$E6,$CC,$EF,$DD,$01,$04
				DB	$FF

				DB	$42,$00			;tview dimens, offset
				DB	$00,$00,$40
				DB	$38,$0C,$66
				DB	$6C
				DB	$7C,$0F,$4F
				DB	$7F,$73,$06
				DB	$2C
				DB	$3F,$71,$73
				DB	$7F,$4F,$60
				DB	$34
				DB	$00,$01,$03
				DB	$1D,$31,$66
				DB	$36
				DB	$64,$40,$40
				DB	$80
				DB	$78,$01,$80
				DB	$1E,$80
				DB	$26,$03,$02
				DB	$80
				DB	$FF				;tview end mark

CEILING			USR	(TANDEM_TENTICLES)-	;F.6
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$E0,$81,$02
				DB	$A2,$2E,$00
				DB	$00,$00,$00
				DB	$22,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$16,$56,$CC,$16,$56,$3A
				DB	$CC,$FF,$DD,$01,$03,$0F
				DB	$FF

				DB	$22,$00			;tview dimens, offset
				DB	$07,$0C,$1C
				DB	$44,$3A,$7B
				DB	$3B
				DB	$70,$1C,$07
				DB	$03,$1D,$1E
				DB	$1D
				DB	$43,$06,$18
				DB	$80
				DB	$63,$37,$1E
				DB	$80
				DB	$FF				;tview end mark

SCAVENGE		USR	(SCAVENGER_______)-	;G.7
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$11,$50			;tview dimens, offset
				DB	$06,$0F,$0F
				DB	$09,$09,$86
				DB	$FF				;tview end mark

SNOUT			USR	(MUTANT_INSECTOID)-	;H.8
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$10			;tview dimens, offset
				DB	$00,$00,$00
				DB	$00,$00,$40
				DB	$43,$60,$70
				DB	$76,$F7,$01
				DB	$03,$1B,$3B
				DB	$3B,$FB,$00
				DB	$00,$00,$00
				DB	$00,$00,$30
				DB	$46,$3C,$00
				DB	$00,$4E,$6C
				DB	$34,$17,$61
				DB	$6E,$2E,$0D
				DB	$71,$78,$7A
				DB	$21,$1D,$1D
				DB	$6C,$63,$07
				DB	$18,$0F,$00
				DB	$00,$1C,$0D
				DB	$0B,$1C,$0C
				DB	$80,$78,$58
				DB	$70,$30,$78
				DB	$6C,$44,$07
				DB	$06,$03,$03
				DB	$06,$06,$05
				DB	$0E,$0C,$80
				DB	$FF				;tview end mark

FIREMAN			USR	(K-60_FIRE_UNIT__)-	;I.9
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$00			;tview dimens, offset
				DB	$40,$40,$0E
				DB	$1F,$1F,$4E
				DB	$40,$07,$71
				DB	$7C,$7D,$70
				DB	$01,$7F,$00
				DB	$5B,$5B,$5B
				DB	$5B,$00,$7F
				DB	$70,$6F,$6F
				DB	$6F,$6F,$70
				DB	$7F,$40,$40
				DB	$80,$59,$7F
				DB	$0C,$80,$6D
				DB	$7F,$0C,$80
				DB	$66,$7F,$0C
				DB	$80
				DB	$FF				;tview end mark

LEASHDOG		USR	(LEASHED_GRUNTER_)-	;J.A
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$00			;tview dimens, offset
				DB	$40,$80,$1F
				DB	$70,$78,$5C
				DB	$2C,$1E,$76
				DB	$78,$0E,$1F
				DB	$3C,$32,$79
				DB	$6F,$03,$80
				DB	$00,$00,$00
				DB	$00,$00,$60
				DB	$70,$06,$0E
				DB	$1B,$33,$61
				DB	$42,$06,$60
				DB	$20,$00,$01
				DB	$00,$41,$63
				DB	$00,$00,$00
				DB	$00,$00,$07
				DB	$0F,$70,$70
				DB	$70,$0E,$78
				DB	$60,$50,$06
				DB	$06,$06,$38
				DB	$0F,$03,$05
				DB	$66,$6C,$60
				DB	$1C,$70,$40
				DB	$20,$0F,$0F
				DB	$0F,$70,$1F
				DB	$07,$0B
				DB	$FF				;tview end mark

TENTICLE		USR	(TENTICLES_______)-	;K.B
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$00
				DB	$78,$08,$E8
				DB	$7F,$00,$7F,$3F,$5F,$5F,$6F
				DB	$7F,$00,$7F,$7E,$7D,$7D,$7E
				DB	$1F,$10,$17,$17,$17,$07,$17
				DB	$68,$60,$68,$68,$6C,$6C,$6E
				DB	$6F,$6F,$6F,$6F,$DF
				DB	$7E,$7D,$7D,$7A,$7B,$F7
				DB	$37,$37,$77,$67,$67,$A7
				DB	$1E,$1E,$5C,$1C,$38,$60,$00
				DB	$60,$7E,$79,$00,$00,$01,$06
				DB	$07,$63,$6D,$60,$40,$80
				DB	$10,$13,$1B,$03,$03,$07,$1C

				DB	$FF

CAUGHTIN		USR	(ULLDA_NICH______)-	;L.C
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$22,$00			;tview dimens, offset
				DB	$46,$6C,$33
				DB	$76,$30,$66
				DB	$6C,$31,$1B
				DB	$67,$36,$07
				DB	$33,$1B,$40
				DB	$60,$20,$80
				DB	$01,$03,$02
				DB	$80
				DB	$FF				;tview end mark

RAGALIEN		USR	(MEERN_MUTATION__)-	;M.D
				DB	$11,$10,$00
				DB	$00,$00,$10
				DB	$08,$00,$00
				DB	$00,$00,$00
				DB	$75,$00,$00
				DB	$00,$00,$18
				DB	$41,$E2,$11
				DB	$AA,$2E,$80
				DB	$10,$28,$00
				DB	$42,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$46,$CC,$17,$CC,$EF,$DD
				DB	$01,$02,$0F,$FF

				DB	$42,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$7E,$06,$06
				DB	$46
				DB	$70,$7C,$0E
				DB	$73,$3C,$4F
				DB	$07
				DB	$07,$1F,$7C
				DB	$7B,$3C,$07
				DB	$18
				DB	$00,$00,$00
				DB	$07,$0E,$18
				DB	$30
				DB	$46,$4C,$18
				DB	$80
				DB	$05,$01,$03
				DB	$80
				DB	$18,$00,$40
				DB	$80
				DB	$3E,$03,$01
				DB	$80
				DB	$FF				;tview end mark

ROBIEN			USR	(ROBIEN_BRAIN____)-	;N.E
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$01
				DB	$A2,$69,$00
				DB	$00,$00,$00
				DB	$22,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$16,$36,$56,$DD,$02,$FF

				DB	$22,$00			;tview dimens, offset
				DB	$7C,$1C,$6C
				DB	$6C,$74,$18
				DB	$6C
				DB	$0F,$0E,$0D
				DB	$0D,$0D,$0E
				DB	$0F
				DB	$16,$0C,$18
				DB	$80
				DB	$09,$80
				DB	$FF				;tview end mark

STRINGY			USR	(ACRUXITE________)-	;O.F
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$01
				DB	$A2,$6E,$00
				DB	$00,$00,$00
				DB	$42,$00
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$E6,$CC,$EF,$DD,$01,$03
				DB	$FF

				DB	$42,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$70,$70,$B8
				DB	$7C,$6C,$7C
				DB	$3D,$7D,$3C
				DB	$7C
				DB	$7F,$6F,$7F
				DB	$7B,$7F,$7B
				DB	$7F
				DB	$00,$00,$00
				DB	$1E,$1E,$38
				DB	$38
				DB	$58,$2C,$34
				DB	$80
				DB	$6C,$7C,$01
				DB	$80
				DB	$6F,$7F,$80
				DB	$34,$68,$5A
				DB	$80
				DB	$FF				;tview end mark

POINTY			USR	(POINTY_HEAD_____)-	;P.10
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	animated+notcompiled+frame0
				DB	$12
				BYTE	attack;uparound
				BYTE	repeat1;normalspeed

				DB	$23,$00
				DB	$1F,$66,$66,$66,$0C,$CC
				DB	$00,$03,$03,$03,$00,$81
				DB	$78,$18,$18,$30,$30,$30,$60
				DB	$01,$80
				DB	$60,$60,$60,$30,$80
				DB	$00,$00,$01,$03,$80

				DB	$23,$01
				DB	$18,$6C,$67,$66,$06,$46,$4C
				DB	$00,$03,$03,$03,$00,$81
				DB	$4C,$6C,$38,$18,$18,$B0
				DB	$01,$80
				DB	$30,$60,$60,$60,$60,$30,$00
				DB	$00,$00,$00,$00,$01,$03,$00

				DB	$FF

SPOOLER			USR	(NUNKI_BLUE_DEVIL)-	;Q.11
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$00			;tview dimens, offset
				DB	$00,$70,$70
				DB	$70,$74,$76
				DB	$74,$00,$00
				DB	$00,$70,$78
				DB	$77,$18,$00
				DB	$00,$00,$0F
				DB	$1F,$6F,$18
				DB	$00,$0E,$0E
				DB	$0E,$2E,$6F
				DB	$2E,$70,$70
				DB	$70,$80,$30
				DB	$60,$80,$0C
				DB	$07,$80,$0E
				DB	$0E,$0E,$80
				DB	$FF				;tview end mark

OMOEBA			USR	(AMOEBOID________)-	;R.12
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	animated+notcompiled+frame0
				DB	$12
				BYTE	blink;updown
				BYTE	repeat2;normalspeed

				DB	$23,$00
				DB	$4C,$36,$7B,$7B,$7B,$75,$6E
				DB	$3F,$77,$6F,$6F,$37,$1B,$07
				DB	$77,$76,$6E,$5C,$3C,$3C,$78
				DB	$1F,$37,$3B,$3B,$3B,$1F,$0F
				DB	$6C,$76,$76,$5C,$3C,$78,$70
				DB	$1C,$1B,$1B,$1F,$1E,$0D,$03

				DB	$23,$00
				DB	$4C,$36,$7B,$7B,$7B,$75,$7E
				DB	$3F,$77,$6F,$6F,$37,$1B,$07
				DB	$6C,$6C,$5C,$58,$38,$38,$78
				DB	$0F,$1B,$1D,$0D,$0F,$1F,$3F
				DB	$76,$7B,$7B,$7E,$1E,$7E,$78
				DB	$29,$37,$37,$3F,$3E,$19,$07

				DB	$23,$00
				DB	$38,$6C,$74,$74,$74,$68,$6E
				DB	$1F,$36,$37,$37,$1B,$1B,$07
				DB	$77,$76,$6E,$5C,$3C,$3C,$78
				DB	$1F,$37,$3B,$3B,$3B,$1F,$3F
				DB	$76,$7B,$7B,$7E,$1E,$7E,$78
				DB	$29,$37,$37,$3F,$3E,$19,$07

				DB	$FF

FURNACE			USR	("SHOVELER"______)-	;S.13
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$00			;tview dimens, offset
				DB	$80,$00,$00
				DB	$60,$60,$60
				DB	$00,$70,$00
				DB	$00,$07,$07
				DB	$07,$00,$0F
				DB	$80,$00,$40
				DB	$60,$77,$7B
				DB	$7D,$5C,$1E
				DB	$67,$7B,$36
				DB	$0F,$7D,$07
				DB	$78,$67,$5F
				DB	$6C,$70,$3F
				DB	$60,$00,$03
				DB	$07,$76,$77
				DB	$77,$03,$0E
				DB	$0E,$0E,$1C
				DB	$78,$60,$00
				DB	$0F,$7E,$00
				DB	$00,$00,$07
				DB	$7C,$70,$3F
				DB	$00,$00,$00
				DB	$1E,$0F,$01
				DB	$80
				DB	$FF				;tview end mark

LONGARM			USR	(LONG_ARMED_EPE__)-	;T.14
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$00			;tview dimens, offset
				DB	$80,$00,$00
				DB	$7D,$7F,$7D
				DB	$00,$6C,$00
				DB	$00,$17,$1F
				DB	$17,$00,$0D
				DB	$80,$00,$00
				DB	$00,$00,$00
				DB	$C0,$0C,$06
				DB	$06,$03,$03
				DB	$81,$18,$30
				DB	$60,$41,$80
				DB	$00,$00,$00
				DB	$01,$83,$60
				DB	$60,$30,$30
				DB	$18,$18,$0C
				DB	$80,$80,$03
				DB	$03,$03,$03
				DB	$03,$80
				DB	$FF				;tview end mark

SLICER			USR	(SLICER_SPHERE___)-	;U.15
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$43,$10			;tview dimens, offset
				DB	$08,$38,$38
				DB	$30,$30,$70
				DB	$40,$00,$00
				DB	$00,$00,$00
				DB	$70,$7D,$7F
				DB	$73,$03,$03
				DB	$00,$03,$0F
				DB	$00,$01,$00
				DB	$00,$00,$0C
				DB	$1E,$00,$00
				DB	$1E,$7C,$80
				DB	$7E,$66,$58
				DB	$2F,$70,$FE
				DB	$1F,$5F,$3F
				DB	$3F,$39,$16
				DB	$0D,$33,$61
				DB	$20,$80,$07
				DB	$0E,$1C,$30
				DB	$60,$40,$00
				DB	$7C,$72,$03
				DB	$63,$61,$61
				DB	$00,$1B,$33
				DB	$60,$00,$00
				DB	$1F,$3C,$00
				DB	$78,$3F,$80
				DB	$FF				;tview end mark

TREADBOT		USR	(PROTOTYPE_2000-7)-	;V.16
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$10			;tview dimens, offset
				DB	$00,$00,$00
				DB	$7E,$43,$C0
				DB	$78,$78,$78
				DB	$79,$09,$71
				DB	$6F,$07,$07
				DB	$07,$07,$04
				DB	$03,$7D,$00
				DB	$00,$06,$0E
				DB	$1E,$36,$67
				DB	$40,$78,$0C
				DB	$80,$71,$09
				DB	$78,$80,$03
				DB	$64,$37,$80
				DB	$06,$07,$80
				DB	$FF				;tview end mark

STICKY			USR	(????????????????)-	;W.17
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$E0,$0C,$0A
				DB	$6B,$2D,$00
				DB	$00,$00,$00
				DB	$53,$01
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$E7,$DD,$01,$FF

				DB	$53,$01			;tview dimens, offset
				DB	$30,$18,$6C
				DB	$3C,$0C,$AC
				DB	$00,$00,$00
				DB	$01,$61,$32
				DB	$5A
				DB	$00,$00,$00
				DB	$00,$19,$7E
				DB	$7F
				DB	$00,$00,$00
				DB	$38,$0F,$02
				DB	$01
				DB	$80
				DB	$5C,$38,$70
				DB	$7C,$0E,$1B
				DB	$23
				DB	$58,$39,$7B
				DB	$7B,$30,$6C
				DB	$1E
				DB	$7F,$7C,$7E
				DB	$73,$4E,$7F
				DB	$42
				DB	$01,$0D,$3B
				DB	$73,$61,$62
				DB	$64
				DB	$80
				DB	$44,$08,$50
				DB	$60,$30,$80
				DB	$4E,$27,$0B
				DB	$06,$80
				DB	$80
				DB	$59,$62,$7A
				DB	$5C,$60,$60
				DB	$00
				DB	$01,$01,$01
				DB	$01,$80
				DB	$FF				;tview end mark

METALMIT		USR	(METAL_MITES_____)-	;X.18
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	blink;uparound
				BYTE	repeat2;normalspeed

				DB	$22,$00
				DB	$66,$3C,$18,$80
				DB	$00,$00,$66,$3C,$18,$80
				DB	$30,$60,$40,$80
				DB	$06,$03,$01,$80

				DB	$22,$01
				DB	$7E,$18,$80
				DB	$00,$00,$7E,$18,$80
				DB	$70,$40,$80
				DB	$07,$01,$80

				DB	$FF

STAFF			USR	(SCEPTARIAN______)-	;Y.19
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$00,$00,$1E
				DB	$3F,$60,$38
				DB	$74,$6C,$0C
				DB	$18,$31,$3F
				DB	$6E,$79,$3F
				DB	$80,$00,$01
				DB	$06,$07,$06
				DB	$06,$13,$3F
				DB	$3F,$1E,$80
				DB	$7F,$01,$80
				DB	$7F,$80,$6F
				DB	$10,$80
				DB	$FF				;tview end mark

DIZZY			USR	("DIZZY"_________)-	;Z.1A
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$00			;tview dimens, offset
				DB	$00,$00,$40
				DB	$60,$37,$0D
				DB	$37,$40,$73
				DB	$37,$5A,$5C
				DB	$5E,$37,$7F
				DB	$7F,$1C,$6B
				DB	$6B,$6B,$1C
				DB	$61,$47,$46
				DB	$7D,$7D,$0D
				DB	$06,$60,$40
				DB	$80,$73,$41
				DB	$80,$7F,$7F
				DB	$80,$07,$01
				DB	$80
				DB	$FF				;tview end mark

BRANCHES		USR	(PSILOTIS_PEDETUM)-	;AA.1B
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$42,$10			;tview dimens, offset
				DB	$3C,$67,$78
				DB	$0E,$70,$1F
				DB	$00,$00,$61
				DB	$3F,$5E,$61
				DB	$7F,$00,$40
				DB	$1F,$7C,$63
				DB	$5F,$5F,$60
				DB	$0F,$1C,$07
				DB	$1F,$7F,$6F
				DB	$2F,$70,$1E
				DB	$40,$80,$73
				DB	$3C,$07,$80
				DB	$7F,$00,$7C
				DB	$80,$1D,$1E
				DB	$07,$80
				DB	$FF				;tview end mark

SPOOR			USR	(SPOOR_PLANT_____)-	;BB.1C
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	animated+iscompiled+frame0
				DB	$22
				BYTE	attack;updown ;correct sequence???
				BYTE	repeat0;normalspeed

				DB	$43,$01
				DB	$00,$00,$40,$60,$70,$70,$78
				DB	$40,$76,$6F,$5F,$0F,$07,$03
				DB	$3F,$7F,$61,$80
				DB	$00,$03,$07,$0E,$0C,$1C,$18
				DB	$78,$7C,$1C,$6C,$70,$00,$70
				DB	$01,$70,$1C,$0E,$06,$0F,$79
				DB	$00,$03,$0F,$18,$30,$38,$01
				DB	$18,$18,$18,$18,$8C
				DB	$18,$0C,$0C,$0C,$0E,$80
				DB	$06,$0F,$06,$06,$06,$0F,$00
				DB	$07,$0C,$18,$1C,$80
				DB	$0C,$0C,$0E,$1A,$3B,$2D,$00

				DB	$22,$01
				DB	$00,$60,$38,$1C,$0C,$0E,$06
				DB	$00,$01,$80
				DB	$06,$02,$80
				DB	$80

				DB	$22,$01
				DB	$70,$1C,$06,$02,$03,$81
				DB	$03,$00,$00,$00,$30,$18,$0C
				DB	$01,$01,$02,$80
				DB	$02,$80

				DB	$22,$01
				DB	$70,$7C,$3E,$1E,$0F,$0F,$07
				DB	$03,$01,$00,$00,$30,$18,$0C
				DB	$07,$03,$02,$80
				DB	$02,$80

				DB	$FF

LIZARD			USR	(ADHARAN_LIZARD__)-	;CC.1D
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$23,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$00,$40,$40
				DB	$60,$30,$1C
				DB	$0E,$07,$07
				DB	$83,$60,$60
				DB	$76,$7E,$6C
				DB	$F0,$03,$07
				DB	$37,$3F,$1B
				DB	$87,$70,$70
				DB	$70,$70,$60
				DB	$60,$40,$07
				DB	$07,$07,$03
				DB	$03,$81
				DB	$FF				;tview end mark

CONSTRIC		USR	(ANKAA_STRANGLER_)-	;DD.1E
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$22,$00			;tview dimens, offset
				DB	$00,$40,$60
				DB	$7C,$7E,$63
				DB	$43,$0E,$3F
				DB	$63,$81,$46
				DB	$80,$01,$03
				DB	$0E,$80
				DB	$FF				;tview end mark

LITPLANE		USR	(SPICA_V_FIGHTER_)-	;EE.1F
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$23,$00			;tview dimens, offset
				DB	$00,$20,$00
				DB	$00,$20,$00
				DB	$20,$02,$00
				DB	$00,$02,$00
				DB	$02,$00,$00
				DB	$20,$00,$20
				DB	$60,$C0,$02
				DB	$02,$00,$02
				DB	$03,$81,$40
				DB	$61,$5F,$58
				DB	$60,$C0,$01
				DB	$43,$7D,$0D
				DB	$03,$81
				DB	$FF				;tview end mark

WATTOWER		USR	(MOIKLER_________)-	;FF.20
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$22,$00			;tview dimens, offset
				DB	$18,$30,$60
				DB	$60,$60,$60
				DB	$30,$18,$0C
				DB	$07,$07,$07
				DB	$07,$0D,$18
				DB	$00,$60,$80
				DB	$19,$01,$06
				DB	$80
				DB	$FF				;tview end mark

ENUNLOAD		USR	(ENERGY_UNLOADER_)-	;GG.21
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$22,$00			;tview dimens, offset
				DB	$00,$00,$00
				DB	$70,$78,$02
				DB	$76,$00,$00
				DB	$00,$07,$0F
				DB	$20,$37,$02
				DB	$78,$70,$80
				DB	$20,$0F,$07
				DB	$80
				DB	$FF				;tview end mark

INSECT			USR	(WORKER_INSECT___)-	;HH.22
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$23,$00			;tview dimens, offset
				DB	$00,$00,$40
				DB	$60,$5E,$E0
				DB	$00,$00,$01
				DB	$03,$3D,$83
				DB	$60,$5E,$60
				DB	$70,$70,$6F
				DB	$70,$03,$3D
				DB	$03,$07,$07
				DB	$7B,$07,$70
				DB	$10,$6E,$36
				DB	$66,$86,$07
				DB	$04,$3B,$66
				DB	$63,$40,$00
				DB	$FF				;tview end mark

WEB				USR	(ULLDA_NICH_WEB__)-	;II.23
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE,$EE,$EE
				DB	$EE

				DB	$FF,$DD,$19,$FF	;temporary

				DB	$72,$00			;tview dimens, offset
				DB	$40,$00,$00
				DB	$1F,$70,$0E
				DB	$7C,$1B,$7E
				DB	$40,$00,$7F
				DB	$70,$5F,$00
				DB	$00,$7F,$48
				DB	$7F,$7F,$48
				DB	$00,$00,$00
				DB	$7F,$7F,$17
				DB	$7F
				DB	$00,$00,$7C
				DB	$27,$7F,$02
				DB	$7F
				DB	$40,$7C,$7F
				DB	$00,$1F,$00
				DB	$7F
				DB	$01,$00,$03
				DB	$00,$00,$00
				DB	$01
				DB	$07,$60,$3C
				DB	$80
				DB	$70,$1F,$80
				DB	$1F,$70,$80
				DB	$41,$3F,$60
				DB	$80
				DB	$3F,$60,$03
				DB	$80
				DB	$00,$07,$80
				DB	$80
				DB	$FF				;tview end mark

DATA_END_15
