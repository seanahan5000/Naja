RPCOUNT			=	$00				;COUNT OF REPEATING BYTES
SCRATCH			=	$06				;LOCATION TO TAKE OVER FLOW FROM SHIFT
LETBUFL			=	$0D				;LOCATION OF LETTER DATA BUFFER (LOW)
LETBUFH			=	$0E				;LOCATION OF LETTER DATA BUFFER (HIGH)
COUNTS			=	$0F
LCOUNT			=	$11
CYCLE			=	$14				;CURSOR CYCLE COUNTER
DELAYL			=	$15				;TIME DELAY COUNTER LOW
DELAYH			=	$17				;TIME DELAY COUNTER HIGH
TOP				=	$11				;TOP BORDER OF AREA TO BE PACKED
BOTTOM			=	$12				;BOTTOM BORDER OF AREA TO BE PACKED
LEFT			=	$13				;LEFT BORDER OF AREA TO BE PACKED
RIGHT			=	$14				;RIGHT BORDER OF AREA TO BE PACKED
CURCHAR			=	$16				;CURRENT CHARACTER (FROM TABLE)
CURCHAR2		=	$17				;NEXT CHARACTER (IF 2 BYTE PATTERN)
DATAPNT			=	$18
COUNTH			=	$1D

WHITE			=	$1F				;WHITE LINE CHARACTER
LINELEN			=	$27				;MAXIMUM LENGTH OF LINE OF CHARACTERS
SPEED			=	$1001			;PULSE CURSOR SPEED
UNSOLID			=	$00				;COLOR TO BE CONSIDERED TRANSPARENT
RPCODE			=	$FE				;REPEAT CODE

				ORG	$0980

***BEGINNING-OF-LINE-DRAWING-ROUTINE*** 
				ERR	*-$0980
LINEOUT			LDY	#$00			;CLEAR LINE OFFSET
				JSR	PNTLOAD			;LOAD A POINT
				LDA	TABEL+1			;PREPARE THE POINT FOR HPOSIONING
				TAX
				LDA	TABEL	
				TAY
				LDA	TABEL+2
				JSR	HPOSN
REPEATL			LDY	LCOUNT			;HPOSN THAT POINT
				JSR	PNTLOAD			;LOAD ANOTHER POINT
				LDA	TABEL			;PREPARE THE POINT FOR LINE DRAWING
				TAX
				LDA	TABEL+2
				TAY
				LDA	TABEL+1	
				JSR	HLINA			;DRAW A LINE TO THAT POINT
				JMP	REPEATL			;REPEAT
TABEL			DB	$00,$00,$00		;TABLE FOR CURRENT POINT
PNTLOAD			LDA	(POINTL),Y		;LOAD A BYTE
				CMP	#$FE			;IS IT AN END OF LINE FLAG?
				BEQ	ENDLINE			;YES, THEN BRANCH
				CMP	#$FF			;IS IT AN END OF DATA FLAG?
				BEQ	ENDDATA			;YES, THEN BRANCH
				STA	TABEL
				INY
				LDA	(POINTL),Y
				STA	TABEL+1
				INY
				LDA	(POINTL),Y
				STA	TABEL+2
				INY
				STY	LCOUNT
				JMP	GOBACK
ENDLINE			INY					;COMPENSATE FOR END OF LINE FLAG
				TYA					;ADD OFFSET TO CURRENT ADDRESS
				CLC					;OF LINE SEGMENT BEING DRAWN 
				ADC	POINTL
				STA	POINTL			;LOW
				LDA	POINTH
				ADC	#$00
				STA	POINTH			;AND HIGH
				PLA					;PULL OFF ONE RETURN ADDRESS
				PLA
				JMP	LINEOUT			;JUMP TO BEGINNING
ENDDATA			PLA					;PULL OFF ONE RETURN ADDRESS
				PLA
GOBACK			RTS					;LEAVE ROUTINE
***END-OF-LINE-DRAWING-ROUTINE***

***BEGINNING-OF-TEXT-LINE-DRAWING-ROUTINE***
				ERR	*-$09E0
TEXTOUT			LDY	#$00			;CLEAR LINE OFFSET
				LDX	#$00			;CLEAR LINE BUFFER OFFSET
				LDA	(POINTL),Y		;LOAD A BYTE
				CMP	#$FF			;IS IT AN END FLAG?
				BEQ	EXIT			;YES, THEN EXIT
				STA	XCOORD
				INY
				LDA	(POINTL),Y
				STA	SHIFT
				INY
				LDA	(POINTL),Y
				STA	YCOORD
				INY
AGAINT			LDA	(POINTL),Y
				STA	TEXTBUF,X
				INY
				INX
				CMP	#$8D			;IS A RETURN CHARACTER ENCOUNTERED?
				BNE	AGAINT			;NO, THEN READ ANOTHER BYTE
				TYA					;ADD LINE OFFSET TO CURRENT ADDRESS
				CLC					;OF TEXT LINE BEING DRAWN
				ADC	POINTL
				STA	POINTL			;LOW
				LDA	POINTH
				ADC	#$00
				STA	POINTH			;AND HIGH
				JSR	LINE2			;DRAW A LINE OF TEXT
				JMP	TEXTOUT			;GO BACK TO START
