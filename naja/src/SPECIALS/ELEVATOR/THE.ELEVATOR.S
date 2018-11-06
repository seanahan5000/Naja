*------------------------------*
*                              *
*         ELEVATOR 1-5         *
*                              *
*           2/15/87            *
*                              *
*------------------------------*
				LST	OFF
				ERR	($310)-$AA
				EXP	OFF
				LSTDO	OFF
				TR	ON

				USE	/NAJA/VARS/MACROS
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/THALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS
				PUT	/NAJA/VARS/TCTRL.VARS


LODPNTL			=	$11
LODPNTH			=	$12
LINENUM			=	$13
LOADLIN			=	$14
COUNTER			=	$15
FROMCNT			=	$16
TOCNT			=	$17

THICK			=	5
UBEGLIN			=	$04
DBEGLIN			=	$BB

				ORG	$9000

********************************
* On Entry:
*   A = 0 if elevator 123
*   A = 1 if elevator 345

				PHA
				LDA	#$40
				STA	PAGE
				LDY	#$02			;ELEVATOR
				JSR	PICKER
				PLA
				STA	FLAG_345		;$0 OR $1
				TAY
				JSR	PICKER			;NUMBERS 123 OR 345

				LDA	#<PRESS_TEXT
				STA	POINTL
				LDA	#>PRESS_TEXT
				STA	POINTH
				JSR	TEXTOUT

				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY

:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				JSR	CPARER2			;LEFT,RIGHT,AROUND
				BNE	:SKIPA
				JMP	RDKEY

:SKIPA			BIT	UNSTROB
				SEC
				SBC	#$B0
				BEQ	:LOOP1			;Shell 0 illegal
				CMP	#$06
				BCS	:LOOP1			;Shell >5 illegal
				CMP	SHELL
				BEQ	:LOOP1			;Same Shell illegal
				LDX	FLAG_345
				BNE	:SKIPB
				CMP	#$04
				BCS	:LOOP1
				BCC	:SKIPC			;Always
:SKIPB			CMP	#$03
				BCC	:LOOP1
:SKIPC			STA	DEST_SHELL
				TAX
				LDA	DISK_SIDES-1,X
				STA	DISK_SIDE

*** Load control file based on DEST_SHELL
***   and file table in camp
				TXA
				CLC
				ADC	#cControl17-1
				TAX
				JSR	SLOAD_FILE

				LDX	#$03
:LOOP5			LDA	SHELL_INFO,X
				STA	MAPSPOT,X
				DEX
				BPL	:LOOP5

				BIT	UNSTROB
				LDA	DEST_SHELL
				TAX
				SEC
				SBC	SHELL
				STX	SHELL
				BMI	UPPER

DOWNER			CMP	#$02
				BNE	:SKIPA

				BIT	UNSTROB
				DEC	XPOS
				DEC	YPOS
				LDA	#$01			;DOWN
				JSR	MIDDLER
				JSR	:SUBA
:SKIPA			DEC	XPOS
				DEC	YPOS
				JSR	GETNSEW
				JSR	:SUBA
:SKIPB			BIT	UNSTROB
				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY
				JMP	RDKEY

:SUBA			JSR	CLEAR2
				LDA	#$40
				STA	PAGE
				JSR	NOSCAN
				LDA	#$20
				STA	PAGE
				BIT	KEYBRD
				BMI	:EXIT
				JSR	DOWN
:EXIT			RTS


UPPER			CMP	#-2
				BNE	:SKIPA

				INC	XPOS
				INC	YPOS
				LDA	#$00			;UP
				JSR	MIDDLER
				JSR	:SUBA
:SKIPA			INC	XPOS
				INC	YPOS
				JSR	GETNSEW
				JSR	:SUBA
:SKIPB			BIT	UNSTROB
				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY
				JMP	RDKEY

:SUBA			JSR	CLEAR2
				LDA	#$40
				STA	PAGE
				JSR	NOSCAN
				LDA	#$20
				STA	PAGE
				BIT	KEYBRD
				BMI	:EXIT
				JSR	UP
:EXIT			RTS


DISK_SIDES
			do ORIGINAL
				DB  side_T1		; 17
				DB  side_T2		; 15
				DB  side_T3		; 13
				DB  side_T4		; 11
				DB  side_T5     ;  9
			else
				DB  side_T1		; 17
				DB  side_T1		; 15
				DB  side_T2		; 13
				DB  side_T2		; 11
				DB  side_T2     ;  9
			fin

DEST_SHELL		DFB	$00
FLAG_345		DFB	$00


**** UP = 0
**** DOWN = 1

MIDDLER			EOR	SHELL
				ASL
				TAX
				LDA	MIDDLES-2,X
				STA	POINTL
				LDA	MIDDLES-1,X
				STA	POINTH
				LDY	#$00
				LDA	(POINTL),Y
				TAX
:LOOP3			INY
				LDA	(POINTL),Y
				STA	BUFFER-1,Y		;HALL BUFFER
				DEX
				BNE	:LOOP3
				RTS

MIDDLES			DW	UP_31
				DW	DOWN_13
				DW	UP_53
				DW	DOWN_35

UP_31			DFB	14
				DFB	$00,$00,$C0
				DFB	$C0,$C0,$C0
				DFB	$C0,$C0,$C0
				DFB	$C0,$D8,$1B
				DFB	$FF,$C0

DOWN_13			DFB	6
				DFB	$00,$00,$D8
				DFB	$1B,$FF,$C0

UP_53			DFB	8
				DFB	$00,$00,$C0
				DFB	$C0,$1B,$D8
				DFB	$FF,$80

DOWN_35			DFB	6
				DFB	$00,$00,$1B
				DFB	$D8,$FF,$C0


PICKER			TYA
				ASL
				TAY
				LDA	PICKS,Y
				STA	TBLPNTL
				LDA	PICKS+1,Y
				STA	TBLPNTH
				JMP	EXPANDR

PICKS			DW	BUTN123
				DW	BUTN345
				DW	ELEVATR

PRESS_TEXT		PLOTAT	140;80;(PRESS)
				PLOTAT	122;88;(SHELL-NUMBER)+

				PUT	SCROLL.UP
				PUT	SCROLL.DOWN

				PUT	BUTN123
				PUT	BUTN345
				PUT	ELEVATR
				PUT	CROSS.SECTION

				SAV	ELEVATOR
