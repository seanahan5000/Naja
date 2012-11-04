PUTON			LDY	COUNTER
LETPNT			LDA	LETR0,Y
				LDY	XHOLD
				STA	(SCREENL),Y
				INC	COUNTER
				RTS

LETOFF			DW	LETR0	
				DW	LETR1	
				DW	LETR2	
				DW	LETR3	
				DW	LETR4	
				DW	LETR5	
				DW	LETR6	
				DW	LETR7	
				DW	LETR8	
				DW	LETR9	
				DW	LETRY	
				DW	LETRE	
				DW	LETRS	
				DW	LETRN	
				DW	LETRO	
				DW	LETRX	
				DW	LETR

POINTAT			ASL
				TAY
				LDA	POINTS,Y
				STA	VALUEL
				LDA	POINTS+1,Y
				STA	VALUEH
				LDA	POINTS+2,Y
				CLC
				SBC	VALUEL
				STA	NUMTYPE
				RTS

POINTS			DW	ATSLOTS
				DW	SRANGES
				DW	HESS
				DW	HPSS
				DW	UPREFS	
				DW	BESS
				DW	BPSS
				DW	ECAPS			;Must be ECAPS
				DW	0
				DW	ECAPS	
				DW	LOWREFS	
				DW	PROGS	
				DW	ASTARTS	
				DW	DUMMY

TEXTER			TYA
				ASL
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT

TEXTS			DW	TEXT0	
				DW	TEXT1	
				DW	TEXT2	
				DW	TEXT3	
				DW	TEXT4	
				DW	TEXT5	
				DW	TEXT6	
				DW	TEXT9	
				DW	TEXT7	
				DW	TEXTC	
				DW	TEXTB	
				DW	TEXT8	
				DW	TEXTA	
				DW	0
				DW	TEXTE	
				DW	TEXT11	
				DW	TEXTF	
				DW	TEXT14		
				DW	TEXT13	
				DW	TEXT10	
				DW	TEXT12	
				DW	TEXT15	
				DW	TEXT16	
				DW	TEXT17	
				DW	TEXT18	
				DW	TEXT19	
				DW	TEXT1A	
				DW	TEXT1B	
				DW	TEXT1C	
				DW	TEXT1D	
				DW	TEXT1E	
				DW	TEXT1F	
				DW	TEXT20	
				DW	TEXT21	
				DW	0
				DW	TEXT23
				DW	TEXT24
				DW	TEXT25
				DW	0
				DW	TEXT27
				DW	TEXT28
				DW	TEXT29
				DW	TEXT2A	
				DW	TEXT2B
				DW	TEXT2C
				DW	TEXT2D
				DW	TEXT2E
				DW	TEXT2F
				DW	TEXT30
				DW	TEXT31
				DW	TEXT32
				DW	TEXT33

LINER			TYA
				ASL
				TAY
				LDA	LINES,Y
				STA	POINTL
				LDA	LINES+1,Y
				STA	POINTH
				JMP	LINEOUT

LINES			DW	LINE0
				DW	LINE1		
				DW	LINE2X
				DW	LINE3	
				DW	LINE4	
				DW	LINE5	
				DW	LINE6	
				DW	LINE7	
				DW	LINE8	
				DW	LINE9	
				DW	LINEA	
				DW	LINEB	
				DW	LINEC	
				DW	LINED	
				DW	LINEE	
				DW	LINEF	
				DW	LINE10	
				DW	LINE11		
				DW	LINE12	
				DW	LINE13	
				DW	LINE14	
				DW	LINE15

TEXT0			PLOTAT	60;2;(HEADS)
				PLOTAT	126;35;(BODIES)
				PLOTAT	191;2;(WEAPONS)
				PLOTAT	188;45;(PROGRAMS)
				PLOTAT	60;45;(ENERGY)
				PLOTAT	120;78;(MOVEMENT)+

TEXT1			PLOTAT	68;113;(AVAILABLE_OPTIONS_ARE:)
				PLOTAT	86;124;(REPLACE_ROBOT_PARTS)
				PLOTAT	86;135;(BUY_A_COMPLETE_ROBOT)
				PLOTAT	86;144;(SELL_A_COMPLETE_ROBOT)
				PLOTAT	86;155;(LEAVE)+

TEXT2			PLOTAT	16;185;(CANCEL)+

TEXT3			PLOTAT	59;93;(WHICH_CYBERNATE_WILL_THIS_NEW)
				PLOTAT	83;102;(ROBOT_BE_ASSIGNED_TO?)+

TEXT4			PLOTAT	37;2;(PLEASE_TURN_TO_THE_RIGHT_)+

