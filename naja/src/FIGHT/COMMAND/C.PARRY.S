PARRY			JSR	CLRBOX
				LDY	#$0A
				JSR	TEXTER
				LDA	TIMLEFT
				JSR	DIGIT_DRAW
				LDA	#$32
				STA	TEXTBUF+2
				LDA	#$0A
				STA	TEXTBUF+3
				LDA	#$8D
				STA	TEXTBUF+4
				JSR	LINE2
				LDA	TIMLEFT
				JSR	INPUT_SUB
				BCC	NOMIND
				STA	TIMTAKE
				TAX
				BEQ	NOMIND
				LDA	COMCNT
				BEQ	NOBEFOR
				LDY	COMPNTR
				LDA	COMMAND-2,Y
				CMP	#cmdPARRY
				BEQ	BEFORE
NOBEFOR			LDA	TIMTAKE
				STA	INSTR2
				LDA	#cmdPARRY
				STA	INSTR1
				BNE	GOCO1			;Always
BEFORE			STA	INSTR1
				LDA	COMMAND-1,Y
				STA	INSTR2
				DEC	COMCNT
				DEC	COMPNTR
				DEC	COMPNTR
				JSR	COMND2
				DEC	COMCNT
				LDY	COMPNTR
				INY
				LDA	COMMAND,Y
				CLC
				SED
				ADC	TIMTAKE
				CLD
				STA	INSTR2
GOCO1			JSR	POST_COMMAND
NOMIND			JSR	CLRBOX
				JSR	OPTIONS
				JMP	GETOP2
