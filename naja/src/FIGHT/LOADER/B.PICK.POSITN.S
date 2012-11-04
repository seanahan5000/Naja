*-------------------------------------------------
* On Entry:
*   ALIEN_NUMBER: Number of current alien (0 to 3)
*
* On Exit:
*   Carry Clear: No positions were picked
*           Set: At least one position was picked
*-------------------------------------------------

PICK_POSITNS	LDA	#<GRID
				STA	POINTL
				LDA	#>GRID
				STA	POINTH
				LDX	ALIEN_NUMBER
				LDY	ALIEN1,X
				INY
				BEQ	:SKIPC
				TXA
				JSR	POINTALN
				LDA	#0												;To fake out INIT_TVPTR
				JSR	INIT_TVPTR2

				LDA	ALIEN_NUMBER
				ASL
				TAX
				LDA	GBUFF_LIST,X
				STA	TEMP
				LDA	GBUFF_LIST+1,X
				STA	TEMP+1
				LDY	#bytespergroup-1
:LOOP1			LDA	(TEMP),Y
				STA	GROUP_BUFF0,Y
				DEY
				BPL	:LOOP1

				JSR	POSITIONS
				LDA	MONS_NUMBER
				CMP	HMANY1,X
				BEQ	:EXIT			;Carry assumed set
				LDX	ALIEN_NUMBER
				LDA	MONS_NUMBER
				BNE	:SKIPB
:SKIPA			LDA	#$FF
				STA	ALIEN1,X
:SKIPB			STA	HMANY1,X
:SKIPC			CLC
:EXIT			RTS

*---------------------------------------------------------------
* On Entry:
*   GROUP_BUFF0: Grouping format data for current alien
*
* On Exit:
*     MONS_NUMBER: Number of monsters that were positioned
*   POSITION_LIST: Positions that were found for those monsters
*---------------------------------------------------------------

POSITIONS		LDA	#0
				STA	MONS_NUMBER
:LOOP0			JSR	MAKE_FILLGRID
				BCS	:1
				RTS					;No space open
:1				LDY	#0
:LOOP1			LDA	GROUP_BUFF0,Y
				INY
				CMP	#$DD
				BNE	:LOOP1
				LDX	#0
:LOOP2			LDA	GROUP_BUFF0,Y
				CMP	#$FF
				BEQ	:2				;branch to branch to :BAD_DATA
				CMP	MONS_NUMBER
				BEQ	:SKIPF
				BCS	:SKIPA
:SKIPF			INX
				INY
				BNE	:LOOP2			;Always
:SKIPA			LDY	#0
:LOOP3			DEX
				BMI	:SKIPB
:LOOP4			LDA	GROUP_BUFF0,Y
				INY
				CMP	#$DD
:2				BEQ	:BAD_DATA
				CMP	#$CC
				BNE	:LOOP4
				BEQ	:LOOP3			;Always
:SKIPB			STY	FIRST_ONE
:LOOP5			INY
				LDA	GROUP_BUFF0,Y
				AND	#%11101110		;#$CC or #$DD
				CMP	#$CC
				BNE	:LOOP5
				STY	LAST_ONE		;This is exclusive
:LOOP6			CPY	FIRST_ONE
				BEQ	:SKIPC			;None found
				DEY
				LDA	GROUP_BUFF0,Y
				BEQ	:LOOP6
				BNE	:SKIPD			;One found
:SKIPC			LDY	LAST_ONE
				LDA	GROUP_BUFF0,Y
				CMP	#$DD
				BEQ	:BAD_DATA
				INY
				BNE	:SKIPB			;Always
:SKIPD
:LOOP7			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00011111
				CMP	FIRST_ONE
				BCC	:LOOP7
				CMP	LAST_ONE
				BCS	:LOOP7
				TAY
				LDA	GROUP_BUFF0,Y
				BEQ	:LOOP7
				STY	RND_HOLD
				PHA
				JSR	ANY_LEGAL
				PLA
				BCS	:SKIPE
				LDY	RND_HOLD
				LDA	#$00
				STA	GROUP_BUFF0,Y
				LDY	LAST_ONE
				BPL	:LOOP6			;Always
:SKIPE			JSR	RAND_POSITION
				LDX	MONS_NUMBER
				STA	POSITION_LIST,X
				INX
				STX	MONS_NUMBER
				LDX	ALIEN_NUMBER
				LDA	HMANY1,X
				CMP	MONS_NUMBER
				BEQ	:EXIT
				JMP	:LOOP0
:EXIT			RTS

:BAD_DATA		LDA	ALIEN_NUMBER						;**
				LDY	ALIEN1						;**
				LDX	ALIEN2						;**
				DEBUG	"Position error"				;**
				LDA	#$FF
				BNE	:SKIPE			;Always

*-------------------------------------------------
* On Exit:
*   FILLED_GRID: Table of unavailable squares
*                  $00 = available
*                  $FF = unavailable
*   Carry Clear: Nothing available
*           Set: At least one square is available
*-------------------------------------------------

