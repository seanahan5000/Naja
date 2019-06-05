MAGNETIC		USR	(MAGNETIC_SWEEPER)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$22
				BYTE	special;upstop
				BYTE	repeat0;normalspeed

				DB	$43,$00
				DB	$40,$38,$38,$58,$18,$D8
				DB	$13,$5B,$5B,$13,$00,$FB
				DB	$49,$5B,$5B,$49,$00,$DF
				DB	$03,$1D,$1D,$1B,$18,$9B
				DB	$58,$58,$18,$58,$58,$18,$60
				DB	$7B,$7B,$78,$7B,$7B,$7B,$7A
				DB	$5F,$5F,$1F,$5E,$DF
				DB	$1B,$1B,$18,$1B,$1B,$19,$06
				DB	$78,$78,$60,$00,$40,$80
				DB	$7A,$7A,$7A,$7B,$7B,$78,$00
				DB	$5F,$5F,$5F,$5F,$5F,$1F,$00
				DB	$1E,$1E,$06,$01,$03,$80

				DB	$43,$00
				DB	$40,$38,$38,$58,$18,$D8
				DB	$13,$5B,$5B,$13,$00,$FB
				DB	$49,$5B,$5B,$49,$00,$DF
				DB	$03,$1D,$1D,$1B,$18,$9B
				DB	$58,$58,$18,$58,$58,$18,$60
				DB	$7B,$7B,$78,$7B,$7B,$7B,$7A
				DB	$5F,$5F,$1F,$5E,$DF
				DB	$1B,$1B,$18,$1B,$1B,$19,$06
				DB	$78,$78,$60,$00,$40,$80
				DB	$0A,$6A,$1A,$7B,$7B,$78,$00
				DB	$58,$5B,$5B,$58,$5F,$1F,$00
				DB	$1E,$1E,$06,$01,$03,$80

				DB	$43,$00
				DB	$40,$38,$38,$58,$18,$D8
				DB	$13,$5B,$5B,$13,$00,$FB
				DB	$49,$5B,$5B,$49,$00,$5C,$5A
				DB	$03,$1D,$1D,$1B,$18,$9B
				DB	$58,$58,$18,$58,$58,$18,$60
				DB	$7B,$7B,$78,$7B,$7B,$7B,$7A
				DB	$52,$4E,$0E,$4C,$56,$51,$5F
				DB	$1B,$1B,$18,$1B,$1B,$19,$06
				DB	$78,$78,$60,$00,$40,$80
				DB	$0A,$6A,$1A,$7B,$7B,$78,$00
				DB	$58,$5B,$5B,$58,$5F,$1F,$00
				DB	$1E,$1E,$06,$01,$03,$80

				DB	$43,$00
				DB	$40,$38,$38,$58,$18,$D8
				DB	$13,$5B,$5B,$13,$00,$7B,$0B
				DB	$49,$5B,$5B,$49,$00,$5C,$5A
				DB	$03,$1D,$1D,$1B,$18,$9B
				DB	$58,$58,$18,$58,$58,$18,$60
				DB	$6B,$33,$48,$7B,$0B,$6B,$6A
				DB	$52,$4E,$0E,$4C,$56,$51,$5F
				DB	$1B,$1B,$18,$1B,$1B,$19,$06
				DB	$78,$78,$60,$00,$40,$80
				DB	$6A,$6A,$62,$3B,$43,$78,$00
				DB	$58,$5A,$5A,$58,$5F,$1F,$00
				DB	$1E,$1E,$06,$01,$03,$80

				DB	$FF

