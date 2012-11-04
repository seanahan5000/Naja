*=========================================
* This is called from the CONTROL routine
*   at the end of a round and should
*   only directly return if neither the
*   monster nor the character front rows
*   are empty.
*=========================================

OPEN_FRONTS		JSR	MONS_OPENROWS
				JSR	CHAR_OPENROWS
				LDA	COFFSET
				ORA	MOFFSET
				BNE	:0
				RTS					;No front row empty so return

:0				LDA	#$7F			;Retreat
				STA	CHAR_ADVFLAG
				LDY	#2
				JSR	TEXTER
				LDA	#0
				STA	MAXTEXT
				JSR	INPUT2
:1				LDA	TEXTBUF
				CMP	#"A"
				BEQ	:3
				CMP	#"R"
				BEQ	:4
				CMP	#$8D
				BNE	:2
				JSR	CHAROUT
:2				JSR	RECALL
				JMP	:1
:3				LDA	#$FF			;Advance
				STA	CHAR_ADVFLAG
:4				JSR	CLRBOX


*-------------------------------
*
*-------------------------------

RUN_RESOLVER	JSR	MRUN_DECIDER
				JSR	EOR_GRID_DOTS
				JSR	COPY_GRID
				JSR	ERASE_MNAMES

				LDX	MOFFSET			;Calc MONS_GAP and MSRC_BOT
				JSR	TIMES_11
				STA	MONS_GAP
				LDA	#127
				STA	DIVIDER_Y		;Init DIVIDER_Y
				CLC
				SBC	MONS_GAP
				STA	MSRC_BOT
				STA	MDST_BOT

				LDX	COFFSET			;Calc CHAR_GAP and CSRC_TOP
				JSR	TIMES_11
				STA	CHAR_GAP
				SEC
				ADC	DIVIDER_Y
				STA	CSRC_TOP
				STA	CDST_TOP

DO_CHARODDS		LDA	#0
				STA	TEMP
				STA	TEMP+1
				STA	COUNT
:1				JSR	POINTIT
				LDY	#lwreflex
				LDA	(CHARDL),Y
				SED
				CLC
				ADC	TEMP
				CLD
				STA	TEMP
				BCC	:2
				INC	TEMP+1
:2				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:1
				JSR	CMODDS_SUB		;On entry A = GRPNUMB
				TAX
				BNE	:3				;Make sure character
				INX					;  odds are non-zero
:3				STX	CHAR_ODDS

DO_MONODDS		LDA	#0
				PHA
				PHA
				STA	COUNT
				STA	POINTER
:1				JSR	POINTTO
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				BEQ	:2
				CMP	#dead
				BNE	:3
				BEQ	:4				;Always
:2				LDY	#monLOREF
				PLA
				TAX
				PLA
				SED
				CLC
				ADC	(MONS_PTR),Y
				PHA
				TXA
				ADC	#0
				PHA
				CLD
:3				SED
				LDA	COUNT
				CLC
				ADC	#1
				STA	COUNT
				CLD
:4				INC	POINTER
				LDA	POINTER
				CMP	MONS_TOTAL
				BNE	:1
				PLA
				STA	TEMP+1
				PLA
				STA	TEMP
				LDA	COUNT
				JSR	CMODDS_SUB
				STA	MONS_ODDS

CMODDS_DONE		LDA	#0
				STA	C_HEADSTART
				STA	M_HEADSTART

				LDA	MONS_ADVFLAG
				BEQ	:1
				BPL	:2
:1				LDA	CHAR_ADVFLAG
				BMI	BOTH_ADVANCE
				JMP	M_CHASE_C
:2				LDA	CHAR_ADVFLAG
				BMI	C_CHASE_M

BOTH_RETREAT
:1				JSR	C_BACKWARD
				JSR	M_BACKWARD
				BEQ	:1
				JSR	RUN_UPDATE
				LDA	MDST_BOT
				CMP	#71
				BEQ	:2
				LDA	CDST_TOP
				CMP	#183
				BNE	:1
