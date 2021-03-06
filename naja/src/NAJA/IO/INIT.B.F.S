SECTOR			EQU	$00
NUMBER1			EQU	$01
NUMBER2			EQU	$02
SYNC			EQU	$03	
SECOUNT			EQU	$04
HOLDA			EQU	$26	
HOLDB			EQU	$27
HOLDD			EQU	$2A
HOLDE			EQU	$2B
MOTCNTL			EQU	$46
MOTCNTH			EQU	$47
HEDADD1			EQU	$50
HEDADD2			EQU	$51
HEDADD3			EQU	$52
HEDDAT1			EQU	$53
HEDDAT2			EQU	$54
HEDDAT3			EQU	$55
EOVALUE			EQU	$80
TRACK			EQU	$0478
HOLDC			EQU	$0678
CODETAB			EQU	$0C00
BUFFER1			EQU	$BB00
BUFFER2			EQU	$BC00
ARM				EQU	$C080
DRIVOFF			EQU	$C088
DRIVEON			EQU	$C089
DRIVE1			EQU	$C08A
READER			EQU	$C08C
PICREAD			EQU	$C08E
BEEP			EQU	$FF3A
DUMMY			EQU	$FF
				ORG	$0800	
				JSR	MAKEOR	
				JSR	SYNHEAD	
				LDY	#$00
				TYA
CLEARBF			STA	$8000,Y
				INY
				BNE	CLEARBF
				LDA	#$00
				STA	$3E
				LDA	#$80
				STA	$3F
				JSR	NIBBLER
				LDX	#$60
				LDA	DRIVE1,X
				LDA	DRIVEON,X
				LDA	PICREAD,X
NOPE			LDY	#$08
				LDA	READER,X
NOWAY			CMP	READER,X
				BNE	NOPE
				DEY
				BNE	NOWAY
				LDA	#$88	
				STA	TRACK
				LDA	#$00
				JSR	ARMOVE
				JSR	GETHEAD
				LDA	SYNC	
				STA	$C08F,X
				ORA	$C08C,X
				NOP
				PHA
				PLA
				LDY	#$FF
WRITLOP			JSR	WRITE
				DEY
				BNE	WRITLOP
TRCLOOP			JSR	GETHEAD
				LDA	#$00
				STA	EOVALUE
				STA	SECOUNT
WRITMOR			LDY	SECOUNT
				LDA	SKEWYOU,Y
				STA	SECTOR
				JSR	WADRESS
				JSR	WDATA
				LDA	SECOUNT
				INC	SECOUNT
				CMP	#$0F
				BNE	WRITMOR
				LDA	TRACK
				CLC
				ADC	#$02
				CMP	#$46
				BEQ	LASTRCK
				JSR	ARMOVE
				JMP	TRCLOOP
LASTRCK			LDA	#$00	
CHCKLOP			JSR	ARMOVE
				JSR	GETHEAD
				LDA	#$00
				STA	SECOUNT
				STA	EOVALUE
CHECKMR			LDY	SECOUNT
				LDA	SKEWYOU,Y
				STA	SECTOR
				JSR	RADRESS
				JSR	RDATA
				BCS	ERRFND
				LDA	SECOUNT
				INC	SECOUNT
				CMP	#$0F
				BNE	CHECKMR
				LDA	TRACK
				CLC
				ADC	#$02
				CMP	#$46
				BNE	CHCKLOP
				STA	DRIVOFF+$60	
				RTS
ERRFND			JSR	BEEP
				RTS
WRITE			NOP
				NOP
				NOP
				STA	$C08F,X
				ORA	$C08C,X
				RTS
WDATA			LDX	#$60
				SEC
				STX	HOLDB
				STX	HOLDC
				LDA	$C08D,X
				LDA	$C08E,X
				BMI	ERROR3
				LDA	BUFFER2
				STA	HOLDA
				LDA	SYNC
				STA	$C08F,X
				ORA	$C08C,X
				PHA
				PLA
				NOP
				LDY	#$04	
SYNCLOP			LDA	SYNC	
				NOP	
				NOP
				JSR	WRITEB
				DEY
				BNE	SYNCLOP
MODD1			LDA	#DUMMY	
				JSR	WRITEA
MODD2			LDA	#DUMMY	
				JSR	WRITEA
MODD3			LDA	#DUMMY	
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
				LDA	$C08C,X	
				DEY
				BNE	SKIPA
				LDA	HOLDA
				NOP
MORBYTE			EOR	BUFFER1,Y
				TAX
				LDA	DECODER,X
				LDX	HOLDC
				STA	$C08D,X
				LDA	$C08C,X
				LDA	BUFFER1,Y
				INY
				BNE	MORBYTE
				EOR	EOVALUE
				TAX
				LDA	DECODER,X
				LDX	HOLDB
				LDX	HOLDB
				STA	$C08D,X
				ORA	$C08C,X
				NOP
				NOP
				NOP
				LDA	#$FE	
				JSR	WRITEA
				LDA	$C08E,X
				LDA	$C08C,X
				CLC
				RTS
