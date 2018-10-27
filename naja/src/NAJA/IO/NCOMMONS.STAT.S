
				ERR	*-$14DC
SPCHARS			LDX	#<CURSOR_DATA
				LDY	#>CURSOR_DATA
				BNE	SHAPER			;Always

				ERR	*-$14E2
REDRAW_SHAPES
RMOD1			LDX	#$00			;Modified
RMOD2			LDY	#$00			;Modified

				ERR	*-$14E6
DRAW_SHAPES		STX	RMOD1+1
				STY	RMOD2+1
SHAPER			JSR SET_SHAPE
				LDA	YPNT
				STA	YCOORD
				LDA	XPNT
				STA	XCOORD
				JSR	TABLER
				JSR	SHFTCLC
				JMP DRAW_SHAPE

				DS	$151A-*,$EA		;* FREE SPACE (#26 bytes)

				ERR	*-$151A
CURSOR_DATA		DB	%00000000
				DB	%00001100
				DB	%00011000
				DB	%01111111
				DB	%00011000
				DB	%00001100
				DB	%00000000

				DB	%00000000
				DB	%00011000
				DB	%00001100
				DB	%01111111
				DB	%00001100
				DB	%00011000
				DB	%00000000

				DB	%00000011
				DB	%00000111
				DB	%00001111
				DB	%00111111
				DB	%00001111
				DB	%00000111
				DB	%00000011

				DB	%01100000
				DB	%01110000
				DB	%01111000
				DB	%01111110
				DB	%01111000
				DB	%01110000
				DB	%01100000

				DB	%00000000
				DB	%00011111
				DB	%00011111
				DB	%00011111
				DB	%00011111
				DB	%00011111
				DB	%00000000


MAJOR_STAT		JSR	BAD_STATUS
				BCS	:EXIT
				LDA	(CHARDL),Y
				AND	#critical
				BEQ	:EXIT
				SEC
:EXIT			RTS

				NOP

BAD_STATUS		LDY	#status			;Exit carry set and BEQ true
				LDA	(CHARDL),Y		;   if it's a major stat
				AND	#%00111111		;   A - holds status
				BEQ	:SKIPA			;   X - is unchanged
				CMP	#lost+1
				BCS	:SKIPA
				CPY	#status			;Set carry and make BEQ true
				RTS
:SKIPA			CLC
				LDY	#status			;Make BEQ false
				RTS

				DS	5				;FREE SPACE

STATWRD			JSR	MAJOR_STAT
				BCC	:SKIPA
				JSR	DAMAGER
				JMP	:SKIPB
:SKIPA			JSR	STATUSR
:SKIPB			LDA	#$8A
				LDY	YPNT
				JMP	LINE

STATUSR			LDY	#$0A
				LDA	(CHARDL),Y
STATUSR2		TAX
				AND	#critical
				BNE	:SKIPA
				TXA
				CMP	#rundown
				BEQ	:SKIPA
				AND	#%00111100
				CMP	#illA
				BEQ	:SKIPA
				TXA
				AND	#%00111111
:SKIPA			LDY	#$00
:LOOP1			CMP	STAT_NUMS,Y
				BEQ	:SKIPB
				INY
				BNE	:LOOP1			;Always
:SKIPB			LDX	#$00
:LOOP2			DEY
				BMI	:SKIPC
:LOOP3			INX
				LDA	STAT_DATA-1,X
				BMI	:LOOP2
				BPL	:LOOP3			;Always
:SKIPC			TXA
				CLC
				ADC	#<STAT_DATA
				STA	TEMP
				LDA	#0
				TAY
				ADC	#>STAT_DATA
				STA	TEMP+1
:LOOP4			LDA	(TEMP),Y
				CMP	#$80
				AND	#$7F
				STA	TEXTBUF,Y
				INY
				BCC	:LOOP4
				LDA	#$8D
				STA	TEXTBUF,Y
				RTS

STAT_NUMS		DB	healthy,dead
				DB	abandoned,broken
				DB	intracc,compressd,inlimbo
				DB	lost
				DB	corroding,poisoned,bleeding
				DB	radiated,illA,blind
				DB	confused
				DB	smotherin,fast,strong
				DB	slipping,numb,ranaway
				DB	onfire,dizzy,stunned
				DB	immobile,controlld,choking
				DB	critical,rundown

STAT_DATA		USR	(HEALTHY)=
				USR	(DEAD)=
				USR	(ABANDONED)=
				USR	(BROKEN)=
				USR	(IN-TRACC)=
				USR	(COMPRESSD)=
				USR	(IN-LIMBO)=
				USR	(LOST)=
				USR	(CORRODING)=
				USR	(POISONED)=
				USR	(BLEEDING)=
				USR	(RADIATED)=
				USR	(ILL)=
				USR	(BLIND)=
				USR	(CONFUSED)=
				USR	(SMOTHERIN)=
				USR	(FAST)=
				USR	(STRONG)=
				USR	(SLIPPING)=
				USR	(NUMB)=
				USR	(RAN_AWAY)=
				USR	(ON_FIRE)=
				USR	(DIZZY)=
				USR	(STUNNED)=
				USR	(IMMOBILE)=
				USR	(CONTROLLD)=
				USR	(CHOKING)=
				USR	(CRITICAL)=
				USR	(RUN_DOWN)=

				DS	4				;FREE SPACE
