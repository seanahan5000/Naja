SHIELD_USE		=	$1111			;1.111 (*** FAKE)
ARMOR_USE_E		=	$0123			;0.123 (*** FAKE)
ARMOR_USE_P		=	$0234			;0.234 (*** FAKE)
EXO_PROT_E		=	$50				;50%
EXO_PROT_P		=	$75				;75%


********************************
***
*** Take base power consumption and...
***    Add armor use if smart armor
***    Add force shield use
***    Add misc stuff (not on back) such as...
***       robot controller, blast visor, organic detector,
***       robotic detector, hand attachment
***     If robot, just look at misc stuff in hands and
***        head slot (if available)
***
*****  If BROKEN: no effect
*****  If FAULTY: maximum power use

CALC_POWRUSE	LDA	#$00
				STA	FAULT_COUNT

				LDY	#basepowercons	;Put base power consumption
				LDA	(CHARDL),Y		;   in TOTAL,+1
				STA	TOTAL+1
				INY
				LDA	(CHARDL),Y
				STA	TOTAL

				LDY	#profrace		;Skip to misc stuff if a robot
				LDA	(CHARDL),Y
				BMI	:SKIPA
				LDX	#$03
				LDY	#e13_ARMOR+3	;Look at what type of armor they
:LOOP1			LDA	(CHARDL),Y		;   are wearing
				STA	ETABLE,X
				DEY
				DEX
				BPL	:LOOP1
				JSR	POWUSE_ARMORS	;Add armor/shield power use to total

:SKIPA			JSR	RESET_EQLIST	;This rectifies robot/char differences
				JSR	ESCAN_FULSLOT	;Eliminate empty slots
				LDX	#2
				LDA	#$FF			;Eliminate back
:LOOP2			STA	EQUIP_LIST,X
				INX
				CPX	#8
				BNE	:LOOP2
				LDX	#<ECALL_ENERUSE	;Eliminate equipment that
				LDY	#>ECALL_ENERUSE	;   doesn't use energy (per round)
				JSR	ESCAN_COMMON

				LDA	#$00			;Get energy use for misc equipment
				STA	COUNTER			;Compare equipment that has
:LOOP3			LDX	COUNTER			;   met the previous criteria
				LDA	EQUIP_LIST,X	;   against the equipment that
				BNE	:SKIPB			;   that actually does use energy
				LDY	CORESPS,X		;   when it is in your hands
				LDX	#$00			;   and add that to total
:LOOP4			LDA	(CHARDL),Y
				STA	ETABLE,X
				INY
				INX
				CPX	#$04
				BNE	:LOOP4
				JSR	POWUSE_MISC
:SKIPB			INC	COUNTER
				LDA	COUNTER
				CMP	#16
				BNE	:LOOP3

				LDA	FAULT_COUNT
				BEQ	:SKIPC
				LDA	#$99			;If anything is faulty,
				STA	TOTAL			;   use as much energy as possible
				STA	TOTAL+1
:SKIPC			LDY	#powerconsumpt	;Put new value in power consumption
				LDA	TOTAL+1
				STA	(CHARDL),Y
				INY
				LDA	TOTAL
				STA	(CHARDL),Y
				RTS


********************************
* On Entry:
*   ETABLE: Equipment to find power use for
*
* On Exit:
*   X = Power use low
*   Y = Power use high
*   X,Y = 0 if nothing was found in tables

ANY_POWUSE		LDA	#$00			;Entry point for Arsenal routines
				STA	TOTAL
				STA	TOTAL+1
				JSR	POWUSE_ARMORS
				BCS	:EXIT
				JSR	POWUSE_MISC
:EXIT			LDX	TOTAL
				LDY	TOTAL+1
				RTS


POWUSE_ARMORS	LDA	ETABLE+0
				AND	#%11011111
				CMP	#$46			;FORCE SHIELD
				BNE	:SKIPA

				LDA	ETABLE+1		;Calculate if force shield
				AND	#%00001111
				STA	TEMP
				JSR	CHECK_FAULTY
				LDX	#<SHIELD_USE
				LDY	#>SHIELD_USE
:LOOP1			JSR	ADD_TO_TOTAL
				DEC	TEMP
				BNE	:LOOP1
				BEQ	:SKIPC			;Always

:SKIPA			CMP	#$44			;ARMOR
				CLC
				BNE	:EXIT
				JSR	CHECK_FAULTY
				LDA	ETABLE+2
				BPL	:SKIPB
				LDA	ETABLE+1		;Calculate armor energy use
				AND	#%00000111		;   based on class if smart
				STA	TEMP
				LDX	#<ARMOR_USE_P
				LDY	#>ARMOR_USE_P
