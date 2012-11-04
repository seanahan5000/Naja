*-------------------------------

PACK_IMAGE		LDA	#<DATA_BUFFER+4
				STA	PTR1
				LDA	#>DATA_BUFFER+4
				STA	PTR1+1

				LDA	pBOTLINE
				STA	PLINE
				LDA	pRIGHTCOL
				STA	PCOLUMN

:1				JSR	GET_BYTE
				STA	BYTE1
				BCS	:7
				JSR	PUSH
				JSR	RUN_SINGLE
				LDA	SREP_COUNT
				SEC
				SBC	#3
				BPL	:2
				LDA	#0
:2				STA	HOLD_SAVE
				JSR	PULL
				JSR	PUSH
				JSR	GET_BYTE
				STA	BYTE2
				JSR	RUN_DOUBLE
				JSR	PULL
				LDA	DREP_COUNT
				SEC
				SBC	#5
				BMI	:3
				BEQ	:3
				CMP	HOLD_SAVE
				BCS	:5
:3				LDA	HOLD_SAVE
				BNE	:4
				LDA	BYTE1
				CMP	#REPFLAG
				BNE	:6
:4				JSR	PACK_SINGLE
				JMP	:1
:5				JSR	PACK_DOUBLE
				JMP	:1
:6				LDA	BYTE1
				JSR	PUT_BYTE
				JMP	:1
:7				RTS

HOLD_SAVE		DB	0

*-------------------------------

PUSH			LDA	PLINE
				STA	HOLD_PLINE
				LDA	PCOLUMN
				STA	HOLD_PCOLUMN
				RTS

PULL			LDA	HOLD_PLINE
				STA	PLINE
				LDA	HOLD_PCOLUMN
				STA	PCOLUMN
				RTS

*-------------------------------

PACK_SINGLE		LDA	#REPFLAG
				JSR	PUT_BYTE
				LDA	SREP_COUNT
				JSR	PUT_BYTE
				LDA	BYTE1
				JSR	PUT_BYTE
				LDA	SREP_COUNT
				JMP	ADVANCER

*-------------------------------

RUN_SINGLE		LDA	#1
				STA	SREP_COUNT
:1				JSR	GET_BYTE
				BCS	:3
				CMP	BYTE1
				BNE	:2
				INC	SREP_COUNT
				BNE	:1
				DEC	SREP_COUNT
:2				CLC
:3				RTS

*-------------------------------

PACK_DOUBLE		LDA	#REPFLAG
				JSR	PUT_BYTE
				LDA	#0
				JSR	PUT_BYTE
				LDA	DREP_COUNT
				JSR	PUT_BYTE
				LDA	BYTE1
				JSR	PUT_BYTE
				LDA	BYTE2
				JSR	PUT_BYTE
				LDA	DREP_COUNT
				JMP	ADVANCER

*-------------------------------

RUN_DOUBLE		LDA	#2
				STA	DREP_COUNT
:1				JSR	GET_BYTE
				BCS	:3
				CMP	BYTE1
				BNE	:2
				JSR	GET_BYTE
				BCS	:3
				CMP	BYTE2
				BNE	:2
				INC	DREP_COUNT
				INC	DREP_COUNT
				BNE	:1
				DEC	DREP_COUNT
				DEC	DREP_COUNT
:2				CLC
:3				RTS

*-------------------------------

GET_BYTE		LDX	PLINE
				LDY	PCOLUMN
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
				JSR	ADVANCE1
				CLC
:2				RTS

ADVANCE1		LDX	PLINE
				DEC	PLINE
				CPX	pTOPLINE
				BNE	:1
				LDX	pBOTLINE
				STX	PLINE
				DEC	PCOLUMN
:1				RTS

ADVANCER		STA	:TEMP
:1				DEC	:TEMP
				BEQ	:2
				JSR	ADVANCE1
				JMP	:1
:2				RTS

:TEMP			DB	0

*-------------------------------

PUT_BYTE		LDY	#0
				STA	(PTR1),Y
				INC	PTR1
				BNE	:1
				INC	PTR1+1
:1				RTS

*-------------------------------

BYTE1			DB	0
BYTE2			DB	0
SREP_COUNT		DB	0
DREP_COUNT		DB	0
PLINE			DB	0
PCOLUMN			DB	0
HOLD_PLINE		DB	0
HOLD_PCOLUMN	DB	0

*-------------------------------
