*-------------------------------

GRID_DRAW		LDA	#gridY
				STA	YCOUNT
				LDA	#WHITE1
				STA	COLOR
VLOOP			LDA	#gridX
				STA	XCOUNT
HLOOP			LDA	YCOUNT			; YCOORD for HPLOT
				LDY	#0				; XCOORDH for HPLOT
				LDX	XCOUNT			; XCOORDL for HPLOT
				BMI	:1
				INY					; XCOUNT wrapped so set XCOORDH to 1
:1				JSR	HPLOT
				LDA	XCOUNT
				CLC
				ADC	#gridDX
				STA	XCOUNT
				CMP	#<gridX+90
				BNE	HLOOP
				LDA	YCOUNT
				CLC
				ADC	#gridDY
				STA	YCOUNT
				CMP	#gridY+66		; TODO: fix assembler to handle 6*gridDY, etc.
				BNE	VLOOP
				RTS

*-------------------------------

; TV_DIMENS:
; TV_OFFSET:
; DATPNTL,H:

TV_DRAW			JSR	POINTAT_TV
				LDA	TV_DIMENS

				; check for new, animated format top views

				CMP	#$E0
				BCC	:1

				; skip 4 byte animation header and just draw first topview
				;	(POINTAT_TV has already skipped 2 bytes)

				LDY	#2
				LDA	(DATPNTL),Y
				STA	TV_DIMENS
				INY
				LDA	(DATPNTL),Y
				STA	TV_OFFSET
				INY
				TYA
				CLC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:1
				INC	DATPNTH

:1				LDA	#$C9
				STA	XPNT
				LDA	#gridY+1
				STA	YPNT

				; split dimensions into counters
				;
				LDA	TV_DIMENS
				TAX
				AND	#$0F
				STA	YCOUNT
				TXA
				LSR
				LSR
				LSR
				LSR
				STA	XCOUNT

				; apply origin offset to x and y coordinates
				;
				LDA	TV_OFFSET
				TAX
				AND	#$0F
				CLC
				ADC	YPNT
				STA	YCOORD
				TXA
				LSR
				LSR
				LSR
				LSR
				CLC
				ADC	XPNT
				STA	XCOORD
				; fall through

; XCOORD:
; YCOORD:
; XCOUNT:
; YCOUNT:
; DATPNTL,H:

FIRST_TLINE		LDA	XCOUNT
				LDX XCOORD

NEXT_TLINE		PHA
				STA	XCOUNT
				TXA
				PHA
				STA	XCOORD

				JSR	TABLER			; reads YCOORD
				JSR	SHFTCLC			; modifies XCOORD, sets SHIFT

NEXT_TCOL		LDY	#0
				LDX	#0
:1				LDA	(DATPNTL),Y
				BPL	:2
				AND	#$7F
				CPX	#6
				BNE	:3
:2				INY
:3				STA	CHARTAB,X
				INX
				CPX	#7
				BNE	:1

				; advance data pointer to next tile
				;
				TYA
				CLC
				ADC DATPNTL
				STA DATPNTL
				BCC :4
				INC DATPNTH
:4
				JSR	CHAROUT			; draw tile (modifies SCRATCH)

				DEC	XCOUNT
				BEQ	:5
				INC XCOORD			; advance by 7 pixels
				BNE	NEXT_TCOL		; always

:5				LDA	YCOORD
				CLC
				ADC	#7
				STA	YCOORD
				PLA					; pull XCOORD
				TAX
				PLA					; pull XCOUNT
				DEC	YCOUNT
				BNE	NEXT_TLINE
				RTS

*-------------------------------

; NOTE: Capturing topview work here for eventual integration into fight code.

			do 0

; A: prof/race
; X: grid X
; Y: grid Y
;
TVIEWIT			PHA
				LDA GRID_XPNTS,X
				STA XCOORD
				LDA GRID_YPNTS,Y
				STA YCOORD
				PLA

				; point at correct profession topview data
				;
				LSR A
				LSR A
				LSR A
				LSR A
				TAX
				LDA TCHAR_OFFSETS,X
				CLC
				ADC #<TCHAR_DATA
				STA DATPNTL
				LDA #0
				ADC #>TCHAR_DATA
				STA DATPNTH

				LDA #2
				STA XCOUNT
				STA YCOUNT
				BNE	FIRST_TLINE		; always

				; pixel positions in topview grid
				;
GRID_XPNTS		DB  #10, #25, #40, #55, #70
GRID_YPNTS		DB  #128,#139,#150,#161,#172

				; byte offsets into TCHARS data
				;
TCHAR_OFFSETS	DB  #0		; warrior
				DB  #20		; android
				DB  #38		; cybernate
				DB  #58		; juicer
				DB  #78		; physician
				DB  #98		; mutant
				DB  #118	; electromedic
				DB  #138	; genius
				DB  #158	; robot

				; profession topview data, without size/offset header
				;
TCHAR_DATA		DB  $32,$73,$7B,$1B,$6F,$6F,$6E		; warrior
				DB  $26,$67,$6F,$6C,$7B,$7B,$3B
				DB  $18,$70,$80
				DB  $0C,$07,$80

				DB  $30,$70,$18,$6C,$6F,$6F,$6F		; android
				DB  $06,$07,$0C,$1B,$FB
				DB  $0C,$78,$80
				DB  $18,$0F,$80

				DB  $30,$77,$73,$7B,$3F,$1F,$1E		; cybernate
				DB  $06,$77,$67,$6F,$7E,$7C,$3C
				DB  $38,$60,$80
				DB  $0E,$03,$80

				DB  $30,$70,$78,$1C,$6F,$2F,$6F		; juicer
				DB  $06,$67,$6F,$6C,$7B,$7A,$3B
				DB  $18,$70,$80
				DB  $0C,$07,$80

				DB  $30,$70,$38,$5C,$6F,$77,$4F		; physician
				DB  $06,$07,$0E,$1D,$7B,$77,$79
				DB  $3C,$70,$80
				DB  $1E,$07,$80

				DB  $32,$73,$7B,$1B,$6F,$2F,$6E		; mutant
				DB  $26,$67,$6F,$6C,$7B,$7A,$3B
				DB  $18,$70,$80
				DB  $0C,$07,$80

				DB  $30,$77,$3B,$5B,$6F,$77,$4E		; electromedic
				DB  $06,$77,$6E,$6D,$7B,$77,$39
				DB  $3C,$70,$80
				DB  $1E,$07,$80

				DB  $30,$73,$7B,$7B,$3F,$1F,$1E		; genius
				DB  $06,$67,$6F,$6F,$7E,$7C,$3C
				DB  $38,$70,$80
				DB  $0E,$07,$80

				DB  $38,$78,$08,$6F,$69,$69,$6F		; robot
				DB  $0E,$0F,$08,$7B,$4B,$4B,$7B
				DB  $08,$78,$80
				DB  $08,$0F,$80

			fin

*-------------------------------
