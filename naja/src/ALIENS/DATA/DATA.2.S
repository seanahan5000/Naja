SNOWJOB			USR	("SUBZERO"_______)-	;A.1
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$10
				DB	$03,$30,$0B,$0C,$60,$72,$18
				DB	$00,$40,$78,$4E,$37,$4C,$38
				DB	$18,$23,$07,$1C,$1B,$3D,$76
				DB	$6C,$33,$0C,$1B,$01,$0E,$2C
				DB	$4D,$22,$0C,$80
				DB	$60,$03,$40,$80
				DB	$63,$60,$0D,$80
				DB	$10,$68,$80
				DB	$FF

REPAIR			USR	(REPAIR_UNIT_1000)-	;B.2
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$45,$11
				DB	$7F,$03,$FB
				DB	$7F,$4C,$4D,$4D,$4D,$4D,$0D
				DB	$01,$7D,$55,$01,$7D,$01,$7C
				DB	$00,$00,$01,$00,$07,$86
				DB	$FB
				DB	$6D,$0D,$0D,$7D,$06,$7E,$06
				DB	$7B,$76,$6D,$6D,$0C,$6D,$3C
				DB	$06,$06,$06,$06,$06,$05,$03
				DB	$FB
				DB	$6D,$6D,$6D,$0D,$7D,$63,$2F
				DB	$39,$4D,$79,$07,$FE
				DB	$03,$03,$07,$0C,$1A,$36,$66
				DB	$7B,$1B,$6B,$33,$5F,$60,$56
				DB	$6F,$60,$6F,$78,$77,$0C,$47
				DB	$7E,$7E,$7E,$00,$7E,$00,$55
				DB	$06,$06,$06,$06,$07,$00,$01
				DB	$3C,$80
				DB	$03,$03,$03,$80
				DB	$7F,$80
				DB	$80
				DB	$FF

TWISTER			USR	("TWISTER"_______)-	;C.3
				DS	48,0

				DB	$36,$CC
				DB	$2A,$4A,$CC
				DB	$39,$DD
				DB	$01,$03,$0F,$FF

				DB	$22,$00
				DB	$04,$08,$50,$70,$1C,$77,$70
				DB	$11,$09,$05,$07,$77,$1C,$07
				DB	$50,$48,$44,$80
				DB	$05,$08,$10,$80
				DB	$FF

PLATFORM		USR	(BETA_CENTAURIAN_)-	;D.4
				DS	48,0

				DB	$E7,$CC
				DB	$EA,$DD
				DB	$01,$02,$FF

				DB	$43,$00
				DB	$00,$00,$00,$40,$60,$30,$58
				DB	$00,$70,$1E,$63,$7C,$1F,$6F
				DB	$00,$0F,$78,$47,$3F,$78,$77
				DB	$00,$00,$00,$03,$06,$0D,$1B
				DB	$58,$6C,$6C,$6C,$6C,$6C,$58
				DB	$33,$5D,$5E,$5E,$36,$76,$65
				DB	$4C,$3B,$7B,$7A,$6C,$6F,$26
				DB	$1B,$37,$36,$36,$36,$36,$1B
				DB	$58,$30,$60,$40,$80
				DB	$1B,$7F,$7C,$63,$1E,$70,$00
				DB	$59,$7F,$3F,$47,$78,$0F,$00
				DB	$1B,$0D,$06,$03,$80
				DB	$FF

SIXARMED		USR	("HEXICLAW"______)-	;E.5
				DS	48,0

				DB	$E6,$CC
				DB	$EF,$DD
				DB	$01,$04,$FF

				DB	$42,$00
				DB	$00,$00,$40,$38,$0C,$66,$6C
				DB	$7C,$0F,$4F,$7F,$73,$06,$2C
				DB	$3F,$71,$73,$7F,$4F,$60,$34
				DB	$00,$01,$03,$1D,$31,$66,$36
				DB	$64,$40,$40,$80
				DB	$78,$01,$80
				DB	$1E,$80
				DB	$26,$03,$02,$80
				DB	$FF

CEILING			USR	(TANDEM_TENTICLES)-	;F.6
				DS	48,0

				DB	$16,$56,$CC
				DB	$16,$56,$3A,$CC
				DB	$FF,$DD
				DB	$01,$03,$0F,$FF

				DB	$22,$00
				DB	$07,$0C,$1C,$44,$3A,$7B,$3B
				DB	$70,$1C,$07,$03,$1D,$1E,$1D
				DB	$43,$06,$18,$80
				DB	$63,$37,$1E,$80
				DB	$FF

