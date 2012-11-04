NARRATE_MONS	JSR	COPY_FBYTES
				LDA	#0
				STA	DEAD_FLAG
				TAX					;*** BOGUS
				LDY	#monCRNTCMD
				LDA	(MONS_PTR),Y
				AND	#%00001111
				CMP	#cmdSWING
				BEQ	GMSWING
				INX					;*** BOGUS
				CMP	#cmdMOVE
				BEQ	GOMMOVE
				INX					;*** BOGUS
				CMP	#cmdAIM
				BEQ	GMAIM
				INX					;*** BOGUS
				CMP	#cmdSHOOT
				BEQ	GMSHOOT
				INX					;*** BOGUS
MON_PARRY
				JSR	BOGUS_MONARR	;*** BOGUS
				JMP	MCOM
GMSWING
				JSR	BOGUS_MONARR	;*** BOGUS
				JMP	MON_SWING
GMSHOOT
				JSR	BOGUS_MONARR	;*** BOGUS
				JMP	MON_SHOOT
GMAIM
				JSR	BOGUS_MONARR	;*** BOGUS
				JMP	MON_AIM
GOMMOVE
				JSR	BOGUS_MONARR	;*** BOGUS
				JMP	MON_MOVE

*-------------------------------

DELDEDCLRMCOM	JSR	DELAYER
				JSR	DRAW_IF_DEAD
				JSR	CLRBOX
MCOM			LDY	#monCRNTCMD
				LDA	(MONS_PTR),Y
				LDY	#monLASTCMD
				STA	(MONS_PTR),Y
				DEY					;monCRNTCMD+1
				LDA	(MONS_PTR),Y
				LDY	#monLASTCMD+1
				STA	(MONS_PTR),Y
				JMP	PICK_MCOMMAND

*-------------------------------

********************************
********************************
BOGUS_MONARR
				RTS					;TEMP****
				LDA	MULT5,X
				PHA
				JSR	CLEAR_TLINE1
				PLA
				TAY
:1				LDA	BTEXT,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#5
				BNE	:1
				LDY	#monCRNTCMD+1
				LDA	(MONS_PTR),Y
				INX
				JSR	:SUB1
				JSR	RETURN
				JSR	BLINK_MONS
				JSR	DELAYER
				JMP	CLRBOX

:SUB1			PHA
				LSR
				LSR
				LSR
				LSR
				JSR	:SUB2
				PLA
				AND	#%00001111
:SUB2			CMP	#10
				BCC	:2
				ADC	#0
:2				STA	TEXTBUF,X
				INX
				RTS

MULT5			DB	0,5,10,15,20,25

BTEXT			USR	(SWING)-
				USR	(MOVE_)-
				USR	(AIM__)-
				USR	(SHOOT)-
				USR	(PARRY)-
********************************
********************************
