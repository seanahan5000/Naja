CALC_VALUE		LDA	ETABLE
				AND	#$1F
				LDY	#0
:LOOP1			CMP	CLUMPS,Y
				BEQ	:SKIPA
				INY
				BNE	:LOOP1
:SKIPA			CPY	#$0E
				BCS	GETODD1
				CPY	#$09			;Miscellaneous group
				BNE	GOTC3
				LDA	ETABLE+1
				AND	#$07
				CMP	#$02
				BCC	GOTC3
				LDA	#0				;Price of orbs, etc. is 0
				LDX	#3
:LOOP2			STA	THE_PRICE,X
				DEX
				BPL	:LOOP2
				RTS

GOTC3			TYA
				ASL
				TAX
				STA	CHUNK
				LDA	CODEOFF,X
				STA	TEMP
				LDA	CODEOFF+1,X
				STA	TEMP+1
				LDX	#0
:LOOP1			TXA
				ASL
				ASL
				TAY
				INY
				LDA	ETABLE+1
				CMP	(TEMP),Y
				BNE	:SKIPA
				INY
				LDA	ETABLE+2
				CMP	(TEMP),Y
				BEQ	GOTDATA
:SKIPA			INX
				BNE	:LOOP1

GOTDATA			STX	DSPLACE
				LDX	CHUNK
				LDA	PRICOFF,X
				STA	TEMP
				LDA	PRICOFF+1,X
				STA	TEMP+1
				LDA	DSPLACE
				ASL
				CLC
				ADC	DSPLACE
				TAY
				LDX	#0
GOLOOP1			LDA	(TEMP),Y
				STA	PRODUCT_3,X
				INY
				INX
				CPX	#3
				BNE	GOLOOP1
				JMP	GOVERIT

GETODD1			CPY	#$0E
				BNE	NOTPROG
				LDA	ETABLE+1
				AND	#$7F
				LDY	#0
GELOOP1			CMP	PROGS,Y
				BEQ	PROGOT
				INY
				BNE	GELOOP1
PROGOT			STY	SCRATCH
				TYA
				ASL
				CLC
				ADC	SCRATCH
				TAY
				LDX	#0
GELOOP2			LDA	RPROPRI,Y
				STA	PRODUCT_3,X
				INY
				INX
				CPX	#3
				BNE	GELOOP2
				LDA	ETABLE+1
				BPL	GOGOVER
				CLC
				SED
				LDA	PRODUCT_3+2
				ADC	#$50
				STA	PRODUCT_3+2
				LDA	PRODUCT_3+1
				ADC	#$00
				STA	PRODUCT_3+1
				CLD
GOGOVER			JMP	GOVERIT

NOTPROG			TYA
				AND	#$01
				CLC
				ADC	#$0D
				LDX	WANTED1
				STA	WANTED1
				TXA
				PHA
				CPY	#$10
				BNE	HELPART
				LDX	ETABLE+1
				TXA
				AND	#$38
				LSR
				LSR
				LSR
				STA	BRNCURS
				TXA
				AND	#$07
				STA	BRNCURS+1
				LDA	ETABLE+2
				ROL
				ROL
				AND	#$01
				CLC
				ADC	#$03
				STA	BRNCURS+2
				BNE	HACOMN			;Always
HELPART			LDX	ETABLE+1
				TXA
				AND	#$0C
				LSR
				LSR
				CLC
				ADC	#$01
				STA	BRNCURS
				TXA
				AND	#$03
				CLC
				ADC	#$02
				STA	BRNCURS+1
				LDA	ETABLE+2
				ROL
				ROL
				AND	#$01
				CLC
				ADC	#$03
				STA	BRNCURS+2
HACOMN			JSR	AHPRICE
				PLA
				STA	WANTED1
				LDX	#3
:LOOP1			LDA	THE_PRICE,X
				STA	PRODUCT_4,X
				DEX
				BPL	:LOOP1

GOVERIT			LDA	#0
				STA	PRODUCT_5
				STA	PRODUCT_5+1
				LDA	FACTOR
				LDX	#<PRODUCT_4
				LDY	#>PRODUCT_4
				JSR	MULTIPLY_14
				LDX	#3
:LOOP1			LDA	PRODUCT_5,X
				STA	THE_PRICE,X
				DEX
				BPL	:LOOP1
				RTS

CLUMPS			DB	$0C,$0D,$0E
				DB	$08,$0F,$00
				DB	$07,$01,$02
				DB	$03,$06
				DB	$19,$18,$1C
				DB	$1A,$05,$04
