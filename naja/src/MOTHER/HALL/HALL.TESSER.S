				JMP	TESBACK

*-------------------------------
*
*-------------------------------

SPRAY			LDX	#0
				STX	LEFTCOL
				INX
				STX	SORCLIN
				LDA	#$27
				STA	RITECOL
				LDA	#$BF	
				STA	LINSORC
:LOOP1			BIT	KEYBRD
				BMI	:EXIT
				JSR	LEFTIN
				JSR	RIGHTIN
				JSR	UPIN
				JSR	DOWNIN
				LDA	LINSORC
				CMP	#$C0	
				BCC	:LOOP1
:EXIT			BIT	UNSTROB
				RTS

LEFTIN			LDA	LEFTCOL
				CMP	#$28
				BEQ	:EXIT
				LDX	#2
:LOOP1			JSR	LR_SUB
				LDY	#1
:LOOP2			LDA	(SCREENL),Y
				DEY
				STA	(SCREENL),Y
				INY
				INY
				CPY	#$28
				BNE	:LOOP2
				LDY	LEFTCOL
				LDA	(DESTINL),Y
				LDY	#$27
				STA	(SCREENL),Y
				TXA
				CLC
				ADC	#4
				TAX
				CPX	#$C2
				BNE	:LOOP1
				INC	LEFTCOL
:EXIT			RTS

RIGHTIN			LDX	RITECOL
				INX
				BEQ	:EXIT
				LDX	#0
:LOOP1			JSR	LR_SUB
				LDY	#$26
:LOOP2			LDA	(SCREENL),Y
				INY
				STA	(SCREENL),Y
				DEY
				DEY
				BPL	:LOOP2
				LDY	RITECOL
				LDA	(DESTINL),Y
				LDY	#$00
				STA	(SCREENL),Y
				TXA
				CLC
				ADC	#4
				TAX
				CPX	#$C0
				BCC	:LOOP1
				DEC	RITECOL
:EXIT			RTS

UPIN			LDA	#1
				BNE	:SKIPA			;Always
:LOOP1			JSR	UD_SUB
:SKIPA			STA	TOCNT
				CLC
				ADC	#4
				STA	FROMCNT
				CMP	#$C1
				BNE	:LOOP1
				LDX	SORCLIN
				TXA
				CLC
				ADC	#4
				STA	SORCLIN
				BCC	END_SUB			;Always

DOWNIN			LDA	#$BF
				BNE	:SKIPA			;Always
:LOOP1			JSR	UD_SUB
:SKIPA			STA	TOCNT
				SEC
				SBC	#4
				STA	FROMCNT
				BCS	:LOOP1
				LDX	LINSORC
				TXA
				SEC
				SBC	#4
				STA	LINSORC
END_SUB			LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				LDY	#$27	
:LOOP1			LDA	(DESTINL),Y
				STA	(SCREENL),Y
				DEY
				BPL	:LOOP1
				RTS

LR_SUB			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				RTS

UD_SUB			LDX	FROMCNT
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				LDX	TOCNT
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				JSR	LINMOVE
				LDA	FROMCNT
				RTS

*============================================
* On Entry:
*   Assume that the drive is still spinning,
*    and the primary page is displayed.
*
* Character statuses signify the following:
*       Lost means lost
*    InTracc means in tracc but compressed
*  Compressd means in group but compressed
*
* There should never be Dead or Broken
*   characters in the group at this point.
*============================================

TESBACK			LDA	#0
				STA	SHELL

				LDA	#$A0			;Load in mothership
				STA	SSTOREH			;   hall controller
				LDX	#<$00E0
				LDY	#>$00E0
				LDA	#$10
				JSR	FLOADER

				LDX	MOMFILES_ADR	;Set mothership file table
				LDY	MOMFILES_ADR+1
				JSR	SET_FILE_TABL

				LDX	#mHallsPicts
				JSR	FLOADER_FILE

				LDA	#$9F			;Load in OPENBUF data
				STA	SSTOREH
				LDX	#<charTrack+$0A
				LDY	#>charTrack+$0A
				LDA	#1
				JSR	FLOAD
				LDX	#10
:LOOP1			LDA	$9F80,X
				STA	OPENBUF,X
				DEX
				BPL	:LOOP1

				LDA	#0
				STA	COUNT
:LOOP2			JSR	POINTIT			;Update lost character count
				LDY	#status			;  and remove orbs, etc. from
				LDA	(CHARDL),Y		;  lost characters
				CMP	#intracc
				BNE	:SKIPB
				INC	LOST_CHARS
:SKIPB			CMP	#lost
				BNE	:SKIPC
*** RECOVER ORBS, ETC. FROM THIS CHARACTER
:SKIPC			INC	COUNT
				LDA	COUNT
				CMP	GRPCONT
				BNE	:LOOP2

				LDA	#$40
				STA	PAGE
				LDA	#$04
				STA	BYTEWID
				LDA	#$01
				STA	FACE
				LDA	#$06
				STA	SRANGE

				LDA	GRPNUMB
				BNE	GROUP_ALIVE

GROUP_DEAD		LDA	GRPCONT
				STA	GRPNUMB