MISER			USR	("MISER"_________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$12,$40
				DB	$09,$06,$0F,$16,$18,$38,$78
				DB	$78,$70,$80
				DB	$FF

EBKALEE			USR	(EBKAL'EE________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$52,$00
				DB	$00,$00,$00,$7E,$7F,$7F,$40
				DB	$1C,$36,$60,$6D,$5B,$3B,$17
				DB	$38,$6C,$06,$76,$7B,$7D,$79
				DB	$00,$00,$00,$77,$6F,$77,$01
				DB	$00,$00,$00,$00,$01,$01,$00
				DB	$80
				DB	$60,$78,$40,$80
				DB	$07,$1F,$03,$80
				DB	$1E,$7F,$60,$80
				DB	$00,$00,$01,$80
				DB	$FF

SCREECHR		USR	("SCREECHER"_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$17
				DB	$36,$1F,$3B,$3F,$73,$66,$5C
				DB	$00,$00,$00,$00,$00,$01,$73
				DB	$60,$40,$60,$60,$70,$38,$5C
				DB	$06,$0F,$0D,$0F,$0C,$06,$03
				DB	$70,$00,$60,$00,$40,$80
				DB	$7D,$7E,$7C,$73,$0D,$26,$20
				DB	$7B,$07,$33,$0C,$1B,$06,$00
				DB	$80
				DB	$FF

MAULER			USR	("MAULER"________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$18,$33,$66,$76,$7C,$60,$30
				DB	$0C,$66,$33,$37,$1F,$03,$06
				DB	$53,$56,$36,$7C,$38,$5C,$36
				DB	$65,$35,$36,$1F,$0E,$1D,$36
				DB	$66,$33,$58,$4C,$0C,$18,$10
				DB	$33,$66,$0D,$19,$18,$0C,$04
				DB	$FF

MEMPLACR		USR	(MEM-PLACER_ROBOT)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$40,$60,$70,$38,$5C,$5E,$27
				DB	$01,$03,$07,$0E,$1D,$3D,$72
				DB	$7B,$27,$5F,$5E,$3D,$6D,$5B
				DB	$6F,$72,$7D,$3D,$5E,$5B,$6D
				DB	$5B,$33,$36,$66,$6C,$58,$40
				DB	$6D,$66,$36,$33,$1B,$0D,$01
				DB	$FF

SPARKLE			USR	(SPARKLE_________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$21
				BYTE	blink;updown
				BYTE	repeat1;normalspeed

				DB	$42,$01
				DB	$00,$00,$00,$00,$32,$80
				DB	$00,$08,$10,$40,$77,$40,$10
				DB	$01,$10,$09,$03,$6F,$03,$09
				DB	$00,$00,$00,$00,$4D,$80
				DB	$80
				DB	$08,$80
				DB	$10,$01,$80
				DB	$80

				DB	$32,$31
				DB	$40,$00,$00,$00,$74,$80
				DB	$00,$03,$56,$7C,$7E,$7C,$56
				DB	$04,$03,$01,$00,$5D,$00,$01
				DB	$00,$40,$80
				DB	$03,$80
				DB	$03,$04,$80

				DB	$22,$61
				DB	$08,$30,$60,$40,$00,$40,$60
				DB	$40,$30,$1D,$0F,$07,$0F,$1D
				DB	$30,$08,$80
				DB	$30,$40,$80

				DB	$FF

ENCEPHAL		USR	(ENCEPHALOID_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$21,$01
				DB	$70,$1C,$6E,$77,$68,$1E,$70
				DB	$07,$1C,$3B,$77,$0B,$3C,$07
				DB	$FF

TRANSPER		USR	(TRANSPARENT_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$21,$03
				DB	$70,$18,$6C,$5C,$3C,$6C,$0C
				DB	$07,$0C,$1B,$1D,$1E,$1B,$18
				DB	$FF

ACIDSPIT		USR	(ACID_SPITTER____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$00,$60,$38,$5C,$5C,$DE
				DB	$00,$03,$0E,$1D,$1D,$BD
				DB	$3E,$76,$0E,$80
				DB	$3E,$37,$38,$80
				DB	$FF

ZETOC			USR	(ZETOC___________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$30,$1C,$7E,$40,$00,$70,$18
				DB	$00,$60,$39,$7F,$1E,$7F,$0C
				DB	$60,$7F,$00,$0F,$78,$43,$03
				DB	$00,$00,$0C,$07,$00,$03,$3E
				DB	$18,$0C,$44,$80
				DB	$0C,$07,$01,$80
				DB	$0E,$18,$18,$80
				DB	$80
				DB	$FF

PHASOID			USR	(PHASOID_________)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

			; turned off until animation works
			do 0
				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	special;upstop
				BYTE	repeat0;normalspeed

				DB	$11,$00
				DB	$80

				DB	$21,$03
				DB	$60,$30,$30,$18,$70,$80
				DB	$03,$06,$06,$0C,$07,$80

				DB	$22,$01
				DB	$60,$70,$78,$38,$38,$18,$70
				DB	$03,$07,$0F,$0E,$0E,$0C,$07
				DB	$60,$80
				DB	$03,$80
			fin

				DB	$22,$01
				DB	$60,$70,$7A,$3B,$3B,$1A,$70
				DB	$03,$07,$2F,$6E,$6E,$2C,$07
				DB	$60,$80
				DB	$03,$80

				DB	$FF

PSEUDOMO		USR	(PSEUDOMORT______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	special;upstop
				BYTE	repeat0;normalspeed

				DB	$42,$00
				DB	$00,$60,$40,$40,$00,$60,$3E
				DB	$78,$41,$01,$1F,$78,$7F,$7C
				DB	$00,$7F,$78,$7F,$63,$75,$2D
				DB	$00,$00,$39,$7F,$5D,$3B,$1B
				DB	$40,$70,$1C,$80
				DB	$0F,$01,$80
				DB	$4C,$78,$80
				DB	$03,$80

				DB	$22,$00
				DB	$00,$40,$00,$70,$1C,$6E,$2E
				DB	$00,$01,$00,$07,$1C,$3B,$3A
				DB	$5E,$46,$16,$80
				DB	$1D,$01,$18,$80

				DB	$FF

TANGIBLE		USR	(TANGIBLE_GAS____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$20
				DB	$00,$40,$24,$52,$44,$12,$44
				DB	$00,$00,$02,$00,$02,$09,$12
				DB	$00,$10,$20,$10,$00,$00,$40
				DB	$00,$01,$04,$09,$02,$09,$05
				DB	$20,$00,$40,$60,$60,$B0
				DB	$68,$56,$57,$2F,$5E,$7E,$7C
				DB	$63,$7F,$1F,$07,$07,$07,$03
				DB	$01,$80
				DB	$28,$10,$24,$12,$08,$12,$09
				DB	$00,$12,$24,$02,$80
				DB	$14,$22,$08,$40,$28,$80
				DB	$80
				DB	$FF

PUDDLE			USR	(PUDDLE_CREATURE_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$12
				BYTE	attack;updown ;is this sequence correct
				BYTE	repeat1;normalspeed

				DB	$52,$01
				DB	$00,$00,$60,$7C,$3E,$5F,$7F
				DB	$00,$47,$7F,$7F,$7F,$7E,$7F
				DB	$7C,$7F,$7F,$71,$60,$71,$7F
				DB	$00,$1F,$7F,$77,$6B,$7F,$3F
				DB	$00,$00,$00,$01,$01,$80
				DB	$7E,$7C,$80
				DB	$43,$80
				DB	$0F,$80
				DB	$0F,$80
				DB	$80

				DB	$51,$02
				DB	$00,$60,$7C,$3E,$5F,$7E,$78
				DB	$7E,$7F,$7F,$3F,$7E,$FF
				DB	$7F,$7F,$78,$70,$78,$FF
				DB	$0F,$7F,$77,$6B,$7F,$1F,$07
				DB	$00,$00,$01,$01,$80

				DB	$42,$01
				DB	$00,$00,$60,$78,$7C,$3C,$7C
				DB	$78,$7C,$7F,$3F,$1E,$3D,$7F
				DB	$00,$47,$7F,$7C,$78,$7C,$7F
				DB	$00,$0F,$3F,$7B,$75,$3F,$1F
				DB	$78,$80
				DB	$7F,$3E,$80
				DB	$7F,$70,$80
				DB	$07,$80

				DB	$FF

IONDIODE		USR	(ION_DIODE_ROBOT_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$10
				DB	$00,$00,$00,$00,$60,$7F,$63
				DB	$40,$60,$30,$58,$6D,$76,$6D
				DB	$00,$01,$03,$06,$6D,$5B,$6D
				DB	$00,$00,$00,$00,$01,$3F,$31
				DB	$03,$07,$03,$80
				DB	$58,$30,$60,$80
				DB	$06,$03,$01,$80
				DB	$30,$38,$30,$80
				DB	$FF

EXPLODER		USR	(VEGAN_EXPLODER__)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	attack;uparound
				BYTE	repeat0;normalspeed

				DB	$11,$42
				DB	$0C,$12,$21,$12,$0C,$80

				DB	$11,$42
				DB	$0C,$12,$33,$12,$0C,$80

				DB	$11,$42
				DB	$0C,$1E,$33,$1E,$0C,$80

				DB	$11,$42
				DB	$0C,$1E,$3F,$1E,$0C,$80

				DB	$FF

CARNIVOR		USR	(CARNIVORE_______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+iscompiled+frame0
				DB	$12
				BYTE	blink;updown
				BYTE	repeat1;normalspeed

				DB	$23,$00
				DB	$00,$7C,$60,$C0
				DB	$00,$00,$03,$06,$05,$8D
				DB	$40,$60,$60,$70,$30,$3C,$3E
				DB	$0D,$0E,$0E,$0E,$0F,$1F,$3F
				DB	$3E,$5F,$6F,$6B,$5B,$33,$02
				DB	$3E,$7D,$7B,$6B,$6D,$66,$20

				DB	$22,$00
				DB	$40,$3C,$20,$00,$00,$A0
				DB	$01,$03,$00,$03,$00,$8B
				DB	$20,$10,$50,$40,$08,$C0
				DB	$0B,$08,$01,$01,$00,$81

				DB	$22,$00
				DB	$00,$20,$20,$10,$10,$D0
				DB	$00,$02,$02,$04,$04,$85
				DB	$50,$40,$48,$48,$C0
				DB	$05,$01,$09,$09,$81

				DB	$22,$00
				DB	$40,$60,$00,$60,$00,$E8
				DB	$01,$1E,$02,$00,$00,$82
				DB	$68,$08,$40,$40,$00,$C0
				DB	$02,$04,$05,$01,$08,$81

				DB	$FF

ATOMARRA		USR	(ATOM_ARRANGER___)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$22
				BYTE	special;uparound
				BYTE	repeat0;normalspeed

				DB	$43,$10
				DB	$00,$00,$40,$60,$60,$00,$60
				DB	$00,$00,$07,$79,$0E,$77,$7B
				DB	$38,$3E,$60,$1F,$78,$F7
				DB	$00,$00,$00,$00,$00,$07,$0F
				DB	$78,$3C,$1C,$1C,$38,$78,$30
				DB	$07,$7C,$00,$38,$40,$00,$07
				DB	$18,$0F,$00,$0D,$4F,$0E,$00
				DB	$7F,$0E,$1F,$0E,$0F,$3E,$07
				DB	$70,$70,$70,$60,$80
				DB	$0F,$0F,$0F,$07,$80
				DB	$00,$60,$40,$60,$60,$30,$10
				DB	$0F,$03,$03,$01,$80

				DB	$43,$01
				DB	$00,$60,$78,$3C,$0E,$7E,$07
				DB	$3E,$4F,$75,$1B,$6D,$76,$1B
				DB	$7C,$3F,$1C,$1B,$1D,$6E,$77
				DB	$1F,$30,$60,$60,$60,$30,$33
				DB	$03,$00,$40,$40,$40,$80
				DB	$67,$7F,$0F,$07,$07,$07,$37
				DB	$6B,$3C,$01,$00,$70,$1C,$06
				DB	$1B,$18,$18,$30,$31,$63,$66
				DB	$80
				DB	$4E,$78,$06,$06,$03,$80
				DB	$03,$1C,$70,$80
				DB	$66,$63,$01,$80

				DB	$43,$00
				DB	$00,$0E,$7E,$7C,$78,$60,$00
				DB	$00,$3E,$4F,$74,$1B,$6D,$76
				DB	$70,$7C,$3F,$1C,$1B,$1D,$2E
				DB	$07,$1F,$80
				DB	$80
				DB	$1B,$67,$7F,$0F,$87
				DB	$77,$6B,$7C,$01,$80
				DB	$00,$03,$03,$80
				DB	$00,$00,$40,$70,$7C,$7C,$78
				DB	$07,$07,$0F,$3F,$FF
				DB	$00,$00,$00,$00,$01,$01,$00
				DB	$80

				DB	$FF

LITTLMEN		USR	(LITTLE_MEN______)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	animated+notcompiled+frame0
				DB	$11
				BYTE	damage;upstop
				BYTE	repeat0;normalspeed

				DB	$22,$00
				DB	$00,$33,$00,$0C,$00,$33,$00
				DB	$18,$00,$60,$06,$00,$18,$00
				DB	$40,$00,$0C,$80
				DB	$61,$00,$06,$80

				DB	$22,$00
				DB	$00,$0C,$00,$00,$30,$00,$03
				DB	$06,$00,$60,$00,$18,$80
				DB	$00,$00,$30,$80
				DB	$06,$00,$60,$80

				DB	$21,$01
				DB	$30,$00,$00,$00,$03,$00,$40
				DB	$00,$60,$00,$00,$18,$00,$01

				DB	$22,$01
				DB	$0C,$80
				DB	$00,$00,$00,$00,$06,$80
				DB	$00,$30,$80
				DB	$80

				DB	$FF

BETEIGUE		USR	(BETEIGUESEN_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$70,$7C,$1E,$6F,$37,$6E,$5E
				DB	$03,$0F,$1C,$3B,$36,$37,$32
				DB	$78,$80
				DB	$11,$10,$10,$80
				DB	$FF

SHARPSHO		USR	("SHARP_SHOOTER"_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$42,$00
				DB	$00,$00,$00,$00,$70,$38,$00
				DB	$00,$70,$1C,$60,$5F,$60,$1E
				DB	$00,$0F,$38,$07,$7B,$07,$78
				DB	$00,$00,$00,$00,$0F,$1C,$00
				DB	$80
				DB	$76,$06,$04,$80
				DB	$6F,$60,$20,$80
				DB	$80
				DB	$FF

TRIPEDIV		USR	(TRIPED_IV_ROBOT_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$43,$03
				DB	$60,$40,$80
				DB	$01,$03,$0F,$4F,$76,$38,$40
				DB	$00,$00,$60,$67,$5F,$38,$77
				DB	$0E,$07,$03,$03,$01,$80
				DB	$7C,$7C,$0C,$0C,$0C,$00,$0C
				DB	$5F,$5F,$20,$70,$40,$20,$40
				DB	$46,$37,$78,$67,$07,$08,$07
				DB	$00,$00,$01,$07,$1E,$78,$30
				DB	$80
				DB	$80
				DB	$03,$03,$03,$80
				DB	$18,$0C,$06,$03,$80
				DB	$FF

PARASITE		USR	(WEBBED_PARASITE_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$00,$30,$58,$7C,$5E,$76,$06
				DB	$00,$07,$0D,$1E,$3D,$37,$30
				DB	$06,$0C,$0C,$80
				DB	$30,$18,$18,$80
				DB	$FF

WORKER			USR	(WORKER_INSECT___)-
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

FIGHTER			USR	(FIGHTER_INSECT__)-
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

OKKARMAR		USR	(OKKAR_MARSUPIAL_)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$22,$00
				DB	$01,$03,$4E,$74,$78,$38,$6C
				DB	$04,$03,$01,$01,$73,$1F,$01
				DB	$0C,$0C,$08,$80
				DB	$80
				DB	$FF

OKKARPLA		USR	(OKKAR_PLANT_____)-
				DS	48,0

				DB	$FF,$DD
				DB	$19,$FF		;temporary

				DB	$23,$00
				DB	$60,$40,$40,$00,$00,$00,$01
				DB	$00,$41,$71,$3B,$1F,$0E,$06
				DB	$07,$1E,$38,$70,$7E,$4F,$31
				DB	$07,$07,$07,$03,$1B,$77,$47
				DB	$78,$38,$1C,$1C,$36,$36,$60
				DB	$0E,$1C,$38,$70,$40,$80
				DB	$FF

DATA_END_13
