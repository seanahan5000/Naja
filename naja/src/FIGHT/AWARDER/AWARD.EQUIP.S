*===============================
*
*===============================

PICK_EQUIPMNT	JSR	FIND_ROOM
				JSR	ANY_LEGAL

			do 0
				; TODO: implement this for real
			else
				; It looks like odds of finding equipment and what equipment
				;	can be found was in the middle of being changed but not
				;	finished.  This temporary code makes it at least work.
				LDY	#aFindingOdds
				LDA	(ALIEN_PTR),Y
				STA FINDODD_ALIEN
				LDY #aFindingGroup
				STA FINDGRP_ALIEN
			fin

				LDA	#2
				STA	COUNT
:LOOP1			LDX	COUNT
				LDA	ATOTAL1,X
				BEQ	:SKIPC
				STA	YCOUNT

			do 0
				; TODO: re-enable once implemented for real
				;	This appears to multiply by 6 while PICK_ITEM
				;	multiplies by 8.
				TXA
				ASL
				STA	TEMP
				ASL
				ADC	TEMP			;Carry assumed clear
				TAY
			else
				LDY #0
			fin
				LDA	FINDGRP_ALIEN,Y
				AND	MASTER_MASK
				BEQ	:SKIPC
:LOOP2			LDA	FINDODD_ALIEN,Y
				BEQ	:SKIPB
:LOOP4			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%11110000
				CMP	#$A0
				BCS	:LOOP4
				STA	TEMP
:LOOP5			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00001111
				CMP	#$0A
				BCS	:LOOP5
				ORA	TEMP
				CMP	FINDODD_ALIEN,Y
				BCS	:SKIPB
				JSR	PICK_ITEM
				LDA	FOUND_COUNT
				ASL
				ASL
				PHA
				TAX
				LDY	#2
:LOOP3			LDA	(POINTL),Y
				STA	FOUND_ITEMS,X
				INX
				INY
				CPY	#6
				BNE	:LOOP3
				JSR	RNDMIZE
				PLA
				TAX
				LDA	RANDOM1
				AND	#%00000111		;1 in 8 chances of being broken
				BNE	:SKIPA
				LDA	FOUND_ITEMS,X
				ORA	#eq_broken
				STA	FOUND_ITEMS,X
:SKIPA			INC	FOUND_COUNT
				LDA	FOUND_COUNT
				CMP	ROOM_FOUND
				BCS	:EXIT
:SKIPB			DEC	YCOUNT
				BNE	:LOOP2
:SKIPC			DEC	COUNT
				BPL	:LOOP1
:EXIT			RTS

*-------------------------------

PICK_ITEM		JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00000111
				TAX
				LDA	COUNT
			do 0
				; TODO: re-enable once implemented for real
				;	PICK_EQUIPMNT appears to multiply by 6, not 8
				ASL
				ASL
				ASL
				TAY
			else
				LDY #0
			fin
				LDA	GROUP_MASKS,X
				AND	FINDGRP_ALIEN,Y
				AND	MASTER_MASK
				BEQ	PICK_ITEM
				STX	GROUP
				LDA	PER_GROUP,X
				STA	ITEM
:LOOP1			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00011111
				CMP	ITEM
				BCS	:LOOP1
				STA	ITEM
				JSR	ITEM_LEGAL
				BCC	PICK_ITEM
				RTS

*-------------------------------

ANY_LEGAL		LDA	#%10000000
				STA	MASK
				LDA	#%11111111
				STA	MASTER_MASK
				LDA	#0
				STA	GROUP
:LOOP1			LDA	#0
				STA	ITEM
:LOOP2			JSR	ITEM_LEGAL
				BCS	:SKIPA
				INC	ITEM
				LDX	GROUP
				CMP	PER_GROUP,X
				BNE	:LOOP2
				LDA	MASTER_MASK
				EOR	MASK
				STA	MASTER_MASK
