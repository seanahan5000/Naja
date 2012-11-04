********************************
*
********************************

ENERGY_USAGE	DB	$00,$00,$00		;Must be consecutive
PERWHAT			DB	$00				;   in this order

CUTUP			TAY
				LDX	#3
:LOOP0			LDA	ENERGY_USAGE-1,X
				PHA
				DEX
				BNE	:LOOP0
				LDA	#3
				CPY	#$EE
				BEQ	:SKIPC
				JSR	RIGHT_DIGITS
				JMP	:SKIPD
:SKIPC			JSR	LEFT_DIGITS
:SKIPD			LDA	#$2E
				STA	TEXTBUF,X
				INX
				STX	TEMP
				LDX	PERWHAT
				LDA	ETABLE+0
				AND	#eq_identified
				BNE	:SKIPA
				LDX	#$06
				LDA	#$00
				STA	TEMP
:SKIPA			LDY	#$00
				TXA
				BEQ	:SKIPB
:LOOP1			INY
				LDA	PERTEXTS-1,Y
				BPL	:LOOP1
				DEX
				BNE	:LOOP1
:SKIPB			LDX	TEMP
:LOOP2			LDA	PERTEXTS,Y
				STA	TEXTBUF,X
				BMI	:EXIT
				INX
				INY
				BNE	:LOOP2			;Always
:EXIT			RTS

PERTEXTS		USR	(SWING)
				USR	(SHOT)
				USR	(USE)
				USR	(HEAL)
				USR	(ROUND)
				USR	(THROW)
				USR	(??????/?????)

********************************
				DS	19				;FREE SPACE
********************************

PARSTAT			LDA	#$30
				STA	TEXTBUF
				LDA	#$32
				STA	TEXTBUF+2
				LDA	#$8D
				STA	TEXTBUF+3
				LDX	#$2C
				LDA	ETABLE+0
				CMP	#$FF
				BEQ	NISKIP
				LDX	#$01
				LDA	ETABLE+2
				AND	#eq_hands12
				BEQ	HOSKIP
				INX
HOSKIP			LDA	ETABLE+2
				AND	#eq_faulty
				BEQ	NFSKIP
				LDX	#$10
NFSKIP			LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				TAY
				LDA	PROUSAB,Y
				AND	ETABLE+3
				BNE	NUSKIP
				LDX	#$22
NUSKIP			LDA	ETABLE+0
				AND	#eq_broken
				BEQ	NBSKIP
				LDX	#$0C
NBSKIP			LDA	ETABLE+0
				AND	#eq_identified
				BNE	NISKIP
				LDX	#$33
NISKIP			STX	TEXTBUF+1
				RTS

PROUSAB			DB	$01,$02,$04
				DB	$08,$10,$FF
				DB	$40,$80,$20

ENERUSE			LDX	#$00
:LOOP1			LDA	(CHARDL),Y
				STA	ETABLE,X
				INY
				INX
				CPX	#$04
				BNE	:LOOP1

ENERGY2			LDA	#$00
				LDX	#$02
:LOOP0			STA	ENERGY_USAGE,X
				DEX
				BPL	:LOOP0
				STX	PERWHAT

				LDA	ETABLE+0		;Called from in ARSENAL
				AND	#$1F
				CMP	#$04
				BEQ	:EXARMOR
				CMP	#$05			;HELMET
				BEQ	:EXIT
				CMP	#$1A			;PROGRAM
				BEQ	:EXIT

				LDX	#$00
:LOOP1			CMP	SETS,X
				BEQ	:SKIPA
				BCC	:EXIT
				INX
				BNE	:LOOP1			;Always

:SKIPA			LDA	ETABLE+0
				AND	#$1F
				CMP	#$03			;Misc equipment
				BNE	:SKIPB
				LDA	ETABLE+1
				AND	#%00000111
				CMP	#$06			;COMPRESSD PERSON, DATA CARD,
				BCS	:SKIPB			;   JUNK
				CMP	#$03
				BCS	:EXIT

:SKIPB			TXA
				ASL
				TAX
				LDA	SUBSETS,X
				STA	TEMP
				LDA	SUBSETS+1,X
				STA	TEMP+1
				LDY	#$00
:LOOP2			LDA	ETABLE+1
				CMP	(TEMP),Y
				BEQ	:SKIPC
				INY
				INY
				INY
				INY
				BNE	:LOOP2			;Always

:SKIPC			INY
				LDA	(TEMP),Y
				STA	PERWHAT
				LDX	#0
:LOOP4			INY
				LDA	(TEMP),Y
				STA	ENERGY_USAGE+1,X
				INX
				CPX	#2
				BNE	:LOOP4
				RTS

:EXARMOR		LDA	#0
				STA	TOTAL
				STA	TOTAL+1
				JSR	POWUSE_ARMORS
				LDA	TOTAL+1
				STA	ENERGY_USAGE+1
				LDA	TOTAL
				STA	ENERGY_USAGE+2
:EXIT			LDA	#Round
				STA	PERWHAT
				RTS
