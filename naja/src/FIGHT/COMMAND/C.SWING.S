SWING			LDA	#$00	
				JSR	SELECT_HAND
				JSR	GETUSCO
				JSR	SET_LEGALS
				LDA	#$00
				STA	LEGALS
				STA	LEGALS+1
				STA	LEGALS+2
				LDX	USEDLOC
				LDA	HANDTAB,X
				BEQ	HAND_SWING
				CMP	#5				;robo sword/dagger
				BNE	:SKIPB
				LDY	CONVERT_TABLE,X
				INY
				LDX	#1				;dagger
				LDA	(CHARDL),Y
				BEQ	:SKIPA
				INX					;sword
:SKIPA			TXA
:SKIPB			CMP	#3
				BNE	NONWHIP_SWING

WHIP_SWING		LDA	#$FF
				STA	LEGALS+2
				JSR	PICK_SWING
				LDY	#3
				JSR	BOXSUB
				JSR	SBOTTOMR
				LDY	#7
				LDA	#1
				LDX	SWTYPE
				BNE	SWING_COMMON
				DEY
				LDA	#3
				BNE	SWING_COMMON	;Always

HAND_SWING		LDY	#3				;Hand ignores SWTYPE value
				JSR	BOXSUB
				JSR	SBOTTOMR
				LDY	#1
				TYA
				BNE	SWING_COMMON	;Always

NONWHIP_SWING	JSR	PICK_SWING
				JSR	SBOTTOMR
				LDY	#3
				TYA
				LDX	SWTYPE
				BEQ	SWING_COMMON
				LDY	#3
				JSR	BOXSUB
				LDY	#$15
				LDX	SWTYPE
				DEX
				BEQ	:SKIPA
				DEY
:SKIPA			STY	:MOD1+1
				JSR	TEXTER
				JSR	PICK_OF_3
:MOD1			LDY	#$FF			;Modified
				JSR	TEXTER
				LDY	TCURSOR
				TYA

SWING_COMMON	STY	DEBOXMOD+1
				ASL
				ASL
				ASL
				STA	INSTR2
				CPY	#3
				BEQ	:SKIPA
				JSR	BOXSUB
:SKIPA			LDY	#$1C
				JSR	TEXTER
				LDX	#$7F
				LDY	#$8F
				JSR	NUMBER_SIGN
				LDX	#<LIMIT_SWNSHT
				LDY	#>LIMIT_SWNSHT
				JSR	GET_MULTIPLE
				PHP
DEBOXMOD		LDY	#$FF			;Modified
				JSR	BOXSUB
				JSR	SWNSHT_UNDO
				PLP
				BCS	:SKIPA
				JMP	DIDCANC
:SKIPA			LDA	#cmdSWING
				STA	INSTR1
				LDX	USEDLOC
				LDA	HANDTAB,X
				ASL
				ASL
				ASL
				ASL
				ASL
				ORA	INSTR2
				STA	INSTR2
				LDX	PLANNER
				LDA	XYSPOTS,X
				LSR
				LSR
				LSR
				LSR
				AND	#%00000111
				ORA	INSTR2
				STA	INSTR2
				LDA	SWTYPE
				ASL
				ASL
				ASL
				AND	#%00010000
				ORA	INSTR1
				STA	INSTR1
				JSR	CHANDER
				LDA	TIMES+timeSWING
				STA	TIMTAKE
				LDA	HOWCUR1
				ASL
				ASL
				ASL
				ASL
				ORA	HOWCUR2
:LOOP1			STA	HOWCUR1
				JSR	POST_COMMAND
				JSR	TAKE_ENERUSE
				LDA	COMCNT
				CMP	#15
				BEQ	:EXIT
				LDA	HOWCUR1
				SEC
				SED
				SBC	#1
				CLD
				BNE	:LOOP1
:EXIT			JMP	DIDCANC

*-------------------------------

PICK_OF_3		LDA	CURSOR
				PHA
				LDX	#<BOX_CURSOR
				LDY	#>BOX_CURSOR
				JSR	SET_GCURSOR
				LDX	PLANNER
				LDA	XYSPOTS,X
				AND	#$F0
				ORA	#$06
				STA	CURSOR
				AND	#$F0
				SEC
				SBC	#$10
				STA	TEMP
				STA	LEFTMOST+1
				CLC
				ADC	#$20
				STA	TEMP+1

				LDA	SWTYPE	
				CMP	#$01
				BNE	:SKIPB
				LDA	CURHOLD
				CMP	#$04
				BCS	:SKIPB

				LSR
				BCC	:SKIPA
				LDA	TEMP
				CLC
				ADC	#$10
				STA	TEMP
				BNE	:SKIPB			;Always
