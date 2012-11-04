*===============================
*
*===============================

TOTALS_OUT		JSR	RESET_CHLIST
				JSR	CSCAN_NOTDEAD
				STA	GOOD_MEN

				LDA	#$5E
				STA	YPNT
				LDA	#$8D
				STA	TEXTBUF+16
				LDY	#0
				STY	COUNT
:LOOP0			LDX	ALIEN1,Y
				INX
				BEQ	:SKIPC
				TYA
				JSR	POINTALN
				LDY	#aName+15
:LOOP3			LDA	(ALIEN_PTR),Y
				STA	TEXTBUF,Y
				DEY
				BPL	:LOOP3
				LDA	COUNT
				ASL
				STA	TEMP
				ASL
				ADC	TEMP			;Carry assumed clear
				TAX
				LDY	#aExperience
				LDA	#6
				STA	TEMP
:LOOP4			LDA	(ALIEN_PTR),Y
				STA	CREDIT_ALIEN,X
				INY
				INX
				DEC	TEMP
				BNE	:LOOP4
				LDA	#$0A
				LDY	YPNT
				JSR	LINE
				LDA	YPNT
				CLC
				ADC	#10
				STA	YPNT
:SKIPC			INC	COUNT
				LDY	COUNT
				CPY	#3
				BNE	:LOOP0
:SKIPB

				JSR	SET_CAMPFILES
				LDA	DISK_SIDE
				SEC
				SBC	#2
				STA	DISK_SIDE
				LDX	#cCtrlCommon
				JSR	FLOADER_FILE
				LDX	SHELL
				JSR	FLOADER_FILE
				LDX	#cCampCommons
				JSR	FLOADER_FILE
				LDX	#cTunnels
				JSR	FLOAD_FILE

				LDA	#$5E
				STA	YPNT
				LDA	#0
				LDX	#3
:LOOP1			STA	CRED_TOTAL,X
				STA	EXPR_TOTAL,X
				DEX
				BPL	:LOOP1
				STA	KILL_TOTAL
				STA	COUNT

				TAY
:LOOP2			LDX	ALIEN1,Y
				INX
				BEQ	:SKIPA
				JSR	ALIEN_LINE
:SKIPA			INC	COUNT
				LDY	COUNT
				CPY	#3
				BNE	:LOOP2

*-------------------------------

TOTAL_LINE		LDA	YPNT			;Draw TOTALS heading
				TAX					;   and dividing line
				DEX
				STX	LINE2A+2
				STX	LINE2A+5
				CLC
				ADC	#$02
				STA	YPNT
				STA	TEXT1+2
				LDY	#$01
				JSR	TEXTER
				LDA	#RED
				STA	COLOR
				LDY	#$02
				JSR	LINER

				LDA	#$00			;Total kills
				STA	TOTAL_CREDITS
				STA	TOTAL_CREDITS+1
				LDA	KILL_TOTAL
				CLC
				SED
				ADC	KILLLO
				STA	KILLLO
				STA	TOTAL_CREDITS+3
				LDA	#$00
				ADC	KILLHI
				STA	KILLHI
				STA	TOTAL_CREDITS+2
				CLD
				LDA	#$5A
				STA	XPNT
				JSR	TOTAL_CREDOUT

				LDX	#3				;Total credit
				CLC
:LOOP1			LDA	CRED_TOTAL,X
				SED
				ADC	CREDHI,X
				CLD
				STA	CREDHI,X
				STA	TOTAL_CREDITS,X
				DEX
				BPL	:LOOP1
				LDA	#$8C
				STA	XPNT
				JSR	TOTAL_CREDOUT

				LDX	#3				;Total experience
				CLC
:LOOP2			LDA	EXPR_TOTAL,X
				SED
				ADC	EXPHI,X
				CLD
				STA	EXPHI,X
				STA	TOTAL_CREDITS,X
				DEX
				BPL	:LOOP2
				LDA	#$C4
				STA	XPNT
				JSR	TOTAL_CREDOUT

*-------------------------------

GROUP_ADD		LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	COUNT
				LDA	CHAR_LIST,Y
				BNE	:SKIPA

				LDX	#<CRED_TOTAL
				LDY	#>CRED_TOTAL
				JSR	CHAR_EARN

				LDY	#experience+3
				LDX	#3
				CLC
