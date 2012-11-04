*------------------------------------------------
* On Entry:
*             X: Slot number to remove item from
*      CHARDL,H: Character to remove from
*   TAKEN_COUNT: Number of items already taken
*
* On Exit:
*     Carry set: No equipment could be taken
*   Carry clear: Equipment was taken
*   TAKEN_COUNT: Number of items already taken
*
* NOTE: If no equipment was taken then calling
*   routines assume that X-reg is still intact.
*------------------------------------------------

TAKE_ITEM		LDY	CORESPS,X
				LDA	TAKEN_COUNT
				CMP	#maxfind		;max found in awarder
				BEQ	:EXIT			;Carry assumed set
				INC	TAKEN_COUNT
				STX	:MOD1+1
				ASL
				ASL
				TAX

				LDA	#4
				STA	TEMP
:LOOP1			LDA	(CHARDL),Y
				STA	TAKEN_ITEMS,X
				INY
				INX
				DEC	TEMP
				BNE	:LOOP1

:MOD1			LDX	#$FF			;Modified
				JSR	REMOVE_ITEM
				CLC
:EXIT			RTS
