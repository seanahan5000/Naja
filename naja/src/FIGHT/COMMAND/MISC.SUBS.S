SELECT_CHAR		STA	WHICH_CDEF
				LDX	#<WHICH_CDEF
				LDY	#>WHICH_CDEF
				JSR	INIT_CURSOR
				JSR	SET_INTERCEPT
				JSR	CHAR_CURSOR2
				JMP	GETKEY2
*-------------------------------
WHICH_CDEF		DB	$FF				;Modified
				DB	$00
				DW	:WHICH_CURS
:WHICH_CURS		BCS	:SKIPA
				JMP	CHAR_CURSOR1
:SKIPA			JMP	CHAR_CURSOR2
*-------------------------------

CONSELT			LDY	MANDNUM	
				BEQ	NLSKIP2
				LDA	XCTAB,Y
				STA	CFIRM
				STA	SLECT
				LDA	SHTAB,Y
				STA	CFIRM+1
				STA	SLECT+1
				LDX	#$00
				LDY	#$09
CSLOOP			LDA	LEGALS,Y
				BNE	NOLSKIP
				INX
NOLSKIP			DEY
				BPL	CSLOOP
				CPX	#$02	
				BCC	NLSKIP2
				LDY	#$30	
				JSR	TEXTER
				LDY	#$31	
				JSR	TEXTER
NLSKIP2			RTS

XCTAB			DFB	$99,$0F,$0E	
				DFB	$0F,$0D	

SHTAB			DFB	$FF,$00,$04	
				DFB	$03,$05	

*-------------------------------

SBOTTOMR		LDA	#$00
				BEQ	BOTTOM_COM		;Always
BOTTOMR			LDA	#$FF
BOTTOM_COM		STA	BOTTOUT+1
				LDA	#GREEN
				STA	COLOR
				LDY	#$0A
				JSR	LINER
				LDY	#$13
				JSR	TEXTER
				LDA	#$A6
				STA	YPNT
				LDA	CURHOLD
				JSR	DRAW_HAND
				LDX	USEDLOC
				LDA	HANDTAB,X
				BNE	PUTE2
				LDY	#$2E
				JSR	TEXTER
				JMP	BOTTOUT
PUTE2			LDX	USEDLOC
				JSR	ONE_EQLINE
				LDA	#$96
				LDY	#$AE
				JSR	LINE
				JSR	PARSTAT
				LDA	#$FC
				LDY	#$AE
				JSR	LINE
BOTTOUT			LDA	#$FF			;Modified
				BMI	:SKIPA
				STA	ENERGY_USAGE
				STA	ENERGY_USAGE+1
				STA	ENERGY_USAGE+2
				STA	PERWHAT
				BPL	:SKIPB			;Always
:SKIPA			JSR	ENERGY2
:SKIPB			LDA	#$EE
				JSR	CUTUP
				LDA	#$96
				LDY	#$B6
				JMP	LINE

*-------------------------------

SET_LEGALS		LDX	#15
				LDA	#$FF
:LOOP1			STA	LEGALS,X
				DEX
				BPL	:LOOP1
				RTS

*-------------------------------

ANDUP			LDX	#$05
				LDA	#$FF
ANDLOOP			AND	LEGALS,X
				DEX
				BPL	ANDLOOP
				TAX
				RTS

*-------------------------------

CANCEL_OUT		LDA	#BLACK1
				STA	COLOR
				LDY	#$08
				JSR	LINER
				LDY	#$0B
				JSR	TEXTER
				LDA	#GREEN
				STA	COLOR
				LDY	#$09
				JMP	LINER

*-------------------------------

CANCEL_IN		LDA	#BLACK1
				STA	COLOR
				LDY	#$09
				JSR	LINER
				LDY	#$0B
				JSR	TEXTER
				LDA	#GREEN
				STA	COLOR
				LDY	#$08
				JMP	LINER

*-------------------------------

SPACE_WAIT		BIT	UNSTROB
:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BEQ	:EXIT
				CMP	#"C"
				BNE	:LOOP1
				CLC
:EXIT			RTS