:LOOP2			JSR	ADD_TO_TOTAL
				DEC	TEMP
				BPL	:LOOP2
:SKIPB			LDA	ETABLE+1		;Calculate armor energy use
				AND	#%00111000		;   based on brand no matter
				LSR					;   if smart or not
				LSR
				LSR
				STA	TEMP
				LDX	#<ARMOR_USE_E
				LDY	#>ARMOR_USE_E
:LOOP3			JSR	ADD_TO_TOTAL
				DEC	TEMP
				BPL	:LOOP3
:SKIPC			SEC
:EXIT			RTS


POWUSE_MISC		LDA	ETABLE+0		;Scan list of equipment that
				AND	#%11011111		;   consumes energy per round
				STA	TEMP			;   and if one matches the object
				JSR	CHECK_FAULTY	;   in ETABLE, add the consumption
				LDX	#$00			;   to TOTAL,+1 and exit
:LOOP3			INX
				INX
				INX
				INX
				LDA	POWUSE_TABLE-4,X
				CMP	#$FF
				BEQ	ADD_EXIT
				CMP	TEMP
				BNE	:LOOP3
				LDA	POWUSE_TABLE-3,X
				CMP	ETABLE+1
				BNE	:LOOP3
				LDY	POWUSE_TABLE-2,X
				LDA	POWUSE_TABLE-1,X
				TAX
ADD_TO_TOTAL	TXA
				CLC
				SED
				ADC	TOTAL
				STA	TOTAL
				TYA
				ADC	TOTAL+1
				STA	TOTAL+1
				CLD
				BCC	ADD_EXIT
				LDA	#$99
				STA	TOTAL
				STA	TOTAL+1
ADD_EXIT		RTS

*** Type, Subtype, Usehigh, Uselow
POWUSE_TABLE
				DB	$40,$02,$98,$76				;BLAST VISOR
				DB	$42,$02,$98,$76				;ORGANIC DETECTOR
				DB	$42,$03,$98,$76				;ROBOTIC DETECTOR
				DB	$42,$05,$98,$76				;VIBRATION SENSOR
				DB	$43,$20,$98,$76				;ROBOT CONTROLLER
				DB	$59,$00,$98,$76				;HAND ATTACHMENT
				DB	$FF				;End-Of-Table marker

ECALL_ENERUSE	INY
				INY
				INY
				LDA	(CHARDL),Y
				AND	#eq_usesenergy
				EOR	#eq_usesenergy
				RTS

TOTAL			DW	$0000


CHECK_FAULTY	LDA	ETABLE+2
				AND	#eq_faulty
				BEQ	:EXIT
				INC	FAULT_COUNT
:EXIT			RTS

FAULT_COUNT		DB	$00


********************************
***
*** Take base shielding and...
***    Adjust for armor, force shields, misc protection, etc.
***
*****  If BROKEN: no effect
*****  If FAULTY: no effect

CALC_SHIELDIN	LDY	#baseshielding
				LDA	(CHARDL),Y
				STA	TOTAL
				INY
				LDA	(CHARDL),Y
				STA	TOTAL+1
				LDY	#profrace
				LDA	(CHARDL),Y
				BMI	:SKIPA
				LDY	#e1_HEAD
				JSR	:SUBA
				LDY	#e13_ARMOR
				JSR	:SUBA
				LDY	#e14_FEET
				JSR	:SUBA
:SKIPA			LDY	#e2_SLOT
				JSR	:SUBA
				LDY	#Eshielding
				LDA	TOTAL
				STA	(CHARDL),Y
				INY
				LDA	TOTAL+1
				STA	(CHARDL),Y
				RTS

:SUBA			JSR	ANY_SHIELDING
				SED					;X=electrical, Y=physical
				TXA
				CLC
				ADC	TOTAL
				CLD
				BCC	:SKIPB
				LDA	#$99
:SKIPB			STA	TOTAL
				SED
				TYA
				CLC
				ADC	TOTAL+1
				CLD
				BCC	:SKIPC
				LDA	#$99
:SKIPC			STA	TOTAL+1
				RTS

ANY_SHIELDING	LDA	(CHARDL),Y
				AND	#%11011111
				TAX
				INY
				INY
				LDA	(CHARDL),Y
				AND	#eq_faulty
				BNE	:EXIT0
				DEY
				TXA

