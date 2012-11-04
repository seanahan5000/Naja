CHAR_NUMBER		=	ZBLOCK_40+0
MONS_NUMBER		=	ZBLOCK_40+1
ALIEN_PTR		=	ZBLOCK_40+2		;+3
MONS_PTR		=	ZBLOCK_40+4		;+5
ZCOUNT			=	ZBLOCK_40+7

XCOUNT			=	ZBLOCK_48+0		;not needed between fight modes
YCOUNT			=	ZBLOCK_48+1		;not needed between fight modes
GROUP_STATUS	=	ZBLOCK_48+2
SUPRISED_FLAG	=	ZBLOCK_48+3		;mc000000
*
*
ROUND			=	ZBLOCK_48+6
MONS_TOTAL		=	ZBLOCK_48+7		;Was MNUMBER

DIRHOLD			=	$60
ALIEN1			=	$61
ALIEN2			=	$62
ALIEN3			=	$63
HMANY1			=	$64
HMANY2			=	$65
HMANY3			=	$66
ALTYPE1			=	$67
ALTYPE2			=	$68
ALTYPE3			=	$69
ALIENID			=	$6A
ATALLY			=	$6B
ENERGY_INDEX	=	$6C
ATOTAL1			=	$6D
ATOTAL2			=	$6E
ATOTAL3			=	$6F

*---------------------------------
* GROUP_STATUS
*   AB......
*
* A = Run away group
* B = All dead, broken, abandoned
*---------------------------------