SCAVENGE		USR	(SCAVENGER_______)-	;G.7
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$11,$50
				DB	$06,$0F,$0F,$09,$09,$86
				DB	$FF

SNOUT			USR	(MUTANT_INSECTOID)-	;H.8
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$10
				DB	$00,$00,$00,$00,$00,$40,$43
				DB	$60,$70,$76,$F7
				DB	$01,$03,$1B,$3B,$3B,$FB
				DB	$00,$00,$00,$00,$00,$00,$30
				DB	$46,$3C,$00,$00,$4E,$6C,$34
				DB	$17,$61,$6E,$2E,$0D,$71,$78
				DB	$7A,$21,$1D,$1D,$6C,$63,$07
				DB	$18,$0F,$00,$00,$1C,$0D,$0B
				DB	$1C,$0C,$80
				DB	$78,$58,$70,$30,$78,$6C,$44
				DB	$07,$06,$03,$03,$06,$06,$05
				DB	$0E,$0C,$80
				DB	$FF

FIREMAN			USR	(K-60_FIRE_UNIT__)-	;I.9
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$40,$40,$0E,$1F,$1F,$4E,$40
				DB	$07,$71,$7C,$7D,$70,$01,$7F
				DB	$00,$5B,$5B,$5B,$5B,$00,$7F
				DB	$70,$6F,$6F,$6F,$6F,$70,$7F
				DB	$40,$40,$80
				DB	$59,$7F,$0C,$80
				DB	$6D,$7F,$0C,$80
				DB	$66,$7F,$0C,$80
				DB	$FF

LEASHDOG		USR	(LEASHED_GRUNTER_)-	;J.A
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$40,$80
				DB	$1F,$70,$78,$5C,$2C,$1E,$76
				DB	$78,$0E,$1F,$3C,$32,$79,$6F
				DB	$03,$80
				DB	$00,$00,$00,$00,$00,$60,$70
				DB	$06,$0E,$1B,$33,$61,$42,$06
				DB	$60,$20,$00,$01,$00,$41,$63
				DB	$00,$00,$00,$00,$00,$07,$0F
				DB	$70,$70,$70,$0E,$78,$60,$50
				DB	$06,$06,$06,$38,$0F,$03,$05
				DB	$66,$6C,$60,$1C,$70,$40,$20
				DB	$0F,$0F,$0F,$70,$1F,$07,$0B
				DB	$FF

TENTICLE		USR	(TENTICLES_______)-	;K.B
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

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
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$46,$6C,$33,$76,$30,$66,$6C
				DB	$31,$1B,$67,$36,$07,$33,$1B
				DB	$40,$60,$20,$80
				DB	$01,$03,$02,$80
				DB	$FF

RAGALIEN		USR	(MEERN_MUTATION__)-	;M.D
				DS	48,0

				DB	$46,$CC
				DB	$17,$CC
				DB	$EF,$DD
				DB	$01,$02,$0F,$FF

				DB	$42,$00
				DB	$00,$00,$00,$7E,$06,$06,$46
				DB	$70,$7C,$0E,$73,$3C,$4F,$07
				DB	$07,$1F,$7C,$7B,$3C,$07,$18
				DB	$00,$00,$00,$07,$0E,$18,$30
				DB	$46,$4C,$18,$80
				DB	$05,$01,$03,$80
				DB	$18,$00,$40,$80
				DB	$3E,$03,$01,$80
				DB	$FF

ROBIEN			USR	(ROBIEN_BRAIN____)-	;N.E
				DS	48,0

				DB	$16,$36,$56,$DD
				DB	$02,$FF

				DB	$22,$00
				DB	$7C,$1C,$6C,$6C,$74,$18,$6C
				DB	$0F,$0E,$0D,$0D,$0D,$0E,$0F
				DB	$16,$0C,$18,$80
				DB	$09,$80
				DB	$FF

STRINGY			USR	(ACRUXITE________)-	;O.F
				DS	48,0

				DB	$E6,$CC
				DB	$EF,$DD
				DB	$01,$03,$FF

				DB	$42,$00
				DB	$00,$00,$00,$70,$70,$B8
				DB	$7C,$6C,$7C,$3D,$7D,$3C,$7C
				DB	$7F,$6F,$7F,$7B,$7F,$7B,$7F
				DB	$00,$00,$00,$1E,$1E,$38,$38
				DB	$58,$2C,$34,$80
				DB	$6C,$7C,$01,$80
				DB	$6F,$7F,$80
				DB	$34,$68,$5A,$80
				DB	$FF

