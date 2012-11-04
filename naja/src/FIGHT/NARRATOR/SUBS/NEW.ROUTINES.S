*----------------------------------------------------------
* Assuming CHARDL,H and COMPNTR are valid, get values for
*   PH_DAMAGEL,H ; EL_DAMAGEL,H ; ENERGYL,H MIN energy
*   level.  Also return shot type if shooting.
*----------------------------------------------------------

GET_EP_ENUSE	JSR	GET_ENERUSE
				LDX	COMPNTR
				LDA	COMMAND,X
				AND	#%00001111
				CMP	#cmdSWING
				BEQ	:SWINGER
				CMP	#cmdSHOOT
				BEQ	:SHOOTER
*CMP #cmdTHROW
*BEQ :THROWER

:THROWER		JSR	:SUBA
				STX	ENERGY_L
				STY	ENERGY_H
				JMP	:SKIPE			;!!!

:SHOOTER		LDX	#0				;0 - (normal shot)
				LDA	(CHARDL),Y
				CMP	#$4F			;misc weapons
				BNE	:SKIPA
				INY
				INX					;1 - (disintegrate shot)
				LDA	(CHARDL),Y
				CMP	#$04			;disintegrator
				BEQ	:SKIPA
				INX					;2 - (brain jam shot)
				CMP	#$05			;brain jammer
				BEQ	:SKIPA
				INX					;3 - (robot restrain shot)
:SKIPA			STX	SHOT_TYPE
				JSR	:SUBA
				BCS	:SKIPB			;Had enough energy
				LDA	SHOT_TYPE
				CMP	#2				;brain jam shot
				BCC	:SKIPB
				LDX	#0				;Zero energy use flags that
				LDY	#0				;   they didn't have enough energy
:SKIPB			STX	ENERGY_L
				STX	EL_DAMAGEL
				STY	ENERGY_H
				STY	EL_DAMAGEH
				LDA	#0
				STA	PH_DAMAGEL
				STA	PH_DAMAGEH
				RTS

:SWINGER		JSR	:SUBA
				STX	ENERGY_L
				STY	ENERGY_H
				LDA	ETABLE
				CMP	#$FF
				BEQ	:SKIPC
				AND	#%01111111
				CMP	#$4D			;Rifles
				BNE	:SKIPE
				LDX	#7				;Base damage inflicted by rifle
				BNE	:SKIPD			;Always
:SKIPC			LDX	#5				;Base damage inflicted by hand
:SKIPD			LDY	#0
				STY	ENERGY_L
				STY	ENERGY_H
:SKIPE			STX	PH_DAMAGEL
				STY	PH_DAMAGEH
				LDA	#0
				STA	EL_DAMAGEL
				STA	EL_DAMAGEH
				RTS

:SUBA			LDX	#<ENERGY_USAGE
				LDY	#>ENERGY_USAGE
				CLC
				JSR	DRAINER_MAIN
				LDX	ENERGY_USAGE+2
				LDY	ENERGY_USAGE+1
				BCS	:EXIT			;Had enough energy
				LDY	#energylev+2
				LDA	(CHARDL),Y
				TAX
				DEY
				LDA	(CHARDL),Y
				TAY
:EXIT			RTS

*-------------------------------
* 0 = normal shot
* 1 = disintegrator shot
* 2 = brain jammer shot
* 3 = robot restrainer shot
*-------------------------------
SHOT_TYPE		DB	0

*-------------------------------
* Take hand pointed to by first
*   byte of current character
*   command and load in that
*   piece of equipment and get
*   its energy use.
*-------------------------------

GET_ENERUSE		LDX	COMPNTR
				LDA	COMMAND,X
				ASL
				ROL
				ROL
				AND	#%00000011
				CLC
				ADC	#uplft
				STA	EQUIP_INDEX
				TAX
				LDY	CORESPS,X
				STY	EQUIP_OFFSET
				JSR	ENERUSE
				LDY	EQUIP_OFFSET
				RTS

EQUIP_OFFSET	DB	0				;COULD BE MOVED
EQUIP_INDEX		DB	0				;COULD BE MOVED


*-------------------------------
* Convert a raw position into a
*   number from 0 to 24 inclusive,
*   and return it in Y register.
*-------------------------------

CCMD_INDEXER	LDX	COMPNTR
				LDA	COMMAND+1,X
ANY_INDEXER		TAX
				AND	#%00001111
				CMP	#$06
				TXA
				BCC	CHAR_INDEXER
MON_INDEXER		SEC
				SBC	#$05
CHAR_INDEXER	JSR	FROM11B
				STX	TEMP
				LDA	TIMES5,Y
				CLC
				ADC	TEMP
				TAY
				RTS					;Must exit with X and Y valid

TIMES5			DB	0,5,10,15,20