:FORCESHIELD	CMP	#$46
				BNE	:ATTACHMENTS
				LDA	(CHARDL),Y
				AND	#%00001111
				LSR
				PHP
				ASL
				ASL
				ASL
				ASL
				PLP
				BCC	:SKIPA
				ORA	#$05
:SKIPA			TAX
				LDY	#$00
				RTS

:ATTACHMENTS	CMP	#$40
				BNE	:MISCPROTECT
				LDA	(CHARDL),Y
				TAY
				LDX	#$00
				AND	#%00000011
				BNE	:SKIPB
				TYA
				AND	%00011100
				LSR
				LSR
				TAX
:SKIPB			LDY	#$00
				RTS

:MISCPROTECT	CMP	#$47
				BNE	:HELMET
				LDA	(CHARDL),Y
				TAX
				AND	#%00000011
				CMP	#$01
				BNE	:SKIPC
				TXA
				AND	#%00011100
				LSR
				LSR
				TAX
				LDY	#$00
				RTS
:SKIPC			LDX	#EXO_PROT_E
				LDY	#EXO_PROT_P
				CMP	#%00000011
				BEQ	:EXIT
:EXIT0			LDX	#$00
				LDY	#$00
:EXIT			RTS

:HELMET			CMP	#$45
				BNE	:ARMOR
				LDA	(CHARDL),Y
				PHA
				AND	#%00000011
				TAX
				LDY	HELM_CLASS,X
				PLA
				AND	#%00001100
				LSR
				LSR
				TAX
				LDA	HELM_BRAND,X
				TAX
				RTS

:ARMOR			CMP	#$44
				BNE	:EXIT
				LDA	(CHARDL),Y
				PHA
				AND	#%00000111
				TAX
				LDY	ARMR_CLASS,X
				PLA
				AND	#%00111000
				LSR
				LSR
				LSR
				TAX
				LDA	ARMR_BRAND,X
				TAX
				RTS

HELM_BRAND		DB	$04,$08,$12,$16
HELM_CLASS		DB	$01,$05,$10
ARMR_BRAND		DB	$10,$20,$30,$40,$60
ARMR_CLASS		DB	$10,$20,$40,$60,$80


********************************
***
*** Take base stats and...
***    Adjust for status (illness, strong, etc.)
***    Adjust for armor/equipment that affect stats
***
*****  If BROKEN: normal effect (smart will also have effect)
*****  If FAULTY: maximum drop in stats

CALC_STATS		LDY	#energylev
				LDA	#$00
:LOOP1			ORA	(CHARDL),Y
				INY
				CPY	#energylev+3
				BNE	:LOOP1
				LDY	#status
				TAX
				BEQ	:SKIPA
				LDA	(CHARDL),Y
				BPL	CONTINUE
				BMI	:SKIPB			;Always
:SKIPA			LDA	(CHARDL),Y
				BMI	CONTINUE
:SKIPB			EOR	#rundown
				STA	(CHARDL),Y
CONTINUE		LDX	#3
				LDY	#basestrength+3	;Put base strng,uprfx,lwrfx,intel
:LOOP1			LDA	(CHARDL),Y		;   into stat holders
				STA	HOLD_STRENGTH,X
				DEY
				DEX
				BPL	:LOOP1
				LDY	#status
				LDA	(CHARDL),Y
				STA	HOLD_STATUS
				AND	#%00111111
				CMP	#dead			;If character is dead or broken,
				BEQ	:SKIPA			;   set all four stats to 0 and exit
				CMP	#broken
				BNE	:SKIPB
:SKIPA			LDX	#$00
				STX	HOLD_INTELLIG
				BEQ	:SKIPD			;Always
:SKIPB			LDX	#$99
				CMP	#fast			;If character is fast or strong, set
				BEQ	:SKIPE			;   appropriate stats to 99 and exit
				CMP	#strong
				BNE	:SKIPC
				STX	HOLD_STRENGTH
				BEQ	:SKIPF			;Always
:SKIPC			AND	#%00110000
				CMP	#$20
				BNE	:SKIPG
:SKIPH			LDX	#$01			;If character status is one of the
:SKIPD			STX	HOLD_STRENGTH	;   $20 class, drop strng,uprfx,lwrfx
:SKIPE			STX	HOLD_UPREFLEX	;   to 1 and exit
				STX	HOLD_LWREFLEX
:SKIPF			JMP	STAT_CALCED

