*===============================
*
*===============================

DEAD_STATUS		LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#dead			;Make dead and broken characters
				BEQ	:SKIPA			;  into lost characters
				CMP	#broken
				BNE	:SKIPC
:SKIPA			LDY	#miscflags		;Auto-compress dead and broken
				LDX	#compressd		;  characters that have implants
				LDA	(CHARDL),Y
				BMI	:SKIPB
				LDX	#lost
:SKIPB			TXA
				LDY	#status
				STA	(CHARDL),Y
:SKIPC			CMP	#compressd		;Convert all compressed
				BNE	:SKIPD			;  characters in group to
				LDA	#intracc		;  intracc status
				STA	(CHARDL),Y
				INC	LOST_CHARS		;Make another character findable
:SKIPD			INC	COUNT
				LDA	COUNT
				CMP	GRPCONT
				BNE	:LOOP1

DEAD_SETUP		JSR	CLEAR2
				LDA	#$40
				STA	PAGE

				LDA	#WHITE1			;Draw desk-top
				STA	COLOR
:LOOP1			LDY	#2
				JSR	LINER
				LDA	#RED
				STA	COLOR
				LDA	OLINE+2
				CLC
				ADC	#2
				STA	OLINE+2
				STA	OLINE+5
				CMP	#$C1
				BNE	:LOOP1

				LDY	#picLCORNER		;Draw view screen opening
				JSR	PICKER
				LDY	#picRCORNER
				JSR	PICKER
				LDA	#WHITE1
				STA	COLOR
				LDY	#0
				JSR	LINER

				LDA	#BLUE			;Draw top of view screen
				STA	COLOR
:LOOP2			LDY	#1
				JSR	LINER
				INC	BBORDER+2
				LDA	BBORDER+2
				STA	BBORDER+5
				CMP	#$7A
				BNE	:LOOP2

				LDY	#picMUG
				JSR	PICKER

				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY

DEAD_BEGIN		JSR	BEEP
				LDA	#0
				JSR	WAIT
				JSR	BEEP
				JSR	BUILD_SCREEN
				JSR	SCROLL_SCREEN
				JSR	FACE_FADER

				LDA	#0
				STA	COUNT
				JSR	GO_TALK
				LDA	#$40
				STA	PAGE
				JSR	BUILD_SCREEN
				JSR	SHOW_STATS
				JSR	FACE_FADER
				LDA	#1
				STA	COUNT
:LOOP1			LDA	#$40
				STA	PAGE
				JSR	GO_TALK
				INC	COUNT
				LDA	COUNT
				CMP	#$04
				BNE	:LOOP1

				JSR	BUILD_SCREEN
				DEC	CLMOD1+2
				DEC	CLMOD2+2
				JSR	FADER

DEAD_DONE		LDA	#side_MS
				STA	DISK_SIDE
				LDA	#$90
				STA	SSTOREH
				LDX	#<$0010
				LDY	#>$0010
				LDA	#3
				JSR	SLOADER
				JMP	$9000

*-------------------------------

BEEP			LDX	#$00
:LOOP1			STA	CLICK
				LDA	#$08	
				JSR	WAIT
				DEX
				BNE	:LOOP1
				RTS

*-------------------------------

WAITER			LDA	#$00
				JSR	WAIT2
				BNE	WAITEND
				DEX
				BPL	WAITER
WAITEND			BIT	UNSTROB
				RTS

*-------------------------------

BUILD_SCREEN	JSR	CLEAR2
				LDA	#$40
				STA	PAGE
				LDY	#picSCREEN
				JSR	PICKER
				LDA	#BLACK2
				STA	COLOR
				LDY	#$03
				JSR	LINER
				LDA	#WHITE2
				STA	COLOR
				LDY	#$04
				JMP	LINER

*-------------------------------

SCROLL_SCREEN	LDX	#$74
				STX	LINENUM	
:LOOP1			JSR	DRAW_SCREEN
				DEC	LINENUM
				DEC	LINENUM
				LDX	LINENUM
				CPX	#$02
				BNE	:LOOP1
				RTS

*-------------------------------

DRAW_SCREEN		STX	LNUMB1
				LDA	#$04
				STA	LNUMB2
SLOOP1			LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				LDX	LNUMB2
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#$25	
				CPX	#$09	
				BCC	SLOOP2X
				LDA	(DESTINL),Y
				ORA	#$80	
				AND	#$FE
				STA	(DESTINL),Y
SLOOP2X			DEY
				CPX	#$08	
				BCS	SLOOP2	
				LDA	(DESTINL),Y
				AND	TCDATA-4,X
				ORA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
SLOOP2			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				CPY	#$0A	
				BNE	SLOOP2
				LDX	LNUMB1
				CPX	#$76
				BCC	NOBCORN
				LDA	#$FF
				CPX	#$79
				BNE	NOTSKIP
				LDA	#$FE
NOTSKIP			AND	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				LDA	(SCREENL),Y
				AND	BCDATA-118,X
				ORA	(DESTINL),Y
				STA	(DESTINL),Y
				JMP	REMERGE
