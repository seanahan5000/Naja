SOURCE			=	$00				;$01
DEST			=	$02				;$03
TEMP			=	$04				;$05
GET_COUNT		=	$06
GET_PNTR		=	$07
SOURCE_ADR		=	$2000
DEST_ADR		=	$1000
return			=	$8D
				LST	OFF

				ORG	$0800

				LDA	#$00
				STA	GET_COUNT
				STA	GET_PNTR

				LDA	#<SOURCE_ADR
				STA	SOURCE
				LDA	#>SOURCE_ADR
				STA	SOURCE+1
				LDA	#<DEST_ADR
				STA	DEST
				LDA	#>DEST_ADR
				STA	DEST+1

				JSR	SCAN_BYTE
:LOOP1			JSR	PUT_HEADER
				LDA	#"("
				JSR	PUT_CHAR
:LOOP2			JSR	SCAN_BYTE
				CMP	#return
				BEQ	:SKIPA
				JSR	CONVERT_BYTE
				JSR	PUT_CHAR
				JMP	:LOOP2
:SKIPA			LDA	#")"
				JSR	PUT_CHAR
				LDA	#$8D
				JSR	PUT_CHAR
				JSR	SCAN_BYTE
				CMP	#$FF
				BNE	:LOOP1
				LDA	DEST
				BNE	:SKIPB
				DEC	DEST+1
:SKIPB			DEC	DEST
				LDA	#"+"
				JSR	PUT_CHAR
				LDA	#return
				JSR	PUT_CHAR
				LDA	#return
				JSR	PUT_CHAR
				JSR	SCAN_BYTE
				JMP	:LOOP1

*-------------------------------

CONVERT_BYTE	CMP	#$0A
				BCC	NUMBER
				BEQ	SPACE
				CMP	#$25			;Z+1
				BCS	SYMBOL
LETTER			ADC	#$B6			;Carry assumed clear
				RTS
SPACE			LDA	#"_"
				RTS
NUMBER			ORA	#$B0
				RTS
SYMBOL			TAX
				LDA	CVERTABLE-$25,X
				RTS

CVERTABLE		ASC	&!"%'*+,-./:<=>?&

*-------------------------------

PUT_CHAR		LDY	#0				;Must not change x register
				STA	(DEST),Y
				INC	DEST
				BNE	:EXIT
				INC	DEST+1
				LDA	DEST+1
				CMP	#$90
				BNE	:EXIT
				BRK
:EXIT			RTS

*-------------------------------

SCAN_BYTE		LDX	GET_PNTR
				CPX	GET_COUNT
				BNE	:SKIPC
				LDA	#0
				STA	GET_PNTR
:LOOP1			JSR	GET_BYTE
				CMP	#" "
				BEQ	:SKIPA
				JSR	PUT_CHAR
				JMP	:LOOP1
:SKIPA
:LOOP2			JSR	GET_BYTE
				CMP	#" "
				BEQ	:LOOP2
				CMP	#return
				BEQ	:SKIPB
				CMP	#"$"
				BNE	:LOOP2
				JSR	BYTE_TO_DIGIT
				ASL
				ASL
				ASL
				ASL
				PHA
				JSR	BYTE_TO_DIGIT
				STA	TEMP
				PLA
				ORA	TEMP
				LDX	GET_PNTR
				STA	GET_TABLE,X
				INC	GET_PNTR
				CPX	#2
				BNE	:LOOP2
:LOOP3			JSR	GET_BYTE
				CMP	#return
				BNE	:LOOP3
:SKIPB			LDA	GET_PNTR
				STA	GET_COUNT
				LDX	#$00
				STX	GET_PNTR
:SKIPC			LDA	GET_TABLE,X
				INC	GET_PNTR
				RTS

GET_TABLE		DB	0,0,0


*-------------------------------

GET_BYTE		LDY	#0
				LDA	(SOURCE),Y
				INC	SOURCE
				BNE	:EXIT
				INC	SOURCE+1
:EXIT			RTS

*-------------------------------

BYTE_TO_DIGIT	JSR	GET_BYTE
				CMP	#"A"
				BCC	:SKIPA
				SBC	#"A"-10
:SKIPA			AND	#%00001111
				RTS

*-------------------------------

PUT_HEADER		PHA
				LDX	#0
:LOOP1			LDA	PLOTAT_TEXT,X
				JSR	PUT_CHAR
				INX
				CPX	#8
				BNE	:LOOP1
				LDA	#0
				STA	TEMP+1
				PLA
				STA	TEMP
				ASL
				ROL	TEMP+1
				ASL
				ROL	TEMP+1
				ASL
				ROL	TEMP+1
				SEC
				SBC	TEMP
				PHA
				BCS	:SKIPA
				DEC	TEMP+1
:SKIPA			LDA	TEMP+1
				PHA
				JSR	SCAN_BYTE
				TAX
				PLA
				STA	TEMP+1
				PLA
				STX	TEMP
				CLC
				ADC	TEMP
				STA	TEMP
				LDA	TEMP+1
				ADC	#$00
				STA	TEMP+1
				JSR	BIN_TO_DEC
				JSR	SCAN_BYTE
				STA	TEMP
				LDA	#$00
				STA	TEMP+1

BIN_TO_DEC		LDA	#0
				STA	TOTAL
				STA	TOTAL+1

				LDX	TEMP+1
				BEQ	:SKIPA
:LOOP1			LDA	TOTAL
				SED
				CLC
				ADC	#$56
				STA	TOTAL
				LDA	TOTAL+1
				ADC	#$02
				STA	TOTAL+1
				CLD
				DEX
				BNE	:LOOP1

:SKIPA			LDA	TEMP
				LSR
				LSR
				LSR
				LSR
				BEQ	:SKIPB
				TAX
:LOOP2			LDA	TOTAL
				CLC
				SED
				ADC	#$16
				STA	TOTAL
				LDA	TOTAL+1
				ADC	#0
				STA	TOTAL+1
				CLD
				DEX
				BNE	:LOOP2

:SKIPB			LDA	TEMP
				AND	#$0F
				BEQ	:SKIPC
				TAX
:LOOP3			LDA	TOTAL
				CLC
				SED
				ADC	#1
				STA	TOTAL
				LDA	TOTAL+1
				ADC	#0
				STA	TOTAL+1
				CLD
				DEX
				BNE	:LOOP3

:SKIPC			LDX	#0
				LDA	TOTAL+1
				AND	#$0F
				BEQ	:SKIPD
				DEX
				ORA	#$B0
				JSR	PUT_CHAR
:SKIPD			LDA	TOTAL
				LSR
				LSR
				LSR
				LSR
				INX
				DEX
				BMI	:SKIPE
				TAY
				BEQ	:SKIPF
:SKIPE			ORA	#$B0
				JSR	PUT_CHAR
				DEX
:SKIPF			LDA	TOTAL
				AND	#$0F
				ORA	#$B0
				JSR	PUT_CHAR
				LDA	#";"
				JMP	PUT_CHAR

TOTAL			DB	0,0

PLOTAT_TEXT		ASC	" PLOTAT "

*-------------------------------
				SAV	CONVERTER
