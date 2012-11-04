RESET_CHRLIST	LDA	#$00
				BEQ	RESET_COM		;Always
RESET_CHLIST	LDA	#$80
RESET_COM		STA	TEMP
				LDA	#$00
				TAX
:LOOP1			STA	CHAR_LIST,X
				INX
				CPX	GRPNUMB
				BCC	:LOOP1
				LDA	#$FF
				CPX	#16
				BNE	:LOOP1
				LDA	#robot*16
				BIT	TEMP
				BMI	CSCAN_NOTPROF
				RTS

LEGALS
CHAR_LIST		DS	7,0
				DS	9,0


********************************
* On Entry:
*   X = Address of routine low
*   Y = Address of routine high
*   A = Value to check against (optional)
*
* On Exit:
*   CHAR_LIST = Characters that meet criteria
*          $00 means they do
*          $FF means they don't

CSCAN_COMMON	STA	:MOD0+1
				STX	:MOD1+1
				STY	:MOD1+2
				LDA	#6
				STA	COUNT
:LOOP1			LDX	COUNT
				LDA	CHAR_LIST,X
				BNE	:SKIPA
				TXA
				JSR	POINTIT
:MOD0			LDA	#$FF			;Mod
:MOD1			JSR	$FFFF			;Mod
				BEQ	:SKIPA
				LDX	COUNT
				LDA	#$FF
				STA	CHAR_LIST,X
:SKIPA			DEC	COUNT
				BPL	:LOOP1

********************************
* On Entry:
*   CHAR_LIST = Characters that meet criteria
*          $00 means they do
*          $FF means they don't
* On Exit:
*   X = Character that meets criteria
*        (selected at random).  If
*        = $FF then none were found
*   A = Number of characters that
*        meet criteria
*   Carry Set = Some one was found
*   Carry Clear = No one was found

CPICK_ONE		LDY	#$00
				LDX	#6
:LOOP1			LDA	CHAR_LIST,X
				BNE	:SKIPA
				INY
:SKIPA			DEX
				BPL	:LOOP1
				CLC
				TYA
				BEQ	:EXIT
:LOOP2			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$07
				CMP	#$07
				BEQ	:LOOP2
				TAX
				LDA	CHAR_LIST,X
				BNE	:LOOP2
				TYA
				SEC
:EXIT			RTS


*-------------------------------
* Eliminate characters that DO
*   match prof*16 passed in Acc.

CSCAN_NOTPROF	LDX	#<CCALL_NOTPROF
				LDY	#>CCALL_NOTPROF
				BNE	CSCAN_COMMON	;Always

*-------------------------------
* Eliminate characters that DON'T
*   match prof*16, race, X*16 or
*   Y passed in Acc.

CSCAN_PROF		LDX	#$F0
				BNE	PRFRAC_COM		;Always
CSCAN_RACE		LDX	#$0F
PRFRAC_COM		STX	TEMP_HOLD
				LDX	#<CCALL_PRFRACE
				LDY	#>CCALL_PRFRACE
				BNE	CSCAN_COMMON	;Always

CSCAN_X			LDX	#$F0
				BNE	XY_COM			;Always
CSCAN_Y			LDX	#$0F
XY_COM			STX	TEMP_HOLD
				LDX	#<CCALL_POSITN
				LDY	#>CCALL_POSITN
				BNE	CSCAN_COMMON	;Always

*-------------------------------
* Eliminate characters that don't
*   have any free slots to receive
*   equipment

CSCAN_PUTABLE	LDX	#<CCALL_PUTABLE
				LDY	#>CCALL_PUTABLE
				BNE	CSCAN_COMMON	;Always

*-------------------------------
* Eliminate characters that are
*   dead, broken, ranaway, or
*   compressd

CSCAN_NOTDEAD	LDX	#<CCALL_NOTDEAD
				LDY	#>CCALL_NOTDEAD
				BNE	CSCAN_COMMON	;Always


CCALL_NOTPROF	LDY	#profrace
				EOR	(CHARDL),Y
				LDX	#$01
				AND	#%11110000
				BEQ	:SKIPA
				DEX
:SKIPA			TXA
				RTS

CCALL_PRFRACE	LDY	#profrace
				BNE	MERGE			;Always
CCALL_POSITN	LDY	#position
MERGE			EOR	(CHARDL),Y
				AND	TEMP_HOLD
				RTS

CCALL_PUTABLE	JSR	RESET_EQLIST
				JSR	ESCAN_PUTABLE
				TXA
				AND	#$80
				RTS

CCALL_NOTDEAD	LDX	#1
				JSR	BAD_STATUS		;dead,broken,ranaway,abandoned
				BEQ	:SKIPA
				CMP	#compressd
				BEQ	:SKIPA
				DEX
