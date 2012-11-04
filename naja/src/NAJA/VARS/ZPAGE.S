SHIFT			=	$04
MAXTEXT			=	$05
XCOORD			=	$08
YCOORD			=	$09
TBLPNTL			=	$0D
DESTINL			=	$0D
TBLPNTH			=	$0E
DESTINH			=	$0E

POINTL			=	$12
POINTH			=	$13
HOLDIT			=	$16

*
*
*
*
*
*
SCREENL			=	$26
SCREENH			=	$27

*-------------------------------

ZBLOCK_28		=	$28				;Narrate, Command, Loader

ZBLOCK_30		=	$30				;Narrate, Command, Loader
ZBLOCK_38		=	$38				;Narrate, Command, Loader

ZBLOCK_40		=	$40				;Fight common
ZBLOCK_48		=	$48				;All fight

ZBLOCK_50		=	$50				;NCOM line plotter
ZBLOCK_58		=	$58				;NCOM line plotter
HCOLOR1			=	$50				;NCOM line plotter
HMASK			=	$51				;
DY				=	$52				;
QDRNT			=	$53				;
EL				=	$54				;
EH				=	$55				;
DXL				=	$56				;
DXH				=	$57				;
HNDX			=	$58				;
COLCNT			=	$59				;
YO				=	$5A				;
XOL				=	$5B				;
XOH				=	$5C				;
YCRD			=	$5D				;
COLFLG			=	$5E				;NCOM line plotter
*

ZBLOCK_60		=	$60				;All fight, (Alien Editor)
ZBLOCK_68		=	$68				;All fight, (Alien Editor)

DELAY_TIME		=	$70
DELAY_MODE		=	$71
CREDHI			=	$72
CREDMH			=	$73
CREDML			=	$74
CREDLO			=	$75
EXPHI			=	$76
EXPMH			=	$77
EXPML			=	$78
EXPLO			=	$79
KILLHI			=	$7A
KILLLO			=	$7B
*
*
*
*
*

ZBLOCK_80		=	$80				;Mothership areas, Narrate
ZBLOCK_88		=	$88				;Mothership areas

SELECT			=	$90
CHARDL			=	$91
CHARDH			=	$92
XPNT			=	$93
YPNT			=	$94
CURSOR			=	$95
COUNT			=	$96
*

ZBLOCK_98		=	$98

ZBLOCK_A0		=	$A0				;Mothership areas
ZBLOCK_A8		=	$A8				;Mothership areas

*
STRACK			=	$B1
SSTOREH			=	$B2
DISK_SIDE		=	$B3
*
*
TEMP			=	$B6				;$B7

ZBLOCK_B8		=	$B8				;Disk routines

ZBLOCK_C0		=	$C0				;Camp (main)
ZBLOCK_C8		=	$C8				;Camp (main)

ZBLOCK_D0		=	$D0
ZBLOCK_D8		=	$D8

*
*
*
*
COLOR			=	$E4
CAMP_HERE		=	$E5
PAGE			=	$E6
*

ZBLOCK_E8		=	$E8

SRANGE			=	$F0
XPOS			=	$F1
YPOS			=	$F2
DIRECTN			=	$F3
MXRANGE			=	$F4
BYTWID0			=	$F5
*
FACE			=	$F7

ZBLOCK_F8		=	$F8


* 'All fight' is used for passing values between:
*    Loader, Command, Narrator, Awarder, DeadGroup

* 'Fight common' are variables that Loader and Narrator
*    use but that don't have to be maintained throughout
*    the entire battle
