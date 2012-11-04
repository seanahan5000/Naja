				ORG	$9E00

*========================================
* On Entry:
*     SSTOREL,H: Pointer to source data
*             X: Destination sector
*     Carry Set: Self-destruct when done
*   Carry Clear: Leave intact when done
*
* Drive must already be up to speed
*   and the correct disk side checked
*
* On Exit:
*     Carry Set: Error occured
*   Carry Clear: No errors
*             Y: -1 = Write protected
*                 1 = Read error
*========================================

WRITE_SECTOR	JMP	DO_WRITE

*-------------------------------
*
*-------------------------------

			do NEW_DOS
ERROR3			SEC
				RTS
			fin
WRITE_DATA		LDX	SLOT_X0
				SEC
				STX	HOLDB
				STX	HOLDC
				LDA	$C08D,X
				LDA	LATCHIN,X
				BMI	ERROR3
				LDA	BUFFER2
				STA	HOLDA
				LDA	PTR1+1			;Was SYNC (Z-Page)
				STA	$C08F,X
				ORA	READER,X
				PHA
				PLA
				NOP
				LDY	#$04
SYNCLOP			PHA
				PLA
				JSR	WRITEB
				DEY
				BNE	SYNCLOP
			do NEW_DOS
				LDA	#$D5
				JSR	WRITEA
				LDA	#$AA
				JSR	WRITEA
				LDA	#$AD
				JSR	WRITEA
			else
				LDA	#$CD
				JSR	WRITEA
				LDA	#$FF
				JSR	WRITEA
				LDA	#$DC
				JSR	WRITEA
			fin
				TYA
				LDY	#$56
				BNE	SKIPS
SKIPA			LDA	BUFFER2,Y
SKIPS			EOR	BUFFER2-1,Y
				TAX
				LDA	DECODER,X
				LDX	HOLDB
				STA	$C08D,X
				LDA	READER,X
				DEY
				BNE	SKIPA
				LDA	HOLDA
				NOP
MORBYTE			EOR	BUFFER1,Y
				TAX
				LDA	DECODER,X
				LDX	HOLDC
				STA	$C08D,X
				LDA	READER,X
				LDA	BUFFER1,Y
				INY
				BNE	MORBYTE
				EOR	PTR1			;Was EOR_VALUE (Z-page)
				TAX
				LDA	DECODER,X
				LDX	HOLDB
				LDX	HOLDB
				STA	$C08D,X
				ORA	READER,X
				NOP
				NOP
				NOP
			do NEW_DOS
				LDA	#$DE
				JSR	WRITEA
				LDA	#$AA
				JSR	WRITEA
				LDA	#$EB
				JSR	WRITEA
			else
				LDA	#$FE
				JSR	WRITEA
			fin
				LDA	LATCHIN,X
				LDA	READER,X
				CLC
				RTS
			do NEW_DOS
			else
ERROR3			SEC
				RTS
			fin

WRITEA			CLC
WRITEB			PHA
				PLA
WRITEC			STA	$C08D,X
				ORA	READER,X
				RTS

*-------------------------------

			do NEW_DOS
DECODER			DB	$96,$97,$9A
				DB	$9B,$9D,$9E
				DB	$9F,$A6,$A7
				DB	$AB,$AC,$AD
				DB	$AE,$AF,$B2
				DB	$B3,$B4,$B5
				DB	$B6,$B7,$B9
				DB	$BA,$BB,$BC
				DB	$BD,$BE,$BF
				DB	$CB,$CD,$CE
				DB	$CF,$D3,$D6
				DB	$D7,$D9,$DA
				DB	$DB,$DC,$DD
				DB	$DE,$DF,$E5
				DB	$E6,$E7,$E9
				DB	$EA,$EB,$EC
				DB	$ED,$EE,$EF
				DB	$F2,$F3,$F4
				DB	$F5,$F6,$F7
				DB	$F9,$FA,$FB
				DB	$FC,$FD,$FE
				DB	$FF
			else
DECODER			DB	$FF,$FE,$FD
				DB	$FC,$FB,$FA
				DB	$F9,$F7,$F6
				DB	$F5,$F4,$F3
				DB	$F2,$AF,$AE
				DB	$AD,$AC,$AB
				DB	$AA,$A7,$A6
				DB	$CF,$CE,$CB
				DB	$EF,$EE,$ED
				DB	$EC,$EB,$EA
				DB	$E9,$E7,$E6
				DB	$E5,$DF,$DE
				DB	$DD,$DB,$DA
				DB	$D9,$D7,$D6
				DB	$D5,$D3,$BF
				DB	$BE,$BD,$BC
				DB	$BB,$BA,$B9
				DB	$B7,$B6,$B5
				DB	$B4,$B3,$B2
				DB	$9F,$9E,$9D
				DB	$9B,$9A,$97
				DB	$96
			fin

*-------------------------------
*
*-------------------------------

NIBBLER			LDX	#$00
				LDY	#$02
:LOOP1			DEY
				LDA	(PTR1),Y
				LSR
				ROL	BUFFER2,X
				LSR
				ROL	BUFFER2,X
				STA	BUFFER1,Y
				INX
				CPX	#$56
				BCC	:LOOP1
				LDX	#$00
				TYA
				BNE	:LOOP1
				LDX	#$55
:LOOP2			LDA	BUFFER2,X
				AND	#$3F
				STA	BUFFER2,X
				DEX
				BPL	:LOOP2
				RTS

*-------------------------------
*
*-------------------------------

DO_WRITE		PHP
				TXA
				AND	#%00001111
				STA	SECTOR
			do NEW_DOS
				;***** HARD-CODED???
				LDA	#0				;CHARACTER DATA TRACK
			else
				LDA	#0				;CHARACTER DATA TRACK
			fin
				STA	STRACK

*SEI
				NOP					;Remove when SEI put in

				LDA	SSTOREL
				STA	PTR1
				LDA	SSTOREH
				STA	PTR1+1
				JSR	NIBBLER

				LDA	#$00
				STA	PTR1			;EOR_VALUE
			do NEW_DOS
				LDA	#$FF
			else
				LDA	#$AF
			fin
				STA	PTR1+1			;SYNC
				LDA	#RETRIES
				STA	ECOUNT2
:LOOP1			JSR	READ_ADDRESS
				BCC	:SKIPA
				DEC	ECOUNT2
				BNE	:LOOP1
				PLA					;Dump carry
				LDY	#1				;Read error
				BNE	RETURN2			;Always
:SKIPA			JSR	WRITE_DATA
				BCC	:SKIPB
				PLA					;Dump carry
				LDY	#-1				;Write protected
				BNE	RETURN2			;Always
:SKIPB			PLP
				BCC	RETURN2
				CLC

*-------------------------------

SELF_DESTRUCT	LDX	#17				;Must not affect Y register or carry
:LOOP1			LDA	CODE,X
				STA	$0200,X
				DEX
				BPL	:LOOP1
				JMP	$0200

CODE			LDX	#0
:LOOP1			LDA	$6100,X
				STA	$9E00,X
				LDA	$6200,X
				STA	$9F00,X
				DEX
				BNE	:LOOP1
RETURN2			RTS

*-------------------------------