TEXT5			PLOTAT	80;55;(PLEASE_STEP_CLOSER_)+

TEXT6			PLOTAT	65;94;(WHOSE_CREDITS_WILL_BE_USED?)
				PLOTAT	14;109;(PROF)
				PLOTAT	58;109;(NAME)
				PLOTAT	114;109;(CREDITS)
				PLOTAT	16;177;(POOLED_CREDITS)+

TEXT7			PLOTAT	30;35;(BODIES)
				PLOTAT	17;56;(UPPER)
				PLOTAT	14;64;(REFLEX/STRENGTH)
				PLOTAT	130;56;(ELECTRICAL)
				PLOTAT	133;64;(SHIELDING)
				PLOTAT	219;56;(PHYSICAL)
				PLOTAT	216;64;(SHIELDING)
TEXT29			PLOTAT	146;131;(25/25)
				PLOTAT	188;131;(E:10_P:10)+

TEXT8			PLOTAT	22;35;(MOVEMENT)
				PLOTAT	131;57;(LOWER)
				PLOTAT	128;65;(REFLEX)
				PLOTAT	181;57;(MOVEMENT)
				PLOTAT	193;65;(TYPE)
				PLOTAT	191;81;(TREAD)
TEXT2C			PLOTAT	146;169;(TREAD)
				PLOTAT	212;169;(LR:20)+

TEXT9			PLOTAT	29;2;(HEADS)
				PLOTAT	14;56;(ATTACHMENT)
				PLOTAT	32;64;(SLOT)
				PLOTAT	97;56;(SIGHT)
				PLOTAT	97;64;(RANGE)
				PLOTAT	144;56;(ELECTRICAL)
				PLOTAT	147;64;(SHIELDING)
				PLOTAT	219;56;(PHYSICAL)
				PLOTAT	216;64;(SHIELDING)
TEXT28			PLOTAT	146;111;(2)
				PLOTAT	146;120;(NO)
				PLOTAT	188;120;(E:4__P:5)+

TEXTA			PLOTAT	20;2;(PROGRAMS)
				PLOTAT	127;56;(PROGRAM)
				PLOTAT	133;64;(LEVEL)
				PLOTAT	197;56;(AUTO-)
				PLOTAT	197;64;(START)
TEXT2D			PLOTAT	146;180;(LEVEL_1)+

TEXTB			PLOTAT	28;2;(ENERGY)
				PLOTAT	139;57;(ENERGY_CAPACITY)
TEXT2B			PLOTAT	146;160;(1000/3000)+

TEXTC			PLOTAT	23;2;(WEAPONS)
				PLOTAT	142;53;(ROBO-DAGGER)
				PLOTAT	142;61;(ROBO-SWORD)
				PLOTAT	142;69;(ROBO-BLASTER_C)
				PLOTAT	142;77;(ROBO-BLASTER_B)
				PLOTAT	142;85;(ROBO-BLASTER_A)
				PLOTAT	142;93;(NOTHING)+

TEXTE			PLOTAT	172;14;(PRICE:)+

TEXTF			PLOTAT	106;14;(ROBOT_BODY)+

TEXT10			PLOTAT	118;14;(MOVEMENT)+

TEXT11			PLOTAT	106;14;(ROBOT_HEAD)+

TEXT12			PLOTAT	124;14;(PROGRAM)+

TEXT13			PLOTAT	100;14;(ENERGY_SUP.)+

TEXT14			PLOTAT	130;14;(WEAPON)+

TEXT15			PLOTAT	100;4;(AVAILABLE_CREDITS:)+

TEXT16			PLOTAT	62;111;(SIGHT_RANGE:)
				PLOTAT	74;120;(HEAD_SLOT:)
				PLOTAT	74;131;(BODY_TYPE:)
				PLOTAT	68;142;(WEAPON_<L>:)
				PLOTAT	68;151;(WEAPON_<R>:)
				PLOTAT	56;180;(PROGRAM_CARD:)
				PLOTAT	50;160;(ENERGY_SUPPLY:)
				PLOTAT	50;169;(MOVEMENT_TYPE:)+

TEXT17			PLOTAT	205;107;(C>ANCEL)+

TEXT18			PLOTAT	191;81;(TREAD)
STOP18			PLOTAT	146;169;(TREAD)+

TEXT19			PLOTAT	179;81;(LEVITATOR)
STOP19			PLOTAT	146;169;(LEVITATOR)+

TEXT1A			PLOTAT	179;81;(TETRA-LEG)
STOP1A			PLOTAT	146;169;(TETRA-LEG)+

