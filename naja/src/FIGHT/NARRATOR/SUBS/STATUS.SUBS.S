*----------------------------------------------
* On Entry;
*         A: Status to inflict
*   TEMP,+1: Duration of status (BCD low,high)
*
* On Exit:
*     Carry set: Status DID take hold
*   Carry clear: Status did NOT take hold
*             X: #0
*----------------------------------------------

STATUS_MONS		STA	HOLD_STATUS
				JSR	ENUMERATE
				STA	HOLD_ENUM

				LDA	TEMP
				ORA	TEMP+1
				BEQ	TRY_FAILED

				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#healthy
				BEQ	DO_ALL

				JSR	ENUMERATE
				TAY
				LDX	HOLD_ENUM
				BEQ	TRY_IMMBLZING
				TYA
				BEQ	TRY_FAILED
				DEX
				BEQ	TRY_BLINDING

TRY_STUNNING	DEY
				BEQ	DO_MAX
DO_ADD			LDY	#monSTATCOUNT+1
				LDA	(MONS_PTR),Y
				SED
				CLC
				ADC	TEMP
				STA	(MONS_PTR),Y
				DEY
				LDA	(MONS_PTR),Y
				ADC	TEMP+1
				STA	(MONS_PTR),Y
				CLD
				BCC	POST_TRY
				LDA	#$99
				STA	(MONS_PTR),Y
				INY
				STA	(MONS_PTR),Y
				BCS	POST_TRY		;Always

TRY_BLINDING	DEY
				BEQ	DO_ADD
DO_MAX			JSR	CAN_OVERRIDE
				BCS	DO_ALL
TRY_FAILED		LDX	#0
				CLC
				RTS

TRY_IMMBLZING	TYA
				BNE	DO_ALL
				JSR	CAN_OVERRIDE
				BCC	POST_TRY

DO_ALL			LDY	#monSTATCOUNT
				LDA	TEMP+1
				STA	(MONS_PTR),Y
				INY
				LDA	TEMP
				STA	(MONS_PTR),Y
				LDY	#monSTATUS
				LDA	HOLD_STATUS
				STA	(MONS_PTR),Y

POST_TRY		LDX	#0
				LDY	HOLD_ENUM
				BEQ	:4				;Immobile has special blink
				DEY
				BEQ	:3				;Blind does nothing extra
				DEY
				BEQ	:1
				LDY	#72				;S>72 Into.The.MonsName
				BNE	:2				;Always
:1				LDY	#18				;S>18 And.Is.Obeyed
:2				JSR	SENTENCE_PRET
:3				JSR	BLINK_MONS
				JMP	:5
:4				JSR	IMMOB_BLINK
:5				LDA	#6
				JSR	CLEAR_TLINE
				LDY	#xMonsName
				LDA	#xIs
				JSR	WORD2_INC
				LDY	HOLD_ENUM
MON_STATWORD	LDA	:MSTATS,Y
				TAY
				JSR	WORD1_PRDRET
				SEC
				RTS
:MSTATS			DB	xImmobile
				DB	xBlinded
				DB	xRestrained
				DB	xJammed

CAN_OVERRIDE	LDY	#monSTATCOUNT+1
				SED
				SEC
				LDA	TEMP
				SBC	(MONS_PTR),Y
				DEY
				LDA	TEMP+1
				SBC	(MONS_PTR),Y
				CLD
				RTS

ENUMERATE		LDX	#0				;Don't change Y-reg
				CMP	#immobile
				BEQ	:1
				INX
				CMP	#blind
				BEQ	:1
				INX
				CMP	#stunned
				BEQ	:1
				INX
:1				TXA
				RTS

HOLD_STATUS		DB	0
HOLD_ENUM		DB	0


*-------------------------------
*
*-------------------------------

DESTATUS_MONS	LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				PHA
				LDA	#healthy
				STA	(MONS_PTR),Y
				PLA
				JSR	ENUMERATE
				PHA
				JSR	CLEAR_TLINE1
				LDY	#xMonsName
				JSR	WORD1_INC
				LDY	#37				;S>37 Is.No.Longer
				JSR	SENTENCE_RET
				PLA
				TAY
				JSR	MON_STATWORD
				JSR	DELAYER
				JMP	CLRBOX


*-------------------------------
*
*-------------------------------

DESTATUS_CHAR	JSR	STATUSR
				JSR	TRAP_WORD
				JSR	CLEAR_TLINE1
				LDY	#xCharsName
				JSR	WORD1_INC
				LDY	#37				;S>37 Is.No.Longer
				JSR	SENTENCE_INC
				JSR	WRITE_WORD
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%11000000
				STA	(CHARDL),Y
				JSR	CALC_ALL
				JSR	DELAYER
				JMP	CLRBOX


TRAP_WORD		LDX	#0
:1				LDA	TEXTBUF,X
				STA	$BB00,X
				INX
				CMP	#$8D
				BNE	:1
				RTS

WRITE_WORD		LDY	#0
:1				LDA	$BB00,Y
				CMP	#$8D
				BEQ	:2
				STA	TEXTBUF,X
				INX
				INY
				BNE	:1				;Always
:2				JMP	PERIOD_RETURN
