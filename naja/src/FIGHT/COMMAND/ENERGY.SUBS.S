*-------------------------------

START_ENERLEV	LDY	#energylev+2
				LDX	#2
:LOOP1			LDA	(CHARDL),Y
				STA	ORIG_ELEVEL,X
				DEY
				DEX
				BPL	:LOOP1
				JSR	ENUDATE
				JSR	SUB_ENERLEV
				LDA	#$C6
				STA	ENERGY_DEF
				LDX	PLANNER
				LDA	YPOINTS,X
				STA	ENERGY_DEF+1
				LDX	#<ENERGY_DEF
				LDY	#>ENERGY_DEF
				LDA	#0
				SEC
				JMP	TEXT_INIT

ORIG_ELEVEL		DB	0,0,0

*-------------------------------

NEW_ENERLEV		JSR	SUB_ENERLEV
				LDA	#0
				JMP	TEXT_UPDATE

*-------------------------------

SUB_ENERLEV		LDX	#2
				LDY	#energylev+2
				SEC
:LOOP1			LDA	ORIG_ELEVEL,X
				SED
				SBC	TOTAL_VALUE,X
				CLD
				STA	(CHARDL),Y
				STA	ENERGY_VALUE,X
				DEY
				DEX
				BPL	:LOOP1
				BCS	:EXIT
				LDY	#energylev
				LDA	#$E0
				STA	(CHARDL),Y
				STA	ENERGY_VALUE
:EXIT			RTS

*-------------------------------

DE_ENERLEV		JSR	ENUDATE
				LDX	#2
				LDY	#energylev+2
:LOOP1			LDA	ORIG_ELEVEL,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP1
				JMP	ENUDATE

*-------------------------------

TAKE_ENERUSE	LDY	#energylev
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#$E0
				BNE	:SKIPA
				RTS
:SKIPA			JSR	ENUDATE
				LDX	#2
				LDY	#energylev+2
				SEC
:LOOP1			LDA	(CHARDL),Y
				SED
				SBC	ENERGY_USAGE,X
				CLD
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP1
				BCS	:SKIPB
				LDA	#$E0
				INY
				STA	(CHARDL),Y
:SKIPB

*-------------------------------

ENUDATE			BIT	FLIPPED_FLAG
				BPL	:SKIPA
				LDA	#$40
				STA	PAGE
:SKIPA			LDY	#energylev
				LDA	(CHARDL),Y
				AND	#%11110000
				CMP	#$E0
				BNE	:SKIPB
				LDX	#6
:LOOP1			LDA	MINUS_TEXT,X
				STA	TEXTBUF,X
				DEX
				BPL	:LOOP1
				BMI	:SKIPC			;Always
:SKIPB			JSR	POWROUT
				LDA	#$8D
				STA	TEXTBUF+6
:SKIPC			LDY	PLANNER
				LDA	YPOINTS,Y
				TAY
				LDA	#$C6
				JSR	LINE
				LDA	#$20
				STA	PAGE
				RTS

MINUS_TEXT		USR	(_MINUS)

*-------------------------------
