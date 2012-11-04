susLIGHT		=	0
susHEAT			=	1
susELECTRICAL	=	2
susPHYSICAL		=	3
susDISINTEG		=	4
susGRENADE		=	5
susIMAGEN		=	6
susSIZE			=	7

** bits of monFLAGS byte
runningbit		=	%10000000
runtestedbit	=	%01000000

lastTextCol		=	29

SCRATCH			=	$00
COUNTER			=	$01

*** Short term variables
WIDTH			=	ZBLOCK_28+0		;Topviews
HEIGHT			=	ZBLOCK_28+1		;Topviews
*
*
*
*
*
*

*** Narrator term varibles
POINTER			=	ZBLOCK_30+0
THROUGH			=	ZBLOCK_30+1
*
*
*
*
*
*

ENTYPE			=	$38				;ONLY IN ENERGY??
*
COMPNTR			=	$3A
*
*
*
*
*

TOTAL_DAMAGEH	=	ZBLOCK_80+0
TOTAL_DAMAGEL	=	ZBLOCK_80+1
EL_DAMAGEH		=	ZBLOCK_80+2
EL_DAMAGEL		=	ZBLOCK_80+3
PH_DAMAGEH		=	ZBLOCK_80+4
PH_DAMAGEL		=	ZBLOCK_80+5
ENERGY_H		=	ZBLOCK_80+6
ENERGY_L		=	ZBLOCK_80+7