TEXT1B			PLOTAT	188;81;(BI-LEG)
STOP1B			PLOTAT	146;169;(BI-LEG)+

TEXT1C			PLOTAT	59;98;(REPLACE_PARTS_ON_WHICH_ROBOT?)+

TEXT1D			PLOTAT	32;89;(YOU_HAVE_OVERSPENT_BY_)
				PLOTAT	56;98;(WHAT_AREA_DO_YOU_WANT_TO_REDO?)+

TEXT1E			PLOTAT	50;126;(YOUR_ROBOT_IS_BEING_REGISTERED)
				PLOTAT	50;135;(UNDER_THE_NAME_)-
ROBOT_NAME		USR	(ROBOT-___1.)+

TEXT1F			PLOTAT	116;126;(IS_BEING)
				PLOTAT	116;126;(HAS_BEEN)
				PLOTAT	50;148;(YOU_CAN_PICK_THE_ROBOT_UP_AT_THE)
				PLOTAT	50;157;(GROUP_ASSEMBLY_OFFICE_AND_CHANGE)
				PLOTAT	50;166;(ITS_NAME_TO_WHAT_EVER_YOU_WISH.)
				PLOTAT	188;179;(<SPACE>)+

TEXT20			PLOTAT	44;89;(_IS_WORTH_)-
TEXCRED			USR	(00000000_CREDITS)
				PLOTAT	50;98;(PRESS_<SPACE>_TO_SELL_IT)+

TEXT21			PLOTAT	50;98;(WHICH_ROBOT_DO_YOU_WANT_TO_SELL?)+

TEXT23			PLOTAT	89;94;(REPLACE_WHICH_PART?)+

TEXT24			PLOTAT	188;120;(E:___P:)
				PLOTAT	188;131;(E:___P:)
				PLOTAT	212;169;(LR:)
				PLOTAT	158;131;(/)
				PLOTAT	146;160;(1000/)
				PLOTAT	146;180;(LEVEL)+

TEXT25			PLOTAT	100;24;(TOTAL_ROBOT_PRICE:)+

TEXT27			PLOTAT	57;89;(_HAS_EQUIPMENT_THAT)
				PLOTAT	57;98;(MUST_BE_SOLD_AT_THE_ARSENAL)+

TEXT2A			PLOTAT	41;89;(YOU_HAVE_OVERSPENT_BY_)-
TEXOVER			USR	(00000000_CREDITS-)
				PLOTAT	41;98;(SELECT_AN_AREA_TO_BE_REDONE)+

TEXT2E			PLOTAT	31;89;(PRESS_<SPACE>_TO_VERIFY_ROBOT_PURCHASE)
				PLOTAT	61;98;(OR_A>DJUST_TO_CHANGE_AN_AREA)+

TEXT2F			PLOTAT	57;93;(SELECT_AN_AREA_TO_BE_ADJUSTED)+

TEXT30			PLOTAT	48;114;(AN_ABLE_BODIED_CYBERNATE_MUST_BE)
				PLOTAT	48;124;(PRESENT_TO_MAKE_ANY_TRANSACTIONS)
				PLOTAT	48;134;(HERE_AT_THE_ROBOT_ORDERING_AND)
				PLOTAT	48;144;(REPLACEMENT_CENTER.)
				PLOTAT	198;155;(<SPACE>)+

TEXT31			PLOTAT	133;37;(>>TOO_EXPENSIVE<<)+

TEXT32			PLOTAT	118;24;(MINUS_TRADE-IN:)+

TEXT33			PLOTAT	205;107;(<SPACE>)+

LINE0			DB	$00,$29,$00
				DB	$00,$2A,$2B
				DB	$00,$6F,$2B
				DB	$00,$6F,$00
				DB	$FE
				DB	$00,$2A,$2B
				DB	$00,$2A,$00
				DB	$00,$70,$00
				DB	$00,$70,$2B
				DB	$FF
LINE1			DB	$00,$6F,$00
				DB	$00,$6F,$2B
				DB	$00,$B1,$2B
				DB	$00,$B1,$00
				DB	$FE
				DB	$00,$70,$2B
				DB	$00,$70,$00
				DB	$00,$B2,$00
				DB	$00,$B2,$2B
				DB	$FF
LINE2X			DB	$00,$B1,$00
				DB	$00,$B1,$2B
				DB	$00,$F5,$2B
				DB	$00,$F5,$00
				DB	$FE
				DB	$00,$B2,$2B
				DB	$00,$B2,$00
				DB	$00,$F6,$00
				DB	$00,$F6,$2B
				DB	$FF
