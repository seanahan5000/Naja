TESTING			JSR	CLRBOX	
				JSR	CLEAR2
				JSR	DOCOTAB
				LDA	#$40
				STA	PAGE
				LDA	#VIOLET
				STA	COLOR
				LDY	#$01
				JSR	LINER2	
				LDY	#$00
				JSR	TEXTER2
				LDY	#$01
				JSR	TEXTER2
				LDA	#GREEN
				STA	COLOR
				LDY	#$00
				JSR	LINER2
				LDA	#$42
				STA	SELECT
				LDA	#$75
				STA	YPNT
				JSR	HEADER

				LDA	#0
				STA	COUNT
:LOOP1			TAY
				LDX	TYPOINTS,Y
				STX	YPNT
				JSR	STATLIN
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1

				STA	SCNDARY
				JSR	RESET_CHLIST
				LDA	#0
				STA	LEGALS+7
				STA	WHICH_CDEF+1
GOKCOMN			LDX	#<WHICH_CDEF
				LDY	#>WHICH_CDEF
				JSR	INIT_CURSOR
				JSR	GETKEY
				LDA	CURSOR
				CMP	#$07
				BNE	NO_LEAVE
				JMP	LEAVES

*-------------------------------
WHICH_CDEF		DB	$07
				DB	$FF				;Modified
				DW	:CURSIT
:CURSIT			LDX	CURSOR
				LDY	TYPOINTS,X
				LDX	#$03
				JMP	ARROWER
*-------------------------------

NO_LEAVE		STA	WHICH_CDEF+1
				JSR	POINTIT
				JSR	MARKIT
				LDY	#status
				LDA	(CHARDL),Y
				CMP	#healthy
				BEQ	:SKIPA
				JSR	CLRTOP
				LDY	#$01
				JSR	TEXTER2
				LDA	#RED
				STA	COLOR
				LDY	#$04
				JSR	LINER2
				LDY	#$0B
				JSR	TEXTER2
				JSR	SPACE_WAIT
				JSR	CLRTOP
				INC	WHICH_CDEF+1
				JMP	PFCOMN2
:SKIPA			LDY	#$01
				JSR	TEXTER2
				JSR	PASS_FAIL
				BCS	PASSES_TEST

FAILS_TEST		LDA	#BLUE
				STA	COLOR
				JSR	CLRTOP
				LDY	#$03
				JSR	LINER2
				LDY	#$03
				JSR	TEXTER2
				LDX	#$01
				JSR	NAMER
				LDY	#$04
				JSR	TEXTER2
				LDX	#$01	
				JSR	LEVPROF
				LDY	#$05
				JSR	TEXTER2
				JSR	MOREX	
				LDA	LEVTOTL
				ORA	LEVTOTL+1
				ORA	LEVTOTL+2
				BNE	:SKIPA
				LDA	LEVTOTL+3	
				CMP	#$01
				BNE	:SKIPA
				LDA	#$EE
				STA	PLURAL
:SKIPA			LDY	#$06
				JSR	TEXTER2
				LDA	#$1D	
				STA	PLURAL
				INC	WHICH_CDEF+1
				JMP	PFCOMN

PASSES_TEST		LDA	#RED
				STA	COLOR
				JSR	CLRTOP
				LDY	#$02
				JSR	LINER2
				LDY	#$02
				JSR	TEXTER2
				LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#physician*16
				BNE	NO_EMED
				LDY	#level
				LDA	(CHARDL),Y
				BNE	NO_EMED
				INY
				LDA	(CHARDL),Y
				CMP	#$14
				BNE	NO_EMED
				LDX	#$02
				JSR	NAMER
				LDY	#$09	
				JSR	TEXTER2
				JSR	LEVEL_OUT
				LDA	#$D5
				LDY	#$0F
				JSR	LINE
				LDY	#$0A	
				JSR	TEXTER2
				JSR	PROFFER
				LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%00001111
				ORA	#electromedic*16
				STA	(CHARDL),Y
				JSR	PROFFER
				JMP	EMEDCOM

NO_EMED			LDX	#$00
				JSR	NAMER
				LDY	#$07
				JSR	TEXTER2
				LDX	#$00
				JSR	LEVPROF
EMEDCOM			LDY	#level
				LDA	LEVCNT
				STA	(CHARDL),Y
				INY
				LDA	LEVCNT+1
				STA	(CHARDL),Y
				LDY	#$08
				JSR	TEXTER2

				JSR	DRWSTAT	
				JSR	UPOWER	
				JSR	DAMINC