:SKIPA			LDA	TEMP+1
				SEC
				SBC	#$10
				STA	TEMP+1
:SKIPB			LDA	TEMP
				BNE	:SKIPC
				LDA	#$10
:SKIPC			ORA	#$06
				TAX
				LDA	TEMP+1
				CMP	#$60
				BCC	:SKIPD
				LDA	#$50
:SKIPD			ORA	#$06
				TAY
				LDA	#$00			;No wrap-around
				JSR	GET_GRIDCURS
				PHP
				LDA	CURSOR
				SEC
LEFTMOST		SBC	#$FF			;Modified
				LSR
				LSR
				LSR
				LSR
				STA	TCURSOR
				JSR	DRAW_GRIDCURS
				PLP
				PLA
				STA	CURSOR
				BCS	:EXIT
				PLA
				PLA
				JMP	DIDCANC
:EXIT			RTS

*-------------------------------

PICK_SWING		LDY	#$0F
				JSR	TEXTER
				LDX	#<SWING_CDEF
				LDY	#>SWING_CDEF
				JSR	FULL_GETKEY
				LDA	CURSOR
				STA	SWTYPE
				BCS	:EXIT
				LDY	#$03
				JSR	BOXSUB
				PLA
				PLA
				JMP	DIDCANC
:EXIT			JMP	CLRBOXZ

SWING_CDEF		DB	$02
				DB	$00
				DW	:SWING_CURS
:SWING_CURS		LDX	CURSOR
				LDY	:YTABLE,X
				LDX	#$88
				JMP	ARROWER
:YTABLE			DB	$93,$9D,$A7

*-------------------------------

GETUSCO			LDX	CURSOR
				CPX	#$04
				BCC	USEDCOM	
				BNE	NOTOP1
				LDX	#$00
				LDA	HANDTAB	
				BNE	USEDCOM
				INX
				BNE	USEDCOM			;Always
NOTOP1			LDX	#$02
				LDA	HANDTAB+2	
				BNE	USEDCOM
				INX	
USEDCOM			STX	USEDLOC
				LDA	CURSOR
				STA	CURHOLD
				RTS

*-------------------------------

CHANDER			LDA	USEDLOC
				AND	#$01
				BEQ	LESKIP
				LDA	#$40
				ORA	INSTR1
				STA	INSTR1
LESKIP			LDA	CURHOLD
				CMP	#$04
				BCC	TWOSKIP
				LDA	#$20
				ORA	INSTR1
				STA	INSTR1
				LDA	CURHOLD
				AND	#$01
				BEQ	ULSKIP
LAZY			LDA	#$80
				ORA	INSTR1
				STA	INSTR1
				BNE	ULSKIP
TWOSKIP			LDA	CURHOLD
				AND	#$02
				BNE	LAZY
ULSKIP			RTS	

*------------------------------------------------------
*
* On Entry:
*   Y -> Box pattern number
*
*     +---+---+---+   +---+---+---+   +   +---+---+
*     | 0 | 1 | 2 |   |     3     |       |   4   |
*     +---+---+---+   +---+---+---+   +   +---+---+
*          <C>             <C>             <C>
*
*     +---+---+   +   +---+---+---+   +   +---+   +
*     |   5   |       |           |       |   |
*     +---+---+   +   +   +---+   +   +   + 7 +   +
*          <C>        |   | 6 |   |       |   |
*                     +---+---+---+   +   +---+   +
*                          <C>             <C>
*

BOXSUB			LDA	BOFFSET,Y
				STA	COUNTER	
:LOOP1			LDY	COUNTER
				LDA	BDATA,Y
				BMI	:SKIPA
				JSR	BOXCALC
				INC	COUNTER	
				BNE	:LOOP1			;Always
:SKIPA			AND	#$7F

BOXCALC			PHA
				AND	#$0F	
				STA	SCRATCH
				LDX	PLANNER
				LDA	XYSPOTS,X
				AND	#$F0	
				TAX
				PLA
				AND	#$F0	
				BEQ	SUB1
				CMP	#$20	
				BEQ	ADD1	
				TXA
				BNE	COMN3
ADD1			TXA
				CLC
				ADC	#$10	
				CMP	#$60	
				BCS	BRET
				BCC	COMN3
SUB1			TXA
				SEC
				SBC	#$10	
				TAX
				AND	#$F0
				BEQ	BRET
				TXA
COMN3			ORA	SCRATCH
				STA	CURSOR	
				JMP	BOX_CURSOR
BRET			RTS

BOFFSET			DB	0,1,2,3
				DB	6,8,10,15

BDATA			DB	$86
				DB	$96
				DB	$A6
				DB	$06,$16,$A6
				DB	$16,$A6
				DB	$06,$96
				DB	$06,$07,$17,$27,$A6
				DB	$16,$97