LINE3			DB	$00,$29,$2B
				DB	$00,$29,$56
				DB	$00,$6F,$56
				DB	$00,$6F,$2B
				DB	$FE
				DB	$00,$2A,$56
				DB	$00,$2A,$2B
				DB	$00,$70,$2B
				DB	$00,$70,$56
				DB	$FF
LINE4			DB	$00,$6F,$2B
				DB	$00,$6F,$56
				DB	$00,$B1,$56
				DB	$00,$B1,$2B
				DB	$FE
				DB	$00,$70,$56
				DB	$00,$70,$2B
				DB	$00,$B2,$2B
				DB	$00,$B2,$56
				DB	$FF
LINE5			DB	$00,$B1,$2B
				DB	$00,$B1,$56
				DB	$00,$F5,$56
				DB	$00,$F5,$2B
				DB	$FE
				DB	$00,$B2,$56
				DB	$00,$B2,$2B
				DB	$00,$F6,$2B
				DB	$00,$F6,$56
				DB	$FF
LINE6			DB	$00,$28,$6B
				DB	$00,$F6,$6B
				DB	$00,$F6,$BF
				DB	$00,$28,$BF
				DB	$00,$28,$6B
				DB	$FF
LINE7			DB	$00,$01,$73
				DB	$01,$15,$73
				DB	$01,$15,$B7
				DB	$00,$01,$B7
				DB	$00,$01,$73
				DB	$FE
				DB	$00,$01,$7D
				DB	$01,$15,$7D
				DB	$FF
LINE8			DB	$00,$21,$00
				DB	$00,$C3,$00
				DB	$00,$C3,$0A
				DB	$00,$21,$0A
				DB	$00,$21,$00
				DB	$FF
LINE9			DB	$00,$49,$34
				DB	$00,$CD,$34
				DB	$00,$CD,$40
				DB	$00,$49,$40
				DB	$00,$49,$34
				DB	$FF
LINEA			DB	$00,$01,$6B
				DB	$01,$15,$6B
				DB	$01,$15,$AF
				DB	$00,$01,$AF
				DB	$00,$01,$6B
				DB	$FE
				DB	$00,$01,$75
				DB	$01,$15,$75
				DB	$FF
LINEB			DB	$00,$5D,$00
				DB	$01,$0D,$00
				DB	$01,$0D,$22
				DB	$00,$5D,$22
				DB	$00,$5D,$00
				DB	$FF
LINEC			DB	$00,$0D,$00
				DB	$00,$53,$00
				DB	$00,$53,$2B
				DB	$00,$0D,$2B
				DB	$00,$0D,$00
				DB	$FF
LINED			DB	$00,$0D,$00
				DB	$00,$4F,$00
				DB	$00,$4F,$2B
				DB	$00,$0D,$2B
				DB	$00,$0D,$00
				DB	$FF
LINEE			DB	$00,$09,$00
				DB	$00,$4D,$00
				DB	$00,$4D,$2B
				DB	$00,$09,$2B
				DB	$00,$09,$00
				DB	$FF
LINEF			DB	$00,$7A,$32
				DB	$00,$F2,$32
				DB	$00,$F2,$66
				DB	$00,$7A,$66
				DB	$00,$7A,$32
				DB	$FF
LINE10			DB	$00,$C8,$6B
				DB	$00,$C8,$73
				DB	$00,$F6,$73
				DB	$FF
LINE11			DB	$00,$C7,$6B
				DB	$00,$F6,$6B
				DB	$00,$F6,$73
				DB	$FF
LINE12			DB	$00,$00,$36
				DB	$00,$00,$36
				DB	$00,$00,$48
				DB	$00,$00,$48
				DB	$00,$00,$36
				DB	$FF
LINE13			DB	$00,$7A,$36
				DB	$00,$EE,$36
				DB	$00,$EE,$5E
				DB	$00,$7A,$5E
				DB	$00,$7A,$36
				DB	$FE
				DB	$00,$80,$4A
				DB	$00,$E8,$4A
				DB	$FF
LINE14			DB	$00,$86,$36
				DB	$00,$E8,$36
				DB	$00,$E8,$56
				DB	$00,$86,$56
				DB	$00,$86,$36
				DB	$FE
				DB	$00,$8C,$42
				DB	$00,$E2,$42
				DB	$FF
LINE15			DB	$00,$28,$6B
				DB	$00,$F6,$6B
				DB	$00,$F6,$A8
				DB	$00,$28,$A8
				DB	$00,$28,$6B
				DB	$FF