ERROR3			SEC
				RTS
WRITEA			CLC
WRITEB			PHA
				PLA
WRITEC			STA	$C08D,X
				ORA	$C08C,X
				RTS
**********END OF DATA WRITE*************
WADRESS			LDX	#$60
				LDA	SECTOR	
				LSR	A
				ORA	#$AA
				STA	NUMBER1
				LDA	SECTOR	
				ORA	#$AA
				STA	NUMBER2
				LDA	$C08D,X
				LDA	$C08E,X
				BMI	ERROR
				LDA	SYNC
				STA	$C08F,X
				ORA	$C08C,X
				PHA
				PLA
				NOP
				LDY	#$18	
LOOPNT			LDA	SYNC	
				NOP	
				NOP
				JSR	WRITEB
				DEY
				BNE	LOOPNT
MODA1			LDA	#DUMMY	
				JSR	WRITEA
MODA2			LDA	#DUMMY	
				JSR	WRITEA
MODA3			LDA	#DUMMY	
				JSR	WRITEA
				PHA
				PLA
				PHA
				PLA
				LDA	NUMBER1
				STA	$C08D,X
				ORA	$C08C,X
				PHA
				PLA
				PHA
				PLA
				LDA	NUMBER2
				JSR	WRITEC
				CLC
				RTS
ERROR			SEC
				RTS
**************END OF ADDRESS WRITER***********
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
				CMP	HEDADD2
				BNE	CHECKA
				NOP	
LOOPC			LDA	READER,X
				BPL	LOOPC
				CMP	HEDADD3
				BNE	CHECKA
				LDA	#00
				STA	HOLDB
LOOPD			LDA	READER,X
				BPL	LOOPD
				ROL	A
				STA	HOLDA
LOOPE			LDA	READER,X
				BPL	LOOPE
				AND	HOLDA
				CMP	SECTOR	
				BNE	RADRESS
				CLC
				RTS
GETHEAD			LDA	TRACK
				LSR	A
				TAY
				LDA	ADD1,Y
				STA	HEDADD1
				STA	MODA1+1
				LDA	#$FF	
				STA	HEDADD2
				STA	MODA2+1
				LDA	ADD3,Y
				STA	HEDADD3
				STA	MODA3+1
				LDA	DAT1,Y
				STA	HEDDAT1
				STA	MODD1+1
				LDA	#$FF	
				STA	HEDDAT2
				STA	MODD2+1
				LDA	DAT3,Y
				STA	HEDDAT3
				STA	MODD3+1
				LDA	SYNCERS,Y	
				STA	SYNC	
				RTS
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF
ADD1			DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC
ADD3			DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD
DAT1			DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD,$CD
				DFB	$CD,$CD
DAT3			DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC,$DC
				DFB	$DC,$DC
SYNCERS			DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF
* END OF SYNCS
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF
				DFB	$FF,$FF,$FF	
				DFB	$FF
				DFB	$FF,$FF,$FF	
ARMOVE			LDX	#$60
				STX	HOLDE
				STA	HOLDD
				CMP	TRACK
				BEQ	MOVDONE
				LDA	#$EF
				STA	MOTCNTL
				LDA	#$D8
				STA	MOTCNTH
				LDA	#$00
				STA	HOLDA
NOTDONE			LDA	TRACK
				STA	HOLDB
				SEC
				SBC	HOLDD
				BEQ	EQUAL
				BCS	POSITIV
				EOR	#$FF
				INC	TRACK
				BCC	NOADD
POSITIV			ADC	#$FE
				DEC	TRACK
NOADD			CMP	HOLDA
				BCC	NOLOAD
				LDA	HOLDA
NOLOAD			CMP	#$0C
				BCS	NOTRANS
				TAY
NOTRANS			SEC
				JSR	HALFSUB
				LDA	DELAYS,Y
				JSR	DELAYER
				LDA	HOLDB
				CLC
				JSR	HALF2
				LDA	DELAYS2,Y
				JSR	DELAYER
				INC	HOLDA
				BNE	NOTDONE
EQUAL			JSR	DELAYER
				CLC
HALFSUB			LDA	TRACK
HALF2			AND	#$03
				ROL	A
				ORA	HOLDE
				TAX
				LDA	ARM,X
				LDX	HOLDE
MOVDONE			RTS
DELAYER			LDX	#$11
DELOOP			DEX
				BNE	DELOOP
				INC	MOTCNTL
				BNE	NOCARRY
				INC	MOTCNTH
NOCARRY			SEC
				SBC	#$01
				BNE	DELAYER
				RTS
RDATA			LDY	#$20
ERRCNT			DEY
				BEQ	ERROR2
LOOP1			LDA	READER,X
				BPL	LOOP1
CHECK1			EOR	HEDDAT1	
				BNE	ERRCNT
				NOP
