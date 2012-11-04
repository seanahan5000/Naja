*------------------------------*
*                              *
*        Find Equipment        *
*                              *
*            3/8/87            *
*                              *
*------------------------------*
				LST	OFF
				TR	ON

				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/CAMP.VARS
				PUT	/NAJA/VARS/THALL.VARS

LINENUM			EQU	$00
COLUMN			EQU	$02

Sword			=	0
Pistol			=	1
Rifle			=	2
Helmet			=	3
DCard			=	4
Shield			=	5
Cmpres			=	6
RSword			=	7
RBlast			=	8
CompCube		=	9

All				=	%00111111

				ORG	$9800

NORMAL_FIND		JSR	MOVETO2
				LDA	#$40
				STA	PAGE
				JSR	PICNPUT
FORCE_FIND		ASL
				TAY
				LDA	PICKS,Y
				STA	TBLPNTL
				LDA	PICKS+1,Y
				STA	TBLPNTH
				JSR	EXPANDR
SPECIAL_FIND	STA	SCNDARY
				JSR	CLEAR1
				LDA	#$20
				STA	PAGE
				LDA	#GREEN
				STA	COLOR
				LDA	#<LINE0
				STA	POINTL
				LDA	#>LINE0
				STA	POINTH
				JSR	LINEOUT
				LDA	#$02
				STA	YPNT
				LDA	#$42
				STA	SELECT
				JSR	HEADER
				LDA	#$00
				STA	COUNT
GRLOOP1			TAY
				LDX	FYPOINTS,Y
				STX	YPNT
				JSR	STATLIN
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	GRLOOP1
				JSR	EQUIP1
				LDA	TEXTBUF
				LDX	#$04
GRLOOP2			CMP	VOWELS,X
				BEQ	ANOKAY
				DEX
				BPL	GRLOOP2
				LDA	#$EE
				STA	NOAMOD
ANOKAY			LDA	#<TEXT0
				STA	POINTL
				LDA	#>TEXT0
				STA	POINTH
				JSR	TEXTOUT
				JSR	EQUIP1
				LDX	#$0F
GRLOOP3			LDA	TEXTBUF,X
				CMP	#$0A
				BNE	GRSKIP1
				DEX
				BPL	GRLOOP3
GRSKIP1			LDA	#$2D
				STA	TEXTBUF+1,X
				LDA	#$8D
				STA	TEXTBUF+2,X
				JSR	LINE2
				JSR	FLIPPER
				JSR	RESET_CHRLIST
				JSR	CSCAN_PUTABLE
				LDA	#$00
				STA	CHAR_LIST+7
				BIT	UNSTROB
				LDA	#$40
				STA	PAGE
				LDX	#<:FIND_DEF
				LDY	#>:FIND_DEF
				JSR	INIT_CURSOR
				JSR	GETKEY
				LDA	CURSOR
				CMP	#$07
				BEQ	:SKIPA
				JSR	POINTIT
				JSR	RESET_EQLIST
				JSR	ESCAN_PUTABLE
				LDA	CORESPS,X
				TAY
				LDX	#$00
:LOOP1			LDA	ETABLE,X
				STA	(CHARDL),Y
				INY
				INX
				CPX	#$04
				BNE	:LOOP1
				JSR	CALC_ALL
				LDA	ETABLE+1
				CMP	#$F3			;Must be $F3 in data tables
				BNE	:SKIPA
				DEC	LOST_CHARS
:SKIPA			JSR	CLEAR1
				LDA	#$20
				STA	PAGE
				LDA	#WHITE1
				STA	COLOR
				JSR	NOSCAN
				STA	PRIMARY
				JMP	RDKEY

*-------------------------------
:FIND_DEF		DB	$07
				DB	$00
				DW	:FIND_CURS

:FIND_CURS		LDX	CURSOR
				LDY	FYPOINTS,X
				LDX	#3
				JMP	ARROWER

FYPOINTS		DFB	$0C,$14,$1C
				DFB	$24,$2C,$34
				DFB	$3C,$44
