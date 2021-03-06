				LST	OFF
				TR	ON

PARAM0			=	$00				;SEG NUMBER
PARAM1			=	$01				;returns length
SCREENL			=	$02
SCREENH			=	$03
BUFPTR			=	$04				;$05

TEXT_BUF		=	$4000

				ORG	$1000

*-------------------------------
*
*-------------------------------

DRIVER			LDX	PARAM0
				CPX	#10
				BCS	GET_FRONTWALL
GET_SIDEWALL	LDA	LEFT_COLUMNS,X
				STA	LEFT_COLUMN
				LDA	RIGHT_COLUMNS,X
				STA	RIGHT_COLUMN
				JSR	GRAB_DATA
				RTS

LEFT_COLUMNS	DB	0,4,12,16,18
				DB	21,22,24,28,36
RIGHT_COLUMNS	DB	4,12,16,18,19
				DB	22,24,28,36,40

GET_FRONTWALL	LDA	FLEFTS-10,X
				STA	LEFT_COLUMN
				LDA	FRIGHTS-10,X
				STA	RIGHT_COLUMN
				JSR	GRAB_DATA
				RTS

FLEFTS			DB	4,12,16,18,19
FRIGHTS			DB	36,28,24,22,21


GRAB_DATA		JSR	GET_BOUNDS
				JSR	INIT_RECORD
				LDX	TOP_LINE
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	LEFT_COLUMN
:2				LDA	(SCREENL),Y
				JSR	RECORD_BYTE
				INY
				CPY	RIGHT_COLUMN
				BNE	:2
				INX
				CPX	BOTTOM_LINE
				BNE	:1

				LDA	BUFPTR
				SEC
				SBC	#<TEXT_BUF
				STA	PARAM0
				LDA	BUFPTR+1
				SBC	#>TEXT_BUF
				STA	PARAM1
				RTS

GET_BOUNDS		LDX	#0
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	LEFT_COLUMN
:2				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:3
				INY
				CPY	RIGHT_COLUMN
				BNE	:2
				INX
				BNE	:1				;Always
:3				STX	TOP_LINE

				LDX	#191
:4				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	LEFT_COLUMN
:5				LDA	(SCREENL),Y
				AND	#$7F
				BNE	:6
				INY
				CPY	RIGHT_COLUMN
				BNE	:5
				DEX
				JMP	:4
:6				INX
				STX	BOTTOM_LINE
				RTS

INIT_RECORD		LDA	#<TEXT_BUF
				STA	BUFPTR
				LDA	#>TEXT_BUF
				STA	BUFPTR+1
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
				LDA	#"$"
				JSR	PUT_CHAR
				LDA	TOP_LINE
				JSR	PUT_BYTE
				LDA	#","
				JSR	PUT_CHAR
				LDA	#"$"
				JSR	PUT_CHAR
				LDA	BOTTOM_LINE
				JSR	PUT_BYTE
				LDA	#$8D
				JSR	PUT_CHAR
				RTS

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
				LDA	RIGHT_COLUMN
				SEC
				SBC	LEFT_COLUMN
				CMP	#17
				BCC	:11
				LDA	#16
:11				CMP	BYTE_COUNT
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
				STA	(BUFPTR),Y
				INC	BUFPTR
				BNE	:1
				INC	BUFPTR+1
:1				RTS


LEFT_COLUMN		DB	0				;INCLUSIVE
RIGHT_COLUMN	DB	0				;EXCLUSIVE
TOP_LINE		DB	0				;INCLUSIVE
BOTTOM_LINE		DB	0				;EXCLUSIVE
BYTE_COUNT		DB	0

HOLDX			DB	0
HOLDY			DB	0

				PUT	/CHANGES/HIRES.TABLES
				SAV	SAVE.SEGS