NOBCORN			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				LDA	(SCREENL),Y
				STA	(DESTINL),Y
REMERGE			INC	LNUMB2
				INC	LNUMB1
				LDX	LNUMB1
				CPX	#$7A	
				BNE	SLOOP1
				LDX	#$70	
SLOWER			CPX	LNUMB2
				BCC	SCROUT
				LDA	#$06	
				JSR	WAIT
				DEX
				BNE	SLOWER
SCROUT			RTS

TCDATA			DFB	$FF,$FC,$F0	
				DFB	$C0

BCDATA			DFB	$F8,$E0,$80
				DFB	$80

*-------------------------------

FACE_FADER		LDY	#picGUY
				JSR	PICKER	
FADER			LDA	#$08
				STA	COUNTER
FLOOP1			LDA	#$10
				STA	LINENUM
FLOOP2			TAX
				LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				EOR	#$60
				STA	SCREENH
				TXA
				CLC
				ADC	COUNTER
				AND	#$07
				TAX
				LDY	#$1E
FLOOP3			LDA	MASKS,X	
				EOR	#$FF
				AND	(DESTINL),Y
				STA	SCRATCH	
				LDA	(SCREENL),Y
				AND	MASKS,X
				ORA	SCRATCH	
				STA	(DESTINL),Y
				INX
				TXA
				AND	#$07
				TAX
				DEY
CLMOD1			LDA	CLICK	
CLMOD2			LDA	CLICK	
				CPY	#$0A
				BNE	FLOOP3
				LDA	LINENUM
				CLC
				ADC	#$05
				STA	LINENUM
				CMP	#$73
				BCC	FLOOP2
				SEC
				SBC	#$62	
				STA	LINENUM
				CMP	#$15	
				BNE	FLOOP2	
				DEC	COUNTER
				BNE	FLOOP1
				LDA	#$BF	
				STA	CLMOD1+2
				STA	CLMOD2+2
				RTS

MASKS			DFB	$01,$10,$02
				DFB	$20,$04,$40
				DFB	$08,$80

*-------------------------------

TALKER			LDA	#$10
				STA	LINENUM
				LDA	TEOFF,X	
				STA	COUNTER
TELOOP1			LDY	COUNTER
				LDA	TEDATA,Y
				STA	SCRATCH
				BPL	TESKIP1
				CMP	#$FF
				BEQ	TALKOUT
				CPY	#$16	
				BEQ	DELAY
				CPY	#$06	
				BNE	NODELAY
DELAY			TAX	
				LDA	#$00
				JSR	WAIT
				LDA	#$00
				JSR	WAIT
				LDA	#$80
				JSR	WAIT
				TXA	
NODELAY			AND	#$7F
				STA	SCRATCH
				LDA	LINENUM
				TAX
				CLC
				ADC	#$09
				STA	LINENUM
				BNE	TESKIP2
TESKIP1			LDA	LINENUM
				TAX
				CLC
				ADC	#$09
TESKIP2			STA	ENDLINE
				INC	SCRATCH
				TXA
				PHA
				JSR	MOUTH_UP
				PLA
				TAX
				LDY	COUNTER
				LDA	TEDATA-1,Y
				BPL	GOSTORE
				LDA	#$FF	
GOSTORE			STA	TESMOD+1
TELOOP2			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
TESMOD			LDY	#$00	
				INY
TELOOP3			LDA	(DESTINL),Y
				STA	(SCREENL),Y
				INY	
				CPY	SCRATCH
				BNE	TELOOP3
				INX
				CPX	ENDLINE
				BNE	TELOOP2
				JSR	MOUTH_DOWN
				INC	COUNTER
				BNE	TELOOP1
TALKOUT			RTS

TEOFF			DFB	$00,$0C,$1A	
				DFB	$26	
				DFB	$FF				;Must be here

TEDATA			DFB	$04,$8F,$06
				DFB	$0B,$8F,$05
				DFB	$90,$05,$8D	
				DFB	$05,$0E,$FF	
				DFB	$08,$8F,$05	
				DFB	$0A,$90,$06
				DFB	$0B,$90,$01
				DFB	$0B,$8F,$04	
				DFB	$0F,$FF	
				DFB	$05	
				DFB	$8F,$03,$07
				DFB	$8B,$03,$8E
				DFB	$05,$8D,$06	
				DFB	$0C,$FF
				DFB	$04,$0F,$13
				DFB	$FF

*-------------------------------

MOUTH_UP		LDY	#picMOUTHB
				JSR	MUDSUB
				JSR	RNDMIZE
				BIT	RANDOM1
				BPL	MTOUT	
				LDY	#picMOUTHC
				BPL	MUDSUB			;Always

MOUTH_DOWN		DEC	MHOLDER
				LDY	MHOLDER
				JSR	MUDSUB2
				LDA	MHOLDER
				CMP	#picMOUTHA
				BNE	MOUTH_DOWN
MTOUT			RTS

MUDSUB			STY	MHOLDER
MUDSUB2			JSR	PICKER
				LDA	#$C0
				JMP	WAIT

