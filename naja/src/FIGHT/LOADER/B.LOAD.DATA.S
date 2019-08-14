*===============================
*
*===============================

LOAD_DATA		LDA	#>SCODE_HEADR
				STA	SSTOREH
				LDX	#<S_SCODE12
				LDY	#>S_SCODE12
				LDA	#2
				JSR	FLOADER

				LDX	#0
				STX	ALIEN_NUMBER
:LOOP1			LDY	ALIEN1,X
				CPY	#$FF
				BEQ	:EXIT
				LDA	OPTIONS2
				AND	LOAD_BITS,X
				BEQ	:SKIPA
				LDA	#0
				STA	SCODE_PRESENT,X
				JSR	DATA_LOADER
:SKIPA			INC	ALIEN_NUMBER
				LDX	ALIEN_NUMBER
				CPX	#3
				BNE	:LOOP1
:EXIT			RTS

LOAD_BITS		DB	Xloaddata1,Xloaddata2,Xloaddata3

*-------------------------------

DATA_LOADER		LDA	DATA_BUFR+1		;Data offset low
				CLC
				ADC	#<DATA_BUFR
				STA	DATPNTL
				LDA	DATA_BUFR+2		;Data offset high
				ADC	#>DATA_BUFR
				STA	DATPNTH
				DEY
				TYA
				ASL
				CLC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:SKIPA
				INC	DATPNTH
:SKIPA			LDA	#>ALIEN_BUFR
				STA	SSTOREH

				LDY	#1
				LDA	(DATPNTL),Y
				CLC
				ADC	#<S_DATA12
				TAX
				LDY	#>S_DATA12
				BCC	:SKIPB
				INY
:SKIPB			LDA	#3
				JSR	FLOADER

				LDY	#0
				LDA	(DATPNTL),Y
				CLC
				ADC	#<ALIEN_BUFR
				STA	DATPNTL
				LDA	#$00
				ADC	#>ALIEN_BUFR
				STA	DATPNTH

				LDA	#<ALIEN_HEAP
				STA	TEMP
				LDA	#>ALIEN_HEAP
				STA	TEMP+1
				LDX	ALIEN_NUMBER
				JSR	ADVANCE_PTR
				LDA	TEMP
				STA	LPTR1
				CLC
				ADC	#2
				STA	LPTR2
				LDA	TEMP+1
				STA	LPTR1+1
				ADC	#0
				STA	LPTR2+1

				LDY	#5
				LDA	#0
:LOOP0			STA	(LPTR2),Y
				DEY
				BPL	:LOOP0
				INY					;data
				LDA	#6
				STA	(LPTR2),Y
				LDY	#2				;topviews
				LDA	#bytesperalien+6
				STA	(LPTR2),Y

				LDA	ALIEN_NUMBER
				JSR	POINTALN
				LDA	ALIEN_PTR
				STA	LPTR3
				LDA	ALIEN_PTR+1
				STA	LPTR3+1
				LDA	#<-bytesperalien
				STA	TEMP
				LDA	#>-bytesperalien
				STA	TEMP+1

				LDY	#bytesperalien-1			;TEMP
:1				LDA	BOGUS_ALIEN-16,Y			;TEMP
				STA	(DATPNTL),Y				;TEMP
				DEY					;TEMP
				CPY	#15				;TEMP
				BNE	:1				;TEMP

				JSR	MOVE_BYTES

GET_GROUPINGS	LDA	ALIEN_NUMBER
				ASL
				TAX
				LDA	GBUFF_LIST,X
				STA	TEMP
				LDA	GBUFF_LIST+1,X
				STA	TEMP+1
				LDY	#0
:LOOP1			LDA	(DATPNTL),Y
				STA	(TEMP),Y
				INY
				CMP	#$DD
				BNE	:LOOP1
:LOOP2			LDA	(DATPNTL),Y
				STA	(TEMP),Y
				INY
				CMP	#$FF
				BNE	:LOOP2
				TYA
				CLC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:SKIPB
				INC	DATPNTH
:SKIPB

