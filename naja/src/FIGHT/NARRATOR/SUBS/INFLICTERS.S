*=================================================
* On Entry:
*   TOTAL_DAMAGEL,H: Damage to inflict on monster
*           POINTTO: Called for monster
*
* On Exit:
*     Carry Set: Monster WAS killed
*   Carry Clear: Monster was NOT killed
*=================================================

DAMAGE_MONS		LDA	#0
DISDAM_MONS		PHA
				JSR	MDAMAGE_SUB
				PLA
				BCC	:EXIT
				PHA
				LDA	#6
				JSR	CLEAR_TLINE
				LDY	#xMonsName
				LDA	#xIs
				JSR	WORD2_INC
				JSR	KILL_DESTROY
				JSR	PERIOD_RETURN
				PLA
				BEQ	:1
				JSR	FADE_ALIEN
				JMP	:2
:1				JSR	DRAW_ALIEN
:2				JSR	MONS_FROMGRID
				JSR	UPDATE_MNAMES
				SEC
:EXIT			RTS


MDAMAGE_SUB		LDY	#monDAMAGE+1
				SED
				LDA	(MONS_PTR),Y
				SEC
				SBC	TOTAL_DAMAGEL
				STA	(MONS_PTR),Y
				STA	TEMP
				DEY
				LDA	(MONS_PTR),Y
				SBC	TOTAL_DAMAGEH
				STA	(MONS_PTR),Y
				CLD
				BCC	:SKIPA
				CLC
				ORA	TEMP
				BNE	:EXIT
:SKIPA			LDA	#0
				STA	(MONS_PTR),Y
				INY
				STA	(MONS_PTR),Y
				LDY	#monSTATUS
				LDA	#dead
				STA	(MONS_PTR),Y
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAX
				INC	ATOTAL1,X
				DEC	ATALLY
				SEC
:EXIT			RTS



*===================================================
* On Entry:
*   TOTAL_DAMAGEL,H: Damage to inflict on character
*          CHARDL,H: Pointing to character
*
* On Exit:
*   DEAD_FLAG: Top 2 bits are set appropriately
*===================================================

DAMAGE_CHAR		JSR	CDAMAGE_SUB
				LDA	#6
				JSR	CLEAR_TLINE
				LDY	#xGoes
				LDA	#xCritical
				BIT	DEAD_FLAG
				BMI	:1
				BVS	:2
				RTS
:1				LDA	#$29			;Asterisk
				STA	TEXTBUF
				STA	TEXTBUF+1
				STA	TEXTBUF+2
				LDX	#3
				LDY	#profrace
				LDA	(CHARDL),Y
				ASL
				LDY	#xIs
				LDA	#xKilled
				BCC	:2
				LDY	#xHas
				LDA	#xBroken
:2				PHA
				TYA
				LDY	#xCharsName
				JSR	WORD2_INC
				PLA
				TAY
				JMP	WORD1_PRDRET


CDAMAGE_SUB		LDA	CHAR_NUMBER
				JSR	POINTIT
				JSR	DAMAGR2
				LDY	CHAR_NUMBER
				LDA	YPOINTS,Y
				STA	YPNT
				TAY
				LDA	#$8A
				JSR	LINE
				LDX	TOTAL_DAMAGEL
				LDY	TOTAL_DAMAGEH
				SEC
				JSR	INFLICTER
				LDA	#%10000000
				BVS	:SKIPA
				LDA	#%00000000
:SKIPA			ROR
				STA	DEAD_FLAG
				JSR	DAMAGR2
				LDA	#$8A
				LDY	YPNT
				JSR	LINE
				BIT	DEAD_FLAG
				BPL	:EXIT
				JSR	CHANGE_CGRID
				LDA	CHAR_NUMBER
				JSR	POINTIT
				JSR	DEAD_PLACER
				JSR	DRAW_IF_DEAD
:EXIT			RTS

*-------------------------------
*
*-------------------------------

DEAD_PLACER		LDY	CHAR_NUMBER
				LDA	TEMPCHAR_XY,Y
				STA	DEAD_XY
				JSR	CHAR_INDEXER
				LDX	#3
:LOOP1			LDA	DEAD_XY
				AND	:MASKS,X
				CMP	:BOUNDS,X
				BEQ	:SKIPA
				TYA
				CLC
				ADC	:INDEXS,X
				TAY
				LDA	MASTER_CGRID,Y
				CMP	#$FF
				BEQ	:SKIPB
:SKIPA			DEX
				BPL	:LOOP1
				RTS

:SKIPB			LDA	:MASKS,X
				AND	#%00000010
				ORA	DEAD_FLAG
				ORA	#%00000001
				STA	DEAD_FLAG
				LDA	DEAD_XY
				SEC
				SBC	:OFFSETS,X
				STA	DEAD_XY
				RTS

:MASKS			DB	$F0,$0F,$F0,$0F
:BOUNDS			DB	$10,$05,$50,$01
:INDEXS			DB	4,-6,-4,5
:OFFSETS		DB	$10,$01,$00,$00


*-------------------------------
* DEAD_FLAG:   AB0000CD
*   A = 1: Character died
*   B = 1: Character went critical
*   C = 0: Horizontal topview drawn
*     = 1: Vertical topview drawn
*   D = 0: No dead topview drawn
*     = 1: Dead topview was drawn

DEAD_FLAG		DB	0				;MAKE ZPAGE LATER