ICON1			DB	$02,$21,$11		;BODIES
				DB	$16,$FE,$0F
				DB	$83,$81,$80
				DB	$80,$81,$80
				DB	$80,$81,$80
				DB	$80,$81,$83
				DB	$83,$81,$FE
				DB	$04,$80,$F9
				DB	$AF,$EA,$BF
				DB	$FE,$0B,$AA
				DB	$E9,$EB,$E8
				DB	$E3,$EE,$ED
				DB	$ED,$ED,$EE
				DB	$E3,$A8,$AA
				DB	$EA,$EA,$BA
				DB	$9A,$8F,$A7
				DB	$FD,$D5,$FF
				DB	$FE,$05,$D5
				DB	$D0,$D7,$CE
				DB	$DB,$BA,$EA
				DB	$EB,$AB,$8B
				DB	$F3,$9C,$ED
				DB	$AD,$ED,$9D
				DB	$F1,$85,$D5
				DB	$D5,$D5,$D7
				DB	$D6,$FC,$F0
				DB	$B0,$F0,$FE
				DB	$04,$B8,$AC
				DB	$AC,$80,$FF
				DB	$D5,$D5,$FF
				DB	$60,$CB,$CB
				DB	$FE,$06,$AB
				DB	$AE,$AC,$B8
				DB	$B0,$E0,$C0
				DB	$FE,$0D,$80
				DB	$FE,$01,$FE
				DB	$AB,$AB,$FE
				DB	$01,$FE,$FE
				DB	$1D,$80,$E0
				DB	$E0,$FE,$13
				DB	$80
ICON4			DB	$35,$45			;MOVEMENT
				DB	$10,$18,$FE
				DB	$0B,$00,$03
				DB	$FE,$09,$00
				DB	$03,$0E,$38
				DB	$67,$67,$70
				DB	$3F,$40,$7F
				DB	$1C,$07,$01
				DB	$00,$01,$07
				DB	$1C,$70,$42
				DB	$2A,$20,$0E
				DB	$0E,$20,$7F
				DB	$00,$7F,$44
				DB	$44,$7F,$08
				DB	$7F,$04,$71
				DB	$71,$04,$55
				DB	$41,$1C,$1C
				DB	$41,$7F,$00
				DB	$7F,$22,$22
				DB	$7F,$00,$7F
				DB	$08,$63,$63
				DB	$08,$2A,$02
				DB	$38,$38,$02
				DB	$7F,$00,$7F
				DB	$11,$11,$7F
				DB	$00,$7F,$10
				DB	$47,$47,$10
				DB	$55,$04,$71
				DB	$71,$04,$7F
				DB	$00,$7F,$08
				DB	$08,$7F,$04
				DB	$7F,$20,$0E
				DB	$0E,$20,$2A
				DB	$08,$61,$67
				DB	$1C,$70,$0E
				DB	$78,$60,$60
				DB	$60,$00,$7F
				DB	$41,$1C,$1C
				DB	$43,$4E,$38
				DB	$60,$FE,$09
				DB	$00,$40,$60
				DB	$60,$60,$40
				DB	$FE,$0C,$00
ICON0			DB	$0A,$29,$08		;HEADS
				DB	$0C,$39,$39
				DB	$39,$FE,$05
				DB	$1D,$0F,$0F
				DB	$0F,$00,$1F
				DB	$1F,$1F,$0F
				DB	$3F,$02,$02
				DB	$07,$02,$02
				DB	$3F,$0F,$1F
				DB	$1F,$0F,$0F
				DB	$0B,$0B,$0A
				DB	$00,$40,$55
				DB	$50,$55,$54
				DB	$FE,$04,$55
				DB	$50,$47,$3F
				DB	$FE,$04,$7F
				DB	$75,$75,$74
				DB	$75,$75,$FE
				DB	$05,$7F,$7E
				DB	$7D,$7B,$70
				DB	$7F,$3F,$1E
				DB	$2E,$1E,$2E
				DB	$1E,$2E,$1E
				DB	$21,$0F,$7E
				DB	$79,$77,$78
				DB	$7D,$7E,$7F
				DB	$3F,$2F,$7F
				DB	$2F,$3F,$7F
				DB	$75,$65,$55
				DB	$3F,$7F,$7F
				DB	$7F,$00,$7F
				DB	$7F,$FE,$07
				DB	$00,$7F,$40
				DB	$3F,$75,$7F
				DB	$00,$5B,$6D
				DB	$36,$5B,$6F
				DB	$70,$7F,$7F
				DB	$7F,$2A,$3F
				DB	$2A,$7F,$7E
				DB	$7C,$78,$10
				DB	$70,$70,$FE
				DB	$07,$00,$40
				DB	$30,$68,$28
				DB	$68,$78,$00
				DB	$40,$40,$00
				DB	$40,$30,$60
				DB	$40,$FE,$0B
				DB	$00
