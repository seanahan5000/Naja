CHR_SWING		JSR	GET_EP_ENUSE

*----------------------------------
* SWING_TYPE       HANDS_USED
*   0 = Thrust       0 = One Hand
*   1 = Vertical     1 = Two hands
*   2 = Horizontal
*
* WEAPON_TYPE      SWING_DIRECTN
*   0 = Hand         0 = left
*   1 = Dagger       1 = center
*   2 = Sword        2 = right
*   3 = Whip         3 = all three
*   4 = Rifle
*----------------------------------

				LDA	#0
				STA	SWING_TYPE		;Thrust
				STA	HANDS_USED		;One hand
				LDX	COMPNTR
				LDA	COMMAND+1,X
				LSR
				LSR
				LSR
				TAY
				AND	#%00000011
				STA	SWING_DIRECTN
				TYA
				LSR
				LSR
				STA	WEAPON_TYPE
				LDA	COMMAND,X
				TAX
				ASL
				ASL
				BPL	:SKIPA
				INC	HANDS_USED
:SKIPA			ASL
				BMI	:SKIPB
				INC	SWING_TYPE
				LDA	SWING_DIRECTN
				CMP	#3				;All 3 squares
				BNE	:SKIPB
				INC	SWING_TYPE
:SKIPB


BLOCK_CHECK		LDA	SWING_TYPE
				LSR
				BEQ	:SKIPD
				LDX	CHAR_NUMBER
				LDA	TEMPCHAR_XY,X
				JSR	CHAR_INDEXER
				LDX	COMPNTR
				LDA	COMMAND,X
				ASL
				BMI	:SKIPA
				DEY
				SEC
				BMI	:SKIPC			;Wall in the way
				BPL	:SKIPB			;Always
:SKIPA			INY
				CPY	#6
				BCS	:SKIPC			;Wall in the way
:SKIPB			LDA	MASTER_CGRID,Y
				CMP	#$FF
				BEQ	:SKIPD
				CLC
:SKIPC			JMP	HINDERD_SWING
:SKIPD

TARGET_CHECK	JSR	PATH_OF_SWING
				PHP
				JSR	SWING_WORD
				JSR	CLEAR_TLINE1
				TYA
				LDY	#xCharsName
				JSR	WORD2_INC
				PLP
				BCS	HAVE_TARGET
				LDY	#xAt
				LDA	#xNothing
				JSR	WORD2_PRDRET
				JMP	TAKDELCLRCCOM

HAVE_TARGET		LDY	#xAt
				LDA	#xThe
				JSR	WORD2_RET
				JSR	CHECK_SWING
				BCS	SWING_HITS

SWING_MISSES	JSR	RNDMIZE
				LDX	#0
				LDY	#xMonsName
				LDA	#xBut
				JSR	WORD2_INC
				LDA	WEAPON_TYPE		;Whips are always BLOCKED/DEFLECTED
				CMP	#3				;Whip
				BEQ	:SKIPA
				LDA	RANDOM1
				AND	#%00000011
				BEQ	:SKIPA
				LDY	#xMisses
				JSR	WORD1_PRDRET
				JMP	TAKDELCLRCCOM

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* ..."IT ISN'T"
* "QUICK ENOUGH AND | IS BLOCKED.       |
*                   | IS DEFLECTED.     |
*                   | MISSES | .      | |
*                            | BADLY. |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
:SKIPA			LDY	#8				;S>8 It.Isnt.RET.Quick.Enough.And
				JSR	SENTENCE_INC

				LDA	RANDOM1
				AND	#%00001100
				BNE	:SKIPB
				LDY	#xMisses
				LDA	#xBadly
				BIT	RANDOM1
				BMI	:SKIPC
				JSR	WORD1_PRDRET
				JMP	TAKDELCLRCCOM

:SKIPB			LDY	#xIs
				LDA	#xBlocked
				BIT	RANDOM1
				BPL	:SKIPC
				LDA	#xDeflected
:SKIPC			JSR	WORD2_PRDRET
				JMP	TAKDELCLRCCOM

