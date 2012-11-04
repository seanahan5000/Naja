DAMINC			JSR	GET_LIMITS
				LDA	LOW
				CMP	HIGH
				BCC	:LOOP1
				LDX	LOW
				LDA	HIGH
				STA	LOW
				STX	HIGH
:LOOP1			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$0F
				CMP	#$0A
				BCS	:LOOP1
				LDA	RANDOM1
				CMP	#$9A
				BCS	:LOOP1
				CMP	LOW
				BCC	:LOOP1
				CMP	HIGH
				BEQ	:SKIPA
				BCS	:LOOP1
:SKIPA			JSR	:SUBA
				LDY	#damagemax+1
				LDA	(CHARDL),Y
				SED
				CLC
				ADC	RANDOM1
				STA	(CHARDL),Y
				DEY
				LDA	(CHARDL),Y
				ADC	#$00
				STA	(CHARDL),Y
				CLD
				BCC	:SUBA
				LDA	#$99
				STA	(CHARDL),Y
				INY
				STA	(CHARDL),Y
:SUBA			JSR	DAMAGER
				LDA	#$0A
				LDX	#4
:LOOP2			STA	TEXTBUF,X
				DEX
				BPL	:LOOP2
				LDY	CURSOR
				LDA	TYPOINTS,Y
				TAY
				LDA	#$8A
				JMP	LINE


GET_LIMITS		LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				CMP	#electromedic
				BNE	NOEMED
				LDA	#physician
NOEMED			PHA
				TAY
				JSR	LOWLIM
				JSR	LIMIT_RANK
				PLA
				ASL
				TAY
				LDA	PROSUBS+1,Y
				PHA
				LDA	PROSUBS,Y
				PHA
				RTS

PROSUBS			DW	WARLIM-1
				DW	ANDLIM-1
				DW	CYBLIM-1
				DW	JUILIM-1
				DW	PHYLIM-1

LOWLIM			LDA	#$00
				STA	LOW
				LDA	ORGOFF,Y
				STA	ORGHOLD
				LDY	#organic
				LDA	#$00
				SEC
				SED
				SBC	(CHARDL),Y
				SEC
				SBC	ORGHOLD
				CLD
				BEQ	:EXIT
				SEC
				LDX	#0
:LOOP1			INX
				SED
				SBC	#$05
				CLD
				BNE	:LOOP1
				INX
				CPX	#$0A
				BCC	:SKIPA
				TXA
				CLC
				ADC	#$06
				TAX
:SKIPA			STX	LOW
:EXIT			RTS

ORGOFF			DB	$20,$60,$30
				DB	$20,$15

LOW				DB	$00
HIGH			DB	$00
ORGHOLD			DB	$00
RANK			DB	$00


LIMIT_RANK		LDY	#level
				LDX	#$99
				LDA	(CHARDL),Y
				BNE	:SKIPA
				INY
				LDA	(CHARDL),Y
				TAX
:SKIPA			STX	RANK
				RTS

*-------------------------------

WARLIM			LDA	#$10
				STA	HIGH
				LDA	RANK
				CMP	#$11
				BCC	:EXIT
				LDA	LOW
				CLC
				SED
				ADC	#$09
				STA	LOW
				LDA	RANK
				CLC
				ADC	#$20
				STA	HIGH
				CLD
				LDA	RANK
				CMP	#$51
				BCC	:EXIT
				LDA	#$45
				STA	HIGH
:EXIT			RTS

*-------------------------------

ANDLIM			LDA	#$08
				STA	HIGH
				LDA	RANK
				CMP	#$11
				BCC	:EXIT
				CLC
				SED
				ADC	#$05
				CLD
				STA	HIGH
				LDA	RANK
				CMP	#$51
				BCC	:EXIT
				LDA	#$40
				STA	HIGH
:EXIT			RTS

*-------------------------------

CYBLIM			LDA	RANK
				CMP	#$11
				BCS	CGT11
				LDA	LOW
				CLC
				SED
				ADC	#$03
				CLD
				STA	HIGH
				RTS
CGT11			CMP	#$21
				BCS	CGT21
				SED
				SEC
				SBC	#$02	
				CLD
				STA	HIGH
				RTS
CGT21			SED
				SEC
				SBC	#$10
				CLD
				STA	HIGH
				CMP	#$26
				BCC	:EXIT
				LDA	#$30
				STA	HIGH
:EXIT			RTS

*-------------------------------

JUILIM			LDA	#$10
				STA	HIGH
				LDA	RANK
				CMP	#$11
				BCC	:EXIT
				CLC
				SED
				ADC	#$05
				CLD
				STA	HIGH
				LDA	RANK
				CMP	#$51
				BCC	:EXIT
				LDA	#$45
				STA	HIGH
:EXIT			RTS

*-------------------------------

PHYLIM			LDA	RANK
				CMP	#$11
				BCS	PGT11
				LDA	LOW
				CLC
				SED
				ADC	#$03
				CLD
				STA	HIGH
				RTS
PGT11			CMP	#$21
				BCS	PGT21
				SED
				SEC
				SBC	#$02
				CLD
				STA	HIGH
				RTS
PGT21			SED
				SEC
				SBC	#$05
				CLD
				STA	HIGH
				CMP	#$36
				BCC	:EXIT
				LDA	#$35
				STA	HIGH
:EXIT			RTS

*-------------------------------
