				LST	OFF
DATA_PTR		=	$00				;$01
SCREENL			=	$02
SCREENH			=	$03
LINENUM			=	$04
BUFFER			=	$6000

firstline		=	79
lastline		=	175
linecount		=	lastline-firstline+1

				ORG	$1800

FILL_TABLES		LDX	#firstline
				STX	LINENUM
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH

				LDY	#19
:2				LDA	(SCREENL),Y
				AND	#$7F
				BEQ	:3
				DEY
				BPL	:2
:3				INY
				TYA
				STA	LCOL_TABLE-firstline,X

				LDA	#%00000001
				STA	TEMP
				LDX	#0
:4				LDA	(SCREENL),Y
				AND	TEMP
				BNE	:5
				ASL	TEMP
				INX
				BNE	:4				;Always
:5				LDA	LEFT_MASKS,X
				LDX	LINENUM
				STA	LMASK_TABLE-firstline,X

				LDY	#20
:6				LDA	(SCREENL),Y
				AND	#$7F
				BEQ	:7
				INY
				CPY	#40
				BNE	:6
:7				DEY
				TYA
				STA	RCOL_TABLE-firstline,X

				LDA	#%01000000
				STA	TEMP
				LDX	#0
:8				LDA	(SCREENL),Y
				AND	TEMP
				BNE	:9
				LSR	TEMP
				INX
				BNE	:8				;Always
:9				LDA	RIGHT_MASKS,X
				LDX	LINENUM
				STA	RMASK_TABLE-firstline,X

				INC	LINENUM
				LDX	LINENUM
				CPX	#lastline+1
				BNE	:1

DUMP_DATA		JSR	INIT_RECORD
				LDX	#0
:1				LDA	LCOL_TABLE,X
				JSR	RECORD_BYTE
				INX
				CPX	#linecount
				BNE	:1
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
				LDX	#0
:2				LDA	LMASK_TABLE,X
				JSR	RECORD_BYTE
				INX
				CPX	#linecount
				BNE	:2
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
				LDX	#0
:3				LDA	RCOL_TABLE,X
				JSR	RECORD_BYTE
				INX
				CPX	#linecount
				BNE	:3
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
				LDX	#0
:4				LDA	RMASK_TABLE,X
				JSR	RECORD_BYTE
				INX
				CPX	#linecount
				BNE	:4
				LDA	#$8D
				JSR	PUT_CHAR

				LDA	DATA_PTR
				SEC
				SBC	#<BUFFER
				STA	DATA_PTR
				LDA	DATA_PTR+1
				SBC	#>BUFFER
				STA	DATA_PTR+1
				RTS


RIGHT_MASKS		DB	%10000000
				DB	%11000000
				DB	%11100000
				DB	%11110000
				DB	%11111000
				DB	%11111100
				DB	%11111110

LEFT_MASKS		DB	%10000000
				DB	%10000001
				DB	%10000011
				DB	%10000111
				DB	%10001111
				DB	%10011111
				DB	%10111111

*-------------------------------
*
*-------------------------------

INIT_RECORD		LDA	#<BUFFER
				STA	DATA_PTR
				LDA	#>BUFFER
				STA	DATA_PTR+1
				LDA	#0
				STA	BYTE_COUNT
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
				LDA	#"D"
				JSR	PUT_CHAR
				LDA	#"B"
				JSR	PUT_CHAR
				LDA	#" "
				JSR	PUT_CHAR
:1				LDA	BYTE_COUNT
				BEQ	:2
				LDA	#","
				JSR	PUT_CHAR
:2				LDA	#"$"
				JSR	PUT_CHAR
				PLA
				JSR	PUT_BYTE
				INC	BYTE_COUNT
				LDA	#3
				CMP	BYTE_COUNT
				BNE	:3
				LDA	#$8D
				JSR	PUT_CHAR
				LDA	#0
				STA	BYTE_COUNT
:3				LDX	HOLDX
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
				STA	(DATA_PTR),Y
				INC	DATA_PTR
				BNE	:1
				INC	DATA_PTR+1
:1				RTS

BYTE_COUNT		DB	0
HOLDX			DB	0
HOLDY			DB	0

START_LINE		DB	0
END_LINE		DB	0
LEFT_COLUMN		DB	0
RIGHT_COLUMN	DB	0
COUNT			DB	0
TEMP			DB	0

LCOL_TABLE		DS	linecount
LMASK_TABLE		DS	linecount
RCOL_TABLE		DS	linecount
RMASK_TABLE		DS	linecount

				PUT	HIRES.TABLES
				SAV	SCAN.DOOR