:2				LDA	#%10000000
				STA	GROUP_STATUS
				PLA
				PLA
				JMP	BATTLE_OVER

*-------------------------------

BOTH_ADVANCE
:1				JSR	C_FORWARD
				JSR	M_FORWARD
				BEQ	:1
				JSR	RUN_UPDATE
				LDA	MONS_GAP
				ORA	CHAR_GAP
				BNE	:1
				JMP	RUN_CONCLUDE

*-------------------------------

C_CHASE_M
				LDA	#2
				STA	M_HEADSTART
:1				JSR	C_FORWARD
				JSR	M_BACKWARD
				BEQ	:1
				JSR	RUN_UPDATE
				LDA	MONS_GAP
				BEQ	MONS_CAUGHT
				LDA	MDST_BOT
				CMP	#71
				BNE	:1

MONS_AWAY		LDA	#2
				JSR	CLEAR_TLINE
				LDY	#55				;S>55 The.Alien.Has.Successfully.RET
				LDA	ATALLY			;      Retreated.
				CMP	#1
				BEQ	:1
				INY					;S>56 The.Aliens.Have.Successfully.RET
:1				JSR	SENTENCE_PRET	;      Retreated.
				JSR	DELAYER
				JSR	CLRBOX
				PLA
				PLA
				JMP	BATTLE_OVER

MONS_CAUGHT		LDA	#2
				JSR	CLEAR_TLINE
				LDY	#xThe
				LDA	#xAlien
				JSR	WORD2_INC
				LDA	#$28			;apostrophe
				STA	TEXTBUF-1,X
				STA	TEXTBUF,X
				LDA	#$1D			;s
				LDY	ATALLY
				DEY
				BNE	:1
				STA	TEXTBUF,X
				BEQ	:2				;Always
:1				STA	TEXTBUF-1,X
:2				LDA	#%10000000
				INX
				INX
				BNE	COME_BACK		;Always

*-------------------------------

M_CHASE_C
				LDA	#2
				STA	C_HEADSTART
:1				JSR	C_BACKWARD
				JSR	M_FORWARD
				BEQ	:1
				JSR	RUN_UPDATE
				LDA	CHAR_GAP
				BEQ	CHAR_CAUGHT
				LDA	CDST_TOP
				CMP	#183
				BNE	:1

CHAR_AWAY		LDA	#2
				JSR	CLEAR_TLINE
				LDY	#57				;S>57 The.Group.Has.Successfully.RET
				JSR	SENTENCE_PRET	;     Retreated.
				JSR	DELAYER
				JSR	CLRBOX
				LDA	#%10000000
				STA	GROUP_STATUS
				PLA
				PLA
				JMP	BATTLE_OVER

CHAR_CAUGHT		LDA	#2
				JSR	CLEAR_TLINE
				LDY	#xThe
				LDA	#zGroup
				JSR	WORD2
				JSR	APOSTROPHE_S
				LDA	#%01000000
COME_BACK		STA	SUPRISED_FLAG
				LDY	#58				;S>58 Attempt.To.Retreat.RET
				JSR	SENTENCE_PRET	;     Is.Unsuccessful.
				JSR	DELAYER
				JSR	CLRBOX
				JMP	RUN_CONCLUDE

*-------------------------------

M_FORWARD		LDA	MONS_ADVFLAG
				BEQ	:2
:1				JSR	RNDMIZE
				AND	#%00001111
				CMP	#10
				BCS	:1
				CMP	MONS_ODDS
				BCS	:2
				DEC	CHANGE_FLAG
				DEC	MONS_GAP
				BPL	:2
				INC	MONS_GAP
				INC	DIVIDER_Y
				DEC	CHAR_GAP
				BPL	:2
				INC	CHAR_GAP
:2				LDA	CHANGE_FLAG
				RTS

M_BACKWARD		DEC	M_HEADSTART
				BPL	:2
:1				JSR	RNDMIZE
				AND	#%00001111
				CMP	#10
				BCS	:1
				CMP	MONS_ODDS
				BCS	:3