:SKIPA			TXA
				RTS

TEMP_HOLD		DB	0


********************************
********************************
********************************


EQUIP_LIST		DS	16

RESET_EQLIST	LDX	#15
				LDA	#$00
:LOOP1			STA	EQUIP_LIST,X
				DEX
				BPL	:LOOP1

*-------------------------------
* Eliminate slots that wouldn't
*   be visible on the individual
*   stats screen

ESCAN_VISIBLE	LDX	#$FF
				STX	EQUIP_LIST+unused
				LDY	#back
				LDA	(CHARDL),Y						;No back slots higher
				TAY							;   than strength
				TXA
				BNE	:SKIPE						;Always
:LOOP1			STA	EQUIP_LIST+back1,Y
				INY
:SKIPE			CPY	#$06
				BNE	:LOOP1
				LDY	#profrace
				LDA	(CHARDL),Y
				BMI	:SKIPC
				STX	EQUIP_LIST+program			;CHARACTERS
				AND	#%00001111
				CMP	#deneb
				BEQ	:SKIPA
				STX	EQUIP_LIST+lwlft					;No lower hands if not denebian
				STX	EQUIP_LIST+lwrgt
:SKIPA			JMP	EPICK_ONE

:SKIPC			STX	EQUIP_LIST+head						;ROBOTS
				STX	EQUIP_LIST+armor
				STX	EQUIP_LIST+feet
				LDY	#e1_HEAD
				LDA	(CHARDL),Y						;Check for slot
				BPL	:SKIPD
				STX	EQUIP_LIST+slot
:SKIPD			JMP	EPICK_ONE


********************************
* On Entry:
*   X = Address of routine low
*   Y = Address of routine high
*   A = Wildcard byte (optional)
*
* On Exit:
*   EQUIP_LIST = Equipment that meets criteria
*          $00 means it does
*          $FF means it doesn't

ESCAN_COMMON	STA	:MOD0+1
				STX	:MOD1+1
				STY	:MOD1+2
				LDA	#15
				STA	COUNTER
:LOOP1			LDX	COUNTER
				LDA	EQUIP_LIST,X
				BNE	:SKIPA
				LDY	CORESPS,X
:MOD0			LDA	#$FF			;Mod
:MOD1			JSR	$FFFF			;Mod
				BEQ	:SKIPA
				LDX	COUNTER
				LDA	#$FF
				STA	EQUIP_LIST,X
:SKIPA			DEC	COUNTER
				BPL	:LOOP1

********************************
* On Entry:
*   EQUIP_LIST = Equipment that meets criteria
*          $00 means it does
*          $FF means it doesn't
* On Exit:
*   X = Equipment that meets criteria
*        (selected at random).  If
*        = $FF then none were found
*   Y = Position in character data
*        of selected equipment position
*        (invalid if X = $FF)
*   A = Number of equipment positions
*        that meet criteria
*
*   Carry clear: No equipment was found that met criteria
*   Carry set:   Equipment was found that met criteria

EPICK_ONE		LDY	#$00
				LDX	#15
:LOOP1			LDA	EQUIP_LIST,X
				BNE	:SKIPA
				INY
:SKIPA			DEX
				BPL	:LOOP1
				CLC
				TYA
				BEQ	:EXIT
:LOOP2			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$0F
				TAX
				LDA	EQUIP_LIST,X
				BNE	:LOOP2
				TYA
				LDY	CORESPS,X
				SEC
:EXIT			RTS


*-------------------------------
* Eliminate slots with unidentified
*   equipment in them.  Empty ones
*   are skipped.

ESCAN_IDENTED	JSR	ESCAN_FULSLOT
				LDX	#<ECALL_IDENTED
				LDY	#>ECALL_IDENTED
				BNE	ESCAN_COMMON	;Always


*-------------------------------
* Eliminate empty slots

ESCAN_FULSLOT	LDX	#<ECALL_FULSLOT
				LDY	#>ECALL_FULSLOT
				BNE	ESCAN_COMMON	;Always


*-------------------------------
* Eliminate full slots

ESCAN_OPESLOT	LDX	#<ECALL_OPESLOT
				LDY	#>ECALL_OPESLOT
				BNE	ESCAN_COMMON	;Always


*-------------------------------
* Eliminate all undropable equipment
*   (orbs, compressed chars, etc.)

ESCAN_CANDROP	LDX	#<ECALL_CANDROP
				LDY	#>ECALL_CANDROP
				BNE	ESCAN_COMMON	;Always


*-------------------------------
* Select open "putable" slots