ADD_TOPVIEWS	LDA	LPTR2
				CLC
				ADC	#bytesperalien+6
				STA	LPTR3
				LDA	LPTR2+1
				ADC	#0
				STA	LPTR3+1

				LDX	ALIEN_NUMBER
				LDY	#0
				TYA
				STA	TV_COUNTS,X
				LDA	(DATPNTL),Y
				STA	TV_ANIMATED,X
				AND	#%11110000
				CMP	#animated
				BNE	:LOOP1

:LOOP0			INY
				LDA	(DATPNTL),Y
				PHA
				LSR
				LSR
				LSR
				LSR
				STA	TV_WIDTHS,X
				PLA
				AND	#%00001111
				STA	TV_HEIGHTS,X
				TXA
				CLC
				ADC	#6				; offset to TV_TYPES,TV_SEQUENCES
				TAX					;	 then TV_REPEATS,TV_SPEEDS
				CPY	#3
				BNE	:LOOP0
				TYA
				SEC					;+1
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:LOOP1
				INC	DATPNTH

:LOOP1			LDY	#0
				LDA	(DATPNTL),Y
				CMP	#$FF
				BEQ	:SKIPB

				LDX	ALIEN_NUMBER
				INC	TV_COUNTS,X
				JSR	TVIEW_LENGTH
				LDY	#0
				LDA	#2
				SEC
				SBC	TEMP
				STA	(LPTR3),Y
				INY
				LDA	#0
				SBC	TEMP+1
				STA	(LPTR3),Y
				LDA	LPTR3
				CLC
				ADC	#2
				STA	LPTR3
				BCC	:SKIPA
				INC	LPTR3+1
:SKIPA			JSR	MOVE_BYTES
				JMP	:LOOP1

:SKIPB			LDX	ALIEN_NUMBER
				LDA	TV_ANIMATED,X
				TAY
				AND	#%11110000
				CMP	#animated
				BEQ	ADD_CODE
				LDA	#0
				STA	TV_ANIMATED,X
				TYA
				JSR	DIMENS_GET
				LDX	ALIEN_NUMBER
				STA	TV_WIDTHS,X
				TYA
				STA	TV_HEIGHTS,X

ADD_CODE		LDY	#4				;code
				LDA	LPTR3
				SEC
				SBC	LPTR2
				STA	(LPTR2),Y
				INY
				LDA	LPTR3+1
				SBC	LPTR2+1
				STA	(LPTR2),Y

				LDX	ALIEN_NUMBER
				LDA	ALIEN1,X
				LDX	#<SCODE_HEADR
				LDY	#>SCODE_HEADR
*JSR SEARCH_LIST
				CLC					;TEMP ***
				BCC	:SKIPB

				STA	DATPNTL
				LDY	#6
				CLC
				SBC	(TEMP),Y
				PHA
				LDY	#3
				LDA	(TEMP),Y
				TAX
				LDY	#7
				SBC	(TEMP),Y
				PHA

				TXA
				CLC
				ADC	#<S_SCODE12
				TAX
				LDY	#>S_SCODE12
				BCC	:SKIPA
				INY
:SKIPA			LDA	#>DATA_BUFR
				STA	SSTOREH
				STA	DATPNTH
				LDA	#3
				JSR	FLOADER

				JSR	MOVE_BYTES
				LDX	ALIEN_NUMBER
				DEC	SCODE_PRESENT,X

:SKIPB			LDY	#0
				LDA	LPTR3
				SEC
				SBC	LPTR1
				STA	(LPTR1),Y
				INY
				LDA	LPTR3+1
				SBC	LPTR1+1
				STA	(LPTR1),Y
				RTS


*-----------------------------------------------
* On Entry:
*   DATPNTL,H: Pointing to source data
*    LPTR3,+1: Pointing to destination
*     TEMP,+1: Negative number of bytes to move
*-----------------------------------------------

MOVE_BYTES		LDA	LPTR3
				SEC
				SBC	TEMP
				TAX
				LDA	LPTR3+1
				SBC	TEMP+1
				CMP	#>heaplength*$100+ALIEN_HEAP
				BCC	:SKIPB
				BNE	:SKIPA
				TXA
				BEQ	:SKIPB
:SKIPA			LDA	ALIEN1								;**
				LDY	ALIEN2								;**
				LDX	ALIEN3								;**
				DEBUG	"Alien heap full"				;**
				LDX	ALIEN_NUMBER
				LDA	#$FF