:2				DEC	CHANGE_FLAG
				INC	MONS_GAP
:3				LDA	CHANGE_FLAG
				RTS

C_FORWARD		LDA	#0
				STA	CHANGE_FLAG
:1				JSR	RNDMIZE
				AND	#%00001111
				CMP	#10
				BCS	:1
				CMP	CHAR_ODDS
				BCS	:2
				DEC	CHANGE_FLAG
				DEC	CHAR_GAP
				BPL	:2
				INC	CHAR_GAP
				DEC	DIVIDER_Y
				DEC	MONS_GAP
				BPL	:2
				INC	MONS_GAP
:2				RTS

C_BACKWARD		DEC	C_HEADSTART
				BPL	:2
				LDA	#0
				STA	CHANGE_FLAG
:1				JSR	RNDMIZE
				AND	#%00001111
				CMP	#10
				BCS	:1
				CMP	CHAR_ODDS
				BCS	:3
:2				DEC	CHANGE_FLAG
				INC	CHAR_GAP
:3				RTS

*-------------------------------

MONS_OPENROWS	LDA	#0
				STA	MOFFSET
				LDX	#24
:1				LDY	#4
:2				LDA	MASTER_MGRID,X
				CMP	#$FF
				BNE	:3
				DEX
				DEY
				BPL	:2
				INC	MOFFSET
				TXA
				BPL	:1
:3				RTS

*-------------------------------

CHAR_OPENROWS	LDA	#0
				STA	COFFSET
				LDX	#0
:1				LDY	#4
:2				LDA	MASTER_CGRID,X
				CMP	#$FF
				BNE	:3
				INX
				DEY
				BPL	:2
				INC	COFFSET
				CPX	#25
				BNE	:1
:3				RTS

*-------------------------------

TIMES_11		LDA	#0
				CLC
:1				DEX
				BMI	:2
				ADC	#11
				BCC	:1				;Always
:2				RTS

*-------------------------------

CMODDS_SUB		LDX	TEMP
				LDY	TEMP+1
				JSR	DIVIDE_12
				TXA
				SED
				CLC
				ADC	#5
				TAX
				TYA
				ADC	#0
				TAY
				CLD
				LDA	#9
				TYA
				BNE	:1
				TXA
				LSR
				LSR
				LSR
				LSR
:1				RTS


*-------------------------------
*
*-------------------------------

RUN_CONCLUDE
:1				LDA	DIVIDER_Y		;Move divider back to center of grid
				CMP	#127
				BEQ	:4
				BCC	:2
				DEC	DIVIDER_Y
				BNE	:3				;Always
:2				INC	DIVIDER_Y
:3				JSR	FAST_UPDATE
				JMP	:1
:4
				LDX	#0				;Update character Y-coordinates
:5				LDA	TEMPCHAR_XY,X
				CLC
				ADC	COFFSET
				STA	TEMPCHAR_XY,X
				INX
				CPX	GRPNUMB
				BNE	:5

				LDA	#0				;Update monster Y-coordinates
				STA	COUNTER
:6				JSR	POINTTO
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				BEQ	:7
				LDY	#monCMDCOUNT	;Forget all current commands
				LDA	#1				;  and parry for 1 time unit
				STA	(MONS_PTR),Y
				INY
				LDA	#cmdPARRY
				STA	(MONS_PTR),Y
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				SEC
				SBC	MOFFSET
				STA	(MONS_PTR),Y
:7				INC	COUNTER
				LDA	COUNTER
				CMP	MONS_TOTAL
				BNE	:6

				JSR	CREATE_CGRID	;Create new character
				JSR	CREATE_MGRID	;  and monster grids
				LDA	MONS_ADVFLAG
				ORA	MOFFSET
				BEQ	:8
				JSR	UPDATE_MNAMES
:8				JMP	EOR_GRID_DOTS


*-------------------------------
*
*-------------------------------

RUN_UPDATE		LDA	#$30
				JSR	WAIT2
				BIT	UNSTROB