PFCOMN			JSR	SPACE_WAIT
PFCOMN2			JSR	CLRTOP
				LDA	#VIOLET
				STA	COLOR
				LDY	#$01
				JSR	LINER2	
				LDY	#$00
				JSR	TEXTER2
				LDY	#$01
				JSR	TEXTER2
				JSR	MARKIT
				JMP	GOKCOMN

SPACE_WAIT		BIT	UNSTROB
:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				BIT	UNSTROB
				JSR	CHECK_ENTER
				BNE	:LOOP1
				RTS

LEAVES			LDA	#$20
				STA	PAGE
				JSR	CLRBOX
				STA	PRIMARY
				LDA	#$01
				STA	CURSOR
				JMP	ANYONEX	

PROFFER			JSR	PROFNAM
				LDA	#$8D
				STA	TEXTBUF+3
				LDY	CURSOR
				LDA	TYPOINTS,Y
				TAY
				LDA	#$10
				JMP	LINE

CLRTOP			LDX	#$00
:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				LDY	#$02
				LDA	#$00
:LOOP2			STA	(SCREENL),Y
				INY
				CPY	#$26
				BNE	:LOOP2
				INX
				CPX	#$6B
				BNE	:LOOP1
				RTS

MARKIT			LDY	CURSOR
				LDA	TYPOINTS,Y
				STA	YPNT
				LDA	#7
				STA	XPNT
				LDA	#3
TEST_SHAPES		LDX	#<SHAPES
				LDY	#>SHAPES
				JMP	DRAW_SHAPES

NAMER			LDY	#name+9
:LOOP1			LDA	(CHARDL),Y
				STA	TEXTBUF,Y
				DEY
				BPL	:LOOP1
				LDY	#$09
NAMSTOP			LDA	TEXTBUF,Y
				CMP	#$0A
				BNE	NOTSPC
				DEY
				BPL	NAMSTOP
NOTSPC			INY
				TXA
				PHA
				LDA	XDATOFF,X
				TAX
XDLOOP			LDA	XDATA,X
				STA	TEXTBUF,Y
				INX
				INY
				CMP	#$8D
				BNE	XDLOOP
				PLA
				TAX
				LDY	#$06
				LDA	XDATX,X
				JMP	LINE

