*==========================================================
* On Entry:
*   A: Number of monster to point to
*
* On Exit:
*          MONS_PTR: Address of data for current monster
*      ALIEN_PTR,+1: Address of that monster's race data
*  SCODE_HOLDPTR,+1: Address of the monster's special code
*  TVIEW_HOLDPTR,+1: Address of that monster's topview
*       TVIEW_(all): All various bytes of topview info
*
* Uses:
*   TEMP,+1
*==========================================================

POINTTO			STX	:MOD1+1			;Preserves the X register
				JSR	GET_MONSPTR
				STX	MONS_PTR
				STY	MONS_PTR+1

				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				PHA
				LDY	#0
:LOOP1			LDA	TV_COUNTS,X
				STA	TVIEW_COUNT,Y
				INX
				INX
				INX
				INY
				CPY	#8
				BNE	:LOOP1
				PLA
				JSR	POINTALN

				LDY	#4				;code
				JSR	USE_OFFSET
				STX	SCODE_HOLDPTR
				STY	SCODE_HOLDPTR+1

				JSR	INIT_TVPTR
:MOD1			LDX	#$FF			;Modified
				RTS


*------------------------------------
* On Entry:
*   A:Number of monster to point to
*
* On Exit:
*   TEMP,+1: Address of monster data
*       X,Y: Address of monster data
*------------------------------------

				ERR	20-bytespermons
GET_MONSPTR		LDY	#>MONSTR0
				CMP	#$0D
				BCC	:SKIPA
				INY
:SKIPA			STY	TEMP+1
				AND	#%00011111
				ASL
				ASL
				STA	TEMP			;times 4
				ASL
				ASL
				CLC
				ADC	TEMP			;plus times 16
				STA	TEMP			;equals times 20
				TAX
				RTS


*-----------------------------------------------------------
* On Entry:
*   A: # of alien to point to (0 to 2)
*
* On Exit:
*   ALIEN_PTR,+1: Address of that alien's data
*        TEMP,+1: Address of alien's offset table
*-----------------------------------------------------------

POINTALN		TAX
				LDA	#<ALIEN_HEAP
				STA	TEMP
				LDA	#>ALIEN_HEAP
				STA	TEMP+1
				JSR	ADVANCE_PTR
				LDA	TEMP
				CLC
				ADC	#2
				STA	TEMP
				BCC	:SKIPA
				INC	TEMP+1
:SKIPA			LDY	#0				;data
				JSR	USE_OFFSET
				STX	ALIEN_PTR
				STY	ALIEN_PTR+1
				RTS


*======================================================
* On Entry:
*       TEMP,+1: Pointing to the alien offset table
*
* On Exit:
*   TVIEW_HOLDPTR,+1: Pointing to topview image
*       TVIEW_DIMENS: Dimensions (in chars) of topview
*       TVIEW_OFFSET: Offset of topview
*
* Uses:
*   TEMP,+1
*======================================================

INIT_TVPTR		LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
INIT_TVPTR2		STA	:MOD1+1
				LDY	#2				;topviews
				JSR	USE_OFFSET
				STX	TEMP
				STY	TEMP+1
:MOD1			LDA	#$FF			;Modified
				AND	#%00000111
				TAX
				JSR	ADVANCE_PTR
				LDY	#2
				LDA	(TEMP),Y
				STA	TVIEW_DIMENS
				INY
				LDA	(TEMP),Y
				STA	TVIEW_OFFSET
				LDA	TEMP
				CLC
				ADC	#4
				STA	TVIEW_HOLDPTR
				LDA	TEMP+1
				ADC	#0
				STA	TVIEW_HOLDPTR+1
				RTS


*-----------------------------------
* On Entry:
*         X: # of offsets to skip
*   TEMP,+1: Pointing to old offset
*
* On Exit:
*   TEMP,+1: Pointing to new offset
*-----------------------------------

ADVANCE_PTR		TXA
				BEQ	:EXIT
:LOOP1			LDY	#1
				LDA	(TEMP),Y
				PHA
				DEY
				LDA	(TEMP),Y
				CLC
				ADC	TEMP
				STA	TEMP
				PLA
				ADC	TEMP+1
				STA	TEMP+1
				DEX
				BNE	:LOOP1
:EXIT			RTS

*---------------------------------------------
* On Entry:
*   TEMP,+1: Pointing to alien's offset table
*         Y: Offset number times 2 to use
*
* On Exit:
*   X,Y: New pointer value
*---------------------------------------------

USE_OFFSET		LDA	(TEMP),Y
				CLC
				ADC	TEMP
				TAX
				INY
				LDA	(TEMP),Y
				ADC	TEMP+1
				TAY
				RTS

*-------------------------------