FAST_UPDATE		LDA	CDST_TOP		;Current top and bottom lines
				STA	OLD_CDST_TOP	;  become old top and bottom lines
				LDA	MDST_BOT
				STA	OLD_MDST_BOT

				LDA	CHAR_GAP		;Calculate new character top line
				SEC
				ADC	DIVIDER_Y
				STA	CDST_TOP
				SEC
				SBC	OLD_CDST_TOP
				STA	C_DELTA

				LDA	DIVIDER_Y		;Calculate new monster bottom line
				CLC
				SBC	MONS_GAP
				STA	MDST_BOT
				SEC
				SBC	OLD_MDST_BOT
				STA	M_DELTA
				ORA	C_DELTA
				BEQ	:EXIT			;Leave if nothing moved

				LDA	M_DELTA
				BPL	:3
				JSR	MONS_MOVED
				JMP	CHAR_MOVED
:3				JSR	CHAR_MOVED
				JMP	MONS_MOVED
:EXIT			RTS


MONS_MOVED		LDA	MSRC_BOT
				SEC
				SBC	#72
				STA	TEMP
				LDA	MDST_BOT
				SEC
				SBC	#72
				CMP	TEMP
				BCS	:1
				STA	TEMP
:1				LDA	MDST_BOT
				SEC
				SBC	TEMP

				LDX	M_DELTA
				BMI	:3

				PHA					;Monster grid moves downward
				JSR	MONS_MOVER
				PLA
				SEC
				SBC	#72
				BEQ	:5
				LDX	#72
				JMP	EMPTY_LINES

:3				LDA	MDST_BOT
				CMP	#72
				BCC	:4
				JSR	MONS_MOVER		;Monster grid moves upward
:4				LDA	DIVIDER_Y
				CLC
				SBC	MDST_BOT
				BEQ	:5
				BMI	:5
				LDX	MDST_BOT
				INX
				JMP	EMPTY_LINES
:5				RTS


CHAR_MOVED		LDA	#182
				SEC
				SBC	CSRC_TOP
				STA	TEMP
				LDA	#182
				SEC
				SBC	CDST_TOP
				CMP	TEMP
				BCS	:1
				STA	TEMP
:1				LDA	CDST_TOP
				CLC
				ADC	TEMP

				LDX	C_DELTA
				BMI	:3

				LDA	CDST_TOP
				CMP	#183
				BCS	:2
				JSR	CHAR_MOVER		;Move character grid downward
:2				LDA	CDST_TOP
				CLC
				SBC	DIVIDER_Y
				BEQ	:5
				BMI	:5
				LDX	DIVIDER_Y
				INX
				JMP	EMPTY_LINES

:3				PHA					;Move character grid upward
				JSR	CHAR_MOVER
				PLA
				TAX
				STA	TEMP
				LDA	#182
				SEC
				SBC	TEMP
				BEQ	:5
				BMI	:5
				INX
				JMP	EMPTY_LINES
:5				RTS


*-------------------------------
* TEMP = number of lines to move
*-------------------------------

MONS_MOVER		LDA	MSRC_BOT
				SEC
				SBC	TEMP
				TAX
				LDA	MDST_BOT
				SEC
				SBC	TEMP
				STA	TEMP+1
				INC	TEMP
				JSR	CM_MOVER
DRAW_DIVIDER	LDY	DIVIDER_Y
				LDA	LOBYTES,Y
				STA	DESTINL
				LDA	HIBYTES,Y
				ORA	#$20
				STA	DESTINH
				LDY	#11
:1				LDA	$5FA8,Y			;line 127
				STA	(DESTINL),Y
				DEY
				BNE	:1
				RTS

*-------------------------------
* TEMP = number of lines to move
*-------------------------------

CHAR_MOVER		INC	TEMP
				LDX	CSRC_TOP
				LDA	CDST_TOP
				STA	TEMP+1
				JSR	DRAW_DIVIDER
