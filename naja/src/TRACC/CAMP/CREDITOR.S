********************************
*** Take character number passed
***   in Acc. and pool the groups
***   credits to him and set every-
***   one else's to zero.
***
*** NOTE: The routine does not
***   check if character number
***   from Acc. is a robot.

POOL_TO_CHAR	PHA
				JSR	POOL_TO_TOTAL	;Pool the credits
				LDA	#$00
				STA	COUNT
:LOOP1			JSR	POINTIT			;Take everyone's credits away
				JSR	SKIP_CREDITS
				BCS	:SKIPA
				LDA	#$00
				LDY	#credits
:LOOP2			STA	(CHARDL),Y
				INY
				CPY	#credits+4
				BNE	:LOOP2
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				PLA
				JSR	POINTIT			;Give designated character
				LDY	#credits+3		;   the pooled credits
				LDX	#3
:LOOP3			LDA	TOTAL_CREDITS,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP3
				RTS

				NOP					;FREE SPACE


********************************
*** Add up all the credits of non-
***   robot characters and put them
***   in TOTAL_CREDITS.

POOL_TO_TOTAL	LDA	#$00
				LDX	#3
:LOOP1			STA	TOTAL_CREDITS,X
				DEX
				BPL	:LOOP1

				STA	COUNT
:LOOP2			JSR	POINTIT
				JSR	SKIP_CREDITS
				BCS	:SKIPA
				LDX	#3
				LDY	#credits+3
				CLC
:LOOP3			LDA	(CHARDL),Y
				SED
				ADC	TOTAL_CREDITS,X
				STA	TOTAL_CREDITS,X
				CLD
				DEY
				DEX
				BPL	:LOOP3
				BCC	:SKIPA
				LDX	#3
				LDA	#$99
:LOOP4			STA	TOTAL_CREDITS,X
				DEX
				BPL	:LOOP4
				RTS
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP2
				RTS

				NOP					;FREE SPACE


********************************
*** Give credits pointed to by
***   X (low) and Y (high) and
***   give them to the current
***   character and limit the
***   total to 99,999,999.

CHAR_EARN		STX	:LOOP1+1
				STY	:LOOP1+2
				LDY	#credits+3
				LDX	#3
				CLC
:LOOP1			LDA	$FFFF,X			;MOD
				SED
				ADC	(CHARDL),Y
				STA	(CHARDL),Y
				CLD
				DEY
				DEX
				BPL	:LOOP1
				BCC	:EXIT
				LDY	#credits
				LDA	#$99
:LOOP2			STA	(CHARDL),Y
				INY
				CPY	#credits+4
				BNE	:LOOP2
:EXIT			RTS


********************************
*** On entry, if carry is clear,
***   test if current character
***   can afford to spend the credits
***   pointed to by X (low) and Y (high).
***   If carry is set, actually take the
***   credits if he can afford them.
*** On exit, carry clear means he couldn't
***   afford them, and carry set means he
***   could.

CHAR_SPEND		PHP
				STX	:MOD1+1
				STY	:MOD1+2
				LDX	#3
				LDY	#credits+3
				SEC
:LOOP1			LDA	(CHARDL),Y
				SED
:MOD1			SBC	$FFFF,X
				STA	TEMP_CREDITS,X
				DEY
				DEX
				BPL	:LOOP1
				CLD
				BCS	:SKIPA
				PLA
				RTS					;Carry clear
:SKIPA			PLP
				BCC	:SKIPB
				LDX	#3
				LDY	#credits+3
:LOOP2			LDA	TEMP_CREDITS,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP2
:SKIPB			SEC
				RTS


*--------------------------------------------------------
* On Entry:
*             X,Y: Pointing to Credits to be taken
*   TOTAL_CREDITS: Valid for current group
*     Carry Clear: Just test if group has enough credits
*       Carry Set: Test and take if the have enough
*
* On Exit:
*   Carry Clear: They COULDN'T afford it
*     Carry Set: They COULD afford it
*
* NOTE: This routine destroys contents of TOTAL_CREDITS
*--------------------------------------------------------

