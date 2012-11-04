CHR_SHOOT		JSR	GET_EP_ENUSE	;Get EL,PH_DAMAGEL,H and ENERGY_L,H

				JSR	CLEAR_TLINE1
				LDY	#67				;S>67 Charsname.Doesnt.Have.Enough.RET
									;     Energy.To.Send.Out.Brain.RET
									;     Jamming.Waves
				LDA	SHOT_TYPE
				CMP	#2				;brain jammer shot
				BCC	:2
				BEQ	:1

				LDY	#11				;S>11 Charsname.Doesnt.Have.Enough.RET
									;     Energy.To.Transmit.A.Robot
									;     Restraining.Message
:1				LDA	ENERGY_L
				ORA	ENERGY_H
				BNE	:2
				JSR	SENTENCE_PRET
				JMP	TAKDELCLRCCOM

:2				JSR	MAKE_CHITGRID	;Draw mons/chars that char can hit

* Set source coordinate for shot, adjusting for which
*   hand the shot is originating from (left,right,both)
				LDX	CHAR_NUMBER
				LDA	TEMPCHAR_XY,X
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XCOORD
				LDA	YPNTS,Y
				STA	YCOORD
				DEC	YCOORD
				LDY	#6				;Six pixels right (both hands)
				LDX	COMPNTR
				LDA	COMMAND,X
				AND	#$20
				BNE	:SKIPB
				LDY	#1				;One pixel right (left hand)
				LDA	COMMAND,X
				AND	#$40
				BEQ	:SKIPB
				LDY	#12				;Twelve pixels right (right hand)
:SKIPB			TYA
				CLC
				ADC	XCOORD
				TAX
				LDY	#0
				LDA	YCOORD
				JSR	HPOSN			;Set source coordinate

* Get destination coordinate for shot, using
*   +/- AIM * 2 for a randomizing factor
				LDY	COMPNTR
				LDX	COMMAND-1,Y
				TXA
				SEC
				SBC	#$05
				STA	YPNT
				JSR	AIM_RATING
				JSR	AIM_DESTSUB
				SEC
				SBC	#$37
				TAY

				LDA	#1				;Brain jammer and robot restrainer
				SEC					;   shots don't ricochet
				SBC	SHOT_TYPE
				JSR	TRACE_SHOT
				JSR	SHOT_CALL
				JSR	TAKE_ENERGY
				LDA	DEAD_FLAG
				BNE	:3
				JSR	DELAYER
:3				JSR	DRAW_IF_DEAD
				LDA	#0
				STA	DEAD_FLAG
				JSR	EOR_SHOT
				JSR	CLRBOX
				JMP	CCOM

SHOT_CALL		LDX	#0
				LDY	SHOT_TYPE
				BEQ	:2
				DEY
				BEQ	:2
				DEY
				BEQ	:1
				JMP	NARR_ROBOTRES
:1				JMP	NARR_BRAINJAM
:2				JMP	NARR_CBLASTER

*-------------------------------
*
*-------------------------------

MAKE_CHITGRID	LDA	#$40
				STA	PAGE
				JSR	CSBOT2			;CHANGE THIS NAME
				LDA	#WHITE1
				STA	COLOR
				LDY	#0				;Shot containment lines
				JSR	LINER

				LDX	COMPNTR
				LDA	COMMAND-1,X
				JSR	CHAR_INDEXER
				LDA	MASTER_MGRID,Y
				AND	#%00111111
				STA	TARGET

				LDA	#0
				STA	COUNT
:LOOP1			LDX	COUNT
				LDA	PECKS,X
				BEQ	:SKIPB
				BMI	:SKIPA
				AND	#$3F
				STA	MONS_NUMBER
				JSR	POINTTO
				JSR	MON_SHOOTABLE
				BCC	:SKIPA
**** SPECIAL CASE INVISIBLE ALIEN
				JSR	DRAW_ALIEN
:SKIPA			INC	COUNT
				BNE	:LOOP1			;Always

:SKIPB			LDX	POINTER
				LDA	PECKS,X
				AND	#$7F
				PHA					;Preserve number of shooting char
				LDA	#0
				STA	COUNT
:LOOP2			STA	CHAR_NUMBER
				JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#dead
				BEQ	:SKIPC
				LDA	COUNT
				LDY	#2
				JSR	OVALSUB
:SKIPC			INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP2
				PLA
				STA	CHAR_NUMBER
				JSR	POINTIT			;Restore CHARDL,H to shooting char
				JMP	COPY_SHOTGRID

*-------------------------------
*
*-------------------------------

MON_SHOOTABLE	LDY	#monSTATUS
				LDA	(MONS_PTR),Y
				CMP	#dead
				CLC
				BEQ	:EXIT
				JSR	SHORTEST_DIST
				STA	TEMP
				LDA	#$10
				SED
				SEC
				SBC	TEMP
				CLD
				ASL
				ASL
				ASL
				ASL
				STA	BASE+1
				LDA	#0
				STA	BASE+2
				STA	BASE+3
				ADC	#0
				STA	BASE+0
				LDA	MONS_NUMBER
				CMP	TARGET
				BEQ	:SKIPA
				LDX	#$75
				LDY	#$00
				JSR	MULTIPLY_BASE
:SKIPA			JSR	GET_SIZE_2
				LDY	SHT_SIZES,X
				LDA	SHT_SIZES+1,X
				TAX
				JSR	LAST_MULTIPLY
				JSR	FINAL_ODDS
:EXIT			RTS

TARGET			DB	0				;MOVE THIS LATER??

SHT_SIZES		HEX	0080			;tiny
				HEX	0090			;small
				HEX	0100			;normal
				HEX	0110			;big

*-------------------------------

AIM_DESTSUB		ASL
				JSR	RND_DIGIT_0
				BIT	RANDOM1
				BPL	:1
				EOR	#$FF
				CLC
				ADC	#$01
:1				CLC
				ADC	#$06
				PHA
				LDA	YPNT
				JSR	FROM11B
				PLA
				CLC
				ADC	XPNTS,X
				TAX
				LDA	YPNTS,Y
				CLC
				ADC	#4
				TAY
				RTS

*-------------------------------