EXIT			RTS
***END-OF-TEXT-LINE-DRAWING-ROUTINE***

				ERR	*-$0A15
INPUT			STA	XCOORD
				STY	YCOORD
				JSR	SHFTCLC			;JSR TO SHIFT CALCULATING ROUTINE
				ERR	*-$0A1C
INPUT2			JSR	TABLER			;CREATE HIRES STORAGE LOCATION TABLE
				LDX	#$00			;SET LETTER POINTER TO ZERO
				TXA
				PHA					;PUSH ITS VALUE
				JSR	CLEAR
				LDA	#$00
				STA	COUNTS
				ERR	*-$0A2A
KEYREAD			JSR	PULSE
				LDA	KEYBRD
				BPL	KEYREAD
				BIT	UNSTROB
				CMP	#$8D	
				BNE	:NORETRN		;BRANCH IF RETURN ENCOUNTERED
				JMP	:RETURN
:NORETRN		CMP	#$88
				BEQ	:BACKSPC		;BRANCH IF BACK ARROW IS PRESSED
				CMP	#$FF			;DELETE
				BEQ	:BACKSPC
				TAY
				LDA	MAXTEXT
				BEQ	:MAXZERO
				CMP	COUNTS
				BEQ	KEYREAD	
				INC	COUNTS
				LDA	XCOORD
				CMP	#LINELEN		;HAS THE END OF THE LINE BEEN REACHED?
				BEQ	KEYREAD			;YES, THEN REREAD KEYBOARD 
				PLA					;PULL X REGISTER
				TAX
				TYA	
				STA	TEXTBUF,X		;STORE LETTER PRESSED IN LINE BUFFER
				INX
				TXA
				PHA					;PUSH X REGISTER
				TYA	
				JSR	CONVERT			;CONVERT ASCII TO USABLE FORM 
				CPX	#$FF			;IS THE INPUT BAD?
				BNE	:GOODLET		;NO, THEN SKIP
				DEC	COUNTS
				PLA
				TAX
				DEX
				TXA
				PHA					;MOVE X POINTER BACK ON LETTER
				JMP	KEYREAD	
:GOODLET		TXA
				PHA
				JSR	CHAROUT			;ERASE CURSOR
				JSR	CLEAR
				PLA
				JSR SET_LETTER		;DRAW_LETTER
				JSR DRAW_SHAPE
				JSR	ADVANCE			;ADVANCE LETTER POSITION
				JSR	CLEAR
				JMP	KEYREAD			;JUMP TO KEY READER
:BACKSPC		PLA
				PHA
				BEQ	KEYREAD			;DONT BACKSPACE IF BEGINNIG OF LINE
				JSR	CHAROUT			;ERASE CURSOR
				JSR	CLEAR
				JSR	RETREAT			;DECREMENT LETTER POSITION
				DEC	COUNTS
				PLA	
				TAX
				DEX
				TXA
				PHA
				LDA	TEXTBUF,X
				JSR	CONVERT	
				TXA
				JSR SET_LETTER		;ERASE PREVIOUS LETTER
				JSR DRAW_SHAPE
				JSR	CLEAR
				JMP	KEYREAD	
:MAXZERO		TYA
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+1
				PLA
				STA	HOLDIT
				RTS
:RETURN			JSR	CHAROUT
				PLA
				TAX	
				LDA	#$8D
				STA	TEXTBUF,X		;STORE RETURN AT END OF LINE BUFFER
				RTS

				NOP					;*
				NOP					;*
				NOP					;*
				NOP					;*
				NOP					;*
				NOP					;*

*-------------------------------------------------------------------------------
* Choose a letter of the font and set it as the current tile.
*
*   A: index of letter
*-------------------------------------------------------------------------------

SET_LETTER      LDX #<FONT
                LDY #>FONT
                ; fall through