:LOOP2			LDA	(CHARDL),Y
				SED
				ADC	EXPR_TOTAL,X
				CLD
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP2
				BCC	:SKIPA
				LDA	#$99
:LOOP3			INY					;#experience first time through
				STA	(CHARDL),Y
				CPY	#experience+3
				BNE	:LOOP3
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS


*-------------------------------
*
*-------------------------------

ALIEN_LINE		LDY	COUNT			;Aliens killed
				LDA	ATOTAL1,Y
				TAX
				CLC
				SED
				ADC	KILL_TOTAL
				CLD
				STA	KILL_TOTAL
				TXA
				LSR
				LSR
				LSR
				LSR
				BNE	:SKIPA
				LDA	#$0A
:SKIPA			STA	TEXTBUF
				TXA
				AND	#$0F
				STA	TEXTBUF+1
				LDA	#$8D
				STA	TEXTBUF+2
				LDA	#$82
				LDY	YPNT
				JSR	LINE

				LDA	COUNT
				ASL
				STA	TEMP
				ASL
				ADC	TEMP			;Carry assumed clear
				PHA
				TAY
				LDA	#0
				STA	TOTAL_CREDITS
				STA	TOTAL_CREDITS+1

				LDX	#2				;Alien credit value
:LOOP1			LDA	CREDIT_ALIEN,Y
				STA	TOTAL_CREDITS,X
				INY
				INX
				CPX	#4
				BNE	:LOOP1
				JSR	CALC_SUB
				LDA	#$8C
				STA	XPNT
				JSR	TOTAL_CREDOUT
				LDX	#3
				CLC
:LOOP2			SED
				LDA	CRED_TOTAL,X
				ADC	TOTAL_CREDITS,X
				STA	CRED_TOTAL,X
				CLD
				DEX
				BPL	:LOOP2

				PLA
				TAY
				LDX	#2				;Alien experience value
:LOOP3			LDA	EXPERI_ALIEN,Y
				STA	TOTAL_CREDITS,X
				INY
				INX
				CPX	#4
				BNE	:LOOP3
				JSR	CALC_SUB
				LDA	#$C4
				STA	XPNT
				JSR	TOTAL_CREDOUT
				LDX	#3
				CLC
:LOOP4			SED
				LDA	EXPR_TOTAL,X
				ADC	TOTAL_CREDITS,X
				STA	EXPR_TOTAL,X
				CLD
				DEX
				BPL	:LOOP4

				LDA	YPNT			;Advance line number
				CLC
				ADC	#$0A
				STA	YPNT
				RTS


*-------------------------------
*
*-------------------------------

CALC_SUB		LDY	COUNT
				LDA	ATOTAL1,Y
				BNE	:SKIPA
				STA	TOTAL_CREDITS+2				;Special case zero aliens
				STA	TOTAL_CREDITS+3
				RTS
:SKIPA			LDX	TOTAL_CREDITS+3
				LDY	TOTAL_CREDITS+2
				JSR	MULTIPLY_12
				LDA	GOOD_MEN
				CMP	#6
				BEQ	:SKIPB
				LDX	#<PRODUCT_3
				LDY	#>PRODUCT_3
				LDA	#6
				JSR	MULTIPLY_13
				LDA	GOOD_MEN
				CMP	#1
				BEQ	:SKIPB
				LDY	PRODUCT_4
				LDX	PRODUCT_4+1
				JSR	DIVIDE_12
				STY	TOTAL_CREDITS+0
				STX	TOTAL_CREDITS+1
				TAY
				LDX	PRODUCT_4+2
				LDA	GOOD_MEN
				JSR	DIVIDE_12
				STX	TOTAL_CREDITS+2
				TAY
				LDX	PRODUCT_4+3
				LDA	GOOD_MEN
				JSR	DIVIDE_12
				STX	TOTAL_CREDITS+3
				RTS
:SKIPB			LDX	#2
:LOOP1			LDA	PRODUCT_3,X
				STA	TOTAL_CREDITS+1,X
				DEX
				BPL	:LOOP1
				RTS

*-------------------------------
