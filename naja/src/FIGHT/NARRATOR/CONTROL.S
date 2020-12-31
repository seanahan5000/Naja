BATTLER			JSR	CLEAR2
				JSR	CLRBOX

				LDA	ROUND			;*** MOVE THIS TO LOADER ???
				BNE	:2
				LDX	#13
:1				STA	DURATION_TABL,X
				DEX
				BPL	:1
:2
				BIT	SUPRISED_FLAG
				BVC	START
				LDA	#$37
				STA	ROUND_LENGTH+1
START			LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDX	COUNT
				LDY	#position
				LDA	(CHARDL),Y
				STA	TEMPCHAR_XY,X
				LDA	#$00
				STA	COMNUMS,X
				STA	CTIME_COUNTS,X
				LDY	#e2_SLOT
				LDA	(CHARDL),Y
				CMP	#$40
				BNE	:SKIPA
				INY
				LDA	(CHARDL),Y
				CMP	#$01
				BNE	:SKIPA
				LDY	#status
				LDA	(CHARDL),Y
				BMI	:SKIPA
				JSR	BAD_STATUS
				BEQ	:SKIPA
				LDA	#$FF			;Have image generator
				BNE	:SKIPB			;Always
:SKIPA			LDA	#$00			;Don't have image generator
:SKIPB			STA	IMAGENS,X
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

				LDA	#GREEN
				JSR	MODE_SUB
				JSR	PECKING_ORDER

INIT_GRIDS		JSR	CREATE_MGRID
				JSR	CREATE_CGRID
				JSR	DRAW_IMAGENS

INIT_CHARS		LDA	#0
				STA	GROUP_STATUS
				STA	POINTER
:LOOP1			LDX	POINTER
				LDA	PECKS,X
				BEQ	INIT_ALIENS
				BPL	:SKIPA
				AND	#$7F
				STA	CHAR_NUMBER
				JSR	POINTIT
				JSR	GETIME
				LDX	CHAR_NUMBER
				STA	CTIME_COUNTS,X
:SKIPA			INC	POINTER
				BNE	:LOOP1			;Always

INIT_ALIENS		JSR	PRE_IDENTIFY
				LDA	ROUND_LENGTH+1
				STA	THROUGH
				LDA	#0
				STA	POINTER
:1				LDX	POINTER
				LDA	PECKS,X
				BMI	:2
				BEQ	:3
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	INIT_MCOMMAND
:2				INC	POINTER
				BNE	:1				;Always
:3

*===============================
*
*===============================

ROUND_LENGTH	LDA	#$73			;Modified
				STA	THROUGH
UNIT_LOOP		LDA	#0
				STA	POINTER
COMMAND_LOOP	LDX	POINTER
				LDA	PECKS,X
				BNE	:1
				JMP	TUNIT_OVER
:1				ASL
				BPL	CHARPEC
*-------------------------------
MONSPEC			LSR
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				BEQ	:2

				LDY	#monSTATCOUNT	;Check if monster has a non-zero
				LDA	(MONS_PTR),Y	;  timed status counter
				INY
				ORA	(MONS_PTR),Y
				BEQ	:1
				LDA	(MONS_PTR),Y	;If so, subtract one from that counter
				SEC
				SED
				SBC	#1
				CLD
				STA	(MONS_PTR),Y
				TAX
				DEY
				LDA	(MONS_PTR),Y
				SED
				SBC	#0
				CLD
				STA	(MONS_PTR),Y
				BNE	:2				;If that counter reaches zero,
				TXA
				BNE	:2
				JSR	DESTATUS_MONS	;  then remove the status
				JMP	:2
:1				LDY	#monCMDCOUNT
				LDA	(MONS_PTR),Y
				SEC
				SED
				SBC	#1
				STA	(MONS_PTR),Y
				CLD
				BNE	NOTIME
				JSR	NARRATE_MONS
:2				JMP	NOTIME
*-------------------------------
CHARPEC			LSR
				STA	CHAR_NUMBER
				JSR	COMCALC
				LDA	CHAR_NUMBER
				JSR	POINTIT
				JSR	BAD_STATUS
				BCS	NOTIME
				LDX	CHAR_NUMBER
				LDA	CTIME_COUNTS,X
				SEC
				SED
				SBC	#$01
				STA	CTIME_COUNTS,X
				CLD
				BNE	:1
				JSR	NARRATE_CHAR
