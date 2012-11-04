				LST	OFF
				EXP	OFF
MLI				MAC
				JSR	$BF00
				DB	]1
				DW	]2
				EOM

				USE	/NAJA/VARS/MACROS

Open			=	$C8
NewLine			=	$C9
Read			=	$CA
Write			=	$CB
Close			=	$CC
SetMark			=	$CE
GetMark			=	$CF

ALIEN_PTR		=	$00				;$01
DATA_BUFFER		=	$2000
FILE_BUFFER		=	$6000
COMMAND_PARSE	=	$BE03

				PUT	/NAJA/VARS/FIGHT.CONSTS

				ORG	$1000

*====================================================
* On Entry:
*   A: Shell number 1 (shell 17) through 5 (shell 9)
*
* This routine assumes that there are 52 aliens on
*   shell 1 (17), 26 in each file.
*====================================================

UPDATE_SOURCE	STA	SHELL_NUMBER

				LDX	#63
:LOOP1			LDA	LOAD_NDOS_RW,X
				STA	$200,X
				DEX
				BPL	:LOOP1
				JSR	COMMAND_PARSE

				LDA	#$EA			;Force NDOS.RW to read
				STA	$896D
				STA	$896E
				STA	$896F

				LDA	#<DATA_BUFFER
				STA	$12
				LDA	#>DATA_BUFFER
				STA	$13
				LDA	#0
				STA	$14
				LDX	SHELL_NUMBER
				LDA	SIDES-1,X
				STA	$15
				LDA	TRACKS-1,X
				STA	$7A
				LDA	SECTORS-1,X
				STA	$7B
				LDA	#$20
				STA	$7C
				JSR	$8400

				LDA	DATA_BUFFER+3
				STA	ALIEN_PTR
				LDA	DATA_BUFFER+4
				CLC
				ADC	#>DATA_BUFFER
				STA	ALIEN_PTR+1
				LDX	DATA_BUFFER+0
				INX
				LDY	#0
				BEQ	:SKIPB			;Always
:LOOP2			INY
				BNE	:SKIPA
				INC	ALIEN_PTR+1
:SKIPA			LDA	(ALIEN_PTR),Y
				CMP	#$FF
				BNE	:LOOP2
				INY
				BNE	:SKIPB
				INC	ALIEN_PTR+1
:SKIPB			DEX
				BNE	:LOOP2
				TYA
				CLC
				ADC	ALIEN_PTR
				STA	ALIEN_PTR
				BCC	:SKIPC
				INC	ALIEN_PTR+1
:SKIPC

				LDX	SHELL_NUMBER
				DEX
				TXA
				ASL
				TAY
				LDX	NAME_TABLE,Y
				LDA	NAME_TABLE+1,Y
				TAY
				LDA	DATA_BUFFER+0
				CPY	#0
				BNE	:SKIPD
				LDA	#26
:SKIPD			JSR	UPDATE_ALIENS

				LDX	SHELL_NUMBER
				DEX
				BNE	:EXIT
				LDX	#<DATA_17B
				LDY	#>DATA_17B
				LDA	#26
				JSR	UPDATE_ALIENS
:EXIT			RTS

SHELL_NUMBER	DB	0

LOAD_NDOS_RW	ASC	"BLOAD /NAJA/IO/NDOS.RW",8D

SIDES			DB	4,4,5,5,5

TRACKS			DB	<S_DATA17/16
				DB	<S_DATA15/16
				DB	<S_DATA13/16
				DB	<S_DATA11/16
				DB	<S_DATA9/16

SECTORS			DB	<S_DATA17&%00001111
				DB	<S_DATA15&%00001111
				DB	<S_DATA13&%00001111
				DB	<S_DATA11&%00001111
				DB	<S_DATA9&%00001111

NAME_TABLE		DW	DATA_17A
				DW	DATA_15
				DW	DATA_13
				DW	DATA_11
				DW	DATA_9

DATA_17A		STR	"/ALIENS/DATA/DATA.17A.S"
DATA_17B		STR	"/ALIENS/DATA/DATA.17B.S"
DATA_15			STR	"/ALIENS/DATA/DATA.15.S"
DATA_13			STR	"/ALIENS/DATA/DATA.13.S"
DATA_11			STR	"/ALIENS/DATA/DATA.11.S"
DATA_9			STR	"/ALIENS/DATA/DATA.9.S"


*-----------------------------------------------------
* On Entry:
*           A: Number of alien blocks to do
*         X,Y: Pointing to name of source code file
*   ALIEN_PTR: Pointer to beginning of an alien block
*-----------------------------------------------------

UPDATE_ALIENS	STX	OPEN_PARMS+1
				STY	OPEN_PARMS+2
				STA	ALIEN_COUNT
				JSR	OPEN_FILE
:LOOP1			JSR	READ_LINE
				JSR	COUNT_TERMS
				BMI	:SKIPA
				BNE	:ERROR
				JSR	ADVANCE_LINE
				JMP	:LOOP1

:SKIPA			JSR	GET_NAME
				JSR	WRITE_LINE
				JSR	ADVANCE_LINE

:LOOP2			JSR	READ_LINE
				BCS	:SKIPC
				JSR	COUNT_TERMS
				BMI	:SKIPC
				BEQ	:SKIPB
				JSR	REPLACE_TERMS
				JSR	WRITE_LINE
:SKIPB			JSR	ADVANCE_LINE
				JMP	:LOOP2
:SKIPC			DEC	ALIEN_COUNT
				BNE	:LOOP1
				JSR	CLOSE_FILE
				RTS