:SKIPA			INC	GROUP
				LSR	MASK
				BNE	:LOOP1
				RTS

*-------------------------------

ITEM_LEGAL		LDA	GROUP
				ASL
				TAY
				LDA	GROUP_ADRS,Y
				STA	POINTL
				LDA	GROUP_ADRS+1,Y
				STA	POINTH
				LDA	ITEM
				ASL
				STA	TEMP
				ASL
				ASL
				SEC
				SBC	TEMP
				TAY
				LDA	(POINTL),Y
				LDX	SHELL
				AND	SHELL_MASKS-1,X
				CLC
				BEQ	:EXIT
				INY
				CPX	#1				;SHELL 1
				SEC
				BNE	:EXIT
				LDA	(POINTL),Y
				LDX	FACE
				AND	FACE_MASKS-1,X
				CLC
				BEQ	:EXIT
				SEC
:EXIT			RTS


*------------------------------------------------
* SHELL MASK, FACE MASK, EQUIPMENT DATA (4 BYTES)
*   None of the groups can be completely empty.
*   44 pieces of equipment per group is maximum.

allfaces		=	face1+face2+face3+face4+face5+face6

GROUP_A			DB	shell1,allfaces,$08,$00,$00,$AD					;BLUE BEAM DAGGER
GROUP_B			DB	shell1,allfaces,$0C,$00,$00,$A7					;FLY PISTOL
				DB	shell1,allfaces,$0C,$01,$00,$A5					;LIGHT PISTOL
				DB	shell1,allfaces,$0C,$02,$08,$A1					;MEDIUM PISTOL
GROUP_C			DB	shell1,allfaces,$0F,$08,$00,$84					;3S MEMORY ERASER
GROUP_D			DB	shell1,allfaces,$05,$00,$00,$DF					;BENDER-C HELMET
				DB	shell1,allfaces,$05,$01,$80,$DF					;BENDER-B HELMET
				DB	shell1,allfaces,$06,$01,$00,$A6					;5% SHIELD
				DB	shell1,allfaces,$06,$02,$00,$A6					;10% SHIELD
				DB	shell1,allfaces,$07,$09,$04,$57					;2% GROUNDERS
				DB	shell1,allfaces,$00,$08,$00,$F7					;2% DISSIPATOR
GROUP_E			DB	shell1,allfaces,$21,$03,$00,$50					;ATOM COMPRESSOR
				DB	shell1,allfaces,$02,$01,$00,$02					;FACE TRACKER
GROUP_F			DB	shell1,allfaces,$18,$00,$00,$20					;ROBO-DAGGER
				DB	shell1,allfaces,$1C,$00,$00,$20					;ROBO-BLASTER C
				DB	shell1,allfaces,$1C,$01,$00,$20					;ROBO-BLASTER B
				DB	shell1,allfaces,$1C,$02,$08,$20					;ROBO-BLASTER A
GROUP_G			DB	0,0,0,0,0,0		;DUMMY
GROUP_H			DB	0,0,0,0,0,0		;DUMMY
GROUP_END

GROUP_ADRS		DW	GROUP_A
				DW	GROUP_B
				DW	GROUP_C
				DW	GROUP_D
				DW	GROUP_E
				DW	GROUP_F
				DW	GROUP_G
				DW	GROUP_H

PER_GROUP		DB	GROUP_B-GROUP_A/6
				DB	GROUP_C-GROUP_B/6
				DB	GROUP_D-GROUP_C/6
				DB	GROUP_E-GROUP_D/6
				DB	GROUP_F-GROUP_E/6
				DB	GROUP_G-GROUP_F/6
				DB	GROUP_H-GROUP_G/6
				DB	GROUP_END-GROUP_H/6

GROUP_MASKS		DB	%10000000
				DB	%01000000
FACE_MASKS		DB	%00100000
SHELL_MASKS		DB	%00010000
				DB	%00001000
				DB	%00000100
				DB	%00000010
				DB	%00000001