*-------------------------------

VOWELS			DFB	$0B,$0F,$13
				DFB	$19,$1F

PICNPUT			LDY	SHELL
				LDA	GROUPS_LOW-1,Y
				STA	POINTL
				LDA	GROUPS_HIGH-1,Y
				STA	POINTH
:LOOP1			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$0F
				ASL
				STA	TEMP
				ASL
				ADC	TEMP			;Carry assumed clear
				TAY
				LDA	(POINTL),Y		;Face flag byte
				LDX	FACE
				AND	FAMASKS-1,X
				BEQ	:LOOP1
				INY
				LDA	(POINTL),Y
				CMP	#CompCube
				BNE	:SKIPA
				LDX	LOST_CHARS
				BEQ	:LOOP1
:SKIPA			PHA
				LDX	#$00
:LOOP2			INY
				LDA	(POINTL),Y
				STA	ETABLE,X
				INX
				CPX	#$04
				BNE	:LOOP2
				PLA
				RTS

FAMASKS			DFB	%00100000		;Face 1
				DFB	%00010000		;     2
				DFB	%00001000		;     3
				DFB	%00000100		;     4
				DFB	%00000010		;     5
				DFB	%00000001		;     6

PICKS			DW	SWORD			;0
				DW	PISTOL			;1
				DW	RIFLE			;2
				DW	HELMET			;3
				DW	CARD			;4
				DW	SHIELD			;5
				DW	COMPRES			;6
				DW	RSWORD			;7
				DW	RBLASTR			;8
				DW	COMPCUBE		;9

FLIPPER			LDA	#$00
				STA	COLUMN
				STA	LINENUM
FLOOP0			LDY	COLUMN
				LDX	LINENUM
FLOOP1			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDA	(SCREENL),Y
				PHA
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				PLA
				STA	(DESTINL),Y
				INX	
				CPY	#$08
				BCS	FSKIP1
				CPX	#$4E
				BEQ	FSKIP2
FSKIP1			CPX	#$58
				BEQ	FSKIP2
				DEY
				BMI	FSKIP2
				CPY	#$08
				BCS	FLOOP1
				CPX	#$4E
				BCC	FLOOP1
FSKIP2			LDA	COLUMN
				CMP	#$27
				BNE	FSKIP4	
				LDA	LINENUM
				CMP	#$57
				BEQ	FOUT
				INC	LINENUM	
				BNE	FLOOP0
FSKIP4			INC	COLUMN	
				BNE	FLOOP0
FOUT			RTS

LINE0			DFB	$00,$01,$0A
				DFB	$00,$01,$4C
				DFB	$00,$39,$4C
				DFB	$00,$39,$56
				DFB	$01,$15,$56
				DFB	$01,$15,$00
				DFB	$00,$01,$00
				DFB	$00,$01,$0A
				DFB	$01,$15,$0A
				DFB	$FE
				DFB	$00,$39,$4C
				DFB	$00,$39,$44
				DFB	$01,$15,$44
				DFB	$FF

TEXT0			DFB	$02,$02,$44
				DFB	$18,$19,$0C
				DFB	$19,$0E,$23
				DFB	$8D,$09,$00
				DFB	$4E,$21,$12
				DFB	$19,$17,$0A
				DFB	$0E,$19,$0A
				DFB	$23,$19,$1F
				DFB	$0A,$21,$0B
				DFB	$18,$1E,$0A
				DFB	$1E,$19,$0A
				DFB	$11,$13,$20
				DFB	$0F,$0A,$13
				DFB	$1E,$0A,$1E
				DFB	$19,$33,$8D
				DFB	$09,$00,$46
				DFB	$23,$19,$1F
				DFB	$0A,$12,$0B
				DFB	$20,$0F,$0A
				DFB	$10,$19,$1F
				DFB	$18,$0E,$0A
				DFB	$0B
NOAMOD			DFB	$18,$0A
				DFB	$8D,$FF

				PUT	FIND.DATA
				PUT	FIND.PICTURES
				SAV	FINDMENT
