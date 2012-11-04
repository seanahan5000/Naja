*===============================
*
*===============================

CREATE_MGRID	LDX	#24
				LDA	#$FF
:1				STA	MASTER_MGRID,X
				STA	AUX_MGRID,X
				DEX
				BPL	:1
				LDA	#0
				STA	POINTER
:2				LDX	POINTER
				LDA	PECKS,X
				BEQ	:4
				BMI	:3
				AND	#$3F
				STA	MONS_NUMBER
				JSR	POINTTO
**** CHECK FOR SPECIAL THINGS LIKE BEING INVISIBLE, ETC.
				LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				BEQ	:3
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				JSR	MONS_TOGRID
				LDY	#monCRNTCMD
				LDA	(MONS_PTR),Y
				AND	#%00001111
				CMP	#cmdMOVE
				BNE	:3
				INY
				LDA	(MONS_PTR),Y
				JSR	PRE_FILLCHK1
				ORA	#%01000000
				LDX	#%10111111
				JSR	FILL_GRID
:3				INC	POINTER
				BNE	:2				;Always
:4				RTS


*===============================
*
*===============================

MONS_FROMGRID	LDX	#24
:1				LDA	AUX_MGRID,X
				AND	#%10111111
				CMP	MONS_NUMBER
				BNE	:2
				LDA	#$FF
				STA	AUX_MGRID,X
				LDA	MASTER_MGRID,X
				AND	#%10111111
				CMP	MONS_NUMBER
				BNE	:2
				LDA	#$FF
				STA	MASTER_MGRID,X
:2				DEX
				BPL	:1
				RTS

*======================================
* On Entry:
*   A: XY coordinate to place alien at
*======================================

MONS_TOGRID		JSR	PRE_FILLCHK2
				ORA	#%01000000
				LDX	#%10111111
				JSR	FILL_GRID
				LDX	#24
:1				LDA	MASTER_MGRID,X
				TAY
				AND	#%10111111
				CMP	MONS_NUMBER
				BNE	:2
				TYA
				STA	AUX_MGRID,X
:2				DEX
				BPL	:1
				RTS

*-------------------------------
*
*-------------------------------

PRE_FILLCHK1	LDX	#<AUX_MGRID
				LDY	#>AUX_MGRID
				BNE	PRE_FC			;Always
PRE_FILLCHK2	LDY	#monPOSITION
				LDA	(MONS_PTR),Y
PRE_FILLCHK3	LDX	#<MASTER_MGRID
				LDY	#>MASTER_MGRID
PRE_FC			STX	POINTL
				STY	POINTH
				LDX	TVIEW_WIDTH
				STX	XCOUNT
				LDY	TVIEW_HEIGHT
				STY	YCOUNT
				JSR	MON_INDEXER
				LDA	MONS_NUMBER
				RTS


*===============================
*
*===============================

UPDATE_MNAMES	LDA	#4
				STA	YCOUNT

:LOOP1			LDA	YCOUNT
				ASL
				ASL
				ADC	YCOUNT			;Carry assumed clear
				STA	:MOD1+1
				ADC	#4				;Carry assumed clear
				STA	XCOUNT

				LDA	#%11111111		;empty
				STA	MNAME_TYPE

:LOOP2			LDX	XCOUNT
				LDA	MASTER_MGRID,X
				BMI	:SKIPC
				ASL
				BPL	:SKIPC
				LSR
				AND	#%00111111
				JSR	POINTTO
				LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
				BPL	:SKIPB

				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				AND	#%00011111
				STA	MNAME_TYPE
				BPL	:SKIPC			;Always

:SKIPB			LDA	MNAME_TYPE		;Check if higher priority
				AND	#%11100000		;   name already picked
				BEQ	:SKIPC
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAY
				LDA	ALTYPE1,Y
				AND	#%11000000
				STA	MNAME_TYPE

:SKIPC			LDA	XCOUNT
				DEC	XCOUNT
