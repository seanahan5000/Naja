				LST	OFF
				TR	ON
				EXP	OFF

				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NDOS.VARS
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MHALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS
				PUT	/NAJA/VARS/MISC.VARS

LINENUM			=	$00
SORCLIN			=	$0B
LINSORC			=	$0C
LEFTCOL			=	$10
RITECOL			=	$11
TOCNT			=	$12
FROMCNT			=	$13

				ORG	$9000	

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

				LDA	GRPNUMB
				BEQ	:SKIPA
				JSR	DRIVE_OFF		;If someone left in group,
				JSR	CLEAR2			;  shut drive off,
				JSR	SPRAY			;  spray in tunnels
				JSR	DRIVE_ON		;  and turn drive back on
:SKIPA			LDA	#side_MS
				STA	DISK_SIDE
				LDA	#0
				STA	SHELL

				LDA	#$A0			;Load in mothership
				STA	SSTOREH			;   hall controller
				LDX	#<$0040
				LDY	#>$0040
				LDA	#$10
				JSR	FLOADER

				LDX	MOMFILES_ADR	;Set mothership file table
				LDY	MOMFILES_ADR+1
				JSR	SET_FILE_TABL

				LDX	#mHallsPicts
				JSR	FLOADER_FILE

				LDA	#$9F			;Load in OPENBUF data
				STA	SSTOREH
				LDX	#<$000A
				LDY	#>$000A
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
				LDX	#wOpen			;To write orb data
				JSR	CALL_WRITERS
				LDX	#wGroup			;Save the group to disk
				JSR	CALL_WRITERS
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

GROUP_ALIVE
				LDA	#0
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

				LDX	#wOpen			;To write orb data
				JSR	CALL_WRITERS

				LDA	GRPNUMB
				PHA
				LDA	GRPCONT
				STA	GRPNUMB
				LDX	#wGroup			;Save the group to disk
				JSR	CALL_WRITERS
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
				LDA	#$EA
				STA	LEFTIN
				STA	RIGHTIN
				STA	UPIN	
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

SPRAY			LDA	#$00
				STA	LEFTCOL
				LDA	#$27
				STA	RITECOL
				LDA	#$01
				STA	SORCLIN
				LDA	#$BF	
				STA	LINSORC
				JMP	DSHORT2
NODONED			JSR	LEFTIN
				LDA	LEFTCOL
				INC	LEFTCOL
				CMP	#$27
				BNE	NODONEL
				LDA	#$60
				STA	LEFTIN
NODONEL			JSR	RIGHTIN
				LDA	RITECOL
				DEC	RITECOL
				CMP	#$00
				BNE	NODONER
				LDA	#$60
				STA	RIGHTIN
NODONER			JSR	UPIN
				LDA	SORCLIN
				CLC
				ADC	#$04
				STA	SORCLIN
				CMP	#$C0
				BCC	NODONEU
				LDA	#$60
				STA	UPIN
NODONEU			JSR	DOWNIN
				LDA	LINSORC
				SEC	
				SBC	#$04
				STA	LINSORC
				CMP	#$C0	
				BCS	UDLROUT	
DSHORT2			BIT	KEYBRD
				BPL	NODONED
				BIT	UNSTROB
UDLROUT			RTS
LEFTIN			NOP
				LDA	#$02
				STA	LINENUM
LEFTIN2			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#$01
OVERL			LDA	(SCREENL),Y
				DEY
				STA	(SCREENL),Y
				INY
				INY
				CPY	#$28
				BNE	OVERL
				LDY	LEFTCOL
				LDA	(DESTINL),Y
				LDY	#$27
				STA	(SCREENL),Y
				LDA	LINENUM
				CMP	#$BE
				BEQ	LEFTOUT
				CLC
				ADC	#$04
				STA	LINENUM
				JMP	LEFTIN2
LEFTOUT			RTS
RIGHTIN			NOP
				LDA	#$00
				STA	LINENUM
RGHTIN2			LDX	LINENUM
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#$26
OVERR			LDA	(SCREENL),Y
				INY
				STA	(SCREENL),Y
				DEY
				DEY
				BPL	OVERR
				LDY	RITECOL
				LDA	(DESTINL),Y
				LDY	#$00
				STA	(SCREENL),Y
				LDA	LINENUM
				CLC
				ADC	#$04	
				STA	LINENUM
				CMP	#$C0
				BCC	RGHTIN2
				RTS
UPIN			NOP
				LDA	#$01
				STA	TOCNT
				LDA	#$05
				STA	FROMCNT
UPS				LDX	FROMCNT
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
				CMP	#$BD
				BEQ	UEND
				STA	TOCNT
				CLC
				ADC	#$04
				STA	FROMCNT
				JMP	UPS	
UEND			LDX	SORCLIN	
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				LDY	#$27
UPLOOP			LDA	(DESTINL),Y
				STA	(SCREENL),Y
				DEY
				BPL	UPLOOP
				RTS
DOWNIN			LDA	#$BB
				STA	FROMCNT
				LDA	#$BF
				STA	TOCNT
DOWNS			LDX	FROMCNT
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
				CMP	#$03
				BEQ	DEND
				STA	TOCNT
				SEC
				SBC	#$04
				STA	FROMCNT
				JMP	DOWNS	
DEND			LDX	LINSORC
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				LDY	#$27	
DLOOP			LDA	(DESTINL),Y
				STA	(SCREENL),Y
				DEY
				BPL	DLOOP
				RTS

				SAV	TESBACK
