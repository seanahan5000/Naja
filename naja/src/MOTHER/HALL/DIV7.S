*-------------------------------
* On Entry:
*   X = number (low)
*   Y = number (high)
*
* On Exit:
*   X = mod 7
*   Y = div 7
*-------------------------------

DIVIDE_7		LDA	#0
				STA	TEMP
				TYA
				BEQ	:1
				LDA	#36
				STA	TEMP
				TXA
				CLC
				ADC	#4
				TAX
:1				LDY	#5
:2				TXA
				SEC
				SBC	TIMES7,Y
				BMI	:3
				TAX
				LDA	TEMP
				CLC
				ADC	POWER7,Y
				STA	TEMP
:3				DEY
				BPL	:2
				LDY	TEMP			;Y = DIV 7
				RTS					;X = MOD 7

TIMES7			DB	7,14,28,56,112,224
POWER7			DB	1,2,4,8,16,32