:MOD1			CMP	#$FF			;Modified
				BNE	:LOOP2

				LDY	YCOUNT
				LDA	YPNTS,Y
				SEC
				SBC	#$36
				STA	YPNT
				LDA	MNAME_TABLE,Y
				CMP	MNAME_TYPE
				BEQ	:SKIPD
				JSR	PRINT_MNAME
				LDY	YCOUNT
				LDA	MNAME_TYPE
				STA	MNAME_TABLE,Y
				JSR	PRINT_MNAME
:SKIPD			DEC	YCOUNT
				BPL	:LOOP1
				LDA	MONS_NUMBER		;Restore monster pointers
				JMP	POINTTO

*-------------------------------

PRINT_MNAME		TAY
				AND	#%00100000
				BNE	:EXIT
				JSR	CLEAR_TEXT
				TYA
				AND	#%11100000
				BEQ	:SKIPA
				TYA
				JSR	MNAME_UNIDENT
				JMP	:SKIPB

:SKIPA			TYA
				AND	#%00011111
				JSR	POINTALN
				LDX	#0
				JSR	MNAME_IDENTIF
:SKIPB			LDA	#$66
				LDY	YPNT
				JSR	LINE
:EXIT			RTS

MNAME_TYPE		DB	0


*===============================
*
*===============================

CHANGE_CGRID	JSR	CAPTURE_CGRID
				JSR	CREATE_CGRID
				JMP	UPDATE_CGRID

*-------------------------------

CREATE_CGRID	LDX	#24
:LOOP1			LDA	#$FF
				STA	MASTER_CGRID,X
				DEX
				BPL	:LOOP1

				LDA	#0
				STA	COUNT
:LOOP2			JSR	POINTIT
				JSR	BAD_STATUS
				BEQ	:SKIPA
				LDX	COUNT
				LDA	TEMPCHAR_XY,X
				JSR	CHAR_INDEXER
				STX	TEMP
				LDA	COUNT
				STA	MASTER_CGRID,Y
				TAX
				LDA	IMAGENS,X
				BEQ	:SKIPA
				LDA	TEMP
				CMP	#$04
				BEQ	:SKIPA
				INY
				LDA	MASTER_CGRID,Y
				CMP	#$FF
				BNE	:SKIPA
				LDA	COUNT
				ORA	#$80
				STA	MASTER_CGRID,Y
:SKIPA			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP2
				LDA	CHAR_NUMBER		;Take note of this
				JSR	POINTIT
				RTS

*-------------------------------

CAPTURE_CGRID	LDX	#$18
:LOOP1			LDA	MASTER_CGRID,X
				STA	OLD_CGRID,X
				DEX
				BPL	:LOOP1
				RTS

*-------------------------------

UPDATE_CGRID	LDA	#$00
				STA	XCOUNT
				STA	YCOUNT
				STA	COUNT
:LOOP1			LDX	COUNT
				LDA	OLD_CGRID,X
				CMP	MASTER_CGRID,X
				BEQ	:SKIPA
				JSR	:SUBA
				LDX	COUNT
				LDA	MASTER_CGRID,X
				JSR	:SUBA
:SKIPA			INC	XCOUNT
				LDA	XCOUNT
				CMP	#5
				BNE	:SKIPB
				LDA	#0
				STA	XCOUNT
				INC	YCOUNT
:SKIPB			INC	COUNT
				LDA	COUNT
				CMP	#25
				BNE	:LOOP1
				LDA	CHAR_NUMBER		;Take note of this
				JSR	POINTIT
				RTS

:SUBA			TAY
				CMP	#$FF
				BEQ	:EXIT
				AND	#$80
				STA	SCRATCH
				TYA
				AND	#$7F
				JSR	POINTIT
				LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				ORA	SCRATCH
				LDX	XCOUNT
				LDY	YCOUNT
				JMP	TVIEWIT
:EXIT			RTS

*-------------------------------