SWING_HITS		JSR	CALC_SWINGDAM
				LDA	TOTAL_DAMAGEH
				ORA	TOTAL_DAMAGEL
				BNE	SWING_DAMAGES
				LDX	#0
				LDY	#26				;S>26 Monsname.But.The.Blow.RET
				JSR	SENTENCE_PRET	;     Is.So.Weak.That.It.Causes.RET
				JMP	TAKDELCLRCCOM	;     No.Damage

SWING_DAMAGES	JSR	RNDMIZE
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<monsname> AND | INFLICTS |
*                 | CAUSES   |
*                 | CONNECTS |
*                 | HITS IT  |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDX	#0
				LDY	#xMonsName
				LDA	#xAnd
				JSR	WORD2_INC
				LDA	RANDOM1
				AND	#%00000011
				CLC
				ADC	#xInflicts
				TAY
				PHA
				JSR	WORD1_RET
				JSR	RNDMIZE
				LDX	#0
				PLA
				CMP	#xConnects
				BCC	:SKIPA
				LDY	#xFor
				JSR	WORD1_INC
:SKIPA			LDA	TOTAL_DAMAGEH
				BEQ	NORMAL_SWING

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "| FOR | A | POWERFUL    | | BLOW   | OF"
*  |     |   | DEVASTATING | | STRIKE |
*            | DESTRUCTIVE |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
BIG_SWING		LDA	RANDOM1
				AND	#$03
				BNE	:SKIPA
				LDA	#$01
:SKIPA			CLC
				ADC	#xPowerful-1
				LDY	#xA
				JSR	WORD2_INC
				LDY	#xStrike
				BIT	RANDOM1
				BPL	:SKIPB
				LDY	#xBlow
:SKIPB			LDA	#xOf
				JSR	WORD2_RET
NORMAL_SWING	LDY	#x9999
				LDA	#xDamage
				JSR	WORD2_PRDRET
				JSR	BLINK_MONS
				JSR	DAMAGE_MONS
				JMP	TAKDELCLRCCOM


*-------------------------------
*
*-------------------------------

HINDERD_SWING	PHP
				STA	:MOD1+1
				JSR	CLEAR_TLINE1

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<charsname> STARTS TO SWING BUT"
* "STOPS ABRUPTLY.  | <charsname> | IS"
*                   | A WALL      |
* "IN THE WAY."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#27				;S>27 Charname.Starts.To.Swing.But.RET
				JSR	SENTENCE_PRD	;     Stops.Abruptly
				PLP
				BCS	:1
:MOD1			LDA	#$FF			;Modified
				JSR	POINTIT
				LDY	#xCharsName
				LDA	#xIs
				JSR	WORD2_RET
				LDA	CHAR_NUMBER
				JSR	POINTIT
				JMP	:2
:1				LDY	#28				;S>28 A.Wall.Is
				JSR	SENTENCE_RET
:2				LDY	#7				;S>7 In.The.Way
				JSR	SENTENCE_PRET
				JMP	TAKDELCLRCCOM


*-------------------------------
*
*-------------------------------

SWING_WORD		LDX	COMPNTR
				LDA	COMMAND+1,X
				AND	#%11100000
				LSR
				LSR
				LSR
				LSR
				LSR
				BEQ	HANDS
				TAX
				DEX
				BEQ	DAGGERS
				DEX
				BEQ	SWORDS
				DEX
				BEQ	WHIPS

RIFLES			LDX	SWING_TYPE
				LDY	:TABLE1,X
				RTS
:TABLE1			DB	xPokes,xHacks,xSwipes

HANDS			JSR	RNDMIZE
				AND	#$01
				TAX
				LDY	:TABLE1,X
				RTS
:TABLE1			DB	xPunches,xThrashes

DAGGERS
SWORDS			JSR	RNDMIZE
				AND	#%00000011
				LDX	SWING_TYPE
				ORA	#%00000100
				BNE	:SKIPA
