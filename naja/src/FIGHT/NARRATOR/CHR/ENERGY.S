CHR_ENERGY

*------------------------------*
*  Prepare for energy attack   *
*------------------------------*

				LDA	#0
				LDX	#24
:LOOP1			STA	ENHIT,X			;Clear hit zone buffer
				DEX
				BPL	:LOOP1

				JSR	ZONE			;Draw boundaries
				LDY	COMPNTR
				LDA	COMMAND,Y
				ROL
				ROL
				ROL
				AND	#$03			;Get type of energy thrown
				STA	ENTYPE			;   from command

				LDA	COMMAND+1,Y
				TAX
				LSR
				LSR
				LSR
				LSR
				STA	XCOUNT
				TXA
				AND	#%00001111
				TAX
				INX
				STX	YCOUNT
				LDA	#0
:LOOP2			CLC
				SED
				ADC	XCOUNT
				CLD
				DEX
				BNE	:LOOP2			;Calculate number of
				STA	SQUARE_COUNT	;   squares in hit zone

				LDA	#<ENHIT
				STA	POINTL
				LDA	#>ENHIT
				STA	POINTH
				LDA	COMMAND-1,Y
				JSR	MON_INDEXER
				LDA	#$FF			;Set squares in hit zone
				TAX					;   to #$FF
				JSR	FILL_GRID

*------------------------------*
*   Begin attack description   *
*------------------------------*

				LDY	COMPNTR
				LDA	COMMAND-2,Y
				LSR
				LSR
				LSR
				LSR					;CHANGE TO 2 BYTE VALUES IN TABLE
				STA	TEMP
				ASL
				ADC	TEMP
				TAX
				LDY	ENTABLE+1,X
				STY	ENERGY_H
				LDA	ENTABLE+2,X
				STA	ENERGY_L
				TAX
				LDA	SQUARE_COUNT
				JSR	MULTIPLY_12
				LDX	#<PRODUCT_3
				LDY	#>PRODUCT_3
				CLC
				JSR	DRAINER_MAIN
				BCS	:SKIPB
				LDY	#energylev+1
				LDA	(CHARDL),Y
				TAX
				DEY
				LDA	(CHARDL),Y
				TAY
				LDA	SQUARE_COUNT
				JSR	DIVIDE_12
				STX	ENERGY_H
				PHA
				LDY	#energylev+2
				LDA	(CHARDL),Y
				TAX
				PLA
				TAY
				LDA	SQUARE_COUNT
				JSR	DIVIDE_12
				STX	ENERGY_L
				TXA					;Check for 0 energy throw
				ORA	ENERGY_H
				BNE	:SKIPB
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<name> RELEASES A HARMLESS"
* "BOLT OF ENERGY."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				JSR	CLEAR_TLINE1
				LDY	#5				;S>5 CharsName.Releases.A.Harmless
				JMP	EXIT_ENERGY		;    Bolt.Of.Energy.
:SKIPB

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<name> | LETS LOOSE | WITH A"
*         | UNLOADS    |
*         | THROWS     |
*         | DISCHARGES |
*         | RELEASES   |
*         | EMITS      |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				JSR	CLEAR_TLINE1
				LDY	#xCharsName
				JSR	WORD1_INC
				LDA	#5
				JSR	RND_DIGIT_0
				TAY
				LDA	ECORES,Y
				TAY
				JSR	WORD1_INC
				LDA	RANDOM1
				AND	#$07
				CMP	#$02
				BCS	:SKIPA
				LDY	#xWith
				JSR	WORD1_INC
:SKIPA			LDY	#xA
				JSR	WORD1_RET

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "| | SCORCHING | | 999999 UNIT | BLAST | OF"
*  | | BURNING   | |             |       |
*  | | SEARING   | |             | BOLT  |
*  |               |             |       |
*  | | CRACKLING | |             | FLASH |
*  | | PULSATING | |
*  | | GLOWING   | |
*  |               |
*  | | BRILLIANT | |
*  | | BLINDING  | |
*  | | GLARING   | |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	ENTYPE
				ASL
				CLC
				ADC	ENTYPE
				STA	SCRATCH
				LDA	#2
				JSR	RND_DIGIT_0
				CLC
				ADC	#xScorching
				ADC	SCRATCH
				TAY
				LDX	#0
				JSR	WORD1_INC

				LDY	#3
:LOOP4			LDA	PRODUCT_4,Y
				PHA
				DEY
				BPL	:LOOP4
				LDA	#4
				JSR	LEFT_DIGITS

				INX
				LDY	ENTYPE
				LDA	BCORES,Y
				LDY	#xUnit
				JSR	WORD2_INC
				LDY	#xOf
				JSR	WORD1_RET

