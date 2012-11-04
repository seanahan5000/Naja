*-------------------------------

UNPACK_MASK		STX	PTR1
				STY	PTR1+1
				INC	pTOPLINE
				LDA	pRIGHTCOL
				PHA

				LDY	#-1
				STY	umREP_COUNT
				INY
:1				LDX	pBOTLINE
:2				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH

				LDA	umREP_COUNT
				BPL	:4
				INC	umREP_COUNT
				LDA	(PTR1),Y
				BPL	:3
				AND	#$7F
				STA	umREP_COUNT

				INY
				LDA	(PTR1),Y
:3				STA	umBYTE1

				INY
				TYA
				CLC
				ADC	PTR1
				STA	PTR1
				BCC	:4
				INC	PTR1+1
:4				LDA	umBYTE1

				LDY	pRIGHTCOL
				STA	(SCREENL),Y
:5				LDY	#0
				DEC	umREP_COUNT

				CPX	pTOPLINE
				DEX
				BCS	:2

				LDA	pRIGHTCOL
				DEC	pRIGHTCOL
				CMP	pLEFTCOL
				BNE	:1
				DEC	pTOPLINE
				PLA
				STA	pRIGHTCOL
				RTS

umBYTE1			DB	0
umREP_COUNT		DB	0

*-------------------------------
