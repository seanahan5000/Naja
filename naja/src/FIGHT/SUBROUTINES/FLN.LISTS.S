*---------------------------------------------------------
* On Entry:
*       A: Alien number to match with
*     X,Y: Address of list structure
*   SHELL: Current shell
*
* On Exit:
*     Carry set: Match WAS found
*   Carry clear: Match was NOT found
*       TEMP,+1: Address of entry that matched (if found)
*             A: Third byte of entry (if found)
*             Y: 3 (if match found)
*
* Uses:
*   TEMP,+1
*---------------------------------------------------------

SEARCH_LIST		STX	TEMP
				STY	TEMP+1
				STA	:MOD1+1
				LDY	#0
				LDA	(TEMP),Y
				TAX
				INY
				LDA	(TEMP),Y
				STA	:MOD2+1
				LDA	TEMP
				CLC
				ADC	#2
				STA	TEMP
				BCC	:LOOP1
				INC	TEMP+1
:LOOP1			LDY	#0
				LDA	(TEMP),Y
				INY
:MOD1			CMP	#$FF			;Modified
				BNE	:SKIPB
				LDA	(TEMP),Y
				CMP	SHELL
				BEQ	:SKIPD
:SKIPB			LDA	TEMP
				CLC
:MOD2			ADC	#$FF			;Modified
				STA	TEMP
				BCC	:SKIPC
				INC	TEMP+1
:SKIPC			DEX
				BNE	:LOOP1
				CLC
				RTS

:SKIPD			INY
				LDA	(TEMP),Y
				INY
				SEC
				RTS


*------------------------------------------
* LIST STRUCTURE
*
*  +0  (byte)  number of entries
*  +1  (byte)  bytes per entry (x)
*
*      Entry #1
*  +2  (byte)  shell
*  +3  (byte)  alien number
*  +4  (x-2 bytes) rest of data (optional)
*
*  and so on...
*------------------------------------------
