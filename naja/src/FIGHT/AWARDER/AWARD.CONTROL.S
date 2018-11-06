*-------------------------------------------------
* It is assumed that on entry to this code,
*   battle-only illnesses have already been cured
*   and characters are in their normal positions.
*
* Group gets credit and experience for all
*   aliens killed even if the group runs away
*   before all of the aliens are killed.
*
* GROUP_STATUS is setup by Fight Narrator
*   AB......
* A = Run away group
* B = All dead, broken, abandoned
*
*-------------------------------------------------

AWARDER			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				LDA	#GREEN
				STA	COLOR
				LDY	#$00
				JSR	LINER
				LDY	#$01
				JSR	LINER
				LDY	#$00
				JSR	TEXTER
				LDY	#$00
				JSR	PICKER
				LDY	#$01
				JSR	PICKER
				LDY	#$02
				JSR	PICKER

				LDA	#$41			;Draw group stats table
				STA	SELECT
				LDA	#$02
				STA	YPNT
				JSR	HEADER
				LDY	#0
:LOOP2			STY	COUNT
				LDA	YPOINTS,Y
				STA	YPNT
				TYA
				JSR	STATLIN
				INC	COUNT
				LDY	COUNT
				CPY	GRPNUMB
				BNE	:LOOP2

				LDA	TAKEN_COUNT
				STA	FOUND_COUNT
				LDX	#19
:LOOP1			LDA	TAKEN_ITEMS,X
				STA	FOUND_ITEMS,X
				DEX
				BPL	:LOOP1

			do 0
			else
				; It looks like odds of finding equipment and what equipment
				;	can be found was in the middle of being changed but not
				;	finished.  This temporary code makes it at least work.
				;	(It must be done before other files are loaded and ALIEN_HEAP
				;	is overwritten.)
				LDY	#aFindingOdds
				LDA	(ALIEN_PTR),Y
				STA FINDODD_ALIEN
				LDY #aFindingGroup
				LDA	(ALIEN_PTR),Y
				STA FINDGRP_ALIEN
			fin

				JSR	TOTALS_OUT
				LDY	#$0D			;"...nothing to scan..."
				BIT	GROUP_STATUS
				BMI	:SKIPB
				JSR	RESET_CHRLIST	;Find a good android
				LDA	#android*16
				JSR	CSCAN_PROF
				LDX	#<FIND_GOODROID
				LDY	#>FIND_GOODROID
				JSR	CSCAN_COMMON
				STX	THE_ANDROID
				BCC	:SKIPA
				TXA					;   and put his name in text
				JSR	POINTIT			;   if he exists
				LDX	#<TEXT3+3
				LDY	#>TEXT3+3
				JSR	FLUSH_NAME
				LDX	#<TEXT7+3
				LDY	#>TEXT7+3
				JSR	FLUSH_NAME
				JSR	PICK_EQUIPMNT
:SKIPA

				LDY	#13				;Nothing to scan...
				LDA	ATOTAL1
				ORA	ATOTAL2
				ORA	ATOTAL3
				BEQ	:SKIPB
				LDY	#8				;No android...
				LDA	THE_ANDROID
				BMI	:SKIPB
				INY					;Full group...
				LDA	ROOM_FOUND
				BEQ	:SKIPB
				LDY	#7				;Nothing found...
				LDA	FOUND_COUNT
				BNE	HAVE_ROOM
:SKIPB			JSR	TEXTER
				LDY	#$0A
				JSR	TEXTER
				STA	SCNDARY
				JSR	SPACE_SUB
				JSR	CLEAR_WIDE
				JMP	ALL_DONE

HAVE_ROOM		LDY	#2
				JSR	TEXTER
				LDA	#$93
				STA	YPNT
				LDA	#0
				STA	:LOOP0+1
				STA	YCOUNT
:LOOP0			LDX	#$FF			;Modified
				LDY	#0
:LOOP1			LDA	FOUND_ITEMS,X
				STA	ETABLE,Y
				INX
				INY
				CPY	#4
				BNE	:LOOP1
				STX	:LOOP0+1
				JSR	EQUIP1
				LDA	#$AC
				LDY	YPNT
				JSR	LINE
				LDA	YPNT
				CLC
				ADC	#$08
				STA	YPNT
				INC	YCOUNT
				LDA	YCOUNT
				CMP	FOUND_COUNT
				BNE	:LOOP0

EKDONE
				LDY	#$03
				JSR	TEXTER
				LDY	#$04
				JSR	TEXTER
				STA	SCNDARY
				JSR	SPACE_SUB
				JSR	CLEAR_NARROW
				LDA	#BLACK1
				STA	COLOR
				LDY	#$03
				JSR	LINER
				LDA	#GREEN
				STA	COLOR
				LDY	#$04
				JSR	LINER
				LDY	#$05
				JSR	TEXTER
				LDY	#$06
				JSR	TEXTER
				LDY	#$04
				JSR	TEXTER

				LDA	#0
				STA	EPOINT
				STA	CURSOR
:LOOP1			JSR	FIND_ROOM
				JSR	ECURSIT
				LDA	CURSOR
				STA	TO_CDEF+1
				LDX	#<TO_CDEF
				LDY	#>TO_CDEF
				JSR	INIT_CURSOR
				JSR	GETKEY
				LDA	CURSOR
				CMP	#7
				BEQ	:SKIPA
				JSR	POINTIT
				JSR	RESET_EQLIST
				JSR	ESCAN_PUTABLE
				LDA	EPOINT
				ASL
				ASL
				TAX
				LDA	#4
				STA	TEMP
