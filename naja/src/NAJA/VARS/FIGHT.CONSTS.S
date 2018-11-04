*-------------------------------

bytesperalien	=	64
bytespermons	=	20
bytespergroup	=	19

maxfind			=	5				;max equipment found

*-------------------------------

				DUMMY	0
aName			DS	16

aSwings			DS	1
aSwingDamage	DS	2
aBlasts			DS	1
aBlastDamage	DS	2
aSwingSquares	DS	1
aInflicting		DS	1
aStatInflictd	DS	1
				DS	1
aFightParams	DS	5
aBlastSource	DS	1

aUpperReflex	DS	1
aLowerReflex	DS	1				;aUpperReflex+1
				DS	1
aDamage			DS	2
aElShield		DS	1
aPhShield		DS	1				;aElShield+1
				DS	1
				DS	1
				DS	1
aExperience		DS	2
aCredit			DS	2				;aExperience+3
aFindingOdds	DS	1				;aCredit+3
aFindingGroup	DS	1				;aFindingOdds+1

aSuprised		DS	1
aSuprising		DS	1
aIdentified		DS	1
aJammed			DS	1
aImmobilized	DS	1
				DS	1
				DS	1
				DS	1
aSusepts		DS	3
aSwingWords		DS	3
aRetreatOdds	DS	1
aAdvanceOdds	DS	1
				DEND

*-------------------------------

monUPREF		=	0
monLOREF		=	1
monSHOTS		=	2
monSWINGS		=	3
monDAMAGE		=	4				;5
monELSHIELD		=	6
monPHSHIELD		=	7
monPOSITION		=	8
monNUMBER		=	9
monSTATUS		=	10
monSTATCOUNT	=	11				;12
monCMDCOUNT		=	13
monCRNTCMD		=	monCMDCOUNT+1	;14,15
monLASTCMD		=	monCRNTCMD+2	;16,17
monTOPVIEW		=	18
monFLAGS		=	19				;A0000000
									;A = running bit

*-------------------------------

face1			=	%00100000
face2			=	%00010000
face3			=	%00001000
face4			=	%00000100
face5			=	%00000010
face6			=	%00000001

shell1			=	%00010000
shell2			=	%00001000
shell3			=	%00000100
shell4			=	%00000010
shell5			=	%00000001

groupA			=	%10000000
groupB			=	%01000000
groupC			=	%00100000
groupD			=	%00010000
groupE			=	%00001000
groupF			=	%00000100
groupG			=	%00000010
groupH			=	%00000001

*-------------------------------

cmdSWING		=	0
cmdSHOOT		=	1
cmdENERGY		=	2
cmdTHROW		=	3
cmdUSE			=	4
*
cmdAIM			=	6
cmdMOVE			=	7
cmdIDENTIFY		=	8
cmdEXCHANGE		=	9
cmdPARRY		=	10
cmdRUN			=	11
cmdTESSERACT	=	12
cmdBACK1		=	15
cmdREDO			=	16
cmdOTHER		=	17

*-------------------------------

loloTime		=	0
upTime			=	1
upupTime		=	2
uploTime		=	3
allTime			=	4
oneTime			=	5
noTime			=	6

timeSWING		=	upTime
timeSHOOT		=	timeSWING		;Must be the same as timeSWING
timeAimSHOOT	=	upupTime
timeENERGY		=	upTime
timeAimENERGY	=	upupTime
timeTHROW		=	uploTime
timeUSE			=	upupTime
*
timeAIM			=	upTime
timeMOVE		=	loloTime
timeIDENTIFY	=	upupTime		;????
timeEXCHANGE	=	upupTime
timePARRY		=	oneTime
timeRUN			=	loloTime
timeTESSERACT	=	upTime

*-------------------------------

			do ORIGINAL
S_PICDATA		=	$0020

S_DATA12		=	$0000
S_DATA17		=	$0000
S_DATA13		=	$0000
S_DATA15		=	$0000
S_DATA11		=	$0000
S_DATA9			=	$0000
S_SCODE12		=	$0140			;TEMP/GARBAGE VALUE
			else
S_PICDATA		=	$0000

S_DATA12		=	$00F0
S_DATA17		=	S_DATA12
S_DATA15		=	S_DATA17+$1C
S_DATA13		=	S_DATA12
S_DATA11		=	S_DATA13+$10
S_DATA9			=	S_DATA13+$21

S_SCODE12		=	$0140			;TEMP VALUE
			fin

