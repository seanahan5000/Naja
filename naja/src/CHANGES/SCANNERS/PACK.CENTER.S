				LST	OFF
DATA_PTR		=	$00				;$01
SCREENL			=	$02
SCREENH			=	$03
SOURCE_PTR		=	SCREENL			;for PACK_LINE
LEFTMASK		=	$09
BUFFER			=	$4000

DATA_PAGE		=	$20
MASK_PAGE		=	$40

*-------------------------------
A1L				=	$3C
A1H				=	$3D
A2L				=	$3E
A2H				=	$3F
A4L				=	$42
A4H				=	$43
MOVEAUX			=	$C311
*-------------------------------

				ORG	$1800

				JMP	PACK_CENTER
				JMP	CLEAR_LSIDE
				JMP	CLEAR_RSIDE

CLEAR_LSIDE		LDA	#-1
				LDX	#19
				JMP	CLEARER
CLEAR_RSIDE		LDA	#19
				LDX	#39
CLEARER			STA	:MOD2+1
				STX	:MOD1+1
				LDX	#191
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#MASK_PAGE
				STA	SCREENH
:MOD1			LDY	#$FF			;modified
				LDA	#0
:2				STA	(SCREENL),Y
				DEY
:MOD2			CPY	#$FF			;modified
				BNE	:2
				DEX
				CPX	#-1
				BNE	:1
				RTS

PACK_CENTER
				JSR	FIND_FIRST
				JSR	FIND_LAST
				JSR	INIT_RECORD

				LDX	START_LINE
SCAN_LOOP		JSR	SCAN_LINE
				INC	START_LINE
				LDX	START_LINE
				CPX	END_LINE
				BNE	SCAN_LOOP
				LDA	#$FF
				JSR	RECORD_BYTE
				LDA	#$8D
				JSR	PUT_CHAR
*-------------------------------
				LDA	#<BUFFER
				STA	A1L
				LDA	#>BUFFER
				STA	A1H
				LDA	DATA_PTR
				STA	A2L
				LDA	DATA_PTR+1
				STA	A2H
				LDA	#$00
				STA	A4L
				LDA	#$40
				STA	A4H
				CLC
				JSR	MOVEAUX
*-------------------------------
				LDA	DATA_PTR
				SEC
				SBC	#<BUFFER
				STA	DATA_PTR
				LDA	DATA_PTR+1
				SBC	#>BUFFER
				STA	DATA_PTR+1
				RTS

FIND_FIRST		LDX	#0
:1				JSR	LINE_EMPTY
				BNE	:2
				INX
				BNE	:1				;Always
:2				STX	START_LINE
				RTS

FIND_LAST		LDX	#191
:1				JSR	LINE_EMPTY
				BNE	:2
				DEX
				BNE	:1				;Always
:2				INX
				STX	END_LINE
				RTS

LINE_EMPTY		LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#MASK_PAGE
				STA	SCREENH
				LDY	#39
:1				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:2
				DEY
				BPL	:1
				INY
:2				RTS

SCAN_LINE
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#MASK_PAGE
				STA	SCREENH

				LDY	#0
:1				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:2
				INY
				CPY	#40
				BNE	:1
:2				STY	LEFT_COLUMN

				LDY	#39
:3				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:4
				DEY
				BNE	:3
:4				STY	RIGHT_COLUMN
				TYA
				SEC
				SBC	LEFT_COLUMN
				BPL	:41
				JMP	RECORD_BYTE
:41				LDA	LEFT_COLUMN
				JSR	RECORD_BYTE

				LDA	#%00000001
				STA	TEMP
				LDX	#0
				LDY	LEFT_COLUMN
:5				LDA	(SCREENL),Y
				AND	TEMP
				BNE	:6
				ASL	TEMP
				INX
				BNE	:5				;Always
:6				LDA	RIGHT_MASKS,X
				STA	LEFTMASK
				CPY	RIGHT_COLUMN
				BEQ	:11

				LDA	SCREENH
				EOR	#$60
				STA	SCREENH
				LDA	(SCREENL),Y
				JSR	RECORD_BYTE
				LDA	LEFTMASK
				JSR	RECORD_BYTE

				LDA	#0
				STA	LEFTMASK

				INC	LEFT_COLUMN
				JSR	PACK_LINE
				LDA	SCREENH
				EOR	#$60
				STA	SCREENH

