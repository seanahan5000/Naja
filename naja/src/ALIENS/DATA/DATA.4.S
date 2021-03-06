DUALTRON		USR	(DUALTRONIC_ROBOT)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$6E,$6C,$0C,$7C,$40,$40,$7C
				DB	$7F,$40,$3F,$33,$6D,$6D,$33
				DB	$7F,$03,$7D,$4C,$37,$37,$4C
				DB	$07,$76,$31,$3F,$03,$03,$3F
				DB	$0C,$6E,$60,$80
				DB	$3F,$40,$7F,$80
				DB	$7D,$03,$7F,$80
				DB	$31,$36,$3B,$80
				DB	$FF

CENTAUR			USR	(CENTAURIAN_ROBOT)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$00,$00,$70,$1E,$1E,$76,$10
				DB	$00,$00,$07,$3C,$3C,$37,$04
				DB	$70,$10,$70,$10,$70,$18,$68
				DB	$07,$04,$07,$04,$07,$0C,$0B
				DB	$2F,$6F,$0B,$7B,$3B,$03,$02
				DB	$7A,$7B,$68,$6F,$6E,$60,$20
				DB	$FF

SLIME			USR	(SLIME_CREATURE__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+iscompiled+frame0
				DB	$22
				BYTE	attack;updown
				BYTE	repeat1;normalspeed

				DB	$53,$00
				DB	$00,$40,$78,$3C,$7C,$7E,$3E
				DB	$70,$7F,$7D,$5F,$7F,$3B,$7F
				DB	$0F,$7D,$3F,$7F,$6D,$FF
				DB	$00,$03,$1F,$3B,$3F,$7B,$7E
				DB	$80
				DB	$76,$7F,$6F,$3F,$3B,$7F,$6F
				DB	$4F,$0B,$01,$0B,$2F,$7E,$00
				DB	$74,$50,$00,$51,$72,$7F,$00
				DB	$7F,$77,$7F,$3D,$7D,$76,$5E
				DB	$00,$81
				DB	$7D,$77,$7F,$5B,$1B,$33,$16
				DB	$7E,$3E,$01,$03,$0E,$19,$03
				DB	$00,$00,$00,$40,$70,$18,$40
				DB	$7E,$36,$7F,$5B,$58,$4D,$65
				DB	$01,$01,$01,$01,$01,$01,$00

				DB	$42,$00
				DB	$80
				DB	$00,$00,$00,$00,$00,$C4
				DB	$00,$00,$00,$00,$10,$10,$00
				DB	$00,$00,$00,$00,$00,$00,$01
				DB	$80
				DB	$30,$44,$08,$20,$50,$08,$00
				DB	$0B,$24,$10,$02,$0F,$08,$00
				DB	$01,$80

				DB	$42,$00
				DB	$80
				DB	$00,$00,$00,$00,$00,$00,$40
				DB	$00,$00,$00,$00,$02,$02,$00
				DB	$80
				DB	$80
				DB	$40,$30,$60,$54,$08,$08,$00
				DB	$00,$0B,$06,$2D,$80
				DB	$80

				DB	$FF

TALUMA			USR	(TALUMA_AND_MOUNT)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$0C,$0C,$5A,$7A,$76,$60,$20
				DB	$18,$18,$2D,$2F,$37,$03,$02
				DB	$60,$38,$60,$26,$6C,$6C,$7A
				DB	$03,$0E,$03,$32,$1B,$1B,$2F
				DB	$7A,$63,$40,$40,$40,$80
				DB	$2F,$63,$01,$01,$03,$87
				DB	$FF

SPECTROM		USR	(SPECTRAMITE_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$52,$00
				DB	$02,$00,$02,$7B,$02,$44,$72
				DB	$06,$73,$7C,$3F,$7C,$73,$00
				DB	$60,$4F,$3E,$7C,$3E,$4F,$00
				DB	$40,$01,$40,$5F,$40,$23,$4E
				DB	$00,$00,$00,$01,$80
				DB	$0C,$04,$04,$80
				DB	$40,$80
				DB	$03,$80
				DB	$30,$20,$20,$80
				DB	$80
				DB	$FF

SPIKE			USR	("SPIKE"_________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$21,$02
				DB	$68,$30,$5F,$30,$68,$58,$44
				DB	$0B,$06,$7D,$06,$0B,$0D,$11
				DB	$FF

SOLICIAN		USR	(SOLICIAN________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$3C,$66,$03,$43,$73,$86
				DB	$78,$0D,$70,$3F,$70,$0C,$78
				DB	$07,$0C,$03,$7F,$43,$2C,$67
				DB	$00,$00,$00,$00,$03,$80
				DB	$0C,$18,$80
				DB	$80
				DB	$40,$40,$80
				DB	$01,$01,$80
				DB	$FF

WANDERIN		USR	(WANDERIN_THOUGHT)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$22
				BYTE	attack;uparound
				BYTE	repeat0;normalspeed

				DB	$43,$01
				DB	$00,$40,$00,$00,$48,$00,$10
				DB	$00,$08,$10,$04,$64,$58,$65
				DB	$08,$00,$12,$10,$04,$36,$0C
				DB	$00,$00,$02,$00,$14,$00,$05
				DB	$00,$04,$20,$00,$10,$00,$08
				DB	$6C,$7A,$76,$7A,$6C,$35,$10
				DB	$77,$2F,$6E,$1F,$67,$1B,$0C
				DB	$10,$04,$02,$28,$40,$12,$00
				DB	$20,$00,$40,$10,$80
				DB	$28,$10,$04,$40,$08,$80
				DB	$0A,$00,$41,$04,$10,$80
				DB	$09,$00,$04,$01,$80

				DB	$43,$01
				DB	$00,$40,$00,$00,$48,$00,$10
				DB	$00,$08,$10,$04,$64,$58,$65
				DB	$08,$00,$12,$10,$04,$36,$0C
				DB	$00,$00,$02,$00,$14,$00,$05
				DB	$00,$04,$20,$00,$10,$00,$08
				DB	$0C,$0A,$06,$0A,$0C,$35,$10
				DB	$70,$20,$61,$10,$60,$1B,$0C
				DB	$10,$04,$02,$28,$40,$12,$00
				DB	$20,$00,$40,$10,$80
				DB	$28,$10,$04,$40,$08,$80
				DB	$0A,$00,$41,$04,$10,$80
				DB	$09,$00,$04,$01,$80

				DB	$43,$01
				DB	$00,$40,$00,$00,$48,$00,$10
				DB	$00,$08,$10,$04,$04,$00,$01
				DB	$08,$00,$12,$10,$00,$20,$00
				DB	$00,$00,$02,$00,$14,$00,$05
				DB	$00,$04,$20,$00,$10,$00,$08
				DB	$60,$70,$70,$70,$60,$01,$00
				DB	$07,$0F,$0E,$0F,$07,$00,$20
				DB	$10,$04,$02,$28,$40,$12,$00
				DB	$20,$00,$40,$10,$80
				DB	$08,$10,$04,$40,$08,$80
				DB	$00,$00,$41,$04,$10,$80
				DB	$09,$00,$04,$01,$80

				DB	$43,$01
				DB	$00,$40,$00,$00,$08,$80
				DB	$00,$00,$00,$00,$60,$58,$64
				DB	$08,$00,$00,$00,$08,$16,$0C
				DB	$00,$00,$00,$00,$10,$80
				DB	$00,$04,$80
				DB	$6C,$7A,$76,$7A,$6C,$34,$10
				DB	$77,$2F,$6E,$1F,$67,$1B,$0C
				DB	$10,$00,$00,$00,$40,$80
				DB	$20,$00,$00,$10,$80
				DB	$20,$00,$00,$00,$08,$80
				DB	$0A,$00,$00,$00,$10,$80
				DB	$00,$00,$04,$80

				DB	$43,$02
				DB	$00,$00,$00,$40,$00,$10,$00
				DB	$08,$10,$04,$64,$58,$65,$6C
				DB	$00,$12,$10,$04,$36,$0C,$77
				DB	$00,$02,$00,$04,$00,$05,$00
				DB	$00,$20,$00,$10,$00,$08,$00
				DB	$7A,$76,$7A,$6C,$35,$10,$28
				DB	$2F,$6E,$1F,$67,$1B,$0C,$0A
				DB	$04,$02,$28,$00,$12,$00,$09
				DB	$00,$40,$80
				DB	$10,$04,$40,$80
				DB	$00,$41,$04,$80
				DB	$00,$00,$01,$80

				DB	$FF

INTRUDER		USR	(INTRUDER_MISSILE)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	attack;upstop
				BYTE	repeat0;normalspeed

				DB	$12,$30
				DB	$66,$5A,$66,$FE
				DB	$3C,$3C,$18,$80

				DB	$22,$02
				DB	$30,$50,$30,$70,$50,$76,$68
				DB	$06,$05,$06,$07,$07,$07,$16
				DB	$60,$80
				DB	$0B,$80

				DB	$21,$03
				DB	$32,$50,$34,$73,$4A,$74,$32
				DB	$06,$35,$46,$57,$65,$1E,$33

				DB	$22,$02
				DB	$18,$2E,$32,$76,$63,$0E,$64
				DB	$5D,$64,$37,$66,$52,$6D,$1A
				DB	$18,$80
				DB	$07,$80

				DB	$22,$00
				DB	$1C,$36,$22,$23,$1E,$12,$23
				DB	$1D,$24,$67,$48,$34,$66,$64
				DB	$63,$6E,$30,$80
				DB	$16,$1B,$0C,$80

				DB	$FF

SPEEDO			USR	("SPEEDO"________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	move;uparound ;ARE THESE RIGHT???
				BYTE	repeat0;normalspeed

				DB	$22,$00
				DB	$0C,$0C,$76,$1A,$6C,$6E,$36
				DB	$60,$6C,$7B,$36,$3D,$1D,$0B
				DB	$66,$2D,$1B,$80
				DB	$06,$02,$80

				DB	$22,$00
				DB	$03,$07,$73,$1B,$6F,$6E,$30
				DB	$0C,$0C,$1B,$16,$0D,$1D,$1B
				DB	$58,$10,$80
				DB	$39,$2D,$36,$80

				DB	$FF

SHIFTER			USR	(SHIFTER_________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$21,$03
				DB	$60,$38,$1F,$3B,$63,$06,$00
				DB	$03,$0E,$7C,$6E,$63,$60,$30
				DB	$FF

GREMLIN			USR	(ADHARAN_GREMLIN_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$60,$60,$60,$60,$60,$00,$60
				DB	$7F,$6E,$7F,$6E,$7F,$00,$01
				DB	$78,$6C,$0C,$80
				DB	$07,$0D,$0C,$80
				DB	$FF

AIRCIRCU		USR	(AIR_CIRCULATOR__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$63,$20
				DB	$80
				DB	$80
				DB	$7C,$0C,$78,$00,$F8
				DB	$07,$06,$03,$00,$83
				DB	$80
				DB	$80
				DB	$00,$00,$00,$38,$00,$0F,$5B
				DB	$00,$00,$79,$1D,$5D,$60,$2F
				DB	$00,$1C,$1E,$1F,$1F,$63,$78
				DB	$00,$07,$6F,$1F,$3F,$78,$43
				DB	$00,$00,$13,$57,$17,$00,$3E
				DB	$00,$00,$00,$03,$00,$1E,$1B
				DB	$5B,$5B,$0F,$80
				DB	$0F,$6F,$40,$40,$80
				DB	$7F,$7F,$04,$7F,$00,$70,$60
				DB	$1F,$7F,$24,$3F,$00,$01,$00
				DB	$3E,$3E,$80
				DB	$1B,$1B,$1E,$80
				DB	$FF

DRILLER			USR	(STATION_DRILLER_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$04
				DB	$00,$7E,$36,$36,$36,$D6
				DB	$70,$3D,$46,$1B,$63,$75,$73
				DB	$0F,$3C,$63,$18,$07,$2F,$4E
				DB	$00,$7F,$6C,$6D,$6D,$EB
				DB	$56,$36,$36,$36,$7E,$80
				DB	$75,$63,$1B,$46,$3D,$70,$00
				DB	$2F,$07,$18,$63,$3C,$0F,$00
				DB	$6B,$6D,$6D,$6C,$7F,$80
				DB	$FF

INVISIBL		USR	(INVISIBLE_ALIEN_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+iscompiled+frame0
				DB	$12
				BYTE	blink;updown
				BYTE	repeat1;normalspeed

				DB	$23,$00
				DB	$04,$0C,$0C,$58,$70,$E0
				DB	$00,$00,$0F,$19,$00,$81
				DB	$70,$10,$60,$78,$1C,$4E,$1F
				DB	$03,$00,$03,$0F,$1C,$39,$7C
				DB	$3B,$73,$33,$06,$07,$0C,$00
				DB	$6E,$67,$66,$30,$70,$18,$00
				DB	$FF

COOLER			USR	(COOLING_UNIT____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$63,$01
				DB	$70,$3B,$3B,$58,$63,$FB
				DB	$00,$FD
				DB	$40,$6E,$1E,$7E,$0E,$72,$1C
				DB	$07,$3B,$3C,$3F,$38,$27,$1C
				DB	$00,$DF
				DB	$00,$6F,$6F,$6F,$6F,$61,$4E
				DB	$7B,$3A,$59,$6B,$5B,$3B,$7B
				DB	$7D,$3C,$3D,$1D,$3D,$3C,$7D
				DB	$66,$7B,$7B,$7D,$7B,$7B,$66
				DB	$33,$6F,$6F,$5F,$6F,$6F,$33
				DB	$1F,$5E,$5E,$1C,$5E,$5E,$5F
				DB	$2B,$67,$68,$EF
				DB	$7B,$7B,$7B,$79,$7A,$7B,$00
				DB	$7D,$7D,$7D,$61,$1D,$7D,$38
				DB	$1C,$72,$0E,$7E,$7E,$7E,$00
				DB	$1C,$27,$38,$3F,$3F,$3F,$00
				DB	$4F,$53,$5D,$3D,$3B,$5B,$30
				DB	$6F,$6F,$0F,$6F,$6F,$6F,$00
				DB	$FF

THERMAL			USR	(THERMAL_UNIT____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$63,$11
				DB	$FB
				DB	$FD
				DB	$7E,$7E,$7E,$0E,$72,$1C,$66
				DB	$3F,$3F,$3F,$38,$27,$1C,$33
				DB	$DF
				DB	$EF
				DB	$FB
				DB	$3D,$3D,$1D,$3D,$3D,$FD
				DB	$7B,$7B,$7D,$7B,$7B,$66,$1C
				DB	$6F,$6F,$5F,$6F,$6F,$33,$1C
				DB	$5E,$5E,$5C,$5E,$5E,$DF
				DB	$EF
				DB	$7B,$7B,$7B,$7B,$7B,$80
				DB	$7D,$7D,$7D,$7D,$7D,$80
				DB	$72,$0E,$7E,$7E,$7E,$80
				DB	$27,$38,$3F,$3F,$3F,$80
				DB	$5F,$5F,$5F,$5F,$5F,$80
				DB	$6F,$6F,$6F,$6F,$6F,$80
				DB	$FF

INFRAFLO		USR	(INFRA-FLOURINOID)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$40,$00,$00,$00,$40,$60,$3C
				DB	$03,$7E,$0C,$00,$3F,$80
				DB	$78,$1E,$06,$03,$03,$81
				DB	$03,$06,$1C,$18,$18,$0C,$06
				DB	$36,$66,$63,$43,$43,$66,$6C
				DB	$40,$40,$00,$01,$5F,$78,$0C
				DB	$00,$00,$40,$79,$0F,$30,$60
				DB	$06,$03,$05,$06,$0C,$0C,$18
				DB	$30,$30,$18,$58,$4C,$4C,$7C
				DB	$0C,$06,$03,$01,$01,$01,$03
				DB	$60,$40,$80
				DB	$1C,$07,$80
				DB	$FF

GASSER			USR	("GASSER"________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$21
				BYTE	kill;upstop
				BYTE	repeat0;normalspeed

				DB	$42,$10
				DB	$00,$00,$00,$00,$04,$64,$36
				DB	$00,$78,$76,$5B,$7B,$76,$78
				DB	$00,$07,$1B,$37,$37,$1B,$07
				DB	$00,$00,$00,$07,$46,$46,$66
				DB	$1B,$0F,$80
				DB	$06,$6C,$60,$80
				DB	$18,$0D,$01,$80
				DB	$3E,$80

				DB	$42,$11
				DB	$00,$00,$00,$04,$64,$36,$1B
				DB	$78,$76,$5B,$7B,$76,$78,$06
				DB	$07,$1B,$37,$37,$13,$1F,$70
				DB	$00,$00,$07,$46,$46,$66,$3C
				DB	$0F,$80
				DB	$6C,$60,$80
				DB	$25,$41,$80
				DB	$05,$06,$80

				DB	$42,$11
				DB	$00,$00,$00,$04,$64,$36,$1B
				DB	$78,$76,$5B,$7B,$76,$38,$46
				DB	$07,$1B,$37,$33,$5C,$23,$65
				DB	$00,$00,$39,$66,$59,$26,$6C
				DB	$0F,$80
				DB	$0C,$20,$80
				DB	$33,$0C,$80
				DB	$31,$0E,$80

				DB	$42,$10
				DB	$00,$00,$00,$00,$04,$24,$36
				DB	$00,$08,$70,$4E,$5B,$23,$3A
				DB	$40,$76,$59,$4E,$02,$4C,$63
				DB	$0F,$38,$26,$51,$60,$59,$50
				DB	$1B,$0F,$80
				DB	$4E,$10,$60,$80
				DB	$74,$59,$07,$80
				DB	$6D,$39,$07,$80

				DB	$42,$10
				DB	$00,$38,$4E,$5B,$15,$23,$36
				DB	$3C,$46,$71,$4C,$52,$21,$3A
				DB	$00,$77,$59,$04,$02,$48,$46
				DB	$0F,$18,$34,$51,$30,$49,$50
				DB	$1B,$7C,$80
				DB	$4E,$65,$38,$80
				DB	$34,$49,$07,$80
				DB	$6C,$39,$07,$80

				DB	$52,$00
				DB	$08,$24,$19,$32,$09,$41,$6A
				DB	$20,$04,$62,$19,$24,$42,$24
				DB	$00,$63,$10,$49,$03,$10,$0C
				DB	$0C,$00,$49,$33,$40,$13,$21
				DB	$00,$00,$00,$01,$00,$81
				DB	$32,$04,$50,$80
				DB	$1C,$0B,$21,$80
				DB	$49,$11,$02,$80
				DB	$18,$21,$04,$80
				DB	$01,$80

				DB	$42,$00
				DB	$08,$00,$10,$02,$08,$41,$40
				DB	$20,$00,$42,$00,$04,$40,$04
				DB	$00,$00,$10,$01,$00,$08,$00
				DB	$00,$20,$01,$12,$40,$04,$40
				DB	$02,$00,$10,$80
				DB	$10,$09,$80
				DB	$01,$00,$10,$80
				DB	$11,$00,$04,$80

				DB	$FF

FUNGUS			USR	(TRACC_FUNGUS____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$02,$07,$0D,$18,$70,$60,$70
				DB	$00,$10,$70,$58,$0F,$06,$7C
				DB	$5A,$4E,$02,$80
				DB	$27,$01,$80
				DB	$FF

QUEEN			USR	(QUEEN_INSECT____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+iscompiled+frame0
				DB	$22
				BYTE	special;upstop
				BYTE	repeat0;normalspeed

				DB	$55,$00
				DB	$00,$00,$6C,$70,$78,$78,$44
				DB	$60,$1E,$7C,$7B,$77,$6F,$5F
				DB	$00,$1F,$6F,$77,$7B,$7B,$7D
				DB	$00,$00,$03,$37,$07,$8F
				DB	$80
				DB	$3C,$7B,$7C,$7C,$00,$7C,$7B
				DB	$0C,$33,$07,$1B,$00,$07,$1B
				DB	$7C,$3B,$40,$79,$76,$F8
				DB	$1F,$00,$1F,$1F,$6F,$9F
				DB	$80
				DB	$7C,$78,$80
				DB	$07,$03,$80
				DB	$70,$20,$5C,$66,$46,$80
				DB	$0F,$08,$77,$6C,$67,$E0
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80

				DB	$52,$07
				DB	$00,$00,$00,$00,$00,$02,$06
				DB	$04,$04,$08,$2C,$00,$08,$2C
				DB	$80
				DB	$80
				DB	$80
				DB	$02,$06,$7C,$80
				DB	$08,$0C,$07,$80
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$00,$00,$00,$20,$20,$E0
				DB	$00,$00,$00,$01,$01,$80

				DB	$22,$07
				DB	$00,$00,$00,$02,$80
				DB	$00,$00,$00,$00,$00,$10,$58
				DB	$00,$00,$70,$70,$80
				DB	$10,$10,$09,$01,$80

				DB	$52,$07
				DB	$80
				DB	$00,$00,$00,$00,$00,$00,$30
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$00,$0A,$08,$78,$60,$00
				DB	$20,$20,$3E,$0E,$0F,$03,$00
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$00,$00,$00,$20,$20,$E0
				DB	$00,$00,$00,$01,$01,$80

				DB	$32,$0E
				DB	$00,$78,$7C,$04,$04,$1C,$78
				DB	$00,$0F,$1F,$10,$10,$1C,$0F
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$60,$80
				DB	$01,$80
				DB	$80

				DB	$33,$E7
				DB	$00,$00,$00,$02,$00,$02,$06
				DB	$04,$04,$08,$2C,$00,$18,$68
				DB	$80
				DB	$02,$00,$00,$00,$00,$02,$06
				DB	$20,$00,$00,$00,$00,$20,$30
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$1C,$7C,$78,$60,$80
				DB	$1E,$1F,$0F,$03,$80
				DB	$80

				DB	$54,$07
				DB	$80
				DB	$00,$00,$00,$00,$00,$04,$3A
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$7E,$0A,$0C,$64,$1E,$06
				DB	$1C,$33,$2C,$18,$13,$3C,$30
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$00,$00,$00,$20,$20,$E0
				DB	$00,$00,$00,$01,$01,$80
				DB	$00,$00,$06,$1E,$7C,$7C,$78
				DB	$00,$00,$30,$3C,$1F,$1F,$0F
				DB	$80
				DB	$80
				DB	$80
				DB	$60,$80
				DB	$03,$80
				DB	$80
				DB	$80
				DB	$80

				DB	$54,$07
				DB	$80
				DB	$00,$00,$00,$00,$00,$04,$16
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$00,$70,$70,$18,$60,$78
				DB	$04,$00,$03,$07,$0C,$03,$0F
				DB	$00,$00,$00,$0A,$0A,$8C
				DB	$00,$00,$00,$20,$20,$E0
				DB	$00,$00,$00,$01,$01,$80
				DB	$7C,$7C,$7E,$7E,$7C,$7C,$78
				DB	$1F,$1F,$3F,$3F,$1F,$1F,$0F
				DB	$80
				DB	$80
				DB	$80
				DB	$60,$80
				DB	$03,$80
				DB	$80
				DB	$80
				DB	$80

				DB	$FF

HOTHEAD			USR	(HAMELER_HOT_HEAD)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	blink;uparound
				BYTE	repeat1;normalspeed

				DB	$22,$02
				DB	$58,$2C,$5E,$36,$06,$04,$14
				DB	$0E,$1D,$3E,$36,$30,$28,$14
				DB	$08,$80
				DB	$08,$80

				DB	$22,$02
				DB	$38,$1C,$5E,$36,$06,$09,$12
				DB	$0D,$1D,$3C,$36,$30,$20,$24
				DB	$04,$80
				DB	$08,$80

				DB	$22,$02
				DB	$18,$5C,$3E,$36,$06,$04,$12
				DB	$0D,$1E,$3D,$36,$30,$28,$10
				DB	$08,$80
				DB	$24,$80

				DB	$FF

FIGHTBUG		USR	(FIGHTER_INSECT__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

			; turned off until animation works
			do 0
				DB	animated+notcompiled+frame0
				DB	$12
				BYTE	special;upstop
				BYTE	repeat0;normalspeed

				DB	$22,$00
				DB	$60,$78,$7C,$7C,$7E,$7E,$7C
				DB	$03,$0F,$1F,$1F,$3F,$3F,$1F
				DB	$7C,$78,$60,$80
				DB	$1F,$0F,$03,$80

				DB	$22,$00
				DB	$40,$70,$78,$78,$7C,$7C,$78
				DB	$07,$1F,$3F,$3F,$7F,$7F,$3F
				DB	$78,$70,$40,$80
				DB	$3F,$1F,$07,$80

				DB	$22,$00
				DB	$70,$7C,$7E,$7E,$6F,$6F,$5E
				DB	$01,$07,$0F,$0F,$1F,$1F,$0E
				DB	$3E,$7C,$70,$80
				DB	$0F,$06,$80

				DB	$22,$00
				DB	$60,$78,$6C,$2C,$5E,$5E,$3C
				DB	$03,$0F,$1F,$1E,$3F,$33,$1D
				DB	$7C,$78,$60,$80
				DB	$1E,$0C,$80

				DB	$22,$00
				DB	$70,$74,$76,$16,$6F,$6F,$5E
				DB	$03,$0F,$1E,$1F,$3D,$31,$06
				DB	$1E,$5C,$10,$60,$30,$60,$00
				DB	$7B,$07,$03,$3F,$36,$33,$30

				DB	$23,$00
				DB	$40,$68,$6C,$2C,$5E,$5E,$24
				DB	$66,$73,$59,$1C,$3B,$37,$0F
				DB	$3C,$58,$40,$60,$60,$00,$6E
				DB	$77,$0F,$07,$3B,$07,$04,$3B
				DB	$36,$66,$06,$06,$80
				DB	$66,$63,$80

				DB	$23,$00
				DB	$30,$74,$76,$06,$4F,$6C,$50
				DB	$03,$75,$60,$0E,$0F,$07,$3B
				DB	$60,$5E,$60,$70,$70,$6F,$70
				DB	$03,$3D,$03,$07,$07,$7B,$07
				DB	$70,$10,$6C,$36,$66,$80
				DB	$07,$04,$3B,$36,$33,$B0
			fin

				DB	$23,$00
				DB	$00,$00,$40,$60,$5E,$E0
				DB	$00,$00,$01,$03,$3D,$83
				DB	$60,$5E,$60,$70,$70,$6F,$70
				DB	$03,$3D,$03,$07,$07,$7B,$07
				DB	$70,$10,$6E,$36,$66,$86
				DB	$07,$04,$3B,$66,$63,$80

				DB	$FF

DATA_END_11