*JSR WRITE_OPEN ;To write orb data
*JSR WRITE_GROUP ;Save the group to disk
				LDA	#0
				STA	GRPNUMB
				JSR	CLEAR2
				STA	SCNDARY
				LDA	#$01			;If no one left in group,
				STA	XPOS			;  send them back to the
				LDA	#$05			;  main transport
				STA	YPOS
				LDA	#$FF
				STA	DIRECTN
				JSR	TRANS_SOUND
				JMP	RDKEY

GROUP_ALIVE		LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status			;Remove rundown status
				LDA	(CHARDL),Y
				BPL	:SKIPA
				AND	#%01111111
				STA	(CHARDL),Y
				LDY	#energylev+1
				LDA	#1
				STA	(CHARDL),Y
				LDY	#status
				LDA	(CHARDL),Y
:SKIPA			ASL
				BPL	:SKIPB
				LSR
				AND	#%00111111		;Remove critical status
				STA	(CHARDL),Y
				LDY	#damagemax+1
				SEC
				SED
				LDA	(CHARDL),Y
				SBC	#critical_amnt+1
				LDY	#damagelev+1
				STA	(CHARDL),Y
				LDY	#damagemax
				LDA	(CHARDL),Y
				SBC	#0
				LDY	#damagelev
				STA	(CHARDL),Y
				CLD
:SKIPB			LDY	#status			;Remove auto-cure statuses
				LDA	(CHARDL),Y
				LDX	#0				;# OF STATUSES - 1 (FILL IN LATER)
:LOOP2			CMP	AUTO_CURES,X
				BNE	:SKIPC
				LDA	#healthy
				STA	(CHARDL),Y
				BCS	:SKIPD			;Always
:SKIPC			DEX
				BPL	:LOOP2
:SKIPD			JSR	CALC_ALL
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

*JSR WRITE_OPEN ;To write orb data

				LDA	GRPNUMB
				PHA
				LDA	GRPCONT
				STA	GRPNUMB
*JSR WRITE_GROUP ;Save the group to disk
				PLA
				STA	GRPNUMB

				LDA	#$08
				STA	XPOS
				LDA	#$01
				STA	YPOS
				LDA	#$0F
				STA	DIRECTN
				JSR	CLEAR2
				JSR	GETNSEW
				LDA	#WHITE1
				STA	COLOR
				JSR	NOSCAN
				LDA	#$20
				STA	PAGE
				JSR	SPRAY
				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY
				JMP	RDKEY

AUTO_CURES		DB	bleeding		;????
** etc.

*-------------------------------
*
*-------------------------------

TESS_BEGIN		LDA	#$40
				STA	PAGE
				JSR	MOVETO2
				JSR	DRAW_TESPIC
				LDY	#$1B
				JSR	TEXTER
				STA	SCNDARY
				LDX	#<TESS_CDEF
				LDY	#>TESS_CDEF
				JSR	INIT_CURSOR
				LDA	KEYBRD
				BPL	:SKIPA
				JSR	CHECK_UP
				BNE	:SKIPA
				BIT	UNSTROB
:SKIPA			JSR	GETKEY
				LDY	#$1B	
				JSR	TEXTER
				LDA	CURSOR
				BEQ	GOTACT
				LDA	#$20
				STA	PAGE
				STA	PRIMARY
				LDA	#WHITE1
				STA	COLOR
				LDA	#$FF	
				RTS

GOTACT			JSR	MOVETO1
				STA	PRIMARY
				JSR	SET_TO_LIMBO	;Mark chars as "inlimbo"
*JSR WRITE_GROUP ;Save that status to disk
				JSR	SET_TO_LIMBO	;Restore real statuses
				LDA	#side_T1
				STA	DISK_SIDE
				LDA	#$9D
				STA	SSTOREH
				LDX	#<$0220
				LDY	#>$0220
				LDA	#2
				JSR	SLOADER
				JMP	$9D00

*-------------------------------

DRAW_TESPIC		LDY	#$04
				JSR	PICKER
				LDY	#$05
				JSR	PICKER
				LDY	#$06
				JSR	PICKER
				LDA	#9
				STA	TEMP+1
:LOOP1			LDY	TEMP+1
				LDA	LCOUNTS,Y
				STA	TEMP
				LDX	LHEIGHTS,Y
:LOOP2			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	#7
:LOOP3			LDA	#$55
				STA	(SCREENL),Y
				INY
				LDA	#$2A
				STA	(SCREENL),Y
				INY
				CPY	#33
				BNE	:LOOP3
				INX
				DEC	TEMP
				BNE	:LOOP2
				DEC	TEMP+1
				BPL	:LOOP1
				RTS

LCOUNTS			DB	1,3,5,7,9,9,7,5,3,1
LHEIGHTS		DB	48,57,66,75,84,111,122,133,144,155

*-------------------------------

SET_TO_LIMBO	LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				PHA
				LDY	#flaglimbo
				LDA	(CHARDL),Y
				LDY	#status
				STA	(CHARDL),Y
				PLA
				LDY	#flaglimbo
				STA	(CHARDL),Y
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				RTS

*-------------------------------
TESS_CDEF		DB	$01
				DB	$80
				DW	:TESS_CURS
:TESS_CURS		LDX	CURSOR
				LDY	:YPNTS,X
				LDX	#$32
				JMP	ARROWER
:YPNTS			DB	$11,$1B
*-------------------------------

TEXT1B			PLOTAT	58;17;(_TESSERACT_TO_TRACC_STATION)
				PLOTAT	58;27;(_CANCEL)+
