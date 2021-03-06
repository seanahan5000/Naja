OFFSET			DFB	$00,OPT1-OPT0,OPT2-OPT0
				DFB	OPT3-OPT0,OPT4-OPT0,OPT5-OPT0
				DFB	OPT6-OPT0,OPT7-OPT0,OPT8-OPT0
				DFB	OPT9-OPT0,OPTA-OPT0,OPTB-OPT0
				DFB	OPTC-OPT0,OPTD-OPT0,OPTE-OPT0
				DFB	OPTF-OPT0,OPT10-OPT0,OPT11-OPT0
				DFB	OPT12-OPT0,OPT13-OPT0,OPT14-OPT0

*-------------------------------

LINER			TYA
				ASL	A
				TAY
				LDA	LINES,Y	
				STA	POINTL
				LDA	LINES+1,Y	
				STA	POINTH
				JMP	LINEOUT

LINES			DW	BOX1	
				DW	RLINE	
				DW	BOXA
				DW	DIVIDE1
				DW	JLINE	
				DW	DIVID1B
				DW	DIVID2B
				DW	UNDLINE
				DW	BIGCANC
				DW	SMLCANC
				DW	DIVIDE3
				DW	DIVIDE4

*-------------------------------

TEXTER			TYA
				ASL	A
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT

TEXTS			DW	TUNITS
				DW	DELAY1
				DW	DELAY2
				DW	STHEADR
				DW	SEEWHOS
				DW	STOLEAV
				DW	FINTEXT
				DW	SELMOVE
				DW	BONE			;$08
				DW	ARESURE
				DW	HOWLONG
				DW	CANTEXT	
				DW	LEFRGHT
				DW	UPLWLR
				DW	PICHAND
				DW	SWNGTYP
				DW	0				;$10
				DW	0
				DW	0
				DW	BOTLABL
				DW	TEXT14
				DW	TEXT15
				DW	0
				DW	0
				DW	AIMAT			;$18
				DW	0
				DW	TEXT1A
				DW	TEXT1B
				DW	TEXT1C
				DW	TEXT1D
				DW	TEXT1E
				DW	TOAIM
				DW	UPPER			;$20
				DW	LOWER
				DW	LEFT
				DW	RIGHT
				DW	LEFRIGH
				DW	SELUL
				DW	SELLR
				DW	OFENER
				DW	THOWMUC			;$28
				DW	0
				DW	0
				DW	0
				DW	0
				DW	0
				DW	BAREH
				DW	0
				DW	CFIRM			;$30
				DW	SLECT
				DW	ENRTYPE
				DW	CONOBJ
				DW	TUSED
				DW	THROWN
				DW	TWHICH
				DW	KWREDO
				DW	ROBHNDS			;$38
				DW	EXCHFRO
				DW	EXCHTO
				DW	PVERIFY
				DW	EXCHOF
				DW	REDPLAN
				DW	IDWANT
				DW	IDWHICH
				DW	YOUHAVE			;$40
				DW	THEATTA
				DW	THEATTS
				DW	ELEMENT

*-------------------------------

OPT0			USR	(SWING)
OPT1			USR	(SHOOT)
OPT2			USR	(ENERGY)
OPT3			USR	(THROW)
OPT4			USR	(USE)
OPT5			DB	$8D
OPT6			DB	$8D				;DUMMY
OPT7			USR	(MOVE)
OPT8			USR	(IDENTIFY)
OPT9			USR	(EXCHANGE)
OPTA			USR	(PARRY)
OPTB			USR	(RUN)
OPTC			USR	(TESSERACT)
OPTD			DB	$8D				;DUMMY
OPTE			USR	(END)
OPTF			USR	(BACK1)
OPT10			USR	(REDO)
OPT11			USR	(OTHER)
OPT12			USR	(FLIP)
OPT13			USR	(DELAY)
OPT14			DB	$8D				;DUMMY

*-------------------------------

BOX1			DFB	$00,$01,$0A
				DFB	$00,$01,$00
				DFB	$01,$15,$00	
				DFB	$01,$15,$44
				DFB	$00,$01,$44
				DFB	$00,$01,$0A
				DFB	$01,$15,$0A
				DFB	$FF

RLINE			DFB	$01,$05,$BE
				DFB	$01,$05,$B7
				DFB	$01,$14,$B7
				DFB	$FF