POINTY			USR	(POINTY_HEAD_____)-	;P.10
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

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
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$00,$70,$70,$70,$74,$76,$74
				DB	$00,$00,$00,$70,$78,$77,$18
				DB	$00,$00,$00,$0F,$1F,$6F,$18
				DB	$00,$0E,$0E,$0E,$2E,$6F,$2E
				DB	$70,$70,$70,$80
				DB	$30,$60,$80
				DB	$0C,$07,$80
				DB	$0E,$0E,$0E,$80
				DB	$FF

OMOEBA			USR	(AMOEBOID________)-	;R.12
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

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
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$80
				DB	$00,$00,$60,$60,$60,$00,$70
				DB	$00,$00,$07,$07,$07,$00,$0F
				DB	$80
				DB	$00,$40,$60,$77,$7B,$7D,$5C
				DB	$1E,$67,$7B,$36,$0F,$7D,$07
				DB	$78,$67,$5F,$6C,$70,$3F,$60
				DB	$00,$03,$07,$76,$77,$77,$03
				DB	$0E,$0E,$0E,$1C,$78,$60,$00
				DB	$0F,$7E,$00,$00,$00,$07,$7C
				DB	$70,$3F,$00,$00,$00,$1E,$0F
				DB	$01,$80
				DB	$FF

LONGARM			USR	(LONG_ARMED_EPE__)-	;T.14
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$80
				DB	$00,$00,$7D,$7F,$7D,$00,$6C
				DB	$00,$00,$17,$1F,$17,$00,$0D
				DB	$80
				DB	$00,$00,$00,$00,$00,$C0
				DB	$0C,$06,$06,$03,$03,$81
				DB	$18,$30,$60,$41,$80
				DB	$00,$00,$00,$01,$83
				DB	$60,$60,$30,$30,$18,$18,$0C
				DB	$80
				DB	$80
				DB	$03,$03,$03,$03,$03,$80
				DB	$FF

SLICER			USR	(SLICER_SPHERE___)-	;U.15
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$10
				DB	$08,$38,$38,$30,$30,$70,$40
				DB	$00,$00,$00,$00,$00,$70,$7D
				DB	$7F,$73,$03,$03,$00,$03,$0F
				DB	$00,$01,$00,$00,$00,$0C,$1E
				DB	$00,$00,$1E,$7C,$80
				DB	$7E,$66,$58,$2F,$70,$FE
				DB	$1F,$5F,$3F,$3F,$39,$16,$0D
				DB	$33,$61,$20,$80
				DB	$07,$0E,$1C,$30,$60,$40,$00
				DB	$7C,$72,$03,$63,$61,$61,$00
				DB	$1B,$33,$60,$00,$00,$1F,$3C
				DB	$00,$78,$3F,$80
				DB	$FF

TREADBOT		USR	(PROTOTYPE_2000-7)-	;V.16
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$10
				DB	$00,$00,$00,$7E,$43,$C0
				DB	$78,$78,$78,$79,$09,$71,$6F
				DB	$07,$07,$07,$07,$04,$03,$7D
				DB	$00,$00,$06,$0E,$1E,$36,$67
				DB	$40,$78,$0C,$80
				DB	$71,$09,$78,$80
				DB	$03,$64,$37,$80
				DB	$06,$07,$80
				DB	$FF

STICKY			USR	(????????????????)-	;W.17
				DS	48,0

				DB	$E7,$DD
				DB	$01,$FF

				DB	$53,$01
				DB	$30,$18,$6C,$3C,$0C,$AC
				DB	$00,$00,$00,$01,$61,$32,$5A
				DB	$00,$00,$00,$00,$19,$7E,$7F
				DB	$00,$00,$00,$38,$0F,$02,$01
				DB	$80
				DB	$5C,$38,$70,$7C,$0E,$1B,$23
				DB	$58,$39,$7B,$7B,$30,$6C,$1E
				DB	$7F,$7C,$7E,$73,$4E,$7F,$42
				DB	$01,$0D,$3B,$73,$61,$62,$64
				DB	$80
				DB	$44,$08,$50,$60,$30,$80
				DB	$4E,$27,$0B,$06,$80
				DB	$80
				DB	$59,$62,$7A,$5C,$60,$60,$00
				DB	$01,$01,$01,$01,$80
				DB	$FF

