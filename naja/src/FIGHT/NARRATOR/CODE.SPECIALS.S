*-----------------------------------------------------
* Give all special monsters a chance to set up before
*   the battle or round starts.  This could include
*   initializing variables as well as outputting some
*   pre-battle text.
*-----------------------------------------------------

PRE_ROUND		LDA	#0
				STA	POINTER
:LOOP1			LDX	POINTER
				LDA	PECKS,X
				BMI	:SKIPA
				BEQ	:EXIT
				JSR	POINTTO
				LDX	#0
				JSR	PRE_COMMON
:SKIPA			INC	POINTER
				BNE	:LOOP1			;Always
:EXIT			RTS

*-----------------------------------------------------------
* On Entry:
*    MONS_PTR: Pointing to the current monster
*   ALIEN_PTR: Pointing to the current alien
*
* On Exit:
*   Carry Clear: Nothing was done, execute normal code
*     Carry Set: Special code took care of it; fall through
*-----------------------------------------------------------

PRE_PICK		LDX	#2				;Before picking alien command
				BPL	PRE_COMMON		;Always
PRE_ATTACK		LDX	#4				;Before executing alien command
				BPL	PRE_COMMON		;Always
PRE_ATTACKED	LDX	#6				;Before executing character command
				BPL	PRE_COMMON		;Always
PRE_DEATH		LDX	#8				;Before alien dies

PRE_COMMON		CLC
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				LDA	SCODE_PRESENT,X
				BNE	:SKIPA
				RTS

:SKIPA			TXA
				TAY
				LDA	SCODE_HOLDPTR
				STA	TEMP
				LDA	SCODE_HOLDPTR+1
				STA	TEMP+1
				JSR	USE_OFFSET
				CLC
				JMP	(TEMP)


*-----------------------------------
* On Entry:
*   A: Forward offset to data table
*
* On Exit:
*   X,Y,P: Preserved
*
*      LDA  #MY_SUB-:1
*  :1  JSR  CALL_REL
*-----------------------------------

CALL_REL		STX	:MOD1+1
				ROR	:MOD2+1
				SEC
				SBC	#2
				TSX
				INX
				CLC
				ADC	STACK,X
				STA	:MOD3+1
				INX
				LDA	#0
				ADC	STACK,X
				STA	:MOD3+2
:MOD1			LDX	#$FF			;Modified
:MOD2			LDA	#$FF			;Modified
				ASL
:MOD3			JMP	$FFFF			;Modified

*-----------------------------------
* On Entry:
*   A: Forward offset to data table
*
* On Exit:
*   X,Y: True address of data table
*
*      LDA  #DATA-:1
*  :1  JSR  GET_RELPTR
*-----------------------------------

GET_RELPTR		SEC
				SBC	#2
				TSX
				INX
				CLC
				ADC	STACK,X
				PHA
				INX
				LDA	#0
				ADC	STACK,X
				TAY
				PLA
				TAX
				RTS

*-----------------------------------