*-------------------------------------------------------------------------------
* Compute pointer into indexed list of 7-byte tiles.
*	Multiply by 7 using (index << 4) - index
*
* Input:
*   X: low address of tile list
*   Y: high address of tile list
*   A: index of tile (assumed to be < #64)
*
* Output:
*   SHAPE_SRC+1,2: pointer to selected tile
*
* Uses:
*   SCRATCH, LETBUFL
*-------------------------------------------------------------------------------

				ERR	*-$0AD1
SET_SHAPE       STX LETBUFL
                STA SCRATCH
                ASL
                ASL                 ; (63 * 4 = 252)
                ASL                 ; (63 * 8 > 255 ?)
                BCC :SKIPA
                INY
                CLC
:SKIPA          ADC LETBUFL
                BCC :SKIPB
                INY
:SKIPB          SEC
                SBC SCRATCH
                STA SHAPE_SRC+1
                BCS :SKIPC
                DEY
:SKIPC          STY SHAPE_SRC+2
                RTS

				NOP					;*
				NOP					;*
				NOP					;*
				NOP					;*

*-------------------------------------------------------------------------------

				ERR	*-$0AF2
CHARTAB         DS  7

				ERR	*-$0AF9
CHAROUT         LDA #<CHARTAB
                STA SHAPE_SRC+1
                LDA #>CHARTAB
                STA SHAPE_SRC+2
                ; fall through

*-------------------------------------------------------------------------------
* Draw the shape either previously set with by SET_SHAPE or in CHAROUT.
*
* Input:
*   XCOORD: current X byte column position (0 to #39)
*   SHIFT: current X right shift (0 to 6)
*   TABLER_L,H: list of 7 hires line pointers
*   SHAPE_SRC+1,2: pointer to source data
*
* Uses:
*   SCREENL,H
*   SCRATCH
*-------------------------------------------------------------------------------

				ERR	*-$0B03
DRAW_SHAPE      LDX #6
SLOOP1          LDA #0
                STA SCRATCH
                LDA TABLER_L,X
                STA SCREENL
                LDA TABLER_H,X
                STA SCREENH
SHAPE_SRC       LDA $FFFF,X         ; modified
                LDY SHIFT
:LOOP2          ASL
                ROL SCRATCH         ; always zero the first time through
                DEY
                BPL :LOOP2
                LSR                 ; undo first shift
                LDY XCOORD
                EOR (SCREENL),Y
                STA (SCREENL),Y
                LDA SCRATCH
                BEQ :SKIPA
                INY
                EOR (SCREENL),Y
                STA (SCREENL),Y
:SKIPA          DEX
                BPL SLOOP1
                RTS

*-------------------------------------------------------------------------------

				ERR	*-$0B32
LINE			STA	XCOORD
				STY	YCOORD
				JSR	SHFTCLC			;LINE ROUTINE REPEATEDLY CALLS
				ERR	*-$0B39
LINE2			JSR	TABLER			;LETTER ROUTINE GIVING A LINE OF TEXT
				LDX	#$00
:NEXTLET		LDA	TEXTBUF,X
				TAY
				INX
				CMP	#$8D
				BEQ	FOUND
				CMP	#$EE
				BEQ	:NEXTLET
				TXA
				PHA
				TYA
				JSR SET_LETTER
				JSR DRAW_SHAPE
				PLA
				TAX
				JSR	ADVANCE
				BNE	:NEXTLET		;Always

*-------------------------------------------------------------------------------

				ERR	*-$0B5B
CONVERT			CMP	#$DB	
				BCS	NONE
				CMP	#$C1
				BCC	NOTLETS
				SBC	#$B6
				TAX
				BNE	FOUND
NOTLETS			TAX
				EOR	#$B0
				CMP	#$0A
				BCS	NOTNUMB
				TAX
				BPL	FOUND
NOTNUMB			CMP	#$10
				BNE	NOTSPAC
				LDX	#$0A
				BNE	FOUND
NOTSPAC			TXA
				EOR	#$A9
				LDX	#$25
COMPARE			CMP	ASCII-37,X
				BEQ	FOUND
				CPX	#$33
				BEQ	NONE
				INX
				BNE	COMPARE
NONE			LDX	#$FF			;SET REJECT LETTER FLAG
FOUND			EOR	#$A9	
				RTS
ASCII			DB	$08,$0B			;!,"
				DB	$0C,$0E,$03		;%,',*
				DB	$02,$05,$04		;+,,,-
				DB	$07,$06			;.,/
				DB	$13,$15,$14		;:,<,=
				DB	$17,$16			;>,?
				DB	$EA,$EA			;PLACE HOLDERS

				ERR	*-$0BA1
SHFTCLC			LDY	#$00			;CALCULATE XCOORD MOD 7
				LDA	XCOORD
REPEAT			CMP	#$07
				BCC	OUT
				SBC	#$07
				INY
				JMP	REPEAT	
OUT				STA	SHIFT			;STORE ANSWER IN SHIFT
				STY	XCOORD			;STORE INT(XCOORD/7) IN XCOORD
				RTS

ADVANCE			LDA	SHIFT			;ADJUST SHIFT
				BNE	NOONE
				LDA	#$06
				STA	SHIFT
				JMP	DONE1	
NOONE			DEC	SHIFT
				INC	XCOORD
DONE1			RTS	

RETREAT			LDA	SHIFT			;ADJUST SHIFT AND XCOORD
				CMP	#$06			;FOR ONE BYTE BACKWARDS
				BNE	NOSIX
				LDA	#$00
				STA	SHIFT
				JMP	DONE2
NOSIX			INC	SHIFT
				DEC	XCOORD
DONE2			RTS

*-------------------------------------------------------------------------------
* Input:
*   YCOORD: current Y position
*   PAGE:   current hires page ($20 or $40)
*
* Output:
*   TABLER_L,H: list of 7 hires line pointers
*-------------------------------------------------------------------------------

				ERR	*-$0BD6
TABLER          LDX #0
                LDY YCOORD
:LOOP1          LDA LOBYTES,Y
                STA TABLER_L,X
                LDA HIBYTES,Y
                ORA PAGE
                STA TABLER_H,X
                INY
                INX
                CPX #7
                BNE :LOOP1
                RTS

                NOP					;*

TABLER_L        DS  7
TABLER_H        DS  7

*-------------------------------------------------------------------------------

PULSE			DEC	DELAYL			;DECREMENT DELAY COUNTER
				LDA	DELAYL
				BNE	RETURN2			;NO, THEN RETURN
				DEC	DELAYH
				LDA	DELAYH
				BNE	RETURN2
				JSR	CHAROUT
				JSR	CLEARIT			;CLEAR CHARACTER TABLE 
				LDA	CYCLE
				CMP	#$04			;DOES CYCLE EQUAL 4?
				BEQ	MIDDLE			;YES, THEN BRANCH
				SEC					;CALCULATE OFFSET FOR GREEN LINE 
				SBC	#$01			;ACCORDING TO CYCLE
				TAX
				LDA	#GREEN
				STA	CHARTAB,X		;STORE A GREEN LINE AT CYCLE - 1
				LDA	#$07			;CALCULATE OFFSET FOR VIOLET LINE
				SEC					;ACCORDING TO CYCLE
				SBC	CYCLE
				TAX
				LDA	#VIOLET
				STA	CHARTAB,X		;STORE A VIOLET LINE AT 7 - CYCLE
				INC	CYCLE
				LDA	CYCLE			;PREFORM MODULO 7 FUNCTION ON CYCLE
				CMP	#$08
				BCC	RETURNS
				SEC
				SBC	#$07
				STA	CYCLE
				JMP	RETURNS			;RETURN
MIDDLE			LDX	#$03
				LDA	#WHITE
				STA	CHARTAB,X		;STORE A WHITE LINE AT OFFSET = 4
				INC	CYCLE	
RETURNS			JSR	CHAROUT
RETURN2			RTS

CLEAR			LDA	#1
				STA	CYCLE
CLEARIT			LDA	#<SPEED			;RESET DELAY COUNTER
				STA	DELAYL	
				LDA	#>SPEED
				STA	DELAYH
				LDA	#$00
				LDX	#$00
ERASE			STA	CHARTAB,X		;ERASE CHARACTER TABLE
				INX
				CPX	#$07
				BNE	ERASE
				RTS

*-------------------------------
*
*-------------------------------

				ERR	*-$0C60
EXPANDR			LDA	#$F0			;BEQ OPCODE
				DB	$2C				; (skip next 2 bytes)
EXPANDR2		LDA	#$24			;BIT OPCODE
				STA	:SIMPOSE		; (prevent $00 transparency)		
				LDY	#0
:1				LDA	(TBLPNTL),Y
				STA	TOP,Y
				INY
				CPY	#4
				BNE	:1
				DEC	TOP
				LDA	RIGHT
				PHA
				
				LDA	#0
				STA	RPCOUNT
:NEXTCOL		LDX	BOTTOM
:NEXTLINE		LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				
				LDA	RPCOUNT
				BNE	:3
				
				INC	RPCOUNT
				LDA	(TBLPNTL),Y
				INY
				CMP	#RPCODE
				BNE	:2
				LDA	(TBLPNTL),Y
				INY
				STA	RPCOUNT
				LDA	(TBLPNTL),Y
				INY
:2				STA	CURCHAR
				TYA
				CLC
				ADC	TBLPNTL
				STA	TBLPNTL
				BCC	:3
				INC	TBLPNTH
:3				LDA	CURCHAR
:SIMPOSE		BEQ	:4				; modified above and below
				LDY	RIGHT
				STA	(SCREENL),Y
:4				LDY	#0
				DEC	RPCOUNT
				
				DEX
				CPX	TOP
				BNE	:NEXTLINE
				
				LDA	RIGHT
				DEC	RIGHT
				CMP	LEFT
				BNE	:NEXTCOL
				
				PLA					; Group assembly expects
				STA	RIGHT			;	TOP,BOTTOM,LEFT,RIGHT to
				INC	TOP				;	be valid after decompress
				
				LDA	#$F0			;BEQ OPCODE
				STA	:SIMPOSE		; (restore $00 transparency)
				RTS

*-------------------------------

				DS	$0D01-*,$EA		;* FREE SPACE (#49 bytes)

*-------------------------------

HPOSN			STA	YCRD			;YCOORD IN ACC. 
				STA	YO
				STX	XOL				;XCOORDL IN X-INDEX 
				STY	XOH				;XCOORDH IN Y-INDEX 
				TAX
				LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDA	XOL
				SEC
				CPY	#$00
				BEQ	HPOSN2
				LDY	#$23
				CLC
				ADC	#$04
				SEC
HPOSN1			INY
HPOSN2			SBC	#$07
				BCS	HPOSN1			; TODO: use div/mod 7 table here
				STY	HNDX
				TAX
				LDA	MSKTBL-249,X
				STA	HMASK
				TYA
				LSR
				LDA	COLOR
				STA	HCOLOR1
				BCC	NOGOSHF	
				JMP	CSHIFT2
NOGOSHF			RTS
MSKTBL			DB	$81,$82,$84
				DB	$88,$90,$A0
				DB	$C0

HPLOT			JSR	HPOSN
				LDA	HCOLOR1
				EOR	(SCREENL),Y
				AND	HMASK
				EOR	(SCREENL),Y
				STA	(SCREENL),Y
				RTS

HLINA			PHA					;COLLISION FLAG SETTINGS
				LDA	#$00			;  00-IGNORE COLLISIONS
				STA	COLFLG			;  FF-EXIT ON COLLISIONS
				PLA
HLIN			PHA					;YCOORD IN Y-INDEX 
				SEC					;XCOORDL IN ACC. 
				SBC	XOL				;XCOORDH IN X-INDEX 
				PHA
FREE1			LDA	#$01
				STA	COLCNT
				TXA
				SBC	XOH
				STA	QDRNT
				BCS	HLIN2
				PLA
				EOR	#$FF
				ADC	#$01
				PHA
				LDA	#$00
				SBC	QDRNT
HLIN2			STA	DXH
				STA	EH
				PLA
				STA	DXL
				STA	EL
				PLA
				STA	XOL
				STX	XOH
				TYA
				CLC
				SBC	YO
				BCC	HLIN3
				EOR	#$FF
				ADC	#$FE
HLIN3			STA	DY
				STY	YO
				ROR	QDRNT
				SEC
				SBC	DXL
				TAX
				LDA	#$FF
				SBC	DXH
				STA	COUNTH
				LDY	HNDX
				BCS	MOVEX2
MOVEX			ASL
				JSR	LFTRT
				SEC
MOVEX2			LDA	EL
				ADC	DY
				STA	EL
				LDA	EH
				SBC	#$00
HCOUNT			STA	EH
				LDA	(SCREENL),Y
				EOR	HCOLOR1
				AND	HMASK
				BNE	NOCOL
				BIT	COLFLG
				BPL	DONT	
				LDA	COLCNT
				BEQ	HITEND
				DEC	COLCNT
				JMP	DONT
HITEND			LDA	#$01			;COLLISION OCCURED
				RTS
NOCOL			EOR	(SCREENL),Y
				STA	(SCREENL),Y
				LDA	#$00
				STA	COLCNT
DONT			INX
				BNE	HLIN4
				INC	COUNTH
HLINE_MOD		BEQ	LINEND			;Modified
HLIN4			LDA	QDRNT
				BCS	MOVEX
				JSR	HLINE_UPDOWN
				CLC
				LDA	EL
				ADC	DXL
				STA	EL
				LDA	EH
				ADC	DXH
				JMP	HCOUNT
LINEND			LDA	#$00			;COMPLETE LINE DRAWN
				RTS

LFTRT			BPL	RIGHT1	
				LDA	HMASK
				LSR
				BCS	LEFT1
				EOR	#$C0
LR1				STA	HMASK
				RTS
LEFT1			DEY
				BPL	LEFT2
				LDY	#$27			; wrap to byte column #0 to #39
LEFT2			LDA	#$C0
NEWNDX			STA	HMASK
				STY	HNDX
				LDA	HCOLOR1
CSHIFT2			ASL
				CMP	#$C0
				BPL	RTS1
				LDA	HCOLOR1
				EOR	#$7F
				STA	HCOLOR1
RTS1			RTS
RIGHT1			LDA	HMASK
				ASL
				EOR	#$80
				BMI	LR1
				LDA	#$81
				INY
				CPY	#$28			; wrap from byte column #40 to #0
				BCC	NEWNDX
				LDY	#$00
				BCS	NEWNDX			; always

HLINE_UPDOWN	BPL	UP4				;called from fight shot sub
				INC	YCRD
				BNE	UPDWN4			; always
UP4				DEC	YCRD
UPDWN4			TYA
				PHA
				LDY	YCRD
				LDA	LOBYTES,Y
				STA	SCREENL
				LDA	HIBYTES,Y
				ORA	PAGE
				STA	SCREENH
				PLA
				TAY
				RTS

*-------------------------------

xLINE_COUNT		=	SHIFT
xTEMP			=	XCOORD			;YCOORD
xCOUNTER		=	SCRATCH

SWAP_HOLES		LDA	#$20
				JSR	:SUBA
				LDA	#$40
:SUBA			STA	xTEMP
				STA	:MOD1+2
				STA	:MOD2+2
				LDA	#$78
				STA	xCOUNTER
				LDX	#181			;TOP LINE
				STX	xLINE_COUNT
:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	xTEMP
				STA	SCREENH
				LDX	xCOUNTER
				LDY	#13				;LEFT COLUMN
:LOOP2			LDA	(SCREENL),Y
				STA	xTEMP+1
:MOD1			LDA	$FF00,X
				STA	(SCREENL),Y
				LDA	xTEMP+1
:MOD2			STA	$FF00,X
				INX
				TXA
				ASL
				BNE	:SKIPA
				ROR
				EOR	#%01111000
				TAX
				INC	:MOD1+2
				INC	:MOD2+2
:SKIPA			INY
				CPY	#27				;RIGHT COLUMN
				BNE	:LOOP2
				STX	xCOUNTER
				INC	xLINE_COUNT
				LDX	xLINE_COUNT
				CPX	#192			;BOTTOM LINE
				BNE	:LOOP1
				RTS

*-------------------------------

CLEAR_HOLES		LDA	#$20
				JSR	:SUBA
				LDA	#$40
:SUBA			STA	:LOOP2+2
				STA	:MOD2+2
				LDA	#$00
				LDY	#32
:LOOP1			LDX	#$78
:LOOP2			STA	$FF00,X			;Modified
:MOD2			STA	$FF80,X			;Modified
				INX
				BPL	:LOOP2
				INC	:LOOP2+2
				INC	:MOD2+2
				DEY
				BNE	:LOOP1
				RTS

*-------------------------------

DRAW_MESSAGE	PHP
				LDA	#$20
				JSR	:SUBA
				PLP
				LDA	#$40
:SUBA			PHP
				STA	PAGE

				LDX	#181
:LOOP1			LDA	LOBYTES,X
				STA	xTEMP
				LDA	HIBYTES,X
				ORA	PAGE
				STA	xTEMP+1

				LDY	#26
				CPX	#181
				BEQ	:SKIPA
				CPX	#191
				BEQ	:SKIPA
				LDA	#%01100000
				STA	(xTEMP),Y
				LDY	#13
				LDA	#%00000011
				STA	(xTEMP),Y
				BNE	:SKIPB			;Always
:SKIPA			LDA	#%01111111
:LOOP2			STA	(xTEMP),Y
				DEY
				CPY	#12
				BNE	:LOOP2
:SKIPB			INX
				CPX	#192
				BNE	:LOOP1

				PLP
				LDA	#98
				BCC	:SKIPC
				LDA	#95
:SKIPC			LDY	#183
				JMP	LINE

*-------------------------------

PRESERVES		DB	XCOORD			;xTEMP
				DB	YCOORD			;xTEMP+1
				DB	SHIFT			;xLINE_COUNT
				DB	SCREENL
				DB	SCREENH
				DB	SCRATCH			;xCOUNTER
				DB	PAGE

SIDE_LETTERS	USR	(MTF)-

MESSAGES		USR	(INSERT_SIDE_XX_)
				USR	(WRITE_PROTECTED)

				NOP					;*

*-------------------------------

				PUT NCOMMONS.FONT.S

HALLDAT			DB	$38,$00
				DB  $00,$5F
				DB  $38,$BE
				DB	$38,$BE
				DB  $38,$BD
				DB  $38,$01
				DB	$38,$00
				DB  $00,$00
				DB  $19,$00
				DB	$2D,$18
				DB  $24,$31
				DB  $24,$91
				DB	$2D,$A7
				DB  $00,$B7
				DB  $00,$00
				DB	$38,$1C
				DB  $30,$34
				DB  $30,$91
				DB	$38,$A6

				DB  $45,$16
				DB  $16,$65
				DB	$45,$B4
				DB  $4F,$AE
				DB  $60,$A3
				DB	$60,$41
				DB  $4F,$25
				DB  $38,$42
				DB	$44,$34
				DB  $59,$4D
				DB  $54,$59
				DB	$54,$8C
				DB  $59,$97
				DB  $44,$9F
				DB	$38,$8F
				DB  $5F,$4E
				DB  $5A,$5A
				DB	$5A,$8C
				DB  $5F,$97

				DB  $64,$47
				DB	$49,$74
				DB  $64,$A0
				DB  $67,$9E
				DB	$6E,$9A
				DB  $6E,$58
				DB  $67,$4C
				DB	$5A,$5E
				DB  $61,$55
				DB  $69,$5F
				DB	$64,$67
				DB  $64,$8A
				DB  $69,$92
				DB	$61,$95
				DB  $5A,$8B
				DB  $6C,$60
				DB	$68,$68
				DB  $68,$8A
				DB  $6C,$92

				DB	$6F,$5A
				DB  $5D,$79
				DB  $6F,$98
				DB	$71,$97
				DB  $75,$95
				DB  $75,$63
				DB	$71,$5D
				DB  $68,$6A
				DB  $6D,$64
				DB	$71,$69
				DB  $6E,$6F
				DB  $6E,$89
				DB	$71,$8F
				DB  $6D,$91
				DB  $68,$8A
				DB	$75,$69
				DB  $72,$6F
				DB  $72,$89
				DB	$75,$8F

				DB  $76,$65
				DB  $68,$7C
				DB	$76,$94
				DB  $77,$94
				DB  $79,$92
				DB	$79,$6A
				DB  $77,$66
				DB  $70,$70
				DB	$73,$6B
				DB  $76,$6F
				DB  $74,$74
				DB	$74,$89
				DB  $76,$8D
				DB  $73,$8E
				DB	$70,$89
				DB  $78,$6F
				DB  $76,$74
				DB	$76,$89
				DB  $78,$8D

				DB  $7A,$6B
				DB	$6E,$7E
				DB  $7A,$92
				DB  $7A,$91
				DB	$7C,$90
				DB  $7C,$6F
				DB  $7A,$6C
				DB	$74,$75
				DB  $78,$70
				DB  $7A,$73
				DB	$76,$77
				DB  $76,$88
				DB  $7A,$8C
				DB	$78,$8D
				DB  $75,$89
				DB  $7C,$73
				DB	$7A,$77
				DB  $7A,$88
				DB  $7C,$8C

				DB	$7C,$6F
				DB  $73,$80
				DB  $7C,$90
				DB	$7D,$90
				DB  $7E,$8F
				DB  $7E,$72
				DB	$7D,$70
				DB  $78,$77
				DB  $7B,$74
				DB	$7C,$75
				DB  $7A,$79
				DB  $7A,$88
				DB	$7C,$8B
				DB  $7B,$8C
				DB  $78,$88
				DB	$7E,$76
				DB  $7C,$79
				DB  $7C,$88
				DB	$7E,$8B

				DB  $7E,$73
				DB  $76,$81
				DB	$7E,$8F
				DB  $7F,$8E
				DB  $7F,$8E
				DB	$7F,$75
				DB  $7F,$73
				DB  $7A,$79
				DB	$7D,$76
				DB  $7E,$78
				DB  $7C,$7B
				DB	$7C,$88
				DB  $7E,$8B
				DB  $7D,$8B
				DB	$7B,$88
				DB  $80,$78
				DB  $7E,$7B
				DB	$7E,$88
				DB  $80,$8B

				DB  $80,$75
				DB	$79,$81
				DB  $80,$8E
				DB  $00,$00

BUFFER			DS	38

CLEAR1			LDA	#$20
				BNE	CLR_COM			;Always
CLEAR2			LDA	#$40
CLR_COM			CMP	CLR_LOOP+2
				BEQ	CLR_SCREEN

				LDX	#3*31
:LOOP1			LDA	CLR_LOOP+2,X
				EOR	#$60
				STA	CLR_LOOP+2,X
				DEX
				DEX
				DEX
				BPL	:LOOP1

CLR_SCREEN		LDA	#$00
				LDX	#$00	
CLR_LOOP		STA	$2000,X
				STA	$2100,X
				STA	$2200,X
				STA	$2300,X
				STA	$2400,X
				STA	$2500,X
				STA	$2600,X
				STA	$2700,X
				STA	$2800,X
				STA	$2900,X
				STA	$2A00,X
				STA	$2B00,X
				STA	$2C00,X
				STA	$2D00,X
				STA	$2E00,X
				STA	$2F00,X
				STA	$3000,X
				STA	$3100,X
				STA	$3200,X
				STA	$3300,X
				STA	$3400,X
				STA	$3500,X
				STA	$3600,X
				STA	$3700,X
				STA	$3800,X
				STA	$3900,X
				STA	$3A00,X
				STA	$3B00,X
				STA	$3C00,X
				STA	$3D00,X
				STA	$3E00,X
				STA	$3F00,X
				INX
				BNE	CLR_LOOP
				RTS

STATLIN			JSR	POINTIT
				JSR	PROFNAM
				LDA	#$10
				LDY	YPNT
				JSR	LINE
				JSR	POWROUT
				LDA	#$C6
				LDY	YPNT
				JSR	LINE
STATL2			BIT	SELECT
				BMI	XYER
				BVC	PICDS	
				LDA	#$0E
				JSR	EPSHLD
				LDA	#$69
				LDY	YPNT
				JSR	LINE
				LDA	#$0F
				JSR	EPSHLD
				LDA	#$79
				LDY	YPNT
				JSR	LINE
				JMP	PICDS
XYER			JSR	DOXY
				LDA	#$71
				LDY	YPNT
				JSR	LINE
PICDS			LDA	SELECT
				LSR
				BCS	GOSTWRD	
				LSR
				BCC	GETOUT
				JSR	DAMAGR2	
				LDA	#$8A
				LDY	YPNT
				JSR	LINE
GETOUT			RTS
GOSTWRD			JMP	STATWRD
				NOP					;*

POINTIT			PHA					;Must not change X or Y registers
				CLC					;   or TEMP,+1
				ADC	#$01
				LSR
				CLC
				ADC	#$BC
				STA	CHARDH
				PLA
				LSR
				ROR
				EOR	#$80
				AND	#$80
				STA	CHARDL
				RTS

				NOP					;*

PROFNAM			LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				PHA
				TAY
				LDA	PROFOFF,Y
				TAY
				LDX	#$00
MORPROF			LDA	PROFDAT,Y
				STA	TEXTBUF,X
				INY
				INX
				CPX	#$03
				BNE	MORPROF
				PLA
				CMP	#$06
				BNE	NOTEMED
				LDA	#$17
				STA	TEXTBUF+1
				LDA	#$0E
				STA	TEXTBUF+2
NOTEMED			LDA	#$0A
				STA	TEXTBUF+3
				INX	
NAMEIT			LDY	#name
:LOOP1			LDA	(CHARDL),Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#name+10
				BNE	:LOOP1
				LDA	#$8D
				STA	TEXTBUF,X
				RTS

DOXY			LDY	#$1E
				LDA	(CHARDL),Y
DOXY2			PHA
				AND	#$0F
				CLC
				ADC	#$0A
				STA	TEXTBUF+1
				PLA
				LSR
				LSR
				LSR
				LSR
				STA	TEXTBUF
				LDA	#$8D
				STA	TEXTBUF+2
				RTS

EPSHLD			LDY	#$1B
				CMP	#$0E
				BEQ	ISELECT
				LDY	#$1C
ISELECT			LDA	(CHARDL),Y
				JSR	SPLIT
				LDA	FEEDERH
				BNE	HSTORE
				LDA	#$0A
HSTORE			STA	TEXTBUF
				LDA	FEEDERL
				STA	TEXTBUF+1
				LDA	#$8D
				STA	TEXTBUF+2
				RTS

				NOP					;*

DAMAGER			LDY	#damagemax+1
:LOOP1			LDA	(CHARDL),Y
				PHA
				DEY
				CPY	#damagelev-1
				BNE	:LOOP1
				LDX	#0
				LDA	#2
				JSR	RIGHT_DIGITS
				LDA	#$2E
				STA	TEXTBUF,X
				INX
				LDA	#2
				JSR	LEFT_DIGITS
				LDA	#$8D
				STA	TEXTBUF,X
				RTS

DAMAGR2			JSR	MAJOR_STAT
				BCC	DAMAGER
				JMP	STATUSR

POWROUT			LDY	#energymax+2
:LOOP1			LDA	(CHARDL),Y
				PHA
				DEY
				CPY	#energylev-1
				BNE	:LOOP1
				LDX	#0
				LDA	#3
				JSR	RIGHT_DIGITS
				LDA	#$2E
				STA	TEXTBUF,X
				INX
				LDA	#3
				JSR	LEFT_DIGITS
				LDA	#$8D
				STA	TEXTBUF,X
				RTS

LEFT_DIGITS		LDY	#$EE
				HEX	2C				;Skip 2 bytes
RIGHT_DIGITS	LDY	#$0A
				STA	TEMP
				PLA
				CLC
				ADC	#1
				STA	:EXIT+1
				PLA
				ADC	#0
				STA	:EXIT+2
:LOOP1			PLA
				DEC	TEMP
				BEQ	:SKIPA
				JSR	TWO_DIGITS
				BNE	:LOOP1			;Always
:SKIPA			JSR	LAST_DIGITS
:EXIT			JMP	$FFFF			;Modified

LAST_DIGITS		PHA
				LSR
				LSR
				LSR
				LSR
				JSR	ONE_DIGIT
				PLA
				AND	#%00001111
				STA	TEXTBUF,X
				INX
				RTS

TWO_DIGITS		PHA
				LSR
				LSR
				LSR
				LSR
				JSR	ONE_DIGIT
				PLA
				AND	#%00001111
ONE_DIGIT		BEQ	:SKIPA
				LDY	#0
				BEQ	:SKIPB
:SKIPA			TYA
:SKIPB			STA	TEXTBUF,X
				INX
				RTS

				DS	23				;FREE SPACE

RECALL			LDA	HOLDIT
				PHA
				JMP	KEYREAD

SPLIT			PHA
				AND	#$0F
				STA	FEEDERL
				PLA
				LSR
				LSR
				LSR
				LSR
				STA	FEEDERH
				RTS
FEEDERH			DB	$00
FEEDERL			DB	$00

HEADER			LDY	#$00
				JSR	TEXTING
				LDY	#$01
				JSR	TEXTING
				LDY	#$07
				JSR	TEXTING
HEADER2			BIT	SELECT
				BMI	PUTXY
				BVC	DORS
				LDY	#$03
				JSR	TEXTING
				LDY	#$04
				JSR	TEXTING
				JMP	DORS

PUTXY			LDY	#$02
				JSR	TEXTING
DORS			LDA	SELECT
				LSR
				BCS	PUTSTAT
				LSR
				BCC	HEADOUT
				LDY	#$05
				JSR	TEXTING
				JMP	HEADOUT
PUTSTAT			LDY	#$06
				JSR	TEXTING
HEADOUT			RTS	

TEXTING			TYA
				ASL
				TAY
				LDA	HEADS,Y
				STA	POINTL
				INY
				LDA	HEADS,Y
				STA	POINTH
				LDY	#$02
				LDA	YPNT
				STA	(POINTL),Y
				JMP	TEXTOUT
HEADS			DW	PROF
				DW	NAME
				DW	XY
				DW	EL2
				DW	PH
				DW	DAMAGE
				DW	STATUS
				DW	ENERGY

PROF			DB	$02,$00,$02
				USR	(PROF)+
NAME			DB	$08,$02,$02
				USR	(NAME)+
XY				DB	$10,$01,$02
				USR	(XY)+
EL2				DB	$0F,$00,$02
				USR	(EL)+
PH				DB	$11,$02,$02
				USR	(PH)+
DAMAGE			DB	$15,$00,$02
				USR	(DAMAGE)+
STATUS			DB	$15,$00,$02
				USR	(STATUS)+
ENERGY			DB	$1F,$02,$02
				USR	(ENERGY)+