GROUP_SPEND		PHP
				STX	TEMP
				STY	TEMP+1
				LDY	#3
:LOOP1			LDA	(TEMP),Y
				STA	TEMP_CREDITS,Y
				DEY
				BPL	:LOOP1

				LDX	#3
				SED
				SEC
:LOOP2			LDA	TOTAL_CREDITS,X
				SBC	TEMP_CREDITS,X
				DEX
				BPL	:LOOP2
				CLD
				BCS	:SKIPA
				PLA
				RTS					;Carry clear

:SKIPA			PLP
				BCC	:EXIT
				LDA	#0
				STA	COUNT
:LOOP3			JSR	POINTIT
				JSR	SKIP_CREDITS
				BCS	:SKIPC
				LDX	#3
				LDY	#credits+3
				SED
				SEC
:LOOP4			LDA	TEMP_CREDITS,X
				STA	TOTAL_CREDITS,X
				SBC	(CHARDL),Y
				STA	TEMP_CREDITS,X
				DEY
				DEX
				BPL	:LOOP4
				CLD
				BCS	:SKIPB
				LDX	#3
				LDY	#credits+3
				SED
				SEC
:LOOP5			LDA	(CHARDL),Y
				SBC	TOTAL_CREDITS,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP5
				CLD
				RTS					;Carry set

:SKIPB			LDY	#credits
				LDA	#0
:LOOP6			STA	(CHARDL),Y
				INY
				CPY	#credits+4
				BNE	:LOOP6

:SKIPC			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP3
:EXIT			SEC
				RTS

SKIP_CREDITS	LDY	#profrace
				LDA	(CHARDL),Y
				CMP	#$80
				BEQ	:EXIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#lost
				BEQ	:EXIT
				CMP	#intracc
:EXIT			RTS

********************************
				DS	30				;FREE SPACE ***
********************************

TOTAL_CREDITS	DB	$00,$00,$00,$00
TEMP_CREDITS	DB	$00,$00,$00,$00


********************************
*
********************************

CHAR_CREDOUT	LDY	#credits
				LDA	CHARDL
				STA	TEMP
				LDA	CHARDH
				STA	TEMP+1
				BNE	CREDCOM			;Always

TOTAL_CREDOUT	LDX	#<TOTAL_CREDITS
				LDY	#>TOTAL_CREDITS

CREDIT_OUT		STX	TEMP
				STY	TEMP+1
				LDY	#$00
CREDCOM			LDX	#$00
CRLOOP1			LDA	(TEMP),Y
				PHA
				LSR
				LSR
				LSR
				LSR
				STA	TEXTBUF,X
				INX
				PLA
				AND	#$0F
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$08
				BNE	CRLOOP1
				LDX	#$00
DEZEROD			LDA	TEXTBUF,X
				BNE	ISZEROD
				LDA	#$0A
				STA	TEXTBUF,X
				INX
				CPX	#$07
				BNE	DEZEROD
ISZEROD			LDA	TEXTBUF+2
				PHA
				LDA	#$8D
				STA	TEXTBUF+2
				LDA	XPNT
				LDY	YPNT
				JSR	LINE
				PLA
				STA	TEXTBUF
				LDA	TEXTBUF+3
				STA	TEXTBUF+1
				LDA	TEXTBUF+4
				STA	TEXTBUF+2
				LDA	#$8D
				STA	TEXTBUF+3
				LDA	XPNT
				CLC
				ADC	#$0E
				LDY	YPNT
				JSR	LINE
				LDX	#$02
SLID			LDA	TEXTBUF+5,X
				STA	TEXTBUF,X
				DEX
				BPL	SLID
				LDA	XPNT
				CLC
				ADC	#$22
				LDY	YPNT
				JMP	LINE