MAKE_FILLGRID	LDX	#24
				LDA	#$FF
:LOOP1			STA	FILLED_GRID,X
				DEX
				BPL	:LOOP1
				LDX	ALIEN_NUMBER
				LDA	TV_WIDTHS,X
				STA	XCOUNT
				LDA	TV_HEIGHTS,X
				STA	HOLD_YCOUNT
				STA	YCOUNT
				LDA	#$16
				STA	COUNT
:LOOP2			JSR	INDEX_SUB
				STY	:MOD1+1
				LDA	#$FF
				JSR	CHECK_GRID
				BCS	:SKIPA
:MOD1			LDY	#$FF			;Modified
				LDA	#$00
				STA	FILLED_GRID,Y
:SKIPA			LDA	HOLD_YCOUNT
				STA	YCOUNT
				LDA	COUNT
				CLC
				ADC	#$10
				STA	COUNT
				CMP	#$60
				BCC	:LOOP2
:SKIPB			AND	#%00001111
				CMP	#$0A
				BCS	:EXIT
				ADC	#$01			;Carry assumed clear
				ORA	#$10
				STA	COUNT
				BNE	:LOOP2			;Always
:EXIT			LDA	#$FF
				JMP	ANY_LEGAL

HOLD_YCOUNT		DB	0

*------------------------------------------------------------
* On Entry:
*   A: Position to check (including random rows and columns)
*
* On Exit:
*   GRID: Contains the newly added monster
*      A: Position where the monster was placed
*------------------------------------------------------------

RAND_POSITION	STA	TEMP+1
:LOOP1			LDA	TEMP+1
				AND	#%11110000
				CMP	#$E0
				BCC	:SKIPA
				JSR	:SUBA
				ASL
				ASL
				ASL
				ASL
:SKIPA			STA	TEMP
				LDA	TEMP+1
				AND	#%00001111
				CMP	#$0E
				BCC	:SKIPB
				JSR	:SUBA
				CLC
				ADC	#$05
:SKIPB			ORA	TEMP
				PHA
				JSR	INDEX_SUB
				PLA
				LDX	FILLED_GRID,Y
				BNE	:LOOP1
				LDX	ALIEN_NUMBER
				LDY	TV_WIDTHS,X
				STY	XCOUNT
				LDY	TV_HEIGHTS,X
				STY	YCOUNT
				PHA
				JSR	INDEX_SUB
				LDA	#$00
				JSR	FILL_GRID
				PLA
				RTS

:SUBA			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00000111
				BEQ	:SUBA
				CMP	#6
				BCS	:SUBA
				RTS


*------------------------------------------------------------
* On Entry:
*   A: Position to check (including random rows and columns)
*   FILLED_GRID: Table of unavailable squares
*                  $00 = available
*                  $FF = unavailable
*
* On Exit:
*   Carry Clear: Nothing available
*           Set: At least one square is available
*------------------------------------------------------------

ANY_LEGAL		TAX
				AND	#$EE
				CMP	#$EE
				BNE	:SKIPA

				LDY	#24
				SEC
:LOOP1			LDA	FILLED_GRID,Y
				BEQ	:EXIT1
				DEY
				BPL	:LOOP1
				CLC					;No open space found
:EXIT1			RTS

:SKIPA			TXA
				AND	#$E0
				CMP	#$E0
				BEQ	:SKIPB

				TXA
				AND	#$0E
				CMP	#$0E
				BEQ	:SKIPC

				TXA					;Scan a single square
				JSR	INDEX_SUB
				SEC
				LDA	FILLED_GRID,Y
				BEQ	:EXIT2
				CLC
:EXIT2			RTS

:SKIPB			TXA					;Scan a ROW
				AND	#%00001111
				ORA	#$10
				JSR	INDEX_SUB
				LDX	#5
				SEC
:LOOP2			LDA	FILLED_GRID,Y
				BEQ	:EXIT3
				INY
				DEX
				BNE	:LOOP2
				CLC					;No open space found
:EXIT3			RTS

:SKIPC			TXA					;Scan a COLUMN
				AND	#%11110000
				ORA	#$0A
				JSR	INDEX_SUB
				LDX	#5
:LOOP3			LDA	FILLED_GRID,Y
				SEC
				BEQ	:EXIT4
				TYA
				CLC
				ADC	#5
				TAY
				DEX
				BNE	:LOOP3
				CLC					;No open space found
:EXIT4			RTS

*-------------------------------

INDEX_SUB		SEC
				SBC	#$05
				JSR	FROM11B
				LDA	TIMES5,Y
				STA	TEMP
				TXA
				CLC
				ADC	TEMP
				TAY
				RTS

TIMES5			DB	0,5,10,15,20

*-------------------------------

GBUFF_LIST		DW	GROUP_BUFF1
				DW	GROUP_BUFF2
				DW	GROUP_BUFF3

*-------------------------------