:SKIPA			TAX
				LDY	:TABLE1,X
				RTS
:TABLE1			DB	xSwings,xSlashes,xCuts,xSlices
				DB	xSwings,xStabs,xThrusts,xLunges

WHIPS			LDY	#xWhips
				LDA	SWING_DIRECTN
				CMP	#3
				BEQ	:EXIT
				LDY	#xCracks
:EXIT			RTS


*------------------------------------------------
* On Entry:
*     WEAPON_TYPE: Valid
*   SWING_DIRECTN: Valid
*
* On Exit:
*   Carry clear: No monster was in swing path
*     Carry set: Monster WAS in swing path
*   MONS_NUMBER: Number of monster in swing path
*       POINTTO: Called for that monster
*------------------------------------------------

PATH_OF_SWING	LDX	SWING_TYPE
				LDA	:STARTS,X
				CPX	#2				;Horizontal
				BEQ	:SKIPA
				CLC
				ADC	SWING_DIRECTN
				TAY
				LDA	WEAPON_TYPE
				CMP	#3				;whip
				BNE	:SKIPC
				INY
				INY
				BNE	:SKIPC			;Always
:SKIPA			TAY
				LDA	WEAPON_TYPE
				CMP	#3				;whip
				BNE	:SKIPB
				INY
:SKIPB			LDX	COMPNTR
				LDA	COMMAND,X
				AND	#%01000000
				BEQ	:SKIPC
				INY
				INY
:SKIPC			LDA	:BEGINS,Y
				STA	SCOUNTR
				LDA	:BEGINS+1,Y
				STA	XCOUNTR
				LDX	CHAR_NUMBER
				LDA	TEMPCHAR_XY,X
				AND	#%11110000
				ORA	#$06
				JSR	MON_INDEXER
				STY	YCOUNTR

				LDX	SCOUNTR
:LOOP1			LDA	YCOUNTR
				CLC
				ADC	:OFFSETS,X
				STA	YCOUNTR
				TAY
				LDA	MASTER_MGRID,Y
				BPL	:SKIPD
				INX
				CPX	XCOUNTR
				BNE	:LOOP1
				CLC
				RTS
:SKIPD			AND	#%00111111
				STA	MONS_NUMBER
				JSR	POINTTO
				SEC
				RTS

:STARTS			DB	0,3,7
:BEGINS			DB	0,1,2
				DB	3,4,5
				DB	6
				DB	8,11,17,20,26
:OFFSETS		DB	-1,0,1			;thrust
				DB	-1,0,1			;vert
				DB	0,-5			;vert whip
				DB	-1,1,1			;horz L to R
				DB	-1,-5,6,-5,1,5	;horz whip L to R
				DB	1,-1,-1			;horz R to L
				DB	1,-5,4,-5,-1,5	;horz whip R to L


*------------------------------------------------------------
*    BASE = 40.00 (% odds of hitting when all else is equal)
*     DIR =  0.90 [ Left     (0) ]
*            1.00 [ Center   (1) ]
*            0.90 [ Right    (2) ]
*            1.00 [ AllThree (3) ]
*      SW =  1.20 [ Thrust     (0) ]
*            1.00 [ Vertical   (1) ]
*            0.80 [ Horizontal (2) ]
*    SIZE =  0.80 [ Tiny   (0) ]
*            0.90 [ Small  (1) ]
*            1.00 [ Normal (2) ]
*            1.10 [ Big    (3) ]
*      DO =  0.90 [ Parrying ]
*            1.10 [ Swinging at different square ]
*            1.00 [ Anything else ]
*    DIFF = UPREFcharacter - (( UPREFalien + LOREFalien) / 2)
*     RAW = ((( BASE + DIFF ) MAX 1 ) MIN 99)
*    ODDS = RAW * DIR * SW * SIZE * DO
*------------------------------------------------------------

CHECK_SWING		LDY	#monSTATUS
				LDA	(MONS_PTR),Y	;If not healthy, swing
				BEQ	:1				;  always hits
				SEC
				RTS