:ERROR			BRK

ALIEN_COUNT		DB	0

*-------------------------------

OPEN_FILE		MLI	Open;OPEN_PARMS
				BCS	:ERROR
				LDA	OPEN_PARMS+5
				STA	NEWLINE_PARMS+1
				STA	SET_PARMS+1
				STA	READ_PARMS+1
				STA	WRITE_PARMS+1
				STA	CLOSE_PARMS+1
				MLI	NewLine;NEWLINE_PARMS
				BCS	:ERROR
				RTS
:ERROR			BRK

*-------------------------------

READ_LINE		MLI	SetMark;SET_PARMS
				BCS	:EXIT
				MLI	Read;READ_PARMS
				LDA	READ_LENGTH
				STA	WRITE_LENGTH
				LDA	READ_LENGTH+1
				STA	WRITE_LENGTH+1
:EXIT			RTS

*-------------------------------

WRITE_LINE		MLI	SetMark;SET_PARMS
				BCS	:ERROR
				MLI	Write;WRITE_PARMS
				BCS	:ERROR
				RTS
:ERROR			BRK

*-------------------------------

ADVANCE_LINE	MLI	GetMark;SET_PARMS
				BCS	:ERROR
				RTS
:ERROR			BRK

*-------------------------------

CLOSE_FILE		MLI	Close;CLOSE_PARMS
				BCS	:ERROR
				RTS
:ERROR			BRK

*-------------------------------

OPEN_PARMS		DB	3
				DW	0				;PATHNAME
				DW	FILE_BUFFER
				DB	0				;FREF

NEWLINE_PARMS	DB	3
				DB	0				;FREF
				DB	$FF
				DB	$8D

SET_PARMS		DB	2
				DB	0				;FREF
				DS	3

READ_PARMS		DB	4
				DB	0				;FREF
				DW	LINE_BUFFER
				DW	64
READ_LENGTH		DW	0

WRITE_PARMS		DB	4
				DB	0				;FREF
				DW	LINE_BUFFER
WRITE_LENGTH	DW	0
				DW	0

CLOSE_PARMS		DB	1
				DB	0				;FREF

LINE_BUFFER		DS	64

*-------------------------------

COUNT_TERMS		LDX	#0
				STX	TERMS
:LOOP1			LDA	LINE_BUFFER,X
				INX
				CMP	#$8D
				BEQ	:EXIT
				CMP	#"*"
				BEQ	:EXIT
				CMP	#" "
				BNE	:LOOP1

:LOOP2			LDA	LINE_BUFFER,X
				INX
				STX	INDEX
				CMP	#$8D
				BEQ	:EXIT
				CMP	#";"
				BEQ	:EXIT
				CMP	#"$"
				BEQ	:LOOP3
				CMP	#"("
				BNE	:LOOP2

				DEC	TERMS
				BMI	:EXIT			;Always

:LOOP3			INC	TERMS
:LOOP4			LDA	LINE_BUFFER,X
				INX
				CMP	#"$"
				BEQ	:LOOP3
				CMP	#";"
				BEQ	:EXIT
				CMP	#$8D
				BNE	:LOOP4
:EXIT			LDA	TERMS
				RTS

INDEX			DB	0
TERMS			DB	0

*-------------------------------

GET_NAME		LDX	INDEX
				LDY	#0
				STY	CHAR_COUNT
:LOOP1			LDA	(ALIEN_PTR),Y
				JSR	CONVERT_CHAR
				STA	LINE_BUFFER,X
				INX
				INC	CHAR_COUNT
				LDY	CHAR_COUNT
				CPY	#16
				BNE	:LOOP1
				LDA	ALIEN_PTR
				CLC
				ADC	#16
				STA	ALIEN_PTR
				BCC	:EXIT
				INC	ALIEN_PTR+1
:EXIT			RTS

CHAR_COUNT		DB	0

*-------------------------------

CONVERT_CHAR	CMP	#$0A			;Must not use X register
				BCC	NUMBER
				BEQ	SPACE
				CMP	#$25			;My Z+1
				BCS	SYMBOLS

LETTER			CLC
				ADC	#"A"-11
				RTS

SPACE			LDA	#"_"
				RTS

NUMBER			CLC
				ADC	#"0"
				RTS

SYMBOLS			LDY	#14
:LOOP1			CMP	NAJA_TEXT,Y
				BEQ	:SKIPA
				DEY
				BPL	:LOOP1
				INY
:SKIPA			LDA	ASCII,Y
				RTS

NAJA_TEXT		USR	(!"%'*+,-./:<=>?)
ASCII			ASC	#!"%'*+,-./:<=>?#

*-------------------------------

REPLACE_TERMS	LDY	#0
				LDX	INDEX
:LOOP1			LDA	(ALIEN_PTR),Y
				PHA
				LSR
				LSR
				LSR
				LSR
				JSR	:SUBA
				STA	LINE_BUFFER,X
				INX
				PLA
				AND	#%00001111
				JSR	:SUBA
				STA	LINE_BUFFER,X
				INX
				INX
				INX
				INY
				CPY	TERMS
				BNE	:LOOP1
				TYA
				CLC
				ADC	ALIEN_PTR
				STA	ALIEN_PTR
				BCC	:EXIT
				INC	ALIEN_PTR+1
:EXIT			RTS

:SUBA			CMP	#10
				BCC	:SKIPA
				CLC
				ADC	#"A"-10
				RTS
:SKIPA			ADC	#"0"
				RTS

*-------------------------------

				SAV	UPDATE.SOURCE
