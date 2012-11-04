*--------------------------------------------
* On Exit:
*    Carry clear: The area is empty
*      Carry set: The area is full or a wall
*              A: New position (if open)
*--------------------------------------------

CAN_SPLIT		JSR	GET_DIMENS
				JSR	RNDMIZE
				LDA	RANDOM1
				ASL
				JSR	SPLIT_LOOK
				BCC	:EXIT
				LDA	RANDOM1
				EOR	#%10000000
				ASL
				JSR	SPLIT_LOOK
:EXIT			RTS

*--------------------------------------------
* On Entry:
*   Carry clear: Look to the right
*     Carry set: Look to the left
*
* On Exit:
*    Carry clear: The area is empty
*      Carry set: The area is full or a wall
*              A: New position (if open)
*--------------------------------------------

SPLIT_LOOK		LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				BCC	:SKIPA
				SBC	#$10
				BNE	:SKIPB			;Always
:SKIPA			ADC	#$10
:SKIPB			CMP	#$60
				BCS	:EXIT
				CMP	#$10
				BCC	:SKIPC
				PHA
				JSR	MON_INDEXER
				LDA	#$FF
				JSR	CHECK_GRID
				PLA
				BCC	:EXIT
:SKIPC			SEC
:EXIT			RTS
