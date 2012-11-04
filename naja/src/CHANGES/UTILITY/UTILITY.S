				LST	OFF
				TR	ON

SCREENL			=	$00
SCREENH			=	$01
PTR1			=	$02				;$03
PAGE			=	$04

DATA_BUFFER		=	$6000

KEYBRD			=	$C000
UNSTROB			=	$C010
GRAPHICS		=	$C050
TEXT			=	$C051
NOMIXED			=	$C052
MIXED			=	$C053
PRIMARY			=	$C054
SCNDARY			=	$C055
HIRES			=	$C057
OPEN_APPLE		=	$C061

GREEN			=	$2A
VIOLET			=	$55
REPFLAG			=	$FE

				ORG	$0800

* U>NPACK
*   N>EW
*     1>
*     2>
*   O>LD
*     1>
*     2>

* S>AVE
*   P>ACKED
*     T>EXT
*     B>INARY
*   S>CREEN
*     1>
*     2>

* L>OAD
*   P>ACKED
*     N>EW
*     O>LD
*   S>CREEN
*     1>
*     2>

* P>ACK
*   A>UTO-SIZE
*   M>ANUAL-SIZE
*   I>MAGE
*     1>
*     2>
*   M>ASK


				STA	GRAPHICS
				STA	HIRES
				STA	PRIMARY
				STA	NOMIXED
				LDA	#$20
				STA	PAGE
DISPATCHER		BIT	UNSTROB
:1				LDA	KEYBRD
				BPL	:1
				BIT	UNSTROB
				LDX	#:END-:KEYS-1
:2				CMP	:KEYS,X
				BEQ	:3
				DEX
				BPL	:2
				BMI	:1
:3				TXA
				ASL
				TAX
				LDA	:TABLE+1,X
				PHA
				LDA	:TABLE,X
				PHA
				RTS

:KEYS			ASC	"LSPUCGDQ12"
:END

:TABLE			DW	LOAD-1
				DW	SAVE-1
				DW	PACK-1
				DW	UNPACK-1
				DW	CLEAR-1
				DW	GREENER-1
				DW	DISK-1
				DW	QUIT-1
				DW	PAGE1-1
				DW	PAGE2-1

LOAD
SAVE
				JMP	DISPATCHER

*-------------------------------

PACK			JSR	GET_MINBOX
				BCC	:1
				LDA	pTOPLINE
				STA	DATA_BUFFER
				LDA	pBOTLINE
				STA	DATA_BUFFER+1
				LDA	pLEFTCOL
				STA	DATA_BUFFER+2
				LDA	pRIGHTCOL
				STA	DATA_BUFFER+3
				JSR	PACK_MASK		;PACK_IMAGE
:1				JMP	DISPATCHER

*-------------------------------

UNPACK
				LDA	DATA_BUFFER
				STA	pTOPLINE
				LDA	DATA_BUFFER+1
				STA	pBOTLINE
				LDA	DATA_BUFFER+2
				STA	pLEFTCOL
				LDA	DATA_BUFFER+3
				STA	pRIGHTCOL

				LDX	#<DATA_BUFFER+4
				LDY	#>DATA_BUFFER+4
				JSR	UNPACK_MASK		;UNPACK_IMAGE
				JMP	DISPATCHER

*-------------------------------

QUIT			JSR	HOME
				STA	PRIMARY
				STA	TEXT
				RTS

*-------------------------------

PAGE1			LDA	#$20
				STA	PAGE
				STA	PRIMARY
				JMP	DISPATCHER

*-------------------------------

PAGE2			LDA	#$40
				STA	PAGE
				STA	SCNDARY
				JMP	DISPATCHER

*-------------------------------

SHOW_PAGE		LDA	PAGE
				CMP	#$40
				BEQ	:1
				STA	PRIMARY
				RTS
:1				STA	SCNDARY
				RTS

*-------------------------------

WHICH_SCREEN	LDX	#:END-:TEXT-1
:1				LDA	:TEXT,X
				STA	$06D0,X
				DEX
				BPL	:1
				BIT	UNSTROB
:2				LDA	KEYBRD
				BPL	:2
				BIT	UNSTROB
				LDX	#$20
				CMP	#"1"
				BEQ	:4
				CMP	#"2"
				BEQ	:3
				CLC
				RTS
:3				LDX	#$40
:4				STX	PAGE
				RTS

:TEXT			ASC	"Which screen (1 or 2) ?"
:END

*-------------------------------

PRE_TEXT		JSR	HOME
				STA	PRIMARY
				STA	MIXED
				RTS

*-------------------------------

POST_TEXT		STA	NOMIXED
				RTS

*-------------------------------

INPUT			LDA	#"_"
				STA	$06D0
				LDX	#0
				BIT	UNSTROB
:1				LDA	KEYBRD
				BPL	:1
				BIT	UNSTROB
				CMP	#$FF
				BEQ	:2
				CMP	#$8D
				BEQ	:3
				CMP	#$9B
				BEQ	:4
				CPX	#38
				BEQ	:1
				STA	$06D0,X
				LDA	#"_"
				STA	$06D1,X
				INX
				BNE	:1				;Always

:2				CPX	#0				;DELETE
				BEQ	:1
				LDA	#" "
				STA	$06D0,X
				DEX
				LDA	#"_"
				STA	$06D0,X
				BNE	:1				;Always

:3				LDA	#" "			;RETURN
				STA	$06D0,X
				TXA
				BEQ	:4
				SEC
				RTS

:4				CLC					;ESCAPE
				RTS

*-------------------------------

HOME			LDA	#" "
				LDX	#39
:1				STA	$400,X
				STA	$480,X
				STA	$500,X
				STA	$580,X
				STA	$600,X
				STA	$680,X
				STA	$700,X
				STA	$780,X
				STA	$428,X
				STA	$4A8,X
				STA	$528,X
				STA	$5A8,X
				STA	$628,X
				STA	$6A8,X
				STA	$728,X
				STA	$7A8,X
				STA	$450,X
				STA	$4D0,X
				STA	$550,X
				STA	$5D0,X
				STA	$650,X
				STA	$6D0,X
				STA	$750,X
				STA	$7D0,X
				DEX
				BPL	:1
				RTS

*-------------------------------

pTOPLINE		DB	0
pLEFTCOL		DB	0
pBOTLINE		DB	0
pRIGHTCOL		DB	0

*-------------------------------

				PUT	UTIL.CLEAR
				PUT	UTIL.GREENER
				PUT	UTIL.DISK
				PUT	USUB.CURSOR
				PUT	USUB.MINAREA
				PUT	USUB.PACKIMAG
				PUT	USUB.PACKMASK
				PUT	USUB.UNPKIMAG
				PUT	USUB.UNPKMASK
				PUT	HIRES.TABLES
				SAV	UTILITY
