*-------------------------------
*
*-------------------------------

SMART_ADVANCE	LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				AND	#$0F
				STA	YPNT
				SEC
				SBC	TVIEW_HEIGHT
				SEC
				SBC	#5
				STA	YCOORD
				LDA	#%01111100
				STA	FINAL_MASK
:1				LDA	YPNT
				JSR	SCAN_ALIEN
				AND	FINAL_MASK
				BEQ	:2
				STA	FINAL_MASK
				DEC	YPNT
				DEC	YCOORD
				BPL	:1
:2				LDA	FINAL_MASK
				JMP	MAKE_CHOICE

*-------------------------------
*
*-------------------------------

SMART_RETREAT	LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				AND	#$0F
				STA	YPNT
				LDA	#10
				SEC
				SBC	YPNT
				STA	YCOORD
				LDA	#%01111100
				STA	FINAL_MASK
:1				LDA	YPNT
				JSR	SCAN_ALIEN
				AND	FINAL_MASK
				BEQ	:2
				STA	FINAL_MASK
				INC	YPNT
				DEC	YCOORD
				BPL	:1
:2				LDA	FINAL_MASK

*-------------------------------

MAKE_CHOICE		STA	TEMP
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				LSR
				LSR
				LSR
				LSR
				STA	TEMP+1
				TAX
				LDY	#0
:1				DEX
				BEQ	:3
				INY
				LDA	HIT_MASKS-1,X
				AND	TEMP
				BEQ	:1

				LDX	TEMP+1
				STY	TEMP+1

				LDY	#0
:2				INX
				CPX	#6
				BEQ	:4
				INY
				LDA	HIT_MASKS-1,X
				AND	TEMP
				BEQ	:2

				CPY	TEMP+1
				BEQ	:5
				BCS	:4
:3				JMP	MOVE_RIGHT
:4				JMP	MOVE_LEFT
:5				JMP	RND_LEFTRIGHT

FINAL_MASK		DB	0

*-------------------------------

SCAN_ALIEN		STA	START_POS
				TAY
				SEC
				SBC	TVIEW_HEIGHT
				STA	END_POS
				LDA	#%01111100
:1				STA	ALIEN_MASK
				TYA
				ORA	#$10
				JSR	MON_INDEXER
				JSR	SCAN_LINE
				AND	ALIEN_MASK
				DEC	START_POS
				LDY	START_POS
				CPY	END_POS
				BNE	:1
				RTS

ALIEN_MASK		DB	0
START_POS		DB	0
END_POS			DB	0

*-------------------------------

OPENMASK		=	TEMP
WDTHMASK		=	TEMP+1

SCAN_LINE		LDA	#0
				STA	OPENMASK
				TAX
:1				LDA	AUX_MGRID,Y
				BMI	:2
				AND	#%10111111
				CMP	MONS_NUMBER
				BNE	:3
:2				LDA	OPENMASK		;Set bits of squares that
				ORA	HIT_MASKS,X		;  are NOT occupied by other
				STA	OPENMASK		;  monsters
:3				INY
				INX
				CPX	#5
				BNE	:1

				LDX	TVIEW_WIDTH
				LDA	WIDTH_MASKS-1,X
				STA	WDTHMASK
				LDX	#0
:4				LDA	WDTHMASK
				AND	#%00000010
				BNE	:5
				LDA	OPENMASK
				AND	WDTHMASK
				CMP	WDTHMASK
				BEQ	:6
:5				LDA	HIT_MASKS,X		;Clear the bit if monster
				EOR	#$FF			;  couldn't stand there
				AND	OPENMASK
				STA	OPENMASK
:6				LSR	WDTHMASK
				INX
				CPX	#5
				BNE	:4
				LDA	OPENMASK
				RTS

WIDTH_MASKS		DB	%01000000
				DB	%01100000
				DB	%01110000
				DB	%01111000
				DB	%01111100

*-------------------------------