BOXA			DFB	$00,$59,$7F
				DFB	$01,$15,$7F	
				DFB	$01,$15,$47	
				DFB	$00,$59,$47
				DFB	$00,$59,$7F	
				DFB	$FF

DIVIDE1			DFB	$00,$A5,$48
				DFB	$00,$A5,$7E
				DFB	$FF

JLINE			DFB	$01,$06,$BF
				DFB	$01,$15,$BF
				DFB	$01,$15,$B8
				DFB	$FF

DIVID1B			DFB	$00,$A5,$80
				DFB	$00,$A5,$B7
				DFB	$01,$04,$B7
				DFB	$FF

DIVID2B			DFB	$00,$CB,$80
				DFB	$00,$CB,$B7
				DFB	$01,$04,$B7
				DFB	$FF

UNDLINE			DFB	$00,$9D,$9C
				DFB	$00,$CF,$9C
				DFB	$FE
				DFB	$00,$A1,$9E
				DFB	$00,$CB,$9E
				DFB	$FF

BIGCANC			DFB	$00,$E7,$BE
				DFB	$00,$E7,$B7
				DFB	$01,$04,$B7
				DFB	$FF

SMLCANC			DFB	$00,$E8,$BF	
				DFB	$01,$05,$BF	
				DFB	$01,$05,$B8	
				DFB	$FF

DIVIDE3			DFB	$00,$5F,$A3
				DFB	$01,$0F,$A3
				DFB	$FF

DIVIDE4			DFB	$00,$5F,$9B
				DFB	$01,$0F,$9B
				DFB	$FF

*-------------------------------

TUNITS			PLOTAT	208;76;(T.UNITS)
				PLOTAT	253;76;(=)+

DELAY1			PLOTAT	132;146;(MAXIMUM_DELAY:_99)
				PLOTAT	132;156;(CURRENT_DELAY:_)+

DELAY2			PLOTAT	156;166;(NEW_DELAY:_)+

STHEADR			PLOTAT	192;2;(IQ_ST_LR_UR_OR_)+

SEEWHOS			PLOTAT	114;152;(SEE_WHOSE_FIGHTING_PLAN?)+

STOLEAV			PLOTAT	107;152;(<SPACE>)
				PLOTAT	104;162;(TO_LEAVE)+

FINTEXT			PLOTAT	97;140;(ORDER_ENTRY_PHASE_IS_COMPLETE)
				PLOTAT	97;159;(WILL_YOU_A>CCEPT_THESE_ORDERS)
				PLOTAT	133;169;(OR_R>EDO_THEM?_)+

SELMOVE			PLOTAT	108;132;(SELECT_DESTINATION_SQUARE)
				PLOTAT	126;180;(L>EAVE_MOVE_COMMAND)+

BONE			PLOTAT	132;171;(B>ACK_ONE_COMMAND)+

ARESURE			PLOTAT	159;147;(>>REDO<<)
				PLOTAT	114;165;(PRESS_<SPACE>_TO_VERIFY)+

HOWLONG			PLOTAT	102;150;(PARRY_FOR_HOW_MANY_T.UNITS?)
				PLOTAT	138;162;(<MAXIMUM:_)+

CANTEXT			PLOTAT	235;185;(C>ANCEL)+

LEFRGHT			PLOTAT	111;146;(LEFT:)
				PLOTAT	105;154;(RIGHT:)+

UPLWLR			PLOTAT	123;146;(UL:)
				PLOTAT	123;154;(UR:)
				PLOTAT	123;162;(LL:)
				PLOTAT	123;170;(LR:)+

PICHAND			PLOTAT	111;133;(SWING_WITH_WHICH_HAND/S?)+

SWNGTYP			PLOTAT	111;134;(USE_WHICH_TYPE_OF_SWING?)
				PLOTAT	150;147;(HORIZONTAL)
				PLOTAT	150;157;(VERTICAL)
				PLOTAT	150;167;(THRUST)+

BOTLABL			PLOTAT	102;166;(HAND/S:)
				PLOTAT	102;174;(WEAPON:)
				PLOTAT	102;182;(ENERGY:)+

TEXT14			PLOTAT	114;142;(THRUST_AT_WHICH_SQUARE?)+

TEXT15			PLOTAT	117;142;(SWING_AT_WHICH_SQUARE?)+

AIMAT			PLOTAT	123;142;(AIM_AT_WHICH_SQUARE?)+

