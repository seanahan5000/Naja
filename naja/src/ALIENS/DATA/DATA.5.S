TIMEWARP		USR	(TIME_WARP_______)-	;THIS NAME HAS CHANGED
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$B6,$00
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$E0
				DB	$36,$36,$36,$36,$36,$3F,$36
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$60,$60,$60,$F0
				DB	$36,$36,$36,$76,$7F,$F6
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$70,$70,$70,$70,$F8
				DB	$76,$76,$76,$7F,$F6
				DB	$00,$00,$00,$00,$81
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$78,$7C,$6C,$6C,$6E,$76,$7E
				DB	$76,$7F,$36,$36,$36,$76,$7F
				DB	$01,$03,$03,$03,$07,$06,$07
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$00,$40,$40,$60,$70,$78
				DB	$77,$77,$7B,$7B,$7D,$ED
				DB	$76,$76,$76,$76,$7F,$B6
				DB	$0E,$0E,$1D,$1D,$3B,$FB
				DB	$00,$00,$00,$00,$00,$00,$01
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$00,$00,$00,$00,$00,$7F
				DB	$00,$00,$00,$00,$00,$78,$7F
				DB	$00,$00,$40,$70,$7E,$47,$7F
				DB	$6C,$7E,$37,$1D,$7F,$63,$7F
				DB	$36,$7F,$36,$33,$7F,$19,$7F
				DB	$66,$7F,$66,$66,$7F,$46,$7F
				DB	$36,$7F,$66,$4C,$7F,$39,$7F
				DB	$03,$07,$1E,$7B,$7F,$1C,$7F
				DB	$00,$00,$00,$00,$07,$7E,$7F
				DB	$00,$00,$00,$00,$00,$01,$7F
				DB	$00,$00,$00,$00,$00,$00,$0F

				DB	$FF

MINDSLAV		USR	(NAJA_MIND_SLAVE_)-	;IS THIS NAME RIGHT???
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$00,$00,$00,$00,$00,$00,$40
				DB	$00,$00,$00,$60,$3C,$5E,$3D
				DB	$00,$00,$00,$1F,$78,$F7
				DB	$00,$00,$00,$00,$01,$03,$0D
				DB	$40,$60,$60,$60,$60,$40,$00
				DB	$03,$6D,$60,$00,$00,$01,$03
				DB	$07,$6E,$1E,$7F,$3F,$7E,$00
				DB	$0E,$1C,$18,$18,$1B,$98
				DB	$80
				DB	$06,$0C,$78,$18,$30,$60,$00
				DB	$00,$00,$01,$03,$02,$01,$00
				DB	$18,$18,$1C,$36,$66,$66,$34
				DB	$FF