:SKIPG			LDY	#profrace		;If rundown robot, set stats to 1
				LDA	(CHARDL),Y
				BPL	RUNDCRIT
				BIT	HOLD_STATUS
				BMI	:SKIPH
				JSR	PROGRAM_BASE
				JMP	OTHER_STATS

RUNDCRIT		BIT	HOLD_STATUS
				BPL	:SKIPA
				LDY	#organic		;If rundown, drop stats by the
				LDA	#$00			;   character's percent inorganic
				SEC
				SED
				SBC	(CHARDL),Y
				CLD
				JSR	PERCENT_ALL
:SKIPA			LDA	HOLD_STATUS
				AND	#critical
				BEQ	OTHER_STATS
				LDY	#strength+3		;If critical, drop stats by the
				LDX	#$03			;   character's percent organic
:LOOP2			LDA	HOLD_STRENGTH,X
				PHA
				LDA	(CHARDL),Y
				STA	HOLD_STRENGTH,X
				DEY
				DEX
				BPL	:LOOP2
				LDY	#organic
				LDA	#$00
				SEC
				SED
				SBC	(CHARDL),Y
				CLD
				JSR	PERCENT_ALL
				LDX	#$00
:LOOP3			PLA
				SED
				SEC
				SBC	HOLD_STRENGTH,X
				CLD
				BEQ	:SKIPH
				BCS	:SKIPI			;Make sure stats don't fall
:SKIPH			LDA	#$01			;   below 1
:SKIPI			STA	HOLD_STRENGTH,X
				INX
				CPX	#$04
				BNE	:LOOP3
				BEQ	HEAVY_CALCED	;Always

OTHER_STATS		LDA	HOLD_STATUS
				LDX	#$00
:LOOP4			INX
				INX
				CMP	STAT_TABLE-1,X
				BEQ	:SKIPK
				EOR	#$80
				CMP	STAT_TABLE-1,X
				BEQ	:SKIPK
				LDY	STAT_TABLE-2,X
				INY
				BNE	:LOOP4
				BEQ	HEAVY_CALCED
:SKIPK			ASL
				LDA	STAT_TABLE-2,X
				PHA
				LDA	#$02
				ADC	#$00
				STA	COUNTER
:LOOP5			LDX	COUNTER
				LDA	HOLD_STRENGTH,X
				TAX
				LDY	#0
				PLA
				PHA
				JSR	LESS_PERCENT
				TXA
				BNE	:SKIPL
				LDA	#$01
:SKIPL			LDX	COUNTER
				STA	HOLD_STRENGTH,X
				DEC	COUNTER
				BPL	:LOOP5
				PLA
HEAVY_CALCED	JSR	HEAVY_STUFF
STAT_CALCED		LDX	#$03			;Move new stat values into
				LDY	#strength+3		;   character data
:LOOP1			LDA	HOLD_STRENGTH,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:LOOP1
				RTS

*** % YOUR STATS DROP, STATUS
*** STATUS HIGH BIT SET MEANS INTELLIGENCE DROPS
***                 CLEAR MEANS IT DOESN'T
STAT_TABLE		DB	$50,corroding
				DB	$50,poisoned
				DB	$50,bleeding
				DB	$50,radiated
				DB	$50,illA
				DB	$50,illB
				DB	$50,illC
				DB	$50,illD
				DB	$50,blind
				DB	$50,confused+$80
				DB	$50,onfire
				DB	$50,dizzy+$80
				DB	$50,stunned+$80
				DB	$50,immobile
				DB	$50,controlld+$80
				DB	$50,choking
				DB	$FF				;End-Of-Table marker


PERCENT_ALL		PHA					;Drop all HOLD values by the
				LDA	#$03			;   value sent in Acc.
				STA	COUNTER
:LOOP1			LDX	COUNTER
				LDA	HOLD_STRENGTH,X
				TAX
				LDY	#0
				PLA
				PHA
				JSR	LESS_PERCENT
				TXA
				BNE	:SKIPA
				LDA	#$01
:SKIPA			LDX	COUNTER
				STA	HOLD_STRENGTH,X
				DEC	COUNTER
				BPL	:LOOP1
				PLA
				RTS

HOLD_STRENGTH	DB	$00				;*
HOLD_UPREFLEX	DB	$00				;* Must be consecutive
HOLD_LWREFLEX	DB	$00				;*    in this order
HOLD_INTELLIG	DB	$00				;*
HOLD_STATUS		DB	$00


