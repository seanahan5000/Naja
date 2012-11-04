				LST	OFF
				TR	ON
				EXP	OFF

				USE	/NAJA/VARS/MLI.VARS

SOURCE			=	$00				;$01
DESTIN			=	$02				;$03
TEMP			=	$04				;$05

FILE_BUFFER		=	$1000
UNPACK1			=	$1400
UNPACK2			=	$1700
SOURCE_BUFFER	=	$2000

return			=	$8D

				ORG	$0800

*-------------------------------
*
*-------------------------------

COMPILER		JSR	BLOAD_SOURCE
				JSR	TEXT_TO_HEX
				LDA	#<SOURCE_BUFFER
				STA	SOURCE
				LDA	#>SOURCE_BUFFER
				STA	SOURCE+1

				MLI	Open;OPEN_OUTPUT     ;Assumes file is already created
				BCS	:ERROR
				LDA	OPEN_OUTPUT+5
				STA	WRITE_OUTPUT+1
				STA	CLOSE_OUTPUT+1

:LOOP1			LDY	#0
				LDA	(SOURCE),Y
				CMP	#$EE
				BEQ	:SKIPB
				STA	DIMENS
				INY
				LDA	(SOURCE),Y
				STA	OFFSET
				JSR	CALC_LENGTH

				LDX	#<UNPACK1
				LDY	#>UNPACK1
				JSR	UNPACKER

				LDX	#<UNPACK1
				LDY	#>UNPACK1
:LOOP2			JSR	PACK_AND_SAVE
				LDA	#return
				JSR	SAVE_CHAR

				LDX	#<UNPACK2
				LDY	#>UNPACK2
				JSR	UNPACKER
				BCS	:SKIPA

				JSR	EOR_2_TO_1
				LDX	#<UNPACK2
				LDY	#>UNPACK2
				JMP	:LOOP2

:SKIPA			JSR	DFB_OUT
				LDA	#$FF
				JSR	BYTE_RETURN
				LDA	#return
				JSR	SAVE_CHAR
				LDA	#return
				JSR	SAVE_CHAR
				INC	SOURCE
				BNE	:LOOP1
				INC	SOURCE+1
				BNE	:LOOP1			;Always

:SKIPB			MLI	Close;CLOSE_OUTPUT
				BCC	:EXIT
:ERROR			BRK
:EXIT			RTS

*-------------------------------

OPEN_OUTPUT		DB	3
				DW	:1
				DW	FILE_BUFFER
				DB	0				;fref

:1				STR	"/ALIENS/TOPVIEWS/OUTPUT.S"

CLOSE_OUTPUT	DB	1
				DB	0				;fref

*-------------------------------

BLOAD_SOURCE	LDX	#SOURCE_END-SOURCE_FILE
:LOOP1			LDA	SOURCE_FILE-1,X
				STA	$200-1,X
				DEX
				BNE	:LOOP1
				JSR	BInterpreter
				LDA	BIError
				BEQ	:EXIT
				BRK
:EXIT			LDA	#"<"
				STA	$94FF			;Just in case
				RTS

SOURCE_FILE		ASC	"BLOAD /ALIENS/TOPVIEWS/INPUT.S,A$2000,TTXT",8D
SOURCE_END

*-------------------------------

TEXT_TO_HEX		LDA	#<SOURCE_BUFFER
				STA	SOURCE
				STA	DESTIN
				LDA	#>SOURCE_BUFFER
				STA	SOURCE+1
				STA	DESTIN+1
:LOOP1			LDX	#0
				LDY	#0
:LOOP2			LDA	(SOURCE),Y
				INY
				CMP	#"<"
				BNE	:SKIPA
				LDY	#0
				LDA	#$EE
				STA	(DESTIN),Y
				RTS

:SKIPA			CMP	#"*"
				BEQ	:SKIPB
				CMP	#";"
				BEQ	:SKIPB
				CMP	#return
				BEQ	:SKIPC
				CMP	#"$"
				BNE	:LOOP2

				LDA	(SOURCE),Y
				INY
				JSR	TO_BINARY
				ASL
				ASL
				ASL
				ASL
				STA	TEMP
				LDA	(SOURCE),Y
				INY
				JSR	TO_BINARY
				ORA	TEMP
				STA	BUFFER,X
				INX
				BNE	:LOOP2			;Always