ESCAN_PUTABLE	JSR	ESCAN_HANDBCK	;Only hands and back
				JSR	ESCAN_OPESLOT	;   that are open
				LDX	#$FF
				LDY	#profrace
				LDA	(CHARDL),Y
				BPL	:SKIPB
				JSR	RHAND_SUB1
				STX	EQUIP_LIST+roblft
				STX	EQUIP_LIST+robrgt
:SKIPB			LDY	#back
				LDA	(CHARDL),Y
				TAY
				DEY
:LOOP1			LDA	EQUIP_LIST+back1,Y
				BNE	:SKIPC			;Find first open spot on back
				DEY
				BMI	:SKIPC
				LDA	EQUIP_LIST+back1,Y
				BNE	:SKIPC
				TXA					;Eliminate rest of back slots
				STA	EQUIP_LIST+back1+1,Y
				BNE	:LOOP1			;Always
:SKIPC			JMP	EPICK_ONE


*-------------------------------
* Select "dropable" slots

ESCAN_DROPABL	JSR	ESCAN_FULSLOT	;Only full slots
				JSR	ESCAN_CANDROP	; that are dropable
				LDX	#$FF
				LDY	#profrace
				LDA	(CHARDL),Y
				BMI	:SKIPA
				LDY	#e2_SLOT		;If character...
				LDA	(CHARDL),Y		;   eliminate head if slot full
				CMP	#$FF
				BEQ	:SKIPC
				STX	EQUIP_LIST+head
				BNE	:SKIPC			;Always
:SKIPA			STX	EQUIP_LIST+program
				LDY	#e4_ROBLWITH	;If robot...
				LDA	(CHARDL),Y		;   eliminate either hand if carrying
				CMP	#$FF			;   something in them
				BEQ	:SKIPB
				STX	EQUIP_LIST+roblft
:SKIPB			LDY	#e6_ROBRWITH
				LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:SKIPC
				STX	EQUIP_LIST+robrgt
:SKIPC			JMP	EPICK_ONE


*-------------------------------
* Eliminate all but the hand and
*   back slots

ESCAN_HANDBCK	LDA	#$FF
				STA	EQUIP_LIST+head
				STA	EQUIP_LIST+slot
				STA	EQUIP_LIST+armor
				STA	EQUIP_LIST+feet
				STA	EQUIP_LIST+program
				JMP	EPICK_ONE


********************************
				DS	25				;FREE SPACE
********************************

*-------------------------------
* Eliminate miscellaneous
*   illegal slots

ESCAN_LEGAL		LDX	#$FF
				LDY	#profrace
				LDA	(CHARDL),Y
				BMI	:SKIPC
				LDY	#e1_HEAD		;If character...
				LDA	(CHARDL),Y		;  no slot if no helmet
				CMP	#$FF
				BEQ	:SKIPA
				LDY	#e1_HEAD+2		;  no slot if helmet doesn't have one
				LDA	(CHARDL),Y
				BMI	:SKIPB
:SKIPA			STX	EQUIP_LIST+slot
:SKIPB			JMP	EPICK_ONE

:SKIPC			JSR	RHAND_SUB1
				JMP	EPICK_ONE

RHAND_SUB1		LDY	#e3_ROBLFT
				LDA	(CHARDL),Y		;If robot...
				AND	#$5F			;  no "with" if no hand to carry it
				CMP	#$59			;HAND ATTACHMENT
				BEQ	:SKIPA
				STX	EQUIP_LIST+roblwith
:SKIPA			LDY	#e5_ROBRGT
				LDA	(CHARDL),Y
				AND	#$5F			;  for both hands
				CMP	#$59			;HAND ATTACHMENT
				BEQ	:EXIT
				STX	EQUIP_LIST+robrwith
:EXIT			RTS


*-------------------------------
* Eliminate equipment that can't
*   be used by char's profession

ESCAN_RGTPROF	LDX	#<ECALL_RGTPROF
				LDY	#>ECALL_RGTPROF
				JMP	EPICK_ONE



ECALL_RGTPROF	INY
				INY
				INY
				LDA	(CHARDL),Y
				PHA
				LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				TAX
				PLA
				AND	PROUSAB,X
				EOR	PROUSAB,X
				RTS

ECALL_CANDROP	INY
				INY
				LDA	(CHARDL),Y
				AND	#eq_undropable
				RTS

ECALL_FULSLOT	LDA	(CHARDL),Y
				LDX	#$01
				EOR	#$FF
				BEQ	:SKIPA
				DEX
:SKIPA			TXA
				RTS

ECALL_IDENTED	LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:EXIT
				AND	#eq_identified
				EOR	#eq_identified
:EXIT			RTS

ECALL_OPESLOT	LDA	(CHARDL),Y
				EOR	#$FF
				RTS