PROGRAM_BASE	LDY	#e15_PROGRAM+1
				LDA	(CHARDL),Y
				AND	#%01111111
				LDX	#$00
:LOOP1			CMP	PROG_TABLE,X
				BEQ	:SKIPA
				INX
				INX
				INX
				BNE	:LOOP1			;Always
:SKIPA			LDA	PROG_TABLE+1,X
				CMP	HOLD_LWREFLEX
				BCS	:SKIPB
				STA	HOLD_LWREFLEX
:SKIPB			LDA	PROG_TABLE+2,X
				CMP	HOLD_STRENGTH
				BCS	:SKIPC
				STA	HOLD_STRENGTH
:SKIPC			CMP	HOLD_UPREFLEX
				BCS	:EXIT
				STA	HOLD_UPREFLEX
:EXIT			RTS

PROG_TABLE		DB	$01,$20,$25
				DB	$02,$20,$25
				DB	$03,$20,$25
				DB	$04,$25,$25
				DB	$05,$25,$25
				DB	$06,$25,$30
				DB	$07,$30,$30
				DB	$10,$35,$35
				DB	$15,$35,$35
				DB	$20,$40,$40
				DB	$25,$45,$45
				DB	$30,$50,$50
				DB	$35,$55,$55
				DB	$40,$60,$60
				DB	$45,$65,$65
				DB	$50,$70,$70
				DB	$55,$75,$75
				DB	$60,$80,$80
				DB	$65,$85,$85
				DB	$70,$90,$90
				DB	$75,$95,$95


HEAVY_STUFF		LDY	#status
				LDA	(CHARDL),Y
				BMI	:SKIPB

				LDY	#e13_ARMOR		;Non-smart armor drops upper and
				LDA	(CHARDL),Y		;   lower reflex by armor class*2
				CMP	#$FF
				BEQ	:SKIPA
				INY
				INY
				LDA	(CHARDL),Y
				BMI	:SKIPA
				DEY
				LDA	(CHARDL),Y
				AND	#%00000111
				STA	TEMP
				INC	TEMP
				CLC
				SED
				ADC	TEMP
				CLD
				PHA
				JSR	SUBFROM_UP
				PLA
				JSR	SUBFROM_LW

:SKIPA			LDY	#e14_FEET		;Anything on feet drops lower
				LDA	(CHARDL),Y		;   reflex by 3
				CMP	#$FF
				BEQ	:SKIPB
				LDA	#3
				JSR	SUBFROM_LW

:SKIPB			LDY	#e3_UPLFT		;Heavy equipment drops upper and
:LOOP1			LDA	(CHARDL),Y		;   lower reflex by 8 each
				CMP	#$FF
				BEQ	:SKIPD
				AND	#%01111111
				CMP	#$4E			;Cannons
				BEQ	:SKIPC
				CMP	#$4F
				BNE	:SKIPD
				INY
				LDA	(CHARDL),Y
				DEY
				CMP	#$04			;Disintegrator
				BNE	:SKIPD
:SKIPC			LDA	#8
				JSR	SUBFROM_UP
				LDA	#8
				JSR	SUBFROM_LW
:SKIPD			INY
				INY
				INY
				INY
				CPY	#e12_BACK6+4
				BNE	:LOOP1
				RTS

SUBFROM_UP		LDX	#0
				BEQ	SUBCOMMON		;Always
SUBFROM_LW		LDX	#1
SUBCOMMON		STA	TEMP
				LDA	HOLD_UPREFLEX,X
				CMP	#$90
				BCS	:SKIPA
				SEC
				SED
				SBC	TEMP
				CLD
				BEQ	:SKIPB
				BCS	:SKIPC
:SKIPB			LDA	#$01
:SKIPC			STA	HOLD_UPREFLEX,X
:SKIPA			RTS


********************************
				DS	46,$EE			;FREE SPACE ********
********************************


CORESPS			DB	e1_HEAD			;0
				DB	e2_SLOT			;1
				DB	e7_BACK1		;2
				DB	e8_BACK2		;3
				DB	e9_BACK3		;4
				DB	e10_BACK4		;5
				DB	e11_BACK5		;6
				DB	e12_BACK6		;7
				DB	e3_UPLFT		;8
				DB	e4_UPRGT		;9
				DB	e5_LWLFT		;A 10
				DB	e6_LWRGT		;B 11
				DB	e13_ARMOR		;C 12
				DB	e14_FEET		;D 13
				DB	e15_PROGRAM		;E 14
				DB	e16_UNUSED		;F 15
