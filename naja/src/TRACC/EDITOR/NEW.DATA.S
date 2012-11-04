*-------------------------------

na				=	99

MAIN_LIST		DB	166
				DB	0,8
				Entry	tName;aName;na;NAME
				Entry	t0_255;aSwings;na;NUMBER_OF_SWINGS
				Entry	t0_9999;aSwingDamage;na;DAMAGE_PER_SWING
				Entry	t0_255;aBlasts;na;NUMBER_OF_BLASTS
				Entry	t0_9999;aBlastDamage;na;DAMAGE_PER_BLAST

				Entry	t0_99;aUpperReflex;na;UPPER_REFLEX
				Entry	t0_99;aLowerReflex;na;LOWER_REFLEX
				Entry	t0_9999;aDamage;na;DAMAGE
				Entry	t0_99;aElShield;na;ELECTRICAL_SHIELDING
				Entry	t0_99;aPhShield;na;PHYSICAL_SHIELDING

				Entry	t0_9999;aExperience;na;EXPERIENCE
				Entry	t0_9999;aCredit;na;CREDIT

				Entry	t0_99;aRetreatOdds;na;GROUP_RETREAT_ODDS
				Entry	t0_99;aAdvanceOdds;na;GROUP_ADVANCE_ODDS

				Transfer	FIGHT_LIST;FIGHTING_CHARACTERISTICS
				Transfer	ABILITY_LIST;ABILITIES
				Transfer	SUSCEPT_LIST;SUSCEPTABLITIES
				Transfer	SWING_LIST;SWING_WORDS
				Transfer	FINDING_LIST;EQUIPMENT_FOUND
				Transfer	SQUARE_LIST;SWING_SQUARES
				Transfer	BLAST_LIST;BLAST_SOURCE
				Transfer	STATUS_LIST;STATUS_INFLICTING
				DB	-1

*-------------------------------

BLAST_LIST
				DB	166
				DB	30,8
				Entry	tBlastY;aBlastSource;0;BLAST_SOURCE_Y
				Entry	tBlastX;aBlastSource;na;BLAST_SOURCE_X
				DB	-1

*-------------------------------

SQUARE_LIST
				DB	100
				DB	10,8
				Entry	tYesNo;aSwingSquares;1;L
				Entry	tYesNo;aSwingSquares;2;X
				Entry	tYesNo;aSwingSquares;3;C
				Entry	tYesNo;aSwingSquares;4;C
				Entry	tYesNo;aSwingSquares;5;C
				Entry	tYesNo;aSwingSquares;6;C
				Entry	tYesNo;aSwingSquares;7;C
				DB	-1

*-------------------------------

FIGHT_LIST
				DB	207
				DB	15,8
				Entry	tfAttack;aFightParams+0;0;ATTACK_TYPE
				Entry	tYesNo;aFightParams+0;4;CAN_ONLY_SHOOT_FROM_FRONT_2
				Entry	tYesNo;aFightParams+0;5;USE_CHEAT_AIM

				Entry	tYesNo;aFightParams+1;0;USE_CHEAT_SWING
				Entry	tfRushDelay;aFightParams+1;na;FRONT_ROW_RUSH_DELAY

				Entry	tYesNo;aFightParams+2;0;RUN_WHEN_OUT_OF_ATTACKS
				Entry	tYesNo;aFightParams+2;1;AIM_MAINLY_AT_FRONT_2_ROWS
				Entry	tfPercentOf4;aFightParams+2;1;FIDGET_ODDS

				Entry	tfPercentOf4;aFightParams+3;0;BLOCKS_OTHER_ALIENS_SHOTS
				Entry	tfAim;aFightParams+3;na;AIM_ACCURACY
				Entry	tfShots;aFightParams+3;3;SHOTS_FIRED_AT_A_TIME

				Entry	tfRunAfter;aFightParams+4;na;ALWAYS_RUN_AFTER_N_ROUNDS
				Entry	tfRunUntil;aFightParams+4;na;CANT_RUN_UNTIL_AFTER
				DB	-1