TEXT1A			PLOTAT	123;132;(FIRE_HOW_MANY_TIMES?)
				PLOTAT	131;143;(=)
				PLOTAT	147;143;(OF_SHOTS:)+

TEXT1B			PLOTAT	129;152;(ENERGY_USED:)+

TEXT1C			PLOTAT	120;132;(SWING_HOW_MANY_TIMES?)
				PLOTAT	125;143;(=)
				PLOTAT	141;143;(OF_SWINGS:)+

TEXT1D			PLOTAT	120;132;(HEAL_HOW_MUCH_DAMAGE?)
				PLOTAT	117;143;(DAMAGE_HEALED:)+

TEXT1E			PLOTAT	114;137;(SELECT_SQUARE_TO_DIRECT)
				PLOTAT	132;146;(TREATMENT_TOWARDS)+

TOAIM			PLOTAT	105;133;(CONFIRM_WEAPON_TO_BE_AIMED)+

UPPER			PLOTAT	150;0;(UPPER_)+

LOWER			PLOTAT	150;0;(LOWER_)+

LEFT			PLOTAT	0;0;(LEFT)+

RIGHT			PLOTAT	0;0;(RIGHT)+

LEFRIGH			PLOTAT	0;0;(LEFT/RIGHT)+

SELUL			PLOTAT	111;146;(SELECT_UPPER-LEFT_CORNER)+

SELLR			PLOTAT	108;146;(SELECT_LOWER-RIGHT_CORNER)+

OFENER			PLOTAT	120;156;(OF_ENERGY_STRIKE_ZONE)+

THOWMUC			PLOTAT	120;135;(EMIT_HOW_MUCH_ENERGY?)
				PLOTAT	129;153;(PER_SQUARE:)
				PLOTAT	159;163;(TOTAL:)+

BAREH			PLOTAT	150;174;(<BARE_HAND>______<1>)+

CFIRM			PLOTAT	1;133;(CONFIRM)+

SLECT			PLOTAT	1;133;(_SELECT)+

ENRTYPE			PLOTAT	105;134;(EMIT_WHICH_TYPE_OF_ENERGY?)
				PLOTAT	150;147;(ELECTRICAL)
				PLOTAT	150;157;(HEAT)
				PLOTAT	150;167;(LIGHT)+

CONOBJ			PLOTAT	102;133;(_CONFIRM_OBJECT_TO_BE)+

TUSED			PLOTAT	234;133;(USED)+

THROWN			PLOTAT	228;133;(THROWN)+

TWHICH			PLOTAT	96;142;(THROW_OBJECT_TO_WHICH_SQUARE?)+

KWREDO			PLOTAT	124;139;(DO_YOU_WANT_TO_REDO)
				PLOTAT	136;153;(THE_ENTIRE_GROUP)
				PLOTAT	136;163;(ONE_GROUP_MEMBER)
				PLOTAT	136;173;(CANCEL)+

ROBHNDS			PLOTAT	123;146;(_L:)
				PLOTAT	123;154;(__:)
				PLOTAT	123;162;(_R:)
				PLOTAT	123;170;(__:)+

EXCHFRO			PLOTAT	102;133;('EXCHANGE'_FROM_WHICH_HAND?)+

EXCHTO			PLOTAT	108;133;('EXCHANGE'_TO_WHICH_HAND?)+

PVERIFY			PLOTAT	114;131;(PRESS_<SPACE>_TO_VERIFY)+

EXCHOF			PLOTAT	120;139;(EXCHANGE_OF_EQUIPMENT)+

REDPLAN			PLOTAT	118;152;(REDO_WHOSE_FIGHT_PLAN?)+

IDWANT			PLOTAT	112;141;(DO_YOU_WANT_TO_I.D._SCAN)
				PLOTAT	138;154;(AN_INDIVIDUAL_SQUARE)
				PLOTAT	138;164;(THE_ENTIRE_AREA)+

IDWHICH			PLOTAT	115;152;(I.D._SCAN_WHICH_SQUARE?)+

YOUHAVE			PLOTAT	148;152;(YOU_HAVE_THE)+

THEATTA			PLOTAT	124;152;(THE_ATTACKER_HAS_THE)+

THEATTS			PLOTAT	118;152;(THE_ATTACKERS_HAVE_THE)+

ELEMENT			PLOTAT	130;161;(ELEMENT_OF_SUPRISE)+