XDATOFF			DB	$00,$05,$0D
XDATA			USR	(_HAS)
				USR	('S_TEST)
				USR	(_IS)

XDATX			DB	$99,$87,$99

LEVPROF			TXA
				PHA
				JSR	LEVEL_OUT
				LDA	#$0A
				STA	TEXTBUF,X
				INX
				LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				CMP	#electromedic
				BNE	RESTPRF
				LDY	#0
DOELEC			LDA	ELECTRO,Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#$07
				BNE	DOELEC
				LDY	#$06
				LDA	PROFOFF,Y
				TAY
				INY
				BNE	REST2

ELECTRO			USR	(ELECTRO)-

RESTPRF			TAY
				LDA	PROFOFF,Y
				TAY
REST2			LDA	PROFDAT,Y
				STA	TEXTBUF,X
				CMP	#$0A
				BEQ	RESTED
				CMP	#$8D
				BEQ	RESTED
				INY
				INX
				BNE	REST2
RESTED			PLA
				PHA
				BNE	ADDMORE
				LDA	#$2D
				STA	TEXTBUF,X
				INX
				LDA	#$8D
				STA	TEXTBUF,X
				BNE	RESTCOM
ADDMORE			LDY	#$00
AM2				LDA	SHOULD,Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#$0D
				BNE	AM2
				BEQ	RESTCOM

SHOULD			USR	(,_AND_SHOULD)

RESTCOM			PLA
				TAX	
				LDA	YCS,X	
				TAY
				LDA	XCS,X	
				JMP	LINE

XCS				DB	$75,$2D
YCS				DB	$18,$2A


LEVEL_OUT		LDY	#level+1
				LDA	(CHARDL),Y
				CLC
				SED
				ADC	#1
				STA	LEVCNT+1
				PHA
				DEY
				LDA	(CHARDL),Y
				ADC	#0
				STA	LEVCNT
				PHA
				CLD
				LDX	#0
				LDA	#2
				JSR	LEFT_DIGITS
				LDA	#$8D
				STA	TEXTBUF+4
				RTS

DRWSTAT			LDA	#$03
				STA	COUNT
UPSTATS			JSR	RNDMIZE
				LDY	COUNT
				LDA	LOCS,Y
				TAY
				LDA	RANDOM1	
				AND	#$03
				CMP	#$03
				BEQ	UPSTATS
				LDX	COUNT
				STA	PLUSTAB,X
				SED
				CLC
				ADC	(CHARDL),Y	
				CLD
				BCC	NOMAXD
				LDA	#$00
				STA	PLUSTAB,X
				LDA	#$99
NOMAXD			STA	(CHARDL),Y
				DEC	COUNT
				BPL	UPSTATS

				LDA	#$03
				STA	COUNT
				LDA	#$8D
				STA	TEXTBUF+2
STLOOP			LDY	COUNT
				LDA	LOCS,Y
				TAY
				LDA	(CHARDL),Y
				PHA
				AND	#$0F
				STA	TEXTBUF+1
				PLA
				LSR
				LSR
				LSR
				LSR
				BNE	NOT0
				LDA	#$0A
NOT0			STA	TEXTBUF
				LDY	COUNT
				LDA	STATYS,Y
				TAY
				STA	YPNT
				LDA	#$9F
				JSR	LINE
				LDA	#$AD
				STA	XPNT
				LDY	COUNT
				LDA	PLUSTAB,Y
				BEQ	MARKED
MARLOOP			LDA	#4
				JSR	TEST_SHAPES
				LDA	XPNT
				CLC
				ADC	#$08
				STA	XPNT
				LDX	COUNT
				DEC	PLUSTAB,X	
				BNE	MARLOOP
MARKED			DEC	COUNT
				BPL	STLOOP
				LDY	#strength
				LDA	(CHARDL),Y
				LDY	#$03
				LDX	#$00
BKLOOP1			CMP	BACKUTS,X
				BCC	GOTBACK
				INY
				INX
				CPX	#$03
				BNE	BKLOOP1
GOTBACK			TYA
				LDY	#back
				STA	(CHARDL),Y
				RTS

LOCS			DB	intelligence
				DB	upreflex
				DB	lwreflex
				DB	strength

STATYS			DB	$41,$4A,$53
				DB	$5C
BACKUTS			DB	$40,$50,$60
PLUSTAB			DB	$00,$00,$00,$00

MOREX			LDX	#3
:LOOP1			LDA	LEVTOTL,X
				PHA
				DEX
				BPL	:LOOP1
				LDA	#4
				INX
				JSR	LEFT_DIGITS
				LDY	#$00
:LOOP2			LDA	MORE,Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#$06
				BNE	:LOOP2
				LDA	#$A5
				LDY	#$33
				JMP	LINE

MORE			USR	(_MORE)

UPOWER			JSR	DOPOW
				LDY	#organic
				LDA	#$00
				SEC
				SED
				SBC	(CHARDL),Y
				CLC
				ADC	#$20
				CLD
				TAX
				ASL
				ASL
				ASL
				ASL
				STA	LEVTOTL+2
				TXA
				LSR
				LSR
				LSR
				LSR
				SED
				CLC
				ADC	#$30
				CLD
				STA	LEVTOTL+1
				LDA	#$00
				STA	LEVTOTL
				LDY	#profrace
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#juicer*16
				BNE	NOJUICR
				LDX	#$02
				CLC
LEVLOOP			SED
				LDA	LEVTOTL,X
				ADC	LEVTOTL,X
				STA	LEVTOTL,X
				CLD
				DEX
				BPL	LEVLOOP
NOJUICR			LDX	#$02
				LDY	#energymax+2
				CLC
ADDCONS			LDA	(CHARDL),Y
				SED
				ADC	LEVTOTL,X
				CLD
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	ADDCONS
				BCC	DOPOW
				LDY	#energymax+2
				LDA	#$00
				STA	(CHARDL),Y
				DEY
				LDA	#$99
				STA	(CHARDL),Y
				DEY
				STA	(CHARDL),Y
DOPOW			JSR	POWROUT
				LDX	#6
				LDA	#$EE
:LOOP1			STA	TEXTBUF,X
				DEX
				BPL	:LOOP1
				LDX	CURSOR
				LDY	TYPOINTS,X
				LDA	#$F0	
				JMP	LINE

TYPOINTS		DB	$7F,$87,$8F
				DB	$97,$9F,$A7
				DB	$AF,$B9
