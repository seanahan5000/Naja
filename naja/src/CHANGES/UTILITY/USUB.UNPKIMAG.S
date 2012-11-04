*-------------------------------

UNPACK_IMAGE	STX	PTR1
				STY	PTR1+1
				INC	pTOPLINE
				LDA	pRIGHTCOL
				PHA
				LDY	#0
				STY	UREP_COUNT
:2				LDX	pBOTLINE
:3				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH

				LDA	UREP_COUNT
				BNE	:7
				INC	UREP_COUNT

				LDA	(PTR1),Y
				INY
				CMP	#REPFLAG
				BNE	:5
				LDA	(PTR1),Y
				BNE	:4
				INY					;***
				LDA	(PTR1),Y		;***
				STA	UREP_COUNT		;***
				INY
				LDA	(PTR1),Y
				STA	UBYTE1			;*** WAS 2
				INY
				LDA	(PTR1),Y
				INY
				BNE	:6				;Always
:4				INY
				STA	UREP_COUNT
				LDA	(PTR1),Y
				INY
:5				STA	UBYTE1			;*** WAS 2
:6				STA	UBYTE2			;*** WAS 1
				TYA
				CLC
				ADC	PTR1
				STA	PTR1
				BCC	:7
				INC	PTR1+1
:7				LDA	UBYTE1
*BEQ :8
				LDY	pRIGHTCOL
				STA	(SCREENL),Y
:8				CMP	UBYTE2
				BEQ	:9
				LDY	UBYTE2
				STA	UBYTE2
				STY	UBYTE1
:9				LDY	#0
				DEC	UREP_COUNT

				CPX	pTOPLINE
				DEX
				BCS	:3

				LDA	pRIGHTCOL
				DEC	pRIGHTCOL
				CMP	pLEFTCOL
				BNE	:2
				DEC	pTOPLINE
				PLA
				STA	pRIGHTCOL
				RTS

UBYTE1			DB	0
UBYTE2			DB	0
UREP_COUNT		DB	0

*-------------------------------