:SKIPB			LDA	(SOURCE),Y
				INY
				CMP	#return
				BNE	:SKIPB
:SKIPC			TYA
				CLC
				ADC	SOURCE
				STA	SOURCE
				BCC	:SKIPD
				INC	SOURCE+1
:SKIPD			TXA
				BEQ	:LOOP1
				LDY	#0
:LOOP3			LDA	BUFFER,Y
				STA	(DESTIN),Y
				INY
				DEX
				BNE	:LOOP3
				TYA
				CLC
				ADC	DESTIN
				STA	DESTIN
				BCC	:LOOP1
				INC	DESTIN+1
				BNE	:LOOP1			;Always

TO_BINARY		CMP	#"A"
				BCC	:SKIPA
				SBC	#"A"-10
				RTS
:SKIPA			AND	#%00001111
				RTS

*-------------------------------

CALC_LENGTH		LDA	DIMENS
				TAX
				AND	#%00001111
				STA	TEMP
				TXA
				LSR
				LSR
				LSR
				LSR
				TAX
				LDA	#0
:LOOP1			CLC
				ADC	TEMP
				DEX
				BNE	:LOOP1
				STA	LENGTH
				RTS

*-------------------------------

UNPACKER		STX	DESTIN
				STY	DESTIN+1

				LDY	#0
				LDA	(SOURCE),Y
				CMP	#$FF
				BNE	:1
				SEC
				RTS

:1				LDA	SOURCE
				CLC
				ADC	#2
				STA	SOURCE
				BCC	:SKIPA
				INC	SOURCE+1
:SKIPA
				LDA	LENGTH
				STA	TEMP

:LOOP1			LDX	#0
				LDY	#0
:LOOP2			LDA	(SOURCE),Y
				BMI	:SKIPB
				STA	BUFFER,X
				INY
				INX
				CPX	#7
				BNE	:LOOP2
				BEQ	:SKIPC			;Always

:SKIPB			AND	#%01111111
				INY
:LOOP3			STA	BUFFER,X
				INX
				CPX	#7
				BNE	:LOOP3

:SKIPC			TYA
				CLC
				ADC	SOURCE
				STA	SOURCE
				BCC	:SKIPD
				INC	SOURCE+1
:SKIPD			LDY	#6
:LOOP4			LDA	BUFFER,Y
				STA	(DESTIN),Y
				DEY
				BPL	:LOOP4

				LDA	#7
				CLC
				ADC	DESTIN
				STA	DESTIN
				BCC	:SKIPE
				INC	DESTIN+1
:SKIPE			DEC	TEMP
				BNE	:LOOP1
				CLC
				RTS

*-------------------------------

EOR_2_TO_1		LDX	#0
:LOOP1			LDA	UNPACK1,X
				EOR	UNPACK2,X
				PHA
				LDA	UNPACK2,X
				STA	UNPACK1,X
				PLA
				STA	UNPACK2,X

				LDA	UNPACK1+$100,X
				EOR	UNPACK2+$100,X
				PHA
				LDA	UNPACK2+$100,X
				STA	UNPACK1+$100,X
				PLA
				STA	UNPACK2+$100,X

				LDA	UNPACK1+$200,X
				EOR	UNPACK2+$200,X
				PHA
				LDA	UNPACK2+$200,X
				STA	UNPACK1+$200,X
				PLA
				STA	UNPACK2+$200,X

				INX
				BNE	:LOOP1
				RTS

*-------------------------------

PACK_AND_SAVE	LDA	SOURCE
				PHA
				LDA	SOURCE+1
				PHA
				STX	SOURCE
				STY	SOURCE+1
				LDA	LENGTH
				STA	TEMP

				LDX	DIMENS
				LDY	OFFSET
				JSR	TWO_BYTES