:1				LDY	#monUPREF
				LDA	(MONS_PTR),Y
				TAX
				INY					;#monLOREF
				LDA	(MONS_PTR),Y
				TAY
				JSR	AVERAGE_OF_2
				STA	TEMP

				SED
				LDY	#upreflex
				LDA	#$40
				CLC
				ADC	(CHARDL),Y
				STA	BASE+1
				LDA	#0
				STA	BASE+2
				ADC	#0
				STA	BASE+0

				SEC
				LDX	#$99
				LDA	BASE+1
				SBC	TEMP
				STA	BASE+1
				LDA	BASE+0
				SBC	#0
				BCC	:SKIPA
				BNE	:SKIPB
				LDA	BASE+1
				BNE	:SKIPC
:SKIPA			LDX	#1
:SKIPB			STX	BASE+1
:SKIPC			CLD

				JSR	GET_SIZE_2
				LDY	SWING_SIZES,X
				LDA	SWING_SIZES+1,X
				TAX
				JSR	FRST_MULTIPLY

				LDY	#0				;0.90 for Left and Right
				LDX	#$90
				LDA	SWING_DIRECTN
				AND	#%00000001
				BEQ	:SKIPD
				INY					;1.00 for Center and AllThree
				LDX	#0
:SKIPD			JSR	MULTIPLY_BASE

				LDY	#1
				LDA	#$20			;Thrust = 1.20
				LDX	SWING_TYPE
				BEQ	:SKIPE
				LDA	#0				;Vertical = 1.00
				DEX
				BEQ	:SKIPE
				DEY
				LDA	#$80			;Horizontal = 0.80
:SKIPE			TAX
				JSR	MULTIPLY_BASE

**** ALSO, CHECK IF ALIEN HAS "INANIMATE" FLAG SET (ALWAYS HIT)

				LDY	#monCRNTCMD
				LDA	(MONS_PTR),Y
				LDY	#1				;1.00 if not PARRYing
				LDX	#0
				AND	#%00001111
				CMP	#cmdPARRY
				BNE	:SKIPF
				DEY					;0.90 if PARRYing
				LDX	#$90
:SKIPF			JSR	LAST_MULTIPLY
				JMP	FINAL_ODDS

SWING_SIZES		HEX	0080			;tiny
				HEX	0090			;small
				HEX	0100			;normal
				HEX	0110			;big


*----------------------------------------
*     BASE = Weapon energy use
*       ST = 0.80 + (Strength / 100)
*       SW = 0.75  [ Thrust     (0) ]
*          = 1.00  [ Vertical   (1) ]
*          = 1.25  [ Horizontal (2) ]
*        H = 1.00  [ One hand  (0) ]
*          = 1.25  [ Two hands (1) ]
*   DAMAGE = BASE * ST * SW * H
*----------------------------------------

CALC_SWINGDAM	LDY	PH_DAMAGEH
				STY	BASE+0
				LDX	PH_DAMAGEL
				STX	BASE+1
				LDA	#0
				STA	BASE+2
				STA	BASE+3

				LDY	#strength		;Calculate STrength factor
				LDA	(CHARDL),Y
				CLC
				SED
				ADC	#$80
				TAX
				LDY	#0
				BCC	:SKIPA
				INY
:SKIPA			CLD
				JSR	MULTIPLY_BASE

				LDA	SWING_TYPE		;Calculate SWing type factor
				ASL
				TAX
				LDY	ST_TABLE,X
				LDA	ST_TABLE+1,X
				TAX
				JSR	MULTIPLY_BASE

				LDY	#$01
				LDX	#$00
				LDA	HANDS_USED
				BEQ	:SKIPB
				LDX	#$25
:SKIPB			JSR	MULTIPLY_BASE
				STY	PH_DAMAGEL
				LDA	BASE+0
				STA	PH_DAMAGEH
				JMP	GET_MDAM_TOTL

ST_TABLE		HEX	0075			;Thrust
				HEX	0100			;Vertical
				HEX	0125			;Horizontal