:1				STA	ALIEN1,X
				INX
				CPX	#3
				BNE	:1
				PLA
				PLA
				RTS

:SKIPB			LDY	#0
:LOOP1			LDA	(DATPNTL),Y
				STA	(LPTR3),Y
				INY
				BNE	:SKIPC
				INC	DATPNTH
				INC	LPTR3+1
:SKIPC			INC	TEMP
				BNE	:LOOP1
				INC	TEMP+1
				BNE	:LOOP1
				TYA
				PHA
				CLC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:SKIPD
				INC	DATPNTH
:SKIPD			PLA
				CLC
				ADC	LPTR3
				STA	LPTR3
				BCC	:EXIT
				INC	LPTR3+1
:EXIT			RTS

*-------------------------------------------------
* On Entry:
*   DATPNTL,H: Pointing to topview offset byte
*
* On Exit:
*   TEMP,+1: Negative length of topview including
*               offset and dimensions
*-------------------------------------------------

TVIEW_LENGTH	LDY	#0
				LDA	(DATPNTL),Y
				TAX
				AND	#%00001111
				STA	YCOUNT
				TXA
				LSR
				LSR
				LSR
				LSR
				STA	XCOUNT
				LDA	DATPNTH
				PHA
				LDA	#<-2
				STA	TEMP
				LDA	#>-2
				STA	TEMP+1
				LDY	#2
:LOOP0			LDA	XCOUNT
				STA	COUNTER
:LOOP1			LDX	#7
:LOOP2			LDA	(DATPNTL),Y
				CMP	#$80
				LDA	TEMP
				BNE	:SKIPA
				DEC	TEMP+1
:SKIPA			DEC	TEMP
				INY
				BNE	:SKIPB
				INC	DATPNTH
:SKIPB			BCS	:SKIPC
				DEX
				BNE	:LOOP2
:SKIPC			DEC	COUNTER
				BNE	:LOOP1
				DEC	YCOUNT
				BNE	:LOOP0
				PLA
				STA	DATPNTH
				RTS


*-------------------------------
* On Entry:
*   A: Dimens in bytes
*
* On Exit:
*   A: Width in squares
*   Y: Height in squares
*-------------------------------

DIMENS_GET		TAX
				LSR
				LSR
				LSR
				LSR
				LDY	#0
:LOOP1			CMP	WIDES,Y
				BCC	:SKIPA
				BEQ	:SKIPA
				INY
				BNE	:LOOP1
:SKIPA			INY
				TYA
				PHA
				TXA
				AND	#%00001111
				LDY	#0
:LOOP2			CMP	HIGHS,Y
				BCC	:SKIPB
				BEQ	:SKIPB
				INY
				BNE	:LOOP2
:SKIPB			INY
				PLA
				RTS

WIDES			DB	$02,$05,$06
				DB	$09,$0B,$0F

HIGHS			DB	$02,$03,$05
				DB	$07,$08,$0F

*-------------------------------

BOGUS_ALIEN
				DB	10				;swings
				DDB	$0005			;damage per swing
				DB	10				;blasts
				DDB	$0005			;damage per blast
				DB	%01110000		;swing squares
				DB	0				;inflicting ability
				DB	0				;status inflicted
				DB	0
				DB	0,0,0,$49,0		;fight parameters
				DB	%00000100		;blast source

				DB	$20				;upper reflex
				DB	$20				;lower reflex
				DB	0
				DDB	$0005			;damage
				DB	$30				;electrical shielding
				DB	$30				;physical shielding
				DB	0
				DB	0
				DB	0
				HEX	0100			;experience
				HEX	0100			;credit
				DB	$90				;finding odds
				DB	%11111100		;finding groups

				DB	$20				;suprisability
				DB	$20				;suprisingability
				DB	$30				;identifyability
				DB	$30				;jammability
				DB	$30				;immobilizability
				DB	0
				DB	0
				DB	0
				DB	$AA,$AA,$AA		;suseptabilities
				DB	$FF,$FF,$FF		;swing words
				DB	$33				;retreat odds
				DB	$33				;advance odds

*-------------------------------