Xmonsprd		=	%10000000
Xchrsprd		=	%01000000
Xalien1			=	%00100000
Xalien2			=	%00010000
Xalien3			=	%00001000
Xhmany1			=	%00000100
Xhmany2			=	%00000010
Xhmany3			=	%00000001

Xpicture		=	%10000000
Xloaddata1		=	%01000000
Xloaddata2		=	%00100000
Xloaddata3		=	%00010000

*-------------------------------

				DUMMY	$8000		;(Through $9FFF)
DATA_BUFR		DS	$300			;* These must
RARITY			DS	$100			;*   begin on
PICT_BUFR							;*   page
ALIEN_BUFR		DS	$300			;*   boundries
SCODE_HEADR		DS	$200
				DS	$1700
				DEND

				DUMMY	$B100

MONSTR0			DS	25*20			;Must be on page boundary
CHARXY			DS	7
MNAME_TABLE		DS	5
TAKEN_COUNT		DS	1
TAKEN_ITEMS		DS	20
COMMAND			DS	7*32
ENTABLE			DS	32
DURATION_TABL	DS	14


TV_COUNTS		DB	0,0,0			;| Number of topviews in lists
TV_ANIMATED		DB	0,0,0			;| BMI true if animated
TV_WIDTHS		DB	0,0,0			;| In grid squares
TV_HEIGHTS		DB	0,0,0			;| In grid squares
TV_TYPES		DB	0,0,0			;|
TV_SEQUENCES	DB	0,0,0			;|
TV_REPEATS		DB	0,0,0			;|
TV_SPEEDS		DB	0,0,0			;|

TVIEW_HOLDPTR	DW	0
TVIEW_DIMENS	DB	0
TVIEW_OFFSET	DB	0

TVIEW_COUNT		DB	0				;|
TVIEW_ANIMATE	DB	0				;|
TVIEW_WIDTH		DB	0				;|
TVIEW_HEIGHT	DB	0				;|
TVIEW_TYPE		DB	0				;|
TVIEW_SEQUEN	DB	0				;|
TVIEW_REPEAT	DB	0				;|
TVIEW_SPEED		DB	0				;|

SCODE_PRESENT	DB	0,0,0
SCODE_HOLDPTR	DW	0

				DS	\

heaplength		=	6				;pages
ALIEN_HEAP		DS	heaplength*$100

				DEND


*---------------------------------------------------------------
* HEAP STRUCTURE
*---------------------------------------------------------------
* ALIEN_HEAP DW ALOFF2-ALIEN_HEAP ;+ offset to next alien data
*               {ALIEN #0}
* ALOFF2     DW ALOFF3-ALOFF2     ;+ offset to next alien data
*               {ALIEN #1}
* ALOFF3     DW AEND-ALOFF3       ;last offset
*               {ALIEN #2}
* AEND
*---------------------------------------------------------------

*-------------------------------
* ALIEN STRUCTURE
*-------------------------------
* ALIEN      DW DATA-ALIEN
*            DW TVIEWS-ALIEN
*            DW CODE-ALIEN
*
* DATA       {ALIEN DATA}
* TVIEWS     {TOPVIEW GROUP}
* CODE       {SPECIALS CODE}
*-------------------------------

*-------------------------------
* ALIEN DATA STRUCTURE
*-------------------------------
* ALIEN_DATA DS 64
*-------------------------------

*--------------------------------------------------------------
* TOP VIEW GROUP STRUCTURE
*--------------------------------------------------------------
* TVIEWGROUP DW TVOFF1-TVIEWGROUP ;offset to next tview offset
*               {TOPVIEW #0}
* TVOFF1     DW TVOFF2-TVOFF1     ;offset to next tview offset
*               {TOPVIEW #1}
* TVOFF2     DW TVEND-TVOFF2      ;offset to next tview offset
*               {TOPVIEW #2}
* TVEND
*--------------------------------------------------------------

*-------------------------------------------
* TOPVIEW STRUCTURE
*-------------------------------------------
* +0 (byte)  top view dimensions (in chars)
* +1 (byte)  topview offset
* +2... topview data
*-------------------------------------------

*-------------------------------
* CODE STRUCTURE
*-------------------------------
* CODE       DW PRE_ROUND-CODE
*            DW PRE_PICK-CODE
*            DW PRE_ATTACK-CODE
*            DW PRE_ATTACKED-CODE
*            DW PRE_DEATH-CODE
*
* PRE_ROUND  RTS
* PRE_PICK   RTS
* PRE_ATTACK RTS
* PRE_ATTACKED RTS
* PRE_DEATH  RTS
*-------------------------------