:1				LDA	CHAR_NUMBER
				ASL
				TAX
				LDA	DURATION_TABL,X
				ORA	DURATION_TABL+1,X
				BEQ	NOTIME
				LDA	DURATION_TABL+1,X
				SEC
				SED
				SBC	#1
				STA	DURATION_TABL+1,X
				TAY
				LDA	DURATION_TABL,X
				SBC	#0
				STA	DURATION_TABL,X
				CLD
				BNE	NOTIME
				TYA
				BNE	NOTIME
				JSR	DESTATUS_CHAR
*-------------------------------
NOTIME			INC	POINTER
				JMP	COMMAND_LOOP	;Always

TUNIT_OVER		JSR	GROUP_TYPER
				BVS	BATTLE_OVER
				LDA	ATALLY
				BNE	:SKIPA
*** UPDATE STATUS DURATION TABLE
***   AND NOTIFY IF STATUS WORE OFF
				LDA	#$07
				CMP	THROUGH
				BCS	:SKIPA
				STA	THROUGH
:SKIPA			LDA	THROUGH
				SED
				SEC
				SBC	#$01
				CLD
				STA	THROUGH
				BEQ	ROUND_OVER
				JSR	PECKING_ORDER
				JMP	UNIT_LOOP

ROUND_OVER		JSR	ABANDON
				JSR	GROUP_TYPER
				BVS	BATTLE_OVER2
				LDX	ATALLY
				BEQ	BATTLE_OVER2
				LDA	#0
				STA	SUPRISED_FLAG
				JSR	OPEN_FRONTS		;Does not always return here
				INC	ROUND
				BNE	:1
				DEC	ROUND
:1				JSR	UPDATE_STAT
				JSR	DRAW_IMAGENS
				JSR	UPDATE_POSITN
				LDA	#BLACK1
				JSR	MODE_SUB
				LDA	#$62
				PHA
				LDA	#$FF
				PHA
				LDX	#fCommand
				JMP	SLOAD_FILE

BATTLE_OVER		JSR	ABANDON
				JSR	GROUP_TYPER
BATTLE_OVER2	JSR	RESTOR_POSITN
				JSR	REMOVE_STATS
				LDA	#BLACK1
				JSR	MODE_SUB

				BIT	GROUP_STATUS
				BVS	ALL_DEAD

			do	DEBUG_KEYS
				BIT	$C061				; left-option/alt
				BMI	FORCE_DEAD
			fin

				LDA	#$8F
				PHA
				LDA	#$FF
				PHA
				LDX	#fAwarder
				JMP	SLOADER_FILE

			do	DEBUG_KEYS
FORCE_DEAD		LDA	#$00
				STA	GRPNUMB
			fin

ALL_DEAD		LDA	#$7F
				PHA
				LDA	#$FF
				PHA
				LDX	#fDeadGroup
				JMP	SLOAD_FILE

*-------------------------------

RESTOR_POSITN	LDX	#7
:LOOP1			LDA	CHARXY,X
				STA	TEMPCHAR_XY,X
				DEX
				BPL	:LOOP1

UPDATE_POSITN	LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDX	COUNT
				LDA	TEMPCHAR_XY,X
				LDY	#position
				STA	(CHARDL),Y
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS

*-------------------------------

UPDATE_STAT		LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%00100000		;Fight only status
				BEQ	:SKIPB
				LDY	#inflictnums
				LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:SKIPB
				CMP	#$01
				BNE	:SKIPA

				JSR	CLEAR_TLINE1
				LDY	#37				;SENTENCE 37
				JSR	SENTENCE_RET
				JSR	STATUSR
				JSR	PERIOD_RETURN
				JSR	DELAYER
				JSR	CLRBOX
				JSR	DEFIGHT_STAT

:SKIPA			LDY	#inflictnums
				LDA	(CHARDL),Y
				BEQ	:SKIPB
				SEC
				SED
				SBC	#$01
				CLD
				STA	(CHARDL),Y
:SKIPB			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS

*-------------------------------

REMOVE_STATS	LDA	#0
				STA	COUNT