:LOOP3			LDA	FOUND_ITEMS,X
				STA	(CHARDL),Y
				INX
				INY
				DEC	TEMP
				BNE	:LOOP3
:SKIPA			JSR	ECURS2
				INC	EPOINT
				LDA	EPOINT
				CMP	FOUND_COUNT
				BNE	:LOOP1
				JSR	CLEAR_WIDE
				JSR	FIND_ROOM
				LDA	ROOM_FOUND
				BNE	NO_FULL
				LDY	#$09
				JSR	TEXTER
				LDY	#$0A
				JSR	TEXTER
				JSR	SPACE_SUB
NO_FULL			LDY	#$05
				JSR	TEXTER
				LDA	#BLACK1
				STA	COLOR
				LDY	#$04
				JSR	LINER
				LDA	#GREEN
				STA	COLOR
				LDY	#$03
				JSR	LINER
				JSR	CLEAR_WIDE

ALL_DONE		LDA	#0
				STA	:MOD1+1
				STA	COUNT
:LOOP1			JSR	POINTIT
				JSR	BAD_STATUS
				BEQ	:SKIPA
				LDY	#status
				LDA	(CHARDL),Y
				AND	#critical
				BEQ	:SKIPC
				LDX	#<TEXTB+3		;critical
				LDY	#>TEXTB+3
				JSR	FLUSH_NAME
				LDY	#$0B
				BNE	:SKIPB			;Always
:SKIPA			LDX	#<TEXTC+3		;dead, etc.
				LDY	#>TEXTC+3
				JSR	FLUSH_NAME
				DEC	:MOD1+1
				LDY	#$0C
:SKIPB			JSR	TEXTER
				LDY	#$0A
				JSR	TEXTER
				JSR	SPACE_SUB
				JSR	CLEAR_WIDE
:SKIPC			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

:MOD1			LDA	#$FF			;Modified
				BMI	SEND_TO_CAMP

				JSR	CLEAR1
				LDA	#WHITE1
				STA	COLOR
				LDA	#$20
				STA	PAGE
				LDA	DIRHOLD
				STA	DIRECTN
				JSR	GETNSEW
				JSR	NOSCAN
				STA	PRIMARY
				JMP	RDKEY

SEND_TO_CAMP	JSR	MOVETO1
				STA	PRIMARY
				JMP	DEAD_VECTOR

*-------------------------------

TO_CDEF			DB	$07
				DB	0				;Modified
				DW	:TO_CURS

:TO_CURS		LDX	CURSOR
				LDY	YPOINTS,X
				CPX	#7
				BNE	:SKIPA
				DEY
				DEY
:SKIPA			LDX	#3
				JMP	ARROWER

*-------------------------------

FIND_GOODROID	LDY	#status
				LDA	(CHARDL),Y
				AND	#%00111111
				LDX	#1
				CMP	#dead
				BEQ	:SKIPA
				CMP	#blind
				BEQ	:SKIPA
				CMP	#confused
				BEQ	:SKIPA
*** MAYBE CHECK FOR OTHER STATUSES HERE
				DEX
:SKIPA			TXA
				RTS

*-------------------------------

FIND_ROOM		JSR	RESET_CHRLIST
				LDA	#0
				STA	CHAR_LIST+7
				STA	ROOM_FOUND
				LDX	#<MY_PUTABLE
				LDY	#>MY_PUTABLE
				JMP	CSCAN_COMMON

MY_PUTABLE		JSR	RESET_EQLIST
				JSR	ESCAN_PUTABLE
				LDY	#1
				BCC	:SKIPB
				CLC
				ADC	ROOM_FOUND
				CMP	#maxfind
				BCC	:SKIPA
				LDA	#maxfind
:SKIPA			STA	ROOM_FOUND
				DEY
:SKIPB			TYA
				RTS

*-------------------------------

SPACE_SUB		BIT	UNSTROB
:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	:LOOP1
				RTS

*-------------------------------

CLEAR_WIDE		LDA	#$26
				BNE	CLEAR_COM		;Always
CLEAR_NARROW	LDA	#$14
CLEAR_COM		STA	TEMP
				LDX	#$86
:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	TEMP
				LDA	#$00
:LOOP2			STA	(SCREENL),Y
				DEY
				BNE	:LOOP2
				INX
				CPX	#$BF
				BNE	:LOOP1
				RTS

*-------------------------------

ECURSIT			LDY	EPOINT
				LDA	EYPNTS,Y
				STA	YPNT
				LDA	#$A1
				STA	XPNT
				LDA	#4
				JSR	SPCHARS
ECURS2			LDY	EPOINT
				LDA	EYPNTS,Y
				STA	YPNT
				LDA	#$A6
				STA	XPNT
				LDX	#<ARROW_TIP
				LDY	#>ARROW_TIP
				LDA	#0
				JMP	DRAW_SHAPES

EYPNTS			DFB	$93,$9B,$A3
				DFB	$AB,$B3

ARROW_TIP		DB	%00000000
				DB	%00000000
				DB	%00000011
				DB	%00001111
				DB	%00000011
				DB	%00000000
				DB	%00000000

*-------------------------------
