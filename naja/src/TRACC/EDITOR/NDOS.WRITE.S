EOR_VALUE		=	$02
DESTL			=	$03
DESTH			=	$04
SYNC			=	$05
SECTOR			=	$06
SECOUNT			=	$07

HOLDA			=	$26
HOLDB			=	$27

HEDADD1			=	$50
HEDADD2			=	$51
HEDADD3			=	$52
HEDDAT1			=	$53
HEDDAT2			=	$54
HEDDAT3			=	$55

BUFFER1			=	$BB00
BUFFER2			=	$BC00

READER			=	$C08C
LATCHIN			=	$C08E

*-------------------------------
*
*-------------------------------

WDATA			LDX	#$60
				SEC
				STX	HOLDB
				STX	HOLDC
				LDA	$C08D,X
				LDA	LATCHIN,X
				BMI	ERROR3
				LDA	BUFFER2
				STA	HOLDA
				LDA	SYNC
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
				LDA	#$CD
				JSR	WRITEA
				LDA	#$FF
				JSR	WRITEA
				LDA	#$DC
				JSR	WRITEA
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
				EOR	EOR_VALUE
				TAX
				LDA	DECODER,X
				LDX	HOLDB
				LDX	HOLDB
				STA	$C08D,X
				ORA	READER,X
				NOP
				NOP
				NOP
				LDA	#$FE
				JSR	WRITEA
				LDA	LATCHIN,X
				LDA	READER,X
				CLC
				RTS
ERROR3			SEC
				RTS

WRITEA			CLC
WRITEB			PHA
				PLA
WRITEC			STA	$C08D,X
				ORA	READER,X
				RTS

*-------------------------------
*
*-------------------------------

RADRESS			LDX	#$60
				LDA	READER,X
				BPL	RADRESS
				CMP	SYNC
				BNE	RADRESS
LOOPX1			LDA	READER,X
				BPL	LOOPX1
				CMP	SYNC
				BNE	RADRESS
LOOPX2			LDA	READER,X
				BPL	LOOPX2
				CMP	SYNC
				BEQ	LOOPX2
				BNE	CHECKA
LOOPA			LDA	READER,X
				BPL	LOOPA
CHECKA			CMP	HEDADD1
				BNE	RADRESS
				NOP
LOOPB			LDA	READER,X
				BPL	LOOPB
				STA	TEMP
				NOP
LOOPC			LDA	READER,X
				BPL	LOOPC
				CMP	HEDADD3
				BNE	CHECKA
				LDA	#00
				STA	HOLDB
:LOOP1			LDA	READER,X
				BPL	:LOOP1
				STA	HOLDA
				SEC
:LOOP2			LDA	READER,X
				BPL	:LOOP2
				ROL
				AND	HOLDA
				STA	TEMP+1
LOOPD			LDA	READER,X
				BPL	LOOPD
				ROL	A
				STA	HOLDA
LOOPE			LDA	READER,X
				BPL	LOOPE
				AND	HOLDA
				CMP	SECTOR
				BNE	RADRESS
				LDA	TEMP+1
				CMP	TRACK
				BNE	BREAK
				DEC	TEMP
				LDA	TEMP
				AND	#%00000111
				CMP	DISK_SIDE
				BNE	BREAK
				CLC
				RTS
BREAK			BRK

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

*-------------------------------
*
*-------------------------------

NIBBLER			LDX	#$00
				LDY	#$02
:LOOP1			DEY
				LDA	(DESTL),Y
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

*===============================
*
*===============================

DO_WRITE		STA	SECOUNT
				TXA
				AND	#%00001111
				STA	SECTOR
				STX	TRACK
				TYA
				LDX	#4
:LOOP1			LSR
				ROR	TRACK
				DEX
				BNE	:LOOP1

				LDA	#0
				STA	EOR_VALUE

				JSR	DRIVE_ON
				JSR	POSITION

				LDA	#$DC
				STA	HEDADD1
				STA	HEDDAT3
				LDA	#$CD
				STA	HEDADD3
				STA	HEDDAT1
				LDA	#$FF
				STA	HEDDAT2

				LDA	DISK_SIDE
				CLC
				ADC	#1
				ORA	#%11111000
				STA	HEDADD2
				LDA	#$AF
				STA	SYNC

				LDA	SSTOREL
				STA	DESTL
				LDA	SSTOREH
				STA	DESTH
:LOOP2			JSR	NIBBLER
				SEI
				JSR	RADRESS
				JSR	WDATA
				CLI
				INC	DESTH
				DEC	SECOUNT
				BEQ	:EXIT
				INC	SECTOR
				LDA	SECTOR
				CMP	#$10
				BNE	:LOOP2
				INC	TRACK
				LDA	#0
				STA	SECTOR
				JSR	POSITION
				JMP	:LOOP2

:EXIT			JSR	DRIVE_OFF
				RTS

*-------------------------------

POSITION		LDA	SSTOREH
				PHA
				LDA	#$87
				STA	SSTOREH

				LDA	TRACK
				ASL
				ASL
				ASL
				ASL
				ORA	SECTOR
				TAX
				LDA	TRACK
				LSR
				LSR
				LSR
				LSR
				TAY
				LDA	#1
				JSR	FLOADER

				PLA
				STA	SSTOREH
				RTS

*-------------------------------

HOLDC			DB	0
TRACK			DB	0