:11				LDA	#0
				JSR	RECORD_BYTE
				LDA	#%01000000
				STA	TEMP
				LDX	#0
				LDY	RIGHT_COLUMN
:9				LDA	(SCREENL),Y
				AND	TEMP
				BNE	:10
				LSR	TEMP
				INX
				BNE	:9				;Always
:10				LDA	LEFT_MASKS,X
				ORA	LEFTMASK
				PHA

				LDA	SCREENH
				EOR	#$60
				STA	SCREENH
				LDY	RIGHT_COLUMN
				LDA	(SCREENL),Y
				JSR	RECORD_BYTE
				PLA
				JSR	RECORD_BYTE
********************************
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
********************************
				RTS


LEFT_MASKS		DB	%00000000
				DB	%01000000
				DB	%01100000
				DB	%01110000
				DB	%01111000
				DB	%01111100
				DB	%01111110

RIGHT_MASKS		DB	%00000000
				DB	%00000001
				DB	%00000011
				DB	%00000111
				DB	%00001111
				DB	%00011111
				DB	%00111111

*-------------------------------
*
*-------------------------------

INIT_RECORD		LDA	#<BUFFER
				STA	DATA_PTR
				LDA	#>BUFFER
				STA	DATA_PTR+1
				LDA	#0
				STA	BYTE_COUNT
				LDA	#" "
				JSR	PUT_CHAR
				LDA	#"D"
				JSR	PUT_CHAR
				LDA	#"B"
				JSR	PUT_CHAR
				LDA	#" "
				JSR	PUT_CHAR
				LDA	#"4"
				JSR	PUT_CHAR
				LDA	#","
				JSR	PUT_CHAR
				LDA	#"$"
				JSR	PUT_CHAR
				LDA	START_LINE
				JSR	PUT_BYTE
				LDA	#","
				JSR	PUT_CHAR
				LDA	#"$"
				JSR	PUT_CHAR
				LDA	END_LINE
				JSR	PUT_BYTE
				LDA	#$8D
				JSR	PUT_CHAR
				RTS

*-------------------------------
*
*-------------------------------

RECORD_BYTE		PHA
				STX	HOLDX
				STY	HOLDY
				LDA	BYTE_COUNT
				BNE	:1
				LDA	#" "
				JSR	PUT_CHAR
				LDA	#"H"
				JSR	PUT_CHAR
				LDA	#"E"
				JSR	PUT_CHAR
				LDA	#"X"
				JSR	PUT_CHAR
				LDA	#" "
				JSR	PUT_CHAR
:1				PLA
				JSR	PUT_BYTE
				INC	BYTE_COUNT
				LDA	#16
				CMP	BYTE_COUNT
				BNE	:2
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
:2				LDX	HOLDX
				LDY	HOLDY
				RTS

PUT_BYTE		PHA
				LSR
				LSR
				LSR
				LSR
				JSR	PUT_DIGIT
				PLA
				AND	#$0F
PUT_DIGIT		CMP	#$0A
				BCC	:1
				CLC
				ADC	#"A"-$0A
				BNE	PUT_CHAR
:1				ORA	#"0"
PUT_CHAR		LDY	#0
				STA	$C005			;write aux 48K
				STA	(DATA_PTR),Y
				STA	$C004			;write main 48K
				INC	DATA_PTR
				BNE	:1
				INC	DATA_PTR+1
:1				RTS

BYTE_COUNT		DB	0
HOLDX			DB	0
HOLDY			DB	0

START_LINE		DB	0
END_LINE		DB	0
INDEX								;for PACK_LINE
LEFT_COLUMN		DB	0
LAST_INDEX							;for PACK_LINE
RIGHT_COLUMN	DB	0
COUNT			DB	0
TEMP			DB	0

				PUT	PACK.LINE
				PUT	HIRES.TABLES
				SAV	PACK.CENTER