:LOOP1			LDA	COUNT
				JSR	POINTIT
				JSR	DEFIGHT_STAT
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS

*-------------------------------

DEFIGHT_STAT	LDY	#status
				LDA	(CHARDL),Y
				AND	#%00100000
				BEQ	:EXIT
				LDA	(CHARDL),Y
				AND	#%11000000
				STA	(CHARDL),Y
				LDY	#inflictnums	;DRUGS SHOULD DO THIS WHEN
				LDA	#0				;   THEY WEAR OFF TOO
				STA	(CHARDL),Y
				JMP	CALC_ALL
:EXIT			RTS


*-------------------------------

ABANDON			LDA	#0
				STA	COUNT
:LOOP1			JSR	ABANDONABLE
				BCC	:SKIPA
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%11000000
				ORA	#abandoned
				STA	(CHARDL),Y
				JSR	CALC_ALL
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS

ABANDONABLE		TAX
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				CLC
				BPL	:EXIT
				LDY	#robotcyblink
				LDA	(CHARDL),Y
				STA	TEMP
				TXA
				PHA

				LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#disklocation
				LDA	(CHARDL),Y
				CMP	TEMP
				BEQ	:SKIPA
				INC	COUNT
				LDA	COUNT
				BNE	:LOOP1			;Always

:SKIPA			JSR	BAD_STATUS
				PLA
				STA	COUNT
				PHP
				JSR	POINTIT
				PLP
:EXIT			RTS


*----------------------------------------------
* On Exit:
*   GROUP_STATUS (AB......)
*      A = Run away group
*      B = Dead group
*
*   Overflow clear: NOT time to leave narrator
*     Overflow set: IS time to leave narrator
*----------------------------------------------

GROUP_TYPER		LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				BEQ	:SKIPA			;healthy
				AND	#%00111100
				BNE	:SKIPA			;dead,broken,abandoned
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				LDA	#%01000000
				ORA	GROUP_STATUS
				STA	GROUP_STATUS
:SKIPA			BIT	GROUP_STATUS
				RTS


*-------------------------------
*
*-------------------------------

MODE_SUB		STA	COLOR
				LDY	#0
				LDA	DELAY_MODE
				BEQ	:SKIPA
				INY
:SKIPA			JSR	TEXTER
				LDY	#1
				JMP	LINER


*-------------------------------
*
*-------------------------------

PECKING_ORDER	LDA	#0
				STA	POINTER
:LOOP1			JSR	POINTIT
				LDX	POINTER
				TXA
				ORA	#$80
				STA	PECKS,X
				LDY	#upreflex
				LDA	(CHARDL),Y
				INY					;lwreflex
				CLC
				SED
				ADC	(CHARDL),Y
				CLD
				STA	VALUES,X
				INC	POINTER
				LDA	POINTER
				CMP	GRPNUMB
				BNE	:LOOP1

				LDA	#$00
				STA	COUNTER
:LOOP2			JSR	POINTTO
				LDA	COUNTER
				ORA	#$40
				LDX	POINTER
				STA	PECKS,X
				LDY	#monLOREF
				LDA	(MONS_PTR),Y
				INY					;monUPREF
				CLC
				SED
				ADC	(MONS_PTR),Y
				CLD
				STA	VALUES,X
				INC	POINTER
				INC	COUNTER
				LDA	COUNTER
				CMP	MONS_TOTAL
				BNE	:LOOP2

				LDX	POINTER
				LDA	#0
				STA	PECKS,X
				STA	VALUES,X
BUBBLE_SORT		LDY	#$00
				STY	TEMP
:LOOP1			LDA	VALUES,Y
				CMP	VALUES+1,Y
				BCS	:SKIPA
				TAX
				LDA	VALUES+1,Y
				STA	VALUES,Y
				TXA
				STA	VALUES+1,Y
				LDX	PECKS,Y
				LDA	PECKS+1,Y
				STA	PECKS,Y
				TXA
				STA	PECKS+1,Y
				SEC
				ROR	TEMP
:SKIPA			INY
				LDA	PECKS+1,Y
				BNE	:LOOP1
				LDA	TEMP
				BMI	BUBBLE_SORT
				RTS

*-------------------------------
