*--------------------------------------------------------
* On entry:
*   X,Y point to a data structure:
*
*   MinMax cursor position (byte)
*   Starting position (byte)
*      If high bit set, clear out LEGALS for minmax range
*   Address of cursor routine (word)
*   Address of destination table (word) optional
*
* On exit:
*   Carry Set if SPACE BAR pressed
*   Carry Clear if INTERCEPT routine caught something
*   DESTINATION set up with a jump to the address from
*      destination table that corresponds with the cursor
*   CURSOR holds the current position


DESTINATION		JMP	$FFFF
INTERCEPT		JMP	$FFFF
ERASE_CURSOR	JMP	$FFFF
DRAW_CURSOR		JMP	$FFFF
ARROWER			STX	XPNT
				STY	YPNT
				JMP	ACURSIT

YPOINTS			DFB	$0C,$14,$1C
				DFB	$24,$2C,$34
				DFB	$3C
				DFB	$46,$58,$62
				DFB	$6C

INIT_CURSOR		STX	TEMP
				STY	TEMP+1
				LDY	#$00
				LDA	(TEMP),Y
				TAX
				AND	#$0F
				STA	MAXIMUM
				TXA
				LSR
				LSR
				LSR
				LSR
				STA	MINIMUM
				INY
				LDA	(TEMP),Y
				PHP
				AND	#%01111111
				STA	CURSOR
				INY
				LDA	(TEMP),Y
				STA	ERASE_CURSOR+1
				STA	DRAW_CURSOR+1
				INY
				LDA	(TEMP),Y
				STA	ERASE_CURSOR+2
				STA	DRAW_CURSOR+2
				INY
				LDA	(TEMP),Y
				STA	JUMP_TABLE1+1
				STA	JUMP_TABLE2+1
				INY
				LDA	(TEMP),Y
				STA	JUMP_TABLE1+2
				STA	JUMP_TABLE2+2
				PLP
				BPL	:SKIPA
				LDX	MINIMUM
				LDA	#$00
:LOOP1			STA	LEGALS,X
				CPX	MAXIMUM
				INX
				BCC	:LOOP1
:SKIPA			JSR	DOWN_SUB2
				LDA	#<:EXIT
				STA	INTERCEPT+1
				LDA	#>:EXIT
				STA	INTERCEPT+2
:EXIT			RTS

BLINK_LOOP		LDA	#$10
				JSR	WAIT
				LDA	#$F0
				JSR	WAIT2
				BMI	GETKEY2
				CLC
				JSR	ERASE_CURSOR
				LDA	#$00
				JSR	WAIT2
GETKEY			CLC
				JSR	DRAW_CURSOR
GETKEY2			SEC
				JSR	INTERCEPT
				BCC	BLINK_OUT
				INC	RANDOM1
				LDA	KEYBRD
				BPL	BLINK_LOOP
				BIT	UNSTROB
				JSR	CHECK_UP
				BEQ	UP
				JSR	CHECK_DOWN
				BEQ	DOWN
				JSR	CHECK_ENTER
				BNE	GETKEY2
				LDA	CURSOR
				ASL
				TAY
JUMP_TABLE1		LDA	$FFFF,Y
				STA	DESTINATION+1
				INY
JUMP_TABLE2		LDA	$FFFF,Y
				STA	DESTINATION+2
				SEC
				JSR	ERASE_CURSOR
				SEC
BLINK_OUT		RTS

UP				SEC
				JSR	ERASE_CURSOR
UP2				LDY	CURSOR
				DEY
				CPY	MINIMUM
				BPL	:1
				LDY	MAXIMUM
:1				STY	CURSOR
				LDA	LEGALS,Y
				BNE	UP2
				SEC
				JSR	DRAW_CURSOR
				JMP	GETKEY2

DOWN			SEC
				JSR	ERASE_CURSOR
DOWN2			JSR	DOWN_SUB1
				SEC
				JSR	DRAW_CURSOR
				JMP	GETKEY2

DOWN_SUB1		LDA	CURSOR
				INC	CURSOR
				CMP	MAXIMUM
				BNE	DOWN_SUB2
				LDA	MINIMUM
				STA	CURSOR
DOWN_SUB2		LDY	CURSOR
				LDA	LEGALS,Y
				BNE	DOWN_SUB1
				RTS

MINIMUM			DB	0
MAXIMUM			DB	0