ICON5			DB	$35,$54			;PROGRAMS
				DB	$1C,$1F,$8F
				DB	$8C,$8D,$8C
				DB	$8D,$8C,$8D
				DB	$8F,$FE,$04
				DB	$8D,$8C,$8D
				DB	$8F,$8C,$8F
				DB	$8C,$8D,$8C
				DB	$8D,$8C,$8D
				DB	$8D,$8C,$8D
				DB	$8D,$8C,$8D
				DB	$8D,$8C,$8F
				DB	$FF,$E6,$C6
				DB	$EF,$CC,$EF
				DB	$CA,$FF,$55
				DB	$55,$FF,$D8
				DB	$9B,$FF,$E1
				DB	$8C,$FF,$8C
				DB	$E1,$FD,$ED
				DB	$E0,$FF,$F0
				DB	$B7,$F6,$FE
				DB	$01,$FE,$B7
				DB	$F6,$FE,$01
				DB	$FE,$87,$FF
				DB	$FF,$ED,$ED
				DB	$FF,$81,$FD
				DB	$D5,$FD,$23
				DB	$26,$FD,$8F
				DB	$ED,$ED,$ED
				DB	$8D,$FD,$8D
				DB	$ED,$EF,$ED
				DB	$8D,$FD,$EF
				DB	$ED,$FD,$ED
				DB	$EF,$FD,$EE
				DB	$EF,$FF,$FE
				DB	$09,$C0,$80
				DB	$C0,$C0,$FE
				DB	$01,$FE,$EA
				DB	$FE,$01,$FE
				DB	$EA,$FE,$01
				DB	$FE,$EA,$FE
				DB	$01,$FE,$C0
				DB	$FE,$01,$FE
				DB	$D4,$FE,$01
				DB	$FE,$C0,$FE
				DB	$01,$FE,$D4
				DB	$FE,$01,$FE
				DB	$C0,$C0,$80
				DB	$C0,$C0
ICON3			DB	$35				;ENERGY
				DB	$54,$07,$0D
				DB	$FE,$06,$80
				DB	$AA,$FE,$0E
				DB	$80,$82,$82
				DB	$82,$AA,$82
				DB	$82,$82,$FE
				DB	$0A,$80,$D0
				DB	$FE,$11,$80
				DB	$D0,$FE,$0C
				DB	$80,$9F,$95
				DB	$9D,$95,$9D
				DB	$95,$9D,$FE
				DB	$07,$85,$9D
				DB	$95,$9D,$95
				DB	$9D,$95,$9F
				DB	$FE,$06,$80
				DB	$FE,$04,$1D
				DB	$0D,$67,$B3
				DB	$B9,$B9,$B7
				DB	$BB,$B7,$B9
				DB	$FE,$05,$AD
				DB	$B9,$B7,$BB
				DB	$B7,$B9,$B9
				DB	$B3,$67,$0D
				DB	$1D,$1D,$1D
				DB	$0D,$07,$FE
				DB	$07,$2A,$6A
				DB	$6A,$2A,$2A
				DB	$2A,$6A,$68
				DB	$6B,$66,$6D
				DB	$6D,$6C,$2D
				DB	$2D,$2D,$66
				DB	$6B,$68,$FE
				DB	$07,$2A,$FE
				DB	$06,$55,$54
				DB	$55,$53,$56
				DB	$4E,$5A,$00
				DB	$7E,$43,$3C
				DB	$7F,$7F,$07
				DB	$60,$7F,$7F
				DB	$3C,$43,$7E
				DB	$00,$FE,$06
				DB	$55,$28,$28
				DB	$20,$20,$10
				DB	$30,$70,$FE
				DB	$06,$50,$10
				DB	$50,$60,$FE
				DB	$06,$30,$68
				DB	$48,$FE,$08
				DB	$28
