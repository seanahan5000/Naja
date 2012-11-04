*-------------------------------
*
*-------------------------------

FLUSH_NAME		STX	TEMP
				STY	TEMP+1
				LDY	#name+9
:LOOP1			LDA	(CHARDL),Y
				STA	(TEMP),Y
				DEY
				BPL	:LOOP1
				LDY	#$09
:LOOP2			LDA	(TEMP),Y
				CMP	#$0A
				BNE	:EXIT
				LDA	#$EE
				STA	(TEMP),Y
				DEY
				BPL	:LOOP2
:EXIT			RTS


*-----------------------------------------
* On Entry:
*   X: Slot number of equipment to remove
*-----------------------------------------

REMOVE_ITEM		LDY	#profrace		;Used to be REMOVE
				LDA	(CHARDL),Y
				STA	TEMP
				LDY	CORESPS,X
				CPX	#armor
				BCS	NORMAL
				CPX	#slot
				BEQ	NORMAL
				BCC	DOUBLE
				CPX	#uplft
				BCS	HANDS
				LDY	#back
				LDA	(CHARDL),Y
				TAY
				INY
				LDA	CORESPS,Y
				CLC
				ADC	#$04
				STA	TEMP
				LDY	CORESPS,X
				BNE	:SKIPB			;Always
:LOOP1			LDA	(CHARDL),Y
				DEY
				DEY
				DEY
				DEY
				STA	(CHARDL),Y
				INY
:SKIPB			INY
				INY
				INY
				INY
				CPY	TEMP
				BNE	:LOOP1
				DEY
				DEY
				DEY
				DEY
				BNE	NORMAL			;Always
HANDS			LDA	TEMP
				BPL	NORMAL
				TXA
				LSR
				BCS	NORMAL
DOUBLE			JSR	NORMAL
NORMAL			LDX	#3
				LDA	#$FF
:LOOP1			STA	(CHARDL),Y
				INY
				DEX
				BPL	:LOOP1
				RTS


*----------------------------------------
* On Entry:
*     A = Multiplier
*   X,Y = Multiplicand (low/high)
*----------------------------------------

MULTIPLY_12		STA	MULTIPLIER
				STX	MULTIPLICAND+3
				STY	MULTIPLICAND+2
				LDA	#0
				STA	MULTIPLICAND+1
				CLC
				BCC	DO_MULT2		;Always

*----------------------------------------
* On Entry:
*     A = Multiplier
*   X,Y = Pointer to 3 byte multiplicand
*
* Handles up to 99 * 999,999
*----------------------------------------

MULTIPLY_13		CLC
				BCC	DO_MULT1		;Always

*----------------------------------------
* On Entry:
*     A = Multiplier
*   X,Y = Pointer to 4 byte multiplicand
*
* Handles up to 99 * 9,999,999
*----------------------------------------

MULTIPLY_14		SEC
DO_MULT1		STA	MULTIPLIER
				STX	TEMP
				STY	TEMP+1

				LDX	#3
				LDY	#3
				BCS	:LOOP1
				DEY
:LOOP1			LDA	(TEMP),Y
				STA	MULTIPLICAND,X
				DEX
				DEY
				BPL	:LOOP1

DO_MULT2		LDX	#4
				LDA	#0
:LOOP1			STA	PRODUCT_5,X
				DEX
				BPL	:LOOP1
				BCS	:SKIPA
				STA	MULTIPLICAND+0
:SKIPA

				LDA	MULTIPLIER
				AND	#%00001111
				JSR	:SUBA
				LDX	#3
:LOOP2			ASL	MULTIPLICAND+3
				ROL	MULTIPLICAND+2
				ROL	MULTIPLICAND+1
				ROL	MULTIPLICAND+0
				DEX
				BPL	:LOOP2
				LDA	MULTIPLIER
				LSR
				LSR
				LSR
				LSR
:SUBA			TAX
:LOOP3			DEX
				BMI	:EXIT
				LDY	#3
				CLC