*-------------------------------

SHOW_STATS		LDA	#$00
				STA	COUNT
STLOOP			JSR	POINTIT
				LDY	#$04	
				JSR	TEXTER
				LDX	#$00
				LDY	#$00
				JSR	NAMEIT
				LDA	#$88
				LDY	#$15
				JSR	LINE
				LDY	#profrace
				LDA	(CHARDL),Y
				PHA
				LSR
				LSR
				LSR
				LSR
				TAX
				LDA	PROFOFF,X
				TAY
				LDX	#$00	
MORPROF			LDA	PROFDAT,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$09
				BNE	MORPROF
				LDA	#$8D
				STA	TEXTBUF,X
				LDA	#$88
				LDY	#$1F	
				JSR	LINE
				PLA
				PHA
				AND	#$0F
				TAX
				LDA	RACEOFF,X
				TAY
				PHA
				PLA
				BPL	NOROB
				LDY	#$8B	
NOROB			LDX	#$00
MORRACE			LDA	RACEDAT,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$07
				BNE	MORRACE
				LDA	#$8D
				STA	TEXTBUF,X
				LDA	#$88
				LDY	#$27
				JSR	LINE
				PLA
				PHA
				BMI	RSKIP1
				LDY	#$0E
				JSR	TOBUFFR
				LDA	#$2F
				JSR	OUTPUT
RSKIP1			LDY	#$09
				JSR	TOBUFFR
				LDA	#$00
				STA	BUFFER
				STA	BUFFER+1
				LDA	#$37
				JSR	OUTPUT
				PLA
				BMI	:SKIPA
				LDY	#$13
				JSR	TOBUFFR
				LDA	#$3F
				JSR	OUTPUT
:SKIPA			LDY	#status
				LDA	(CHARDL),Y
				LDY	#5				;"Presumed compressed"
				CMP	#lost
				BNE	:SKIPB
				INY					;"Presumed lost"
:SKIPB			JSR	TEXTER
				BIT	UNSTROB
				JSR	FADER
				JSR	BUILD_SCREEN
KEYLOOP			LDA	KEYBRD
				BPL	KEYLOOP
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	KEYLOOP
				INC	COUNT
				LDA	COUNT
				CMP	GRPCONT
				BEQ	RTS1	
				JMP	STLOOP

TOBUFFR			LDX	#$00
TOLOOP			LDA	(CHARDL),Y
				STA	BUFFER,X
				INY
				INX
				CPX	#$04
				BNE	TOLOOP
RTS1			RTS

OUTPUT			STA	YPNT
				LDY	#3
:LOOP1			LDA	BUFFER,Y
				PHA
				DEY
				BPL	:LOOP1
				LDX	#0
				LDA	#4
				JSR	LEFT_DIGITS
				LDA	#$8D
				STA	TEXTBUF,X
				LDA	#$88
				LDY	YPNT
				JMP	LINE

*-------------------------------

GO_TALK			JSR	CLEAR2
				LDY	COUNT
				JSR	TEXTER
				JSR	DUPCATE
				LDA	#$20
				STA	PAGE
				LDX	COUNT
				JSR	TALKER
				LDY	COUNT
				LDX	WAITS,Y
				JSR	WAITER
REPLACE			LDX	#SCREENL
				LDY	#DESTINL	
				BNE	MOVECOM
DUPCATE			LDX	#DESTINL	
				LDY	#SCREENL	
MOVECOM			STX	SORCMOD+1
				STY	DESTMOD+1
				LDX	#$10	
MOVLOOP			LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	DESTINH
				TXA
				EOR	#$80
				TAX
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				TXA
				EOR	#$80
				TAX
				LDY	#$13	
SORCMOD			LDA	(SCREENL),Y
DESTMOD			STA	(DESTINL),Y
				DEY
				BPL	SORCMOD
				TXA
				INX
				AND	#$7F
				CMP	#$3C
				BNE	MOVLOOP
				RTS

WAITS			DFB	$0D,$0D,$0D
				DFB	$03

*-------------------------------

TEXTER			TYA
				ASL
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT

TEXTS			DW	MESSAGE
				DW	MESSAG2	
				DW	MESSAG3	
				DW	MESSAG4	
				DW	HEADING	
				DW	PRESUME
				DW	PRESUME2

LINER			TYA
				ASL
				TAY
				LDA	LINES,Y
				STA	POINTL
				LDA	LINES+1,Y
				STA	POINTH
				JMP	LINEOUT

LINES			DW	HALL
				DW	BBORDER
				DW	OLINE
				DW	REMOVER
				DW	ADDER

PICKER			TYA
				ASL
				TAY
				LDA	PICKS,Y
				STA	TBLPNTL
				LDA	PICKS+1,Y
				STA	TBLPNTH
				JMP	EXPANDR

PICKS			DW	LCORNER			;0
				DW	RCORNER			;1
				DW	MUG				;2
				DW	SCREEN			;3
				DW	GUY				;4
				DW	MOUTHA			;5
				DW	MOUTHB			;6
				DW	MOUTHC			;7