ICON2			DB	$0A,$29			;WEAPONS
				DB	$1B,$21,$1F
				DB	$1A,$1E,$1B
				DB	$FE,$0B,$1A
				DB	$0E,$06,$06
				DB	$0E,$06,$06
				DB	$0E,$06,$06
				DB	$0E,$1A,$1A
				DB	$0E,$06,$03
				DB	$01,$00,$4A
				DB	$7F,$55,$7F
				DB	$FE,$07,$55
				DB	$54,$55,$53
				DB	$56,$4E,$5A
				DB	$40,$1F,$71
				DB	$6E,$6A,$6E
				DB	$71,$1F,$40
				DB	$FE,$05,$55
				DB	$7F,$3F,$6F
				DB	$2F,$7B,$2B
				DB	$2B,$2B,$2A
				DB	$2A,$00,$3F
				DB	$75,$5D,$57
				DB	$56,$5C,$5C
				DB	$5A,$1A,$62
				DB	$FE,$04,$6A
				DB	$0A,$2B,$2B
				DB	$2E,$2C,$38
				DB	$30,$60,$00
				DB	$00,$00,$FE
				DB	$04,$40,$60
				DB	$60,$80,$7F
				DB	$2A,$2A,$7F
				DB	$80,$FE,$08
				DB	$58,$70,$60
				DB	$40,$FE,$06
				DB	$00,$FE,$09
				DB	$80,$7E,$B3
				DB	$DB,$DA,$DB
				DB	$BE,$8C,$98
				DB	$FE,$18,$80
				DB	$88,$82,$FA
				DB	$D2,$FA,$E2
				DB	$88,$FE,$1B
				DB	$80,$F0,$AA
				DB	$F0,$FE,$12
				DB	$80

LETR0			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETR1			DB	$80,$8A
				DB	$80,$8A,$C0
				DB	$8A,$C0,$8A
				DB	$C0,$8A,$80
				DB	$8A,$80,$8A
				DB	$80,$8A,$80
				DB	$8A,$80,$8A
				DB	$80,$8A,$80
				DB	$8A,$C0,$AA
				DB	$C0,$AA,$C0
				DB	$AA
LETR2			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$80,$A8,$80
				DB	$A8,$D0,$AA
				DB	$D4,$AA,$D4
				DB	$8A,$94,$80
				DB	$94,$80,$94
				DB	$80,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA
LETR3			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$80,$A8,$80
				DB	$A8,$C0,$AA
				DB	$C0,$8A,$C0
				DB	$AA,$80,$A8
				DB	$80,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETR4			DB	$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$80,$A8
				DB	$80,$A8,$80
				DB	$A8,$80,$A8
				DB	$80,$A8,$80
				DB	$A8
LETR5			DB	$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$80
				DB	$94,$80,$94
				DB	$80,$D4,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$80,$A8
				DB	$80,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETR6			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$80,$94
				DB	$80,$D4,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETR7			DB	$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$80,$A8,$80
				DB	$A8,$80,$A8
				DB	$80,$8A,$80
				DB	$8A,$C0,$82
				DB	$C0,$82,$C0
				DB	$82,$C0,$82
				DB	$C0,$82,$C0
				DB	$82
LETR8			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D0,$8A,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETR9			DB	$D0,$8A
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$AA,$80,$A8
				DB	$80,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D0
				DB	$8A
LETRY			DB	$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$80,$A8
				DB	$80,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA
LETRE			DB	$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$80,$94
				DB	$80,$D4,$82
				DB	$D4,$82,$D4
				DB	$82,$94,$80
				DB	$94,$80,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA
LETRS			DB	$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$80,$94
				DB	$80,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$80,$A8
				DB	$80,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA
LETRN			DB	$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$A8
				DB	$D4,$A8,$D4
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$AA
				DB	$94,$AA,$94
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8
LETRO			DB	$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$94,$A8
				DB	$94,$A8,$94
				DB	$A8,$D4,$AA
				DB	$D4,$AA,$D4
				DB	$AA
LETRX			DB	$80,$80
				DB	$80,$80,$80
				DB	$B8,$80,$BC
				DB	$80,$BE,$80
				DB	$9F,$C0,$8F
				DB	$E0,$87,$F0
				DB	$83,$F8,$81
				DB	$FC,$80,$BC
				DB	$80,$9C,$80
				DB	$80,$80,$80
				DB	$80
LETR			DB	$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80,$80,$80
				DB	$80

ATSLOTS			DB	$FF,$AA
SRANGES			DB	$02,$03
				DB	$04,$05,$06
				DB	$07
HESS			DB	$04,$08
				DB	$12,$16
HPSS			DB	$05
				DB	$10,$15
UPREFS			DB	$25,$30
				DB	$35,$40,$45
				DB	$50,$55,$60
				DB	$65,$70,$75
				DB	$80,$85,$90
				DB	$95
BESS			DB	$10,$15
				DB	$20,$25,$30
				DB	$40,$50,$60
BPSS			DB	$10,$15,$20
				DB	$25,$30,$40
				DB	$50,$60,$70
				DB	$80
