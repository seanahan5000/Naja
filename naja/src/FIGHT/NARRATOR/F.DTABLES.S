*************
				DUMMY	$4000

*-------------------------------------
* MASTER_CGRID
*          $FF = empty square
*   $00 to $06 = characters
*   $80 to $86 = images of characters
*-------------------------------------
MASTER_CGRID	DS	25

AGDEAD			DS	1
				DS	1
XPLUS4			DS	1
YPLUS4			DS	1
XMINUS4			DS	1
YMINUS4			DS	1
				DEND
*************
				DUMMY	$4400

*------------------------------------------------------
* MASTER_MGRID
*          $FF = empty square
*   $40 to $58 = Actual monster positions
*   $00 to $18 = Additional space taken up by monsters
*------------------------------------------------------
MASTER_MGRID	DS	25

				DEND
*************
				DUMMY	$4800
* OPEN
**** these are only for debugging
deMPLIER		DS	2				;param to MULTIPLY_BASE
deMBUFFER		DS	4				;init value of BASE
deMBASE			DS	4				;final value of BASE
deAIMRATE		DS	1				;Result from AIM_RATING
deDISTSRC1		DS	1				;param1 to DISTANCER
deDISTSRC2		DS	1				;param2 to DISTANCER
deDISTANCE		DS	1				;Result from DISTANCER
deIDODDS		DS	1				;Result of ID_ODDS
				DEND
*************
				DUMMY	$4C00
DEAD_XY			DS	1
FBYTE1			DS	1
FBYTE2			DS	1
FBYTE3			DS	1
FBYTE4			DS	1
FBYTE5			DS	1
AUX_MGRID		DS	25
				DEND
*************
				DUMMY	$5000
OLD_CGRID		DS	25
				DEND
*************
				DUMMY	$5400
ENHIT			DS	25
				DEND
*************
				DUMMY	$5800
XCOUNTR			DS	1
YCOUNTR			DS	1
SCOUNTR			DS	1
MCOUNTR			DS	1
				DEND
*************
				DUMMY	$5C00
				DEND
*************
				DUMMY	$4080
SQUARE_HIT		DS	1
RICOCHETS		DS	1
BLOCKED			DS	1
ABSORBED		DS	1
SWING_TYPE		DS	1				;Used in SWING
HANDS_USED		DS	1				;Used in SWING
WEAPON_TYPE		DS	1				;Used in SWING
SWING_DIRECTN	DS	1				;Used in SWING
				DEND
*************
				DUMMY	$4480
*** OPEN
				DEND
*************
				DUMMY	$4880
COMNUMS			DS	7
IMAGENS			DS	7
				DEND
*************
				DUMMY	$4C80
				DS	14
CTIME_COUNTS	DS	7
				DEND
*************
				DUMMY	$5080
PECKS			DS	33				;25+7+1
				DEND
*************
				DUMMY	$5480
VALUES			DS	25
				DEND
*************
				DUMMY	$5880
TEMPCHAR_XY		DS	7
TIMES			DS	6
				DEND
*************
				DUMMY	$5C80
*----------------------------------
* $00 = Don't move (n/a for chars)
* $7F = Retreat
* $FF = Advance
*----------------------------------
CHAR_ADVFLAG	DS	1
MONS_ADVFLAG	DS	1

COFFSET			DS	1
MOFFSET			DS	1
CHAR_ODDS		DS	1
MONS_ODDS		DS	1
CHAR_GAP		DS	1
MONS_GAP		DS	1

CSRC_TOP		DS	1
CDST_TOP		DS	1
OLD_CDST_TOP	DS	1
DIVIDER_Y		DS	1
MSRC_BOT		DS	1
MDST_BOT		DS	1
OLD_MDST_BOT	DS	1

CHANGE_FLAG		DS	1

C_HEADSTART		DS	1
M_HEADSTART		DS	1

C_DELTA			DS	1
M_DELTA			DS	1
				DEND