METALMIT		USR	(METAL_MITES_____)-	;X.18
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

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
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$00,$00,$00,$00,$00,$1E,$3F
				DB	$60,$38,$74,$6C,$0C,$18,$31
				DB	$3F,$6E,$79,$3F,$80
				DB	$00,$01,$06,$07,$06,$06,$13
				DB	$3F,$3F,$1E,$80
				DB	$7F,$01,$80
				DB	$7F,$80
				DB	$6F,$10,$80
				DB	$FF

DIZZY			USR	("DIZZY"_________)-	;Z.1A
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$00,$00,$40,$60,$37,$0D,$37
				DB	$40,$73,$37,$5A,$5C,$5E,$37
				DB	$7F,$7F,$1C,$6B,$6B,$6B,$1C
				DB	$61,$47,$46,$7D,$7D,$0D,$06
				DB	$60,$40,$80
				DB	$73,$41,$80
				DB	$7F,$7F,$80
				DB	$07,$01,$80
				DB	$FF

BRANCHES		USR	(PSILOTIS_PEDETUM)-	;AA.1B
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$10
				DB	$3C,$67,$78,$0E,$70,$1F,$00
				DB	$00,$61,$3F,$5E,$61,$7F,$00
				DB	$40,$1F,$7C,$63,$5F,$5F,$60
				DB	$0F,$1C,$07,$1F,$7F,$6F,$2F
				DB	$70,$1E,$40,$80
				DB	$73,$3C,$07,$80
				DB	$7F,$00,$7C,$80
				DB	$1D,$1E,$07,$80
				DB	$FF

SPOOR			USR	(SPOOR_PLANT_____)-	;BB.1C
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

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
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$00,$00,$00,$00,$40,$40,$60
				DB	$30,$1C,$0E,$07,$07,$83
				DB	$60,$60,$76,$7E,$6C,$F0
				DB	$03,$07,$37,$3F,$1B,$87
				DB	$70,$70,$70,$70,$60,$60,$40
				DB	$07,$07,$07,$03,$03,$81
				DB	$FF

CONSTRIC		USR	(ANKAA_STRANGLER_)-	;DD.1E
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$00,$40,$60,$7C,$7E,$63,$43
				DB	$0E,$3F,$63,$81
				DB	$46,$80
				DB	$01,$03,$0E,$80
				DB	$FF

LITPLANE		USR	(SPICA_V_FIGHTER_)-	;EE.1F
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$00,$20,$00,$00,$20,$00,$20
				DB	$02,$00,$00,$02,$00,$02,$00
				DB	$00,$20,$00,$20,$60,$C0
				DB	$02,$02,$00,$02,$03,$81
				DB	$40,$61,$5F,$58,$60,$C0
				DB	$01,$43,$7D,$0D,$03,$81
				DB	$FF

WATTOWER		USR	(MOIKLER_________)-	;FF.20
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$18,$30,$60,$60,$60,$60,$30
				DB	$18,$0C,$07,$07,$07,$07,$0D
				DB	$18,$00,$60,$80
				DB	$19,$01,$06,$80
				DB	$FF

ENUNLOAD		USR	(ENERGY_UNLOADER_)-	;GG.21
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$00,$00,$00,$70,$78,$02,$76
				DB	$00,$00,$00,$07,$0F,$20,$37
				DB	$02,$78,$70,$80
				DB	$20,$0F,$07,$80
				DB	$FF

INSECT			USR	(WORKER_INSECT___)-	;HH.22
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$00,$00,$40,$60,$5E,$E0
				DB	$00,$00,$01,$03,$3D,$83
				DB	$60,$5E,$60,$70,$70,$6F,$70
				DB	$03,$3D,$03,$07,$07,$7B,$07
				DB	$70,$10,$6E,$36,$66,$86
				DB	$07,$04,$3B,$66,$63,$40,$00
				DB	$FF

WEB				USR	(ULLDA_NICH_WEB__)-	;II.23
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$72,$00
				DB	$40,$00,$00,$1F,$70,$0E,$7C
				DB	$1B,$7E,$40,$00,$7F,$70,$5F
				DB	$00,$00,$7F,$48,$7F,$7F,$48
				DB	$00,$00,$00,$7F,$7F,$17,$7F
				DB	$00,$00,$7C,$27,$7F,$02,$7F
				DB	$40,$7C,$7F,$00,$1F,$00,$7F
				DB	$01,$00,$03,$00,$00,$00,$01
				DB	$07,$60,$3C,$80
				DB	$70,$1F,$80
				DB	$1F,$70,$80
				DB	$41,$3F,$60,$80
				DB	$3F,$60,$03,$80
				DB	$00,$07,$80
				DB	$80
				DB	$FF

DATA_END_15
