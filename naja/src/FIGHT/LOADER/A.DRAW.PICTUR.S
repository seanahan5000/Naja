*===============================
*
*===============================

DRAW_PICTURE	LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				LDA	DIRECTN
				STA	DIRHOLD
				LDA	BUFFER+4
				CMP	#$FF
				BNE	GOTDIR
				LDA	DIRECTN
				EOR	#$0F
				STA	DIRECTN
				JSR	GETNSEW
				LDA	BUFFER+4
				CMP	#$FF
				BNE	GOTDIR
				LDA	DIRECTN
				EOR	#$FF
				STA	DIRECTN
				JSR	GETNSEW
				LDA	BUFFER+4
				CMP	#$FF
				BNE	GOTDIR
				LDA	DIRECTN
				EOR	#$0F
				STA	DIRECTN
				JSR	GETNSEW
GOTDIR			LDA	SRANGE
				PHA
				LDX	#<SRANGE_TABLE
				LDY	#>SRANGE_TABLE
				LDA	ALIEN1
				JSR	QUIK_SEARCH
				LDX	#6
				BCC	:SKIPA
				TAX
:SKIPA			STX	SRANGE
				CPX	MXRANGE
				BCC	GOTUNL
				LDA	MXRANGE
				STA	SRANGE
GOTUNL			JSR	NOSCAN
				PLA
				STA	SRANGE

				LDX	ALIEN1
				LDA	DATA_BUFR+4,X	;PICTURE #'S

				CMP	#$FF
				BEQ	:NO_PICT		; sets carry

				PHA
				LDA	#>PICT_BUFR
				STA	SSTOREH
				LDX	#<S_PICDATA
				LDY	#>S_PICDATA
				LDA	#1
				JSR	FLOADER
				PLA
				ASL
				TAY
				LDA	PICT_BUFR+1,Y	; offset high byte (sector offset)
				STA	TEMP
				CLC
				ADC	#<S_PICDATA
				TAX
				LDA	PICT_BUFR+0,Y	; offset low byte (byte offset in sector)
				PHA
				LDA	PICT_BUFR+3,Y	; offset high byte of next picture to compute size
				PHA
				LDY	#>S_PICDATA
				BCC	:SKIPA
				INY
:SKIPA			PLA
				SEC
				SBC	TEMP
				ADC	#$00
				JSR	FLOADER
				PLA
				STA	TBLPNTL
				LDA	#>PICT_BUFR
				STA	TBLPNTH
				JSR	EXPANDR
				CLC					; clear carry if picture was drawn
:NO_PICT		RTS

SRANGE_TABLE	DB	3				;# of entries
				DB	3				;bytes per entry
				DB	1,$25,3			;SHELL #, ALIEN #, SRANGE
				DB	1,$2B,5
				DB	1,$2F,5