LOOP2			LDA	READER,X
				BPL	LOOP2
				CMP	HEDDAT2
				BNE	CHECK1
				LDY	#$56
LOOP3			LDA	READER,X
				BPL	LOOP3
				CMP	HEDDAT3
				BNE	CHECK1
				LDA	#$00
CHECK2			DEY
				STY	HOLDA
LOOP4			LDY	READER,X
				BPL	LOOP4
				EOR	CODETAB,Y
				LDY	HOLDA
				STA	BUFFER2,Y
				BNE	CHECK2
CHECK3			STY	HOLDA
LOOP5			LDY	READER,X
				BPL	LOOP5
				EOR	CODETAB,Y
				LDY	HOLDA
				STA	BUFFER1,Y
				INY
				BNE	CHECK3
LOOP6			LDY	READER,X
				BPL	LOOP6
				EOR	EOVALUE
				CMP	CODETAB,Y
				BNE	ERROR2
				CLC
				JMP	EXIT	
ERROR2			SEC
EXIT			RTS
				DFB	$EA,$EA,$EA
DELAYS			DFB	$01,$30,$28
				DFB	$24,$20,$1E
				DFB	$1D,$1C,$1C
				DFB	$1C,$1C,$1C
DECODER			DFB	$FF,$FE,$FD	
				DFB	$FC,$FB,$FA	
				DFB	$F9,$F7,$F6	
				DFB	$F5,$F4,$F3	
				DFB	$F2,$AF,$AE	
				DFB	$AD,$AC,$AB	
				DFB	$AA,$A7,$A6	
				DFB	$CF,$CE,$CB	
				DFB	$EF,$EE,$ED	
				DFB	$EC,$EB,$EA	
				DFB	$E9,$E7,$E6
				DFB	$E5,$DF,$DE	
				DFB	$DD,$DB,$DA	
				DFB	$D9,$D7,$D6	
				DFB	$D5,$D3,$BF	
				DFB	$BE,$BD,$BC
				DFB	$BB,$BA,$B9	
				DFB	$B7,$B6,$B5	
				DFB	$B4,$B3,$B2	
				DFB	$9F,$9E,$9D	
				DFB	$9B,$9A,$97	
				DFB	$96	
				DFB	$3F,$3E,$98
				DFB	$99,$3D,$3C	
				DFB	$9C,$3B,$3A	
				DFB	$39,$A0,$A1
				DFB	$A2,$A3,$A4
				DFB	$A5,$14,$13	
				DFB	$A8,$A9,$12	
				DFB	$11,$10,$0F	
				DFB	$0E,$0D,$B0
				DFB	$B1,$38,$37	
				DFB	$36,$35,$34	
				DFB	$33,$B8,$32	
				DFB	$31,$30,$2F	
				DFB	$2E,$2D,$2C	
				DFB	$C0,$C1,$C2
				DFB	$C3,$C4,$C5
				DFB	$C6,$C7,$C8
				DFB	$C9,$CA,$17	
				DFB	$CC,$CD,$16	
				DFB	$15,$D0,$D1
				DFB	$D2,$2B,$D4
				DFB	$2A,$29,$28	
				DFB	$D8,$27,$26	
				DFB	$25,$DC,$24	
				DFB	$23,$22,$E0
				DFB	$E1,$E2,$E3
				DFB	$E4,$21,$20	
				DFB	$1F,$E8,$1E	
				DFB	$1D,$1C,$1B	
				DFB	$1A,$19,$18	
				DFB	$F0,$F1,$0C	
				DFB	$0B,$0A,$09	
				DFB	$08,$07,$F8
				DFB	$06,$05,$04	
				DFB	$03,$02,$01	
				DFB	$00	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF,$FF,$FF	
				DFB	$FF	
EORTABL			DFB	$28,$36,$1D
				DFB	$1E,$0E,$3A
				DFB	$2F,$1C,$07
				DFB	$28,$00,$00
				DFB	$00,$00,$00
				DFB	$00
DELAYS2			DFB	$70,$2C,$26
				DFB	$22,$1F,$1E
				DFB	$1D,$1C,$1C
				DFB	$1C,$1C,$1C
NIBBLER			LDX	#$00
				LDY	#$02
NIBLOOP			DEY
				LDA	($3E),Y
				LSR	A
				ROL	BUFFER2,X
				LSR	A
				ROL	BUFFER2,X
				STA	BUFFER1,Y
				INX
				CPX	#$56
				BCC	NIBLOOP
				LDX	#$00
				TYA
				BNE	NIBLOOP
				LDX	#$55
ANDER			LDA	BUFFER2,X
				AND	#$3F
				STA	BUFFER2,X
				DEX
				BPL	ANDER
				RTS
SKEWYOU			DFB	$00,$08,$01
				DFB	$09,$02,$0A
				DFB	$03,$0B,$04
				DFB	$0C,$05,$0D
				DFB	$06,$0E,$07
				DFB	$0F
MAKEOR			RTS					;*****
SYNHEAD			RTS					;*****