:LOOP1			LDY	#6
:LOOP2			LDA	(SOURCE),Y
				STA	BUFFER,Y
				DEY
				BPL	:LOOP2

				LDA	#7
				CLC
				ADC	SOURCE
				STA	SOURCE
				BCC	:SKIPA
				INC	SOURCE+1
:SKIPA			LDX	#5
:LOOP3			LDA	BUFFER+1,X
				AND	#%01111111
				CMP	BUFFER,X
				BNE	:SKIPB
				ORA	#%10000000
				STA	BUFFER,X
				DEX
				BPL	:LOOP3

				do	0				;TEMP ***
:SKIPB			LDX	BUFFER
				BMI	:1
				LDY	BUFFER+1
				BMI	:2
				LDA	BUFFER+2
				BMI	:3
				JSR	THREE_BYTES
				LDX	BUFFER+3
				BMI	:1
				LDY	BUFFER+4
				BMI	:2
				LDA	BUFFER+5
				BMI	:3
				JSR	THREE_BYTES
				LDX	BUFFER+6
:1				JSR	ONE_BYTE
				JMP	:SKIPC
:2				JSR	TWO_BYTES
				JMP	:SKIPC
:3				JSR	THREE_BYTES
				else				;TEMP ***
:SKIPB			JSR	DFB_OUT
				LDX	#0
				STX	TEMP+1
:1				LDA	BUFFER,X
				BMI	:2
				JSR	BYTE_COMMA
				INC	TEMP+1
				LDX	TEMP+1
				CPX	#6
				BNE	:1
				LDA	BUFFER+6
:2				JSR	BYTE_RETURN
				fin					;TEMP ***
:SKIPC			DEC	TEMP
				BNE	:LOOP1
				PLA
				STA	SOURCE+1
				PLA
				STA	SOURCE
				RTS

*-------------------------------

DFB_OUT			LDA	#" "
				JSR	SAVE_CHAR
				LDA	#"D"
				JSR	SAVE_CHAR
				LDA	#"B"
				JSR	SAVE_CHAR
				LDA	#" "
				JMP	SAVE_CHAR

*-------------------------------

ONE_BYTE		TXA
				PHA					;First
				JSR	DFB_OUT
				PLA
				JMP	BYTE_RETURN

*-------------------------------

TWO_BYTES		TYA
				PHA					;Second
				TXA
				PHA					;First
				JSR	DFB_OUT
				PLA
				JSR	BYTE_COMMA
				PLA
				JMP	BYTE_RETURN

*-------------------------------

THREE_BYTES		PHA					;Third
				TYA
				PHA					;Second
				TXA
				PHA					;First
				JSR	DFB_OUT
				PLA
				JSR	BYTE_COMMA
				PLA
				JSR	BYTE_COMMA
				PLA
				JMP	BYTE_RETURN

*-------------------------------

BYTE_RETURN		JSR	SAVE_BYTE
				LDA	#return
				JMP	SAVE_CHAR

*-------------------------------

BYTE_COMMA		JSR	SAVE_BYTE
				LDA	#","
				JMP	SAVE_CHAR

*-------------------------------

SAVE_BYTE		PHA
				LDA	#"$"
				JSR	SAVE_CHAR
				PLA
				PHA
				LSR
				LSR
				LSR
				LSR
				JSR	:SUBA
				PLA
				AND	#%00001111
:SUBA			CMP	#$0A
				BCC	:SKIPA
				CLC
				ADC	#"A"-10
				JMP	SAVE_CHAR
:SKIPA			ORA	#"0"
				JMP	SAVE_CHAR

*-------------------------------

SAVE_CHAR		STA	WRITE_BUFFER
				MLI	Write;WRITE_OUTPUT
				BCC	:EXIT
				BRK
:EXIT			RTS

WRITE_OUTPUT	DB	4
				DB	0				;fref
				DW	WRITE_BUFFER
				DW	1
				DW	0

WRITE_BUFFER	DB	0

*-------------------------------

DIMENS			DB	0
OFFSET			DB	0
LENGTH			DB	0
BUFFER			DB	0,0,0,0,0,0,0

*-------------------------------

				SAV	COMPILER
