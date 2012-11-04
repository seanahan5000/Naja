*-------------------------------

*****************************
********************************
**** FILTER OUT INCAPACITATING STATUS HERE
********************************
*****************************

NARRATE_CHAR
				LDA	#0
				STA	OUT_OF_ENERGY
				STA	DEAD_FLAG

				LDA	CHAR_NUMBER
				JSR	COMCALC
				ASL
				TAX
				LDA	CSPOTS+1,X
				PHA
				LDA	CSPOTS,X
				PHA
				RTS

CSPOTS			DW	CHR_SWING-1
				DW	CHR_SHOOT-1
				DW	CHR_ENERGY-1
				DW	CHR_THROW-1
				DW	CHR_USE-1
				DW	0				;was ADJUST
				DW	CHR_AIM-1
				DW	CHR_MOVE-1
				DW	CHR_IDENTIFY-1
				DW	CHR_EXCHANGE-1
				DW	CHR_PARRY-1
				DW	CHR_RUN-1
				DW	0				;was TESSERACT

CHR_AIM			NOP
CHR_PARRY		NOP
				JMP	CCOM

*-------------------------------

TAKDELCLRCCOM	JSR	TAKE_ENERGY
DEL_CLR_CCOM	JSR	DELAYER
				JSR	CLRBOX
CCOM			JSR	RUNDOWN_SUB
				LDX	POINTER
				LDA	PECKS,X
				AND	#$7F
				TAX
				INC	COMNUMS,X
				INC	COMNUMS,X
				JSR	GETIME
				LDX	CHAR_NUMBER
				STA	CTIME_COUNTS,X
				LDX	COMPNTR
				LDA	COMMAND,X
				AND	#$0F
				CMP	#$01
				BEQ	CMERGE
				DEX
				DEX
				LDA	COMMAND,X
				AND	#$0F
				CMP	#$01
				BNE	LASHOT
				INX
				LDA	COMMAND,X
				AND	#$3F
				SEC
				SED
				SBC	#$01
				CLD
				BEQ	LASHOT
				STA	SCRATCH
				LDA	COMMAND,X
				AND	#$C0
				ORA	SCRATCH
				STA	COMMAND,X
				LDX	POINTER
				LDA	PECKS,X
				AND	#$7F
				TAX
				DEC	COMNUMS,X
				DEC	COMNUMS,X
CMERGE			JSR	GETIME
				LDX	CHAR_NUMBER
				STA	CTIME_COUNTS,X
LASHOT			RTS


*-------------------------------
*
*-------------------------------

RUNDOWN_SUB		BIT	OUT_OF_ENERGY
				BPL	:EXIT
				JSR	CLEAR_TLINE1
				LDY	#29				;S>29 <CharName>.Runs.Out.Of.Energy
				JSR	SENTENCE
				JSR	PERIOD_RETURN
				JSR	DELAYER
				JSR	CLRBOX
:EXIT			RTS


*--------------------------------------
* Take energy passed in ENERGY_L,H and
*   update stats box
*--------------------------------------

TAKE_ENERGY		JSR	:SUBA
				LDX	ENERGY_L
				LDY	ENERGY_H
				SEC
				JSR	DRAIN_DIRECT2
				BPL	:SUBA
				PHA
				JSR	STATWRD
				LDY	#status
				PLA
				STA	(CHARDL),Y
				JSR	STATWRD
				DEC	OUT_OF_ENERGY
:SUBA			JSR	POWROUT
				LDA	#$8D
				STA	TEXTBUF+6
				LDX	CHAR_NUMBER
				LDY	YPOINTS,X
				LDA	#$C6
				JMP	LINE

OUT_OF_ENERGY	DB	0				;MAKE ZPAGE LATER?

*-------------------------------