*------------------------------*
*   Check individual squares   *
*------------------------------*

				LDA	#$10
				STA	XCOUNTR
				LDA	#$06
				STA	YCOUNTR
				LDY	#0
				STY	ANY_HIT_FLAG
				STY	SCOUNTR
ENSQUARE_LOOP	LDA	ENHIT,Y
				BEQ	:SKIPD			;Next square
				LDA	MASTER_MGRID,Y
				AND	#%00111111
				STA	MONS_NUMBER

				LDY	SCOUNTR
				TYA
				PHA
				LDA	#0
				STA	MCOUNTR
				BEQ	:SKIPA			;Always

:LOOP2			LDA	ENHIT,Y
				BEQ	:SKIPB
				LDA	MASTER_MGRID,Y
				AND	#%00111111
				CMP	MONS_NUMBER
				BNE	:SKIPB
:SKIPA			INC	MCOUNTR
				LDA	#0
				STA	ENHIT,Y
				JSR	TAKE_ENERGY
:SKIPB			INC	SCOUNTR
				LDY	SCOUNTR
				CPY	#25
				BNE	:LOOP2
				PLA
				STA	SCOUNTR

				JSR	CLEAR_TEXT
				LDA	MONS_NUMBER
				CMP	#$3F
				BEQ	:SKIPD
				JSR	POINTTO
				JSR	ENAPART

:SKIPD			JSR	INCSUB			;Next square
				LDY	SCOUNTR
				CPY	#25
				BNE	ENSQUARE_LOOP

				BIT	ANY_HIT_FLAG	;Last square
				BMI	EEXIT2
				LDX	#0
				LDY	#xEnergy
				JSR	WORD1_INC
				LDY	#0				;S>0 But.No.One.Is.Affected
EXIT_ENERGY		JSR	SENTENCE_PRET
				JSR	DELAYER
EEXIT2			JSR	CLRBOX
				JSR	ZONE
				JMP	CCOM

*-------------------------------

INCSUB			INC	SCOUNTR
				LDA	XCOUNTR
				CLC
				ADC	#$10
				STA	XCOUNTR
				CMP	#$60
				BNE	INCOUT
				LDA	#$10
				STA	XCOUNTR
				INC	YCOUNTR
INCOUT			RTS

*-------------------------------

ENAPART			LDA	ANY_HIT_FLAG
				BNE	:SKIPA
				LDX	#0
				LDY	#xEnergy
				JSR	WORD1_PRDRET
:SKIPA			DEC	ANY_HIT_FLAG
				LDX	#$A5
				JSR	CLOOP2
				LDX	ENTYPE
				BEQ	HEAT
				DEX
				BEQ	ELECTRICAL
				JMP	LIGHT

*-------------------------------

ELECTRICAL		LDA	#xHit
				STA	TEMP
				LDA	#$75			;Type % adjustment
				LDX	#monELSHIELD
				LDY	#susELECTRICAL
				BPL	EH_COM			;Always

HEAT			LDA	#xBurned
				STA	TEMP
				LDA	#$50			;Type % adjustment
				LDX	#monPHSHIELD
				LDY	#susHEAT

EH_COM			STX	:MOD1+1
				STY	:MOD2+1
				LDX	TEMP
				STX	HITMOD+1
				LDX	ENERGY_L
				LDY	ENERGY_H
				JSR	PERCENT_OF
				STY	TEMP
:MOD1			LDY	#$FF			;Modified
				LDA	(MONS_PTR),Y
				LDY	TEMP
				JSR	LESS_PERCENT
:MOD2			LDA	#$FF			;Modified
				JSR	SUSEPTABILITY
				LDA	MCOUNTR
				JSR	MULTIPLY_12
				LDX	PRODUCT_3+2
				LDY	PRODUCT_3+1
				LDA	PRODUCT_3+0
				BEQ	:SKIPA
				LDX	#$99
				LDY	#$99
:SKIPA			STX	TOTAL_DAMAGEL
				STY	TOTAL_DAMAGEH
				TXA
				BNE	HAS_EFFECT
				TYA
				BEQ	NO_EFFECT

HAS_EFFECT
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<monsname> IS | HIT    | FOR"
*                | BURNED |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	#5
				JSR	CLEAR_TLINE
				LDY	#xMonsName
				LDA	#xIs
				JSR	WORD2_INC
HITMOD			LDY	#$FF			;Modified
				LDA	#xFor
				JSR	WORD2_RET

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<damage> DAMAGE|.               |
*                 | AND DESTROYED. |
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				JSR	MDAMAGE_SUB
				PHP
				LDX	#0
				LDY	#x9999
				LDA	#xDamage
				JSR	WORD2
				PLP
				PHP
				BCC	:SKIPA
				INX
				LDY	#xAnd
				LDA	#xIs
				JSR	WORD2_INC
				JSR	KILL_DESTROY
