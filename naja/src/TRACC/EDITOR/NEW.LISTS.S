*----------------------------------------
* X,Y: address of list to be initialized
*
* LIST_PTR,+1: address of list
* ENTRY_COUNT: number of entries in list
*----------------------------------------

INIT_LIST		STX	LIST_PTR
				STX	PTR
				STY	LIST_PTR+1
				STY	PTR+1
				LDY	#0
:0				LDA	(PTR),Y
				STA	TEXT_XCRD,Y
				INY
				CPY	#3
				BNE	:0
				LDA	TEXT_XCRD
				CLC
				ADC	#2
				STA	CURSOR_XCRD
				ADC	#9
				STA	DATA_XCRD
				JSR	ADVANCE_PTR
				LDX	#0
:1				LDA	(PTR),Y
				BMI	:2
				JSR	ADVANCE_ENTRY
				LDA	ENTRY_YCRD
				STA	YCRD_TABLE,X
				CLC
				ADC	LEADING
				STA	ENTRY_YCRD
				INX
				BNE	:1				;Always
:2				STX	ENTRY_COUNT
				RTS

*-------------------------------
* X = entry number to point to
*
* PTR,+1 pointing to entry X
* Y = 0
* X is preserved and incremented
* ENTRY_TYPE,OFFSET,SUB_OFFSET valid
*-------------------------------

FIND_ENTRY		LDA	YCRD_TABLE,X
				STA	ENTRY_YCRD
				LDA	LIST_PTR
				STA	PTR
				LDA	LIST_PTR+1
				STA	PTR+1
				LDY	#3
				JSR	ADVANCE_PTR
				TXA
				BEQ	:2
				PHA
:1				JSR	ADVANCE_ENTRY
				DEX
				BNE	:1
				PLA
				TAX
:2				LDA	(PTR),Y
				STA	ENTRY_TYPE
				INY
				LDA	(PTR),Y
				STA	ENTRY_OFFSET
				INY
				LDA	(PTR),Y
				STA	SUB_OFFSET
				INY
				JSR	ADVANCE_PTR
				INX
				RTS

*-------------------------------
*
*-------------------------------

ADVANCE_ENTRY	INY					; must not change X register
				INY
				INY
:1				LDA	(PTR),Y
				BMI	:2
				INY
				BNE	:1				; always
:2				INY
									; fall through
*-------------------------------
*
*-------------------------------

ADVANCE_PTR		TYA					;must not change X register
				CLC
				ADC	PTR
				STA	PTR
				BCC	:1
				INC	PTR+1
:1				LDY	#0
				RTS

*-------------------------------
*
*-------------------------------

DRAW_LTEXT		LDX	#0
:1				JSR	FIND_ENTRY
				TXA
				PHA
:2				LDA	(PTR),Y
				BMI	:3
				STA	TEXTBUF,Y
				INY
				BNE	:2				;Always
:3				AND	#$7F
				STA	TEXTBUF,Y
				LDA	#$8D
				STA	TEXTBUF+1,Y
				LDA	TEXT_XCRD
:4				SEC
				SBC	#6
				DEY
				BPL	:4
				LDY	ENTRY_YCRD
				JSR	LINE
				PLA
				TAX
				CPX	ENTRY_COUNT
				BNE	:1
				RTS

*-------------------------------
*
*-------------------------------

DRAW_LDATA		LDX	#0
:1				JSR	FIND_ENTRY
				TXA
				PHA
				JSR	DRAW_EDATA
				PLA
				TAX
				CPX	ENTRY_COUNT
				BNE	:1
				RTS

*-------------------------------

ENTRY_COUNT		DB	0
LIST_PTR		DW	0

TEXT_XCRD		DB	0				;* Must be
ENTRY_YCRD		DB	0				;*   consecutive
LEADING			DB	0				;*     in this order
CURSOR_XCRD		DB	0
DATA_XCRD		DB	0

ENTRY_TYPE		DB	0
ENTRY_OFFSET	DB	0
SUB_OFFSET		DB	0

YCRD_TABLE		DS	25

*-------------------------------
