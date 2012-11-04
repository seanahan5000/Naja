*-------------------------------
* X,Y Address of data block
* A   Reference number (0,1, or 2)
* Carry set    Draw the initial value
* Carry clear  Don't draw initial value

TEXT_INIT		PHA
				PHP
				STX	TEMP
				STY	TEMP+1
				ASL
				ASL
				ASL
				TAX

				LDY	#2
:LOOP1			LDA	TEMP
				CLC
				ADC	OFFSETS,Y
				STA	ADR_TABLE,X
				INX
				LDA	TEMP+1
				ADC	#0
				STA	ADR_TABLE,X
				INX
				DEY
				BPL	:LOOP1
:LOOP0			INY
				LDA	(TEMP),Y
				STA	ADR_TABLE,X
				INX
				CPY	#1
				BNE	:LOOP0

				PLP
				BCC	:SKIPA

				LDY	#5
				LDA	#$0A
:LOOP2			STA	(TEMP),Y		;Same as OLDPTR
				INY
				CPY	#11
				BNE	:LOOP2
				PLA
				JMP	TEXT_UPDATE

:SKIPA			PLA
				JSR	POINTERS
				JSR	SPLITTER
				LDY	#5
:LOOP3			LDA	(NEWPTR),Y
				STA	(OLDPTR),Y
				DEY
				BPL	:LOOP3
				RTS

OFFSETS			DB	11,5,2
TIMES6			DB	0,6,12


*-------------------------------
* A:  Reference number (0,1, or 2)

TEXT_UPDATE		JSR	POINTERS
				JSR	SPLITTER

				LDY	#5
:LOOP1			LDA	(OLDPTR),Y
				CMP	(NEWPTR),Y
				BNE	:SKIPA
				LDA	#$0A
:SKIPA			STA	TEXTBUF,Y
				DEY
				BPL	:LOOP1

				LDA	#$8D
				STA	TEXTBUF+6
				LDA	TEXT_XHOLD
				LDY	TEXT_YPNT
				JSR	LINE

				LDY	#5
:LOOP2			LDA	(NEWPTR),Y
				CMP	(OLDPTR),Y
				BNE	:SKIPB
				LDA	#$0A
:SKIPB			STA	TEXTBUF,Y
				DEY
				BPL	:LOOP2

				LDA	TEXT_XHOLD
				LDY	TEXT_YPNT
				JSR	LINE

				LDY	#5
:LOOP3			LDA	(NEWPTR),Y
				STA	(OLDPTR),Y
				DEY
				BPL	:LOOP3
				RTS

*-------------------------------

POINTERS		ASL
				ASL
				ASL
				TAX
				LDY	#0
:LOOP1			LDA	ADR_TABLE,X
				STA	VALPTR,Y
				INX
				INY
				CPY	#6
				BNE	:LOOP1
				LDA	ADR_TABLE,X
				STA	TEXT_XHOLD
				LDA	ADR_TABLE+1,X
				STA	TEXT_YPNT
				RTS

TEXT_XHOLD		DB	0
TEXT_YPNT		DB	0

*-------------------------------

SPLITTER		LDY	#0
				LDA	(VALPTR),Y
				AND	#%11110000
				CMP	#$E0
				BNE	:SKIPA
				LDY	#5
:LOOP0			LDA	MINUS_TEXT,Y
				STA	(NEWPTR),Y
				DEY
				BPL	:LOOP0
				RTS
:SKIPA			LDY	#2
:LOOP1			LDA	(VALPTR),Y
				TAX
				AND	#%00001111
				PHA
				TXA
				LSR
				LSR
				LSR
				LSR
				PHA
				DEY
				BPL	:LOOP1
				LDY	#0
:LOOP2			PLA
				BNE	:SKIPB
				LDA	#$0A
				STA	(NEWPTR),Y
				INY
				CPY	#5
				BNE	:LOOP2
:LOOP3			PLA
:SKIPB			STA	(NEWPTR),Y
				INY
				CPY	#6
				BNE	:LOOP3
				RTS