ECAPS			DB	$83,$86,$89
				DB	$92,$95,$03
				DB	$05,$07,$10
				DB	$12,$15,$17
				DB	$20,$22,$25
				DB	$27,$30,$32
				DB	$35,$37,$40
LOWREFS			DB	$20,$25
				DB	$30,$35,$40
				DB	$45,$50,$55
				DB	$60,$65,$70
				DB	$75,$80,$85
				DB	$90,$95
PROGS			DB	$01
				DB	$02,$03,$04
				DB	$05,$06,$07
				DB	$10
				DB	$15,$20,$25
				DB	$30,$35,$40
				DB	$45,$50,$55
				DB	$60,$65,$70
				DB	$75
ASTARTS			DB	$FF,$AA
DUMMY			DB	$00

SLT				DB	$00,$00,$00
				DB	$00,$50,$00
SR				DB	$00,$00,$10
				DB	$00,$08,$00
				DB	$00,$80,$00
				DB	$04,$00,$00
				DB	$08,$00,$00
				DB	$12,$50,$00
ESH				DB	$00,$00,$15
				DB	$00,$30,$00
				DB	$01,$50,$00
				DB	$05,$00,$00
PSH				DB	$00,$00,$15
				DB	$00,$40,$00
				DB	$02,$00,$00
URS				DB	$00,$00,$20
				DB	$00,$04,$00
				DB	$00,$20,$00
				DB	$00,$60,$00
				DB	$01,$20,$00
				DB	$02,$00,$00
				DB	$03,$50,$00
				DB	$05,$50,$00
				DB	$09,$00,$00
				DB	$13,$00,$00
				DB	$18,$00,$00
				DB	$23,$00,$00
				DB	$30,$00,$00
				DB	$38,$50,$00
				DB	$50,$00,$00
ESB				DB	$00,$00,$20
				DB	$00,$05,$00
				DB	$00,$20,$00
				DB	$01,$00,$00
				DB	$04,$00,$00
				DB	$08,$00,$00
				DB	$13,$00,$00
				DB	$21,$00,$00
PSB				DB	$00,$00,$20
				DB	$00,$05,$00
				DB	$00,$20,$00
				DB	$01,$00,$00
				DB	$02,$00,$00
				DB	$03,$00,$00
				DB	$05,$00,$00
				DB	$09,$00,$00
				DB	$14,$00,$00
				DB	$20,$00,$00
WEA				DB	$00,$00,$60
				DB	$00,$03,$00
				DB	$00,$01,$00
				DB	$00,$02,$20
				DB	$00,$90,$00
				DB	$00,$00,$00
				DB	$01,$00,$00
EC				DB	$00,$00,$50
				DB	$00,$02,$00
				DB	$00,$07,$50
				DB	$00,$20,$00
				DB	$00,$40,$00
				DB	$00,$60,$00
				DB	$01,$00,$00
				DB	$01,$75,$00
				DB	$02,$75,$00
				DB	$04,$50,$00
				DB	$06,$50,$00
				DB	$09,$00,$00
				DB	$11,$50,$00
				DB	$15,$00,$00
				DB	$19,$00,$00
				DB	$25,$00,$00
				DB	$30,$00,$00
				DB	$36,$00,$00
				DB	$42,$00,$00
				DB	$48,$00,$00
				DB	$50,$00,$00
LR				DB	$00,$00,$40
				DB	$00,$04,$00
				DB	$00,$15,$00
				DB	$00,$40,$00
				DB	$00,$80,$00
				DB	$01,$20,$00
				DB	$02,$00,$00
				DB	$03,$50,$00
				DB	$05,$50,$00
				DB	$09,$00,$00
				DB	$13,$00,$00
				DB	$18,$00,$00
				DB	$23,$00,$00
				DB	$30,$00,$00
				DB	$38,$50,$00
				DB	$50,$00,$00
PRO				DB	$00,$00,$20
				DB	$00,$00,$80
				DB	$00,$01,$20
				DB	$00,$01,$70
				DB	$00,$02,$30
				DB	$00,$02,$90
				DB	$00,$03,$70
				DB	$00,$07,$50
				DB	$00,$20,$00
				DB	$00,$40,$00
				DB	$00,$60,$00
				DB	$01,$00,$00
				DB	$01,$75,$00
				DB	$02,$75,$00
				DB	$04,$50,$00
				DB	$06,$50,$00
				DB	$09,$00,$00
				DB	$11,$50,$00
				DB	$15,$00,$00
				DB	$19,$00,$00
				DB	$25,$00,$00
AUT				DB	$00,$00,$00
				DB	$00,$50,$00