:SKIPA			JSR	PERIOD_RETURN
				JSR	BLINK_MONS
				PLP
				BCC	:EXIT
				JSR	DRAW_ALIEN
				JSR	MONS_FROMGRID
				JSR	UPDATE_MNAMES
:EXIT			JMP	DELAYER


NO_EFFECT
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<monsname> IS HIT BUT"
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	#5
				JSR	CLEAR_TLINE
				LDY	#39				;s>39 <monsname>.Is.Hit.But
				JSR	SENTENCE_RET

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "NOT AFFECTED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDY	#xNot
				LDA	#xAffected
				JSR	WORD2_PRDRET
				JMP	DELAYER

*-------------------------------

LIGHT			LDA	ENERGY_H
				STA	BASE+0
				LDA	ENERGY_L
				STA	BASE+1
				LDY	#0
				STY	BASE+2
				STY	BASE+3
				LDX	#$25			;Type % adjustment
				JSR	MULTIPLY_BASE

				LDY	#aSusepts
				LDA	(ALIEN_PTR),Y
				ASL
				ROL
				ROL
				ASL
				AND	#%00000110
				TAX
				LDY	LIGHT_SUS,X
				LDA	LIGHT_SUS+1,X
				TAX
				JSR	MULTIPLY_BASE

				LDY	#monUPREF
				JSR	MUCHTIM
				TYA
				ASL
				TAX
				LDY	PER_TABLE,X
				LDA	PER_TABLE+1,X
				TAX
				JSR	MULTIPLY_BASE

				LDY	MCOUNTR
				LDX	#0
				JSR	MULTIPLY_BASE
				LDY	BASE+0
				LDX	BASE+1
				STY	TEMP+1
				STX	TEMP
				LDA	#blind
				JSR	STATUS_MONS
				BCS	:SKIPA			;Branch if it had effect

*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* "<monsname> IS"
* "NOT AFFECTED."
*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
				LDA	#5
				JSR	CLEAR_TLINE
				LDY	#25				;S>25 <monsname>.Is.RET.Not.Affected
				JSR	SENTENCE_PRET
:SKIPA			JMP	DELAYER

LIGHT_SUS		HEX	0000			;never
				HEX	0010			;little
				HEX	0025			;some
				HEX	0100			;very

PER_TABLE		HEX	0360			;36/10?
				HEX	0090			;18/20?
				HEX	0040			;12/30?
				HEX	0022			; 9/40?
				HEX	0014			; 7/50?
				HEX	0010			; 6/60?

*-------------------------------
*
*-------------------------------

ZONE			LDX	COMPNTR
				LDA	COMMAND-1,X
				CLC
				JSR	CURZONE
				LDX	COMPNTR
				LDA	COMMAND+1,X
				TAX
				AND	#$F0
				CLC
				ADC	CURSOR
				SEC
				SBC	#$10
				TAY
				TXA
				AND	#$0F
				STA	CURSOR
				TYA
				SEC
				SBC	CURSOR
				SEC
CURZONE			PHP
				STA	CURSOR
				SEC
				SBC	#$05
				JSR	FROM11B
				LDA	XPNTS,X
				STA	XPNT
				LDA	YPNTS,Y
				SEC
				SBC	#$37
				STA	YPNT
				PLP
				PHP
				LDA	XPNT
				PHA
				DEC	XPNT
				BCC	:SKIPA
				CLC
				ADC	#$0E
				STA	XPNT
:SKIPA			LDA	#0
				LDX	#<BOUNDS_SHAPES
				LDY	#>BOUNDS_SHAPES
				JSR	DRAW_SHAPES
				LDA	YPNT
				PHA
				CLC
				ADC	#$05
				STA	YPNT
				LDA	#0
				JSR	REDRAW_SHAPES
				PLA
				STA	YPNT
				DEC	YPNT
				PLA
				STA	XPNT
				PLP
				BCC	:SKIPB
				LDA	YPNT
				CLC
				ADC	#$0B
				STA	YPNT
				CMP	#$7F
				BNE	:SKIPB
:SKIPB			LDA	#1
				JSR	REDRAW_SHAPES
				LDA	XPNT
				CLC
				ADC	#$07
				STA	XPNT
				LDA	#1
				JSR	REDRAW_SHAPES
				JMP	CLEAN_FRONT

BOUNDS_SHAPES	DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000001
				DB	%00000000
				DB	%00000000

				DB	%01111111
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000
				DB	%00000000

*-------------------------------

SQUARE_COUNT	DB	0
ANY_HIT_FLAG	DB	0

ECORES			DB	xLetsLoose,xUnloads,xThrows
				DB	xDischarges,xReleases,xEmits
BCORES			DB	xBlast,xBolt,xFlash

*-------------------------------
