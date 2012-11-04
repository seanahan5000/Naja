*-------------------------------

PACK_MASK		LDA	#<DATA_BUFFER+4
				STA	PTR1
				LDA	#>DATA_BUFFER+4
				STA	PTR1+1

				LDA	pBOTLINE
				STA	pmLINE
				LDA	pRIGHTCOL
				STA	pmCOLUMN

:1				JSR	pmGET_BYTE
				STA	pmBYTE1
				BCS	:5
				JSR	pmPUSH

				LDA	#0
				STA	pmREP_COUNT
:2				JSR	pmGET_BYTE
				BCS	:3
				CMP	pmBYTE1
				BNE	:3
				INC	pmREP_COUNT
				BPL	:2
				DEC	pmREP_COUNT
:3				JSR	pmPULL

				LDA	pmREP_COUNT
				CMP	#2
				BCC	:4
				JSR	pmADVANCER
				LDA	pmREP_COUNT
				ORA	#$80
				JSR	pmPUT_BYTE
:4				LDA	pmBYTE1
				JSR	pmPUT_BYTE
				JMP	:1
:5				RTS

*-------------------------------

pmPUSH			LDA	pmLINE
				STA	HOLD_pmLINE
				LDA	pmCOLUMN
				STA	HOLD_pmCOLUMN
				RTS

pmPULL			LDA	HOLD_pmLINE
				STA	pmLINE
				LDA	HOLD_pmCOLUMN
				STA	pmCOLUMN
				RTS

*-------------------------------

pmGET_BYTE		LDX	pmLINE
				LDY	pmCOLUMN
				CPX	pTOPLINE
				BNE	:1
				CPY	pLEFTCOL
				SEC
				BMI	:2
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDA	(SCREENL),Y
				AND	#$7F
				JSR	pmADVANCE1
				CLC
:2				RTS

pmADVANCE1		LDX	pmLINE
				DEC	pmLINE
				CPX	pTOPLINE
				BNE	:1
				LDX	pBOTLINE
				STX	pmLINE
				DEC	pmCOLUMN
:1				RTS

pmADVANCER		STA	:TEMP
:1				JSR	pmADVANCE1
				DEC	:TEMP
				LDA	:TEMP
*CMP #$FF
				BNE	:1
:2				RTS

:TEMP			DB	0

*-------------------------------

pmPUT_BYTE		LDY	#0
				STA	(PTR1),Y
				INC	PTR1
				BNE	:1
				INC	PTR1+1
:1				RTS

*-------------------------------

pmBYTE1			DB	0
pmREP_COUNT		DB	0
pmLINE			DB	0
pmCOLUMN		DB	0
HOLD_pmLINE		DB	0
HOLD_pmCOLUMN	DB	0

*-------------------------------