CM_MOVER		LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	TEMP+1
				LDA	LOBYTES,Y
				STA	DESTINL
				LDA	HIBYTES,Y
				ORA	#$20
				STA	DESTINH
				LDY	#11
:1				LDA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				BNE	:1
				INX
				INC	TEMP+1
				DEC	TEMP
				BNE	CM_MOVER
				RTS


*-------------------------------
*
*-------------------------------

EMPTY_LINES		STA	TEMP
:1				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDY	#11
				LDA	#0
:2				STA	(SCREENL),Y
				DEY
				CPY	#1
				BNE	:2
				LDA	#%00000001
				STA	(SCREENL),Y
				INX
				DEC	TEMP
				BNE	:1
				RTS


*-------------------------------
*
*-------------------------------

COPY_GRID		LDX	#71
:1				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#12
:2				LDA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				BPL	:2
				INX
				CPX	#184
				BNE	:1
				RTS


*-------------------------------
*
*-------------------------------

ERASE_MNAMES	LDA	MONS_ADVFLAG
				ORA	MOFFSET
				BEQ	:2
				LDY	#0
				STY	YCOUNT
:1				LDA	YPNTS,Y
				SEC
				SBC	#$36
				STA	YPNT
				LDA	MNAME_TABLE,Y
				PHA
				LDA	#$FF
				STA	MNAME_TABLE,Y
				PLA
				JSR	PRINT_MNAME
				INC	YCOUNT
				LDY	YCOUNT
				CPY	#5
				BNE	:1
:2				RTS


*-------------------------------
*
*-------------------------------

EOR_GRID_DOTS	LDA	#83
				STA	TEMP
				LDA	#0
				STA	TEMP+1
:1				LDX	#3
:2				TXA
				CLC
				ADC	TEMP+1
				TAY
				LDA	MASTER_MGRID,Y
				BMI	:3
				EOR	MASTER_MGRID+6,Y
				AND	#%00111111
				BEQ	:4
:3				LDY	TEMP
				JSR	EOR_DOT
:4				LDA	TEMP
				CLC
				ADC	#55
				TAY
				JSR	EOR_DOT
				DEX
				BPL	:2
				LDA	TEMP+1
				CLC
				ADC	#5
				STA	TEMP+1
				LDA	TEMP
				CLC
				ADC	#11
				STA	TEMP
				CMP	#127
				BNE	:1
				RTS

*-------------------------------
* X = 0 to 3 coordinate
* Y = Screen Y coordinate
*-------------------------------

EOR_DOT			LDA	LOBYTES,Y
				STA	SCREENL
				LDA	HIBYTES,Y
				ORA	PAGE
				STA	SCREENH
				LDY	XTABLE,X
				LDA	(SCREENL),Y
				EOR	STABLE,X
				STA	(SCREENL),Y
				RTS

XTABLE			DB	3,5,7,9
STABLE			DB	%00001000
				DB	%00010000
				DB	%00100000
				DB	%01000000

*-------------------------------

OPEN_TEXT		PLOTAT	99;143;(THERE_IS_SPACE_IN_THE_FRONT)
				PLOTAT	99;152;(ROW_TO_BE_OCCUPIED._WILL_THE)
				PLOTAT	99;161;(GROUP_A>DVANCE_OR)
				PLOTAT	135;170;(R>ETREAT?_)+

* <CHARNAME>_GIVES_THE_RETREAT
* SIGNAL.

* THE_GROUP'S_ATTEMPT_TO_RETREAT
* IS_UNSUCCESSFUL.
*
* THE_ALIEN'S_ATTEMPT_TO_RETREAT
* IS_UNSUCCESSFUL.
*
* THE_ALIENS'_ATTEMPT_TO_RETREAT
* IS_UNSUCCESSFUL.

* THE_ALIEN_IS_RETREATING.
* WILL_THE_GROUP_A>DVANCE OR
* _______________R>ETREAT?_
*
* THE ALIENS ARE RETREATING.
* WILL_THE_GROUP_A>DVANCE OR
* _______________R>ETREAT?_