:LOOP4			LDA	PRODUCT_4,Y
				SED
				ADC	MULTIPLICAND,Y
				CLD
				STA	PRODUCT_4,Y
				DEY
				BPL	:LOOP4
				BCC	:LOOP3
				INC	PRODUCT_5
				BNE	:LOOP3			;Always
:EXIT			RTS


MULTIPLIER		DB	0
MULTIPLICAND	DB	0,0,0,0
PRODUCT_5		DB	0				;Must be
PRODUCT_4		DB	0				;   consecutive
PRODUCT_3		DB	0,0,0			;      in this order


*-------------------------------
*
*-------------------------------

LESS_PERCENT	STA	TEMP
				SED
				LDA	#0
				SEC
				SBC	TEMP
				CLD					;fall through

*-------------------------------

PERCENT_OF		JSR	MULTIPLY_12
				LDA	PRODUCT_3+2
				CLC
				SED
				ADC	#$49
				LDA	PRODUCT_3+1
				ADC	#$00
				TAX
				LDA	PRODUCT_3+0
				ADC	#$00
				TAY
				CLD
				RTS


*-------------------------------
* On Entry:
*     A: Divisor
*   X,Y: Dividend (low/high)
*
* On Exit:
*     A: Remainder
*   X,Y: Quotient (low/high)
*-------------------------------

DIVIDE_12		STX	divDVND+0
				STY	divDVND+1
				LDX	#1
				STX	divADD+1
				DEX
				STX	divADD+0
				STX	TEMP+0
				STX	divQUOT+0
				STX	divQUOT+1
				STA	TEMP+1
				SED
				LDY	#3
:1				LDA	divDVND+0
				SEC
				SBC	TEMP+0
				TAX
				LDA	divDVND+1
				SBC	TEMP+1
				BCC	:2
				STX	divDVND+0
				STA	divDVND+1
				LDA	divADD+0
				CLC
				ADC	divQUOT+0
				STA	divQUOT+0
				LDA	divADD+1
				ADC	divQUOT+1
				STA	divQUOT+1
				BCC	:1				;Always
:2				LDX	#3
:3				LSR	divADD+1
				ROR	divADD+0
				LSR	TEMP+1
				ROR	TEMP+0
				DEX
				BPL	:3
				DEY
				BNE	:1
				CLD
				LDA	divDVND+0
				LDX	divQUOT+0
				LDY	divQUOT+1
				RTS


*-------------------------------
*
*-------------------------------

CPARER1			JSR	CHECK_UP
				BEQ	CPAROUT
CPARER2			JSR	CHECK_DOWN
				BEQ	CPAROUT
				JSR	CHECK_LEFT
				BEQ	CPAROUT
				JSR	CHECK_RIGHT
CPAROUT			RTS


*-------------------------------
*
*-------------------------------

CHECK_UP		CMP	#"A"
				BEQ	:SKIPA
				CMP	#"I"
				BEQ	:SKIPA
				CMP	#$8B			;Up Arrow
:SKIPA			RTS

				DS	3				;*** FREE SPACE

CHECK_DOWN		CMP	#"Z"
				BEQ	:SKIPA
				CMP	#"M"
				BEQ	:SKIPA
				CMP	#$8A
:SKIPA			RTS

CHECK_LEFT		CMP	#"J"
				BEQ	:SKIPA
				CMP	#$88
:SKIPA			RTS

				DS	3				;*** FREE SPACE

CHECK_RIGHT		CMP	#"K"
				BEQ	:SKIPA
				CMP	#$95
:SKIPA			RTS

				DS	3				;*** FREE SPACE

CHECK_ENTER		CMP	#" "
				BEQ	:SKIPA
				CMP	#$8D			;Return
:SKIPA			RTS


*-------------------------------
*
*-------------------------------

ACURSIT			LDA	#$2C
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+1
				LDA	XPNT
				LDY	YPNT
				JSR	LINE
				LDA	XPNT
				PHA
				CLC
				ADC	#$05
				STA	XPNT
				LDA	#$00
				JSR	SPCHARS
				PLA
				STA	XPNT
				RTS