PLASMAN			USR	(PLASMANOID______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$09,$64,$38,$4D,$66,$1E,$76
				DB	$24,$03,$2E,$59,$33,$3C,$37
				DB	$16,$06,$24,$80
				DB	$34,$31,$12,$80
				DB	$FF

BLASTBRE		USR	(BLAST_BREATHER__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$00,$00,$60,$F0
				DB	$00,$07,$1F,$39,$30,$30,$11
				DB	$70,$60,$60,$70,$78,$0F,$77
				DB	$11,$03,$03,$07,$0F,$78,$77
				DB	$6C,$48,$40,$80
				DB	$1B,$0B,$03,$07,$07,$80
				DB	$FF

ASYMETRI		USR	(ASYMMETRIC_ALIEN)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+iscompiled+frame0
				DB	$22
				BYTE	attack;updown
				BYTE	repeat1;normalspeed

				DB	$53,$00
				DB	$78,$7E,$7D,$5B,$5F,$5F,$6E
				DB	$00,$03,$07,$3F,$4F,$77,$7F
				DB	$00,$00,$00,$00,$0F,$3F,$7F
				DB	$00,$00,$00,$00,$00,$00,$1F
				DB	$80
				DB	$7E,$3C,$50,$78,$78,$40,$3F
				DB	$7F,$7E,$3F,$7E,$79,$1F,$6F
				DB	$7F,$7F,$7E,$76,$78,$7F,$1F
				DB	$7F,$7C,$3B,$3F,$07,$18,$0F
				DB	$80
				DB	$78,$3C,$77,$60,$80
				DB	$70,$0F,$07,$80
				DB	$03,$00,$60,$30,$80
				DB	$1E,$3F,$7F,$6E,$4C,$4C,$6C
				DB	$00,$00,$00,$00,$01,$01,$00

				DB	$22,$E7
				DB	$80
				DB	$00,$00,$00,$50,$80
				DB	$10,$20,$40,$00,$20,$20,$5C
				DB	$00,$00,$00,$00,$01,$01,$00

				DB	$21,$EE
				DB	$00,$00,$20,$20,$80
				DB	$00,$00,$20,$5B,$5A,$74,$30

				DB	$21,$EE
				DB	$00,$00,$00,$40,$80
				DB	$00,$00,$2A,$0A,$2E,$18,$00

				DB	$FF

RICOCHET		USR	(RICOCHET_MISSILE)-
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

CEREBROM		USR	(CEREBROMORPH____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	attack;uparound
				BYTE	repeat1;normalspeed

				DB	$22,$00
				DB	$70,$18,$3E,$66,$4C,$7C,$66
				DB	$03,$0E,$1B,$31,$37,$1C,$31
				DB	$36,$3C,$60,$80
				DB	$37,$1E,$03,$80

				DB	$22,$00
				DB	$08,$64,$41,$19,$32,$02,$19
				DB	$04,$11,$24,$4E,$48,$23,$4E
				DB	$49,$42,$10,$80
				DB	$48,$21,$04,$80

				DB	$FF

BLINKER			USR	("BLINKER"_______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$00
				DB	$80
				DB	$00,$00,$00,$40,$04,$04,$08
				DB	$00,$00,$00,$00,$11,$89
				DB	$00,$00,$00,$00,$00,$00,$01
				DB	$00,$20,$40,$78,$7C,$70,$0C
				DB	$68,$70,$3B,$7B,$5B,$77,$62
				DB	$57,$0D,$5F,$5A,$5F,$6E,$07
				DB	$00,$00,$03,$1F,$3F,$0F,$30
				DB	$1A,$1A,$1B,$33,$33,$30,$00
				DB	$11,$10,$08,$00,$00,$7F,$00
				DB	$09,$11,$12,$00,$00,$40,$00
				DB	$58,$58,$6C,$66,$63,$01,$00
				DB	$FF

LEVITATR		USR	(MAN_IN_LEVITATOR)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$33,$40
				DB	$00,$6F,$7B,$6B,$8B
				DB	$00,$4C,$4C,$7F,$00,$00,$3F
				DB	$00,$3D,$37,$35,$B4
				DB	$4B,$73,$7B,$7B,$5B,$5B,$1B
				DB	$61,$5E,$5E,$56,$61,$FF
				DB	$34,$33,$37,$37,$B6
				DB	$13,$4B,$0B,$0B,$7B,$0F,$7F
				DB	$00,$0D,$00,$00,$7F,$0C,$7F
				DB	$32,$34,$34,$34,$37,$3C,$3F
				DB	$FF

MECHANIC		USR	(MECHANICO_450___)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$03,$7B,$0B,$6F,$69,$69,$6F
				DB	$60,$6F,$68,$7B,$4B,$4B,$7B
				DB	$0B,$7B,$3B,$80
				DB	$68,$6F,$6E,$80
				DB	$FF

AIRLOCK			USR	(PORTABLE_AIRLOCK)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$B6,$01
				DB	$80
				DB	$80
				DB	$80
				DB	$60,$00,$60,$00,$60,$00,$7C
				DB	$7F,$00,$7F,$00,$7F,$00,$7F
				DB	$79,$00,$79,$00,$79,$00,$7F
				DB	$3F,$00,$3F,$00,$3F,$00,$7F
				DB	$00,$00,$00,$00,$00,$00,$03
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$00,$00,$00,$00,$3C,$00
				DB	$7E,$7F,$07,$77,$B7
				DB	$7F,$7F,$02,$7F,$00,$6F,$7F
				DB	$7F,$7F,$00,$7F,$00,$30,$7F
				DB	$7F,$7F,$04,$7F,$60,$EF
				DB	$07,$0F,$0E,$0E,$0E,$6E,$0E
				DB	$00,$00,$00,$00,$00,$03,$00
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$3C,$00,$3C,$00,$3C,$00,$3C
				DB	$37,$37,$37,$37,$37,$37,$77
				DB	$40,$3E,$3E,$4E,$6E,$0E,$5C
				DB	$1F,$6F,$6F,$1F,$3F,$40,$1F
				DB	$60,$67,$67,$67,$67,$67,$73
				DB	$6E,$0E,$6E,$0E,$6E,$0E,$6E
				DB	$03,$00,$03,$00,$03,$00,$03
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$00,$3C,$00,$7C,$00,$7C,$00
				DB	$07,$7F,$7E,$7D,$00,$6F,$00
				DB	$1E,$4E,$5E,$4E,$1E,$4E,$1E
				DB	$40,$1F,$5F,$1F,$40,$19,$40
				DB	$07,$77,$77,$77,$07,$37,$07
				DB	$0E,$6F,$07,$7B,$00,$7F,$00
				DB	$00,$03,$00,$03,$00,$03,$00
				DB	$80
				DB	$80
				DB	$80
				DB	$80
				DB	$7C,$00,$7C,$00,$00,$00,$70
				DB	$6F,$00,$6F,$00,$00,$40,$3F
				DB	$4E,$1E,$4E,$1C,$3F,$7F,$00
				DB	$19,$40,$19,$40,$60,$70,$0F
				DB	$37,$07,$37,$03,$0F,$1F,$60
				DB	$7F,$00,$7F,$00,$00,$00,$7F
				DB	$03,$00,$03,$80
				DB	$80
				DB	$80
				DB	$7B,$06,$7F,$7F,$06,$7B,$00
				DB	$7F,$00,$7F,$7F,$00,$7F,$00
				DB	$0F,$70,$2F,$2F,$70,$0F,$70
				DB	$7F,$00,$7F,$7F,$00,$FF
				DB	$7F,$00,$7F,$7F,$00,$FF
				DB	$7F,$00,$7F,$7F,$00,$FF
				DB	$7F,$00,$7F,$7F,$00,$FF
				DB	$0F,$70,$2F,$2F,$70,$0F,$7F
				DB	$7F,$00,$7F,$7F,$00,$7F,$00
				DB	$7F,$00,$7F,$7F,$00,$7F,$00
				DB	$0D,$06,$0F,$0F,$06,$0D,$00
				DB	$FF

THROWER			USR	("THROWER"_______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$18,$18,$30,$68,$68,$C4
				DB	$0C,$0C,$06,$0B,$0B,$91
				DB	$44,$34,$74,$78,$5C,$46,$38
				DB	$11,$16,$17,$0F,$1D,$31,$0E
				DB	$7E,$7F,$61,$5E,$33,$4C,$73
				DB	$3F,$7F,$43,$3D,$66,$19,$67
				DB	$FF

LATCHER			USR	("LATCHER"_______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$12
				BYTE	special;uparound
				BYTE	repeat0;normalspeed

				DB	$22,$01
				DB	$30,$60,$60,$70,$70,$5C,$66
				DB	$07,$01,$03,$07,$07,$1D,$33
				DB	$44,$80
				DB	$11,$80

				DB	$23,$04
				DB	$30,$60,$40,$60,$C0
				DB	$00,$06,$03,$01,$03,$81
				DB	$40,$40,$40,$60,$60,$70,$58
				DB	$01,$01,$01,$03,$03,$07,$0D
				DB	$6C,$4C,$08,$80
				DB	$1B,$19,$08,$80

				DB	$FF

INVERSE			USR	(INVERSION_ALIEN_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	blink;updown
				BYTE	repeat1;normalspeed

				DB	$22,$00
				DB	$60,$78,$0C,$60,$0C,$7A,$66
				DB	$00,$03,$06,$78,$66,$03,$00
				DB	$06,$06,$06,$80
				DB	$80

				DB	$22,$00
				DB	$60,$7A,$0C,$60,$0D,$7A,$66
				DB	$08,$03,$26,$78,$66,$03,$04
				DB	$16,$06,$06,$80
				DB	$80

				DB	$22,$00
				DB	$64,$78,$0C,$62,$0C,$7A,$66
				DB	$04,$13,$06,$78,$66,$0B,$00
				DB	$06,$06,$06,$80
				DB	$01,$80

				DB	$FF

ANTICIP			USR	(ANTICIPATOR_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$01
				DB	$60,$78,$6C,$2C,$0C,$0C,$08
				DB	$07,$1F,$37,$34,$30,$30,$10
				DB	$1C,$80
				DB	$30,$80
				DB	$FF

SNARC			USR	(SNARC___________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$21,$05
				DB	$60,$38,$67,$18,$0C,$80
				DB	$01,$07,$39,$06,$0C,$80
				DB	$FF

ASSASSIN		USR	(ALIEN_ASSASSIN__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$01
				DB	$78,$08,$6F,$69,$69,$6F,$08
				DB	$0F,$08,$7B,$4B,$4B,$7B,$08
				DB	$78,$38,$80
				DB	$0F,$0E,$80
				DB	$FF

INFORMER		USR	(INFORMER________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	move;uparound
				BYTE	repeat0;normalspeed

				DB	$11,$56
				DB	$03,$13,$0E,$1F,$0E,$80

				DB	$11,$94
				DB	$18,$19,$0E,$1F,$0E,$80

				DB	$11,$42
				DB	$03,$13,$0E,$1F,$0E,$80

				DB	$11,$00
				DB	$18,$19,$0E,$1F,$0E,$80

				DB	$FF

DATA_END_9