* THE_GROUP_HAS_SUCCESSFULLY
* RETREATED.
*
* THE_ALIEN_HAS_SUCCESSFULLY
* RETREATED.
*
* THE_ALIENS_HAVE_SUCCESSFULLY
* RETREATED.


*-------------------------------
*
*-------------------------------

MRUN_DECIDER
*     - Clear NEVER_RET,_ADV, VOTE_RET,_ADV,_STAY
				LDX	#4
				LDA	#0
:0				STA	NEVER_RET,X
				DEX
				BPL	:0
				STX	POINTER
* (1) - Get next monster
:1				INC	POINTER
				LDX	POINTER
				LDA	PECKS,X
				BEQ	:7
				BMI	:1
				AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
*     - If monster is dead then (1)
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				BEQ	:1
				TAX
*     - If alien run odds = 0 then NEVER_RET += 1
				LDY	#aRetreatOdds
				LDA	(ALIEN_PTR),Y
				BNE	:2
				INC	NEVER_RET
:2
*     - If alien advance odds = 0 then NEVER_ADV += 1
				LDY	#aAdvanceOdds
				LDA	(ALIEN_PTR),Y
				BNE	:3
				INC	NEVER_ADV
:3
*     - If monster is IMMOBILE/JAMMED/RESTRAINED then
*       - VOTE_STAY += 1
*       - Goto (1)
				CPX	#immobile
				BEQ	:4
				CPX	#controlld
				BNE	:5
:4				INC	VOTE_STAY
				BNE	:1				;Always
:5
*     - If monster already running then VOTE_RET += 1, goto (1)
				LDY	#monFLAGS
				LDA	(MONS_PTR),Y
				BPL	:6
				INC	VOTE_RET
				BNE	:1				;Always
*
*     - Pick a random number
*
				JSR	RNDMIZE
				BPL	:6
*
*       - If random is true then
*         - Call RND_RET subroutine
*         - If result is false then
*           - Call RND_ADV subroutine
*         - Goto (1)
*
				JSR	RND_RET
				BCS	:1
				JSR	RND_ADV
				JMP	:1
*
*       - If random is false then
*         - Call RND_ADV subroutine
*         - If result is false then
*           - Call RND_RET subroutine
*         - Goto (1)
*
:6				JSR	RND_ADV
				BCS	:1
				JSR	RND_RET
				JMP	:1
*
* If ADV >= RET + STAY true and
*    NEVER_ADV false then MONS_ADVFLAG = Advance ($FF)
* If RET >= ADV + STAY true and
*    NEVER_RET false then MONS_ADVFLAG = Retreat ($7F)
* If neither of above are true then MONS_ADVFLAG = Stay ($00)
*
:7				LDA	NEVER_ADV
				BNE	:8
				LDX	#$FF			;Advance
				LDA	VOTE_RET
				CLC
				ADC	VOTE_STAY
				CMP	VOTE_ADV
				BCC	:10
:8				LDA	NEVER_RET
				BNE	:9
				LDX	#$7F			;Retreat
				LDA	VOTE_ADV
				CLC
				ADC	VOTE_STAY
				CMP	VOTE_RET
				BCC	:10
:9				LDX	#$00			;Stay
:10				STX	MONS_ADVFLAG
				RTS


RND_RET
**** MAKE SURE IT'S NOT TOO SOON TO RUN
				LDY	#aRetreatOdds
				LDA	(ALIEN_PTR),Y
				TAY
				JSR	FINAL_ODDS
				BCC	:1
				INC	VOTE_RET
:1				RTS

RND_ADV			LDY	#aAdvanceOdds
				LDA	(ALIEN_PTR),Y
				TAY
				JSR	FINAL_ODDS
				BCC	:1
				INC	VOTE_ADV
:1				RTS

NEVER_RET		DB	0				;These five must be consecutive
NEVER_ADV		DB	0				;  in this order
VOTE_RET		DB	0
VOTE_ADV		DB	0
VOTE_STAY		DB	0