*-------------------------------

STATUS_LIST
				DB	167
				DB	30,8
				Entry	t0_99;aInflicting;na;INFLICTINGABILITY
				Entry	tIntensity;aStatInflictd;0;STATUS_INTENSITY
				Entry	tStatus;aStatInflictd;na;STATUS_INFLICTED
				DB	-1

*-------------------------------

FINDING_LIST
				DB	187
				DB	10,8
				Entry	t0_99;aFindingOdds;na;EQUIPMENT_FOUND_ODDS
				Entry	tYesNo;aFindingGroup;0;GROUP_A
				Entry	tYesNo;aFindingGroup;1;GROUP_B
				Entry	tYesNo;aFindingGroup;2;GROUP_C
				Entry	tYesNo;aFindingGroup;3;GROUP_D
				Entry	tYesNo;aFindingGroup;4;GROUP_E
				Entry	tYesNo;aFindingGroup;5;GROUP_F
				Entry	tYesNo;aFindingGroup;6;GROUP_G
				Entry	tYesNo;aFindingGroup;7;GROUP_H
				DB	-1

*-------------------------------

ABILITY_LIST
				DB	167
				DB	10,8
				Entry	t0_99;aSuprised;na;SUPRISABILITY
				Entry	t0_99;aSuprising;na;SUPRISINGABILITY
				Entry	t0_99;aIdentified;na;IDENTIFYABILITY
				Entry	t0_99;aJammed;na;JAMMABILITY
				Entry	t0_99;aImmobilized;na;IMMOBILIZABILITY
				DB	-1

*-------------------------------

SUSCEPT_LIST
				DB	130
				DB	30,8
				Entry	tSomeVery;aSusepts+0;0;LIGHT
				Entry	tSomeVery;aSusepts+0;1;HEAT
				Entry	tSomeVery;aSusepts+0;2;ELECTRICAL
				Entry	tSomeVery;aSusepts+0;3;PHYSICAL
				Entry	tSomeVery;aSusepts+1;0;DISINTEGRATOR
				Entry	tSomeVery;aSusepts+1;1;GRENADE
				Entry	tSomeVery;aSusepts+1;2;IMAGE_GENERATOR
				Entry	tSize;aSusepts+1;3;ALIEN_SIZE
				DB	-1

*-------------------------------

SWING_LIST
				DB	120
				DB	10,8
				Entry	tYesNo;aSwingWords+0;0;SWINGS
				Entry	tYesNo;aSwingWords+0;1;STRIKES
				Entry	tYesNo;aSwingWords+0;2;POKES
				Entry	tYesNo;aSwingWords+0;3;SCRATCHES
				Entry	tYesNo;aSwingWords+0;4;CLAWS
				Entry	tYesNo;aSwingWords+0;5;STABS
				Entry	tYesNo;aSwingWords+0;6;THRUSTS
				Entry	tYesNo;aSwingWords+0;7;HACKS
				Entry	tYesNo;aSwingWords+1;0;SLASHES
				Entry	tYesNo;aSwingWords+1;1;BITES
				Entry	tYesNo;aSwingWords+1;2;SNIPS
				Entry	tYesNo;aSwingWords+1;3;PUNCHES
				Entry	tYesNo;aSwingWords+1;4;GRABS
				Entry	tYesNo;aSwingWords+1;5;REACHES
				Entry	tYesNo;aSwingWords+1;6;KICKS
				Entry	tYesNo;aSwingWords+1;7;WHIPS
				Entry	tYesNo;aSwingWords+2;0;SWOOPS
				Entry	tYesNo;aSwingWords+2;1;SPRAYS
				Entry	tYesNo;aSwingWords+2;2;LUNGES
				Entry	tYesNo;aSwingWords+2;3;JUMPS
				DB	-1

*-------------------------------
