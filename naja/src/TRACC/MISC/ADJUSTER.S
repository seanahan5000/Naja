				LST	OFF
SCRATCH			EQU	$01	
MAXTEXT			EQU	$05	
POINTL			EQU	$12
POINTH			EQU	$13
MONSPRD			EQU	$4B	
CHRSPRD			EQU	$4C	
SSTOREH			EQU	$B2	
STRACK			EQU	$BA	
SSECTOR			EQU	$BB	
READNUM			EQU	$BC	
ROUND			EQU	$DF	
COLOR			EQU	$E4
AREHERE			EQU	$E5
PAGE			EQU	$E6	
XPOS			EQU	$F1	
YPOS			EQU	$F2	
FACE			EQU	$FA	
TEXTBUF			EQU	$0200	
SREADIT			EQU	$0669	
FREAD			EQU	$071E
TEXTOUT			EQU	$09E0
INPUT			EQU	$0A15
INPUT2			EQU	$0A1C	
CONVERT			EQU	$0B5B	
ADVANCE			EQU	$0BB4
CLEAR1			EQU	$11AA
CLEAR2			EQU	$1212	
RDKEY			EQU	$6000	
GETNSEW			EQU	$614A	
NOSCAN			EQU	$6653	
WIDTH1			EQU	$6F46
CLEARSUB		EQU	$BAD4
KEYBRD			EQU	$C000
UNSTROB			EQU	$C010
PRIMARY			EQU	$C054	
SCNDARY			EQU	$C055	
DRIVEOFF		EQU	$C0E8
DRIVEON			EQU	$C0E9
WHITE1			EQU	$7F
				ORG	$9000
				BIT	UNSTROB
				JSR	CLEAR2
				STA	SCNDARY
				LDA	#$40
				STA	PAGE
				LDY	#$00
				JSR	TEXTER
KEYLOOP			LDA	KEYBRD
				BPL	KEYLOOP
				BIT	UNSTROB
				CMP	#"F"
				BEQ	GOFACER
				CMP	#"A"
				BEQ	GOALIENR
				CMP	#"S"
				BEQ	SHELLER
				CMP	#"E"
				BNE	KEYLOOP
OUT				JSR	CLEAR1
				LDA	#$20
				STA	PAGE
				LDA	#WHITE1
				STA	COLOR
				JSR	GETNSEW
				JSR	NOSCAN
				STA	PRIMARY
				JMP	RDKEY
GOFACER			JMP	FACER
GOALIENR		JMP	ALIENER
SHELLER			JSR	CLEARSUB
				LDA	#$00			;TEMP
				STA	AREHERE			;TEMP
REINPUT1		JSR	CLEAR2
				LDY	#$01
				JSR	TEXTER
				LDA	#$01
				STA	MAXTEXT
				JSR	INPUT2
				LDA	TEXTBUF
				CMP	#$8D
				BEQ	OUT
				AND	#$0F
				BEQ	REINPUT1
				CMP	#$06
				BCS	REINPUT1
				PHA
				TAY
				LDA	WIDTHS-1,Y
				STA	WIDTH1
				LDY	#$03
				JSR	TEXTER
KEYLOOPA		LDA	KEYBRD
				BPL	KEYLOOPA
				BIT	UNSTROB
				LDA	#$20
				STA	SSTOREH
				LDA	#$22
				STA	STRACK
				LDA	#$0F
				STA	SSECTOR
				LDA	#$01
				STA	READNUM
				JSR	SREADIT
				STA	DRIVEOFF
				LDA	$2002
				AND	#$07
				SEC
				SBC	#$02
				STA	SCRATCH
				PLA
				CMP	SCRATCH
				BNE	REINPUT1
				STA	DRIVEON
				LDA	#$A0
				STA	SSTOREH
				LDA	#$21
				STA	STRACK
				LDA	#$00
				STA	SSECTOR
				LDA	#$13
				STA	READNUM
				JSR	FREAD
				STA	DRIVEOFF
				LDA	#$01
				STA	XPOS
				STA	YPOS
				STA	FACE
				JMP	OUT
FACER			LDA	#$02
				STA	MAXTEXT
				JSR	CLEAR2
				LDY	#$02
				JSR	TEXTER
				LDY	#$5A
				JSR	NUMSUB
				STA	XPOS
				LDY	#$62
				JSR	NUMSUB
				STA	YPOS
				LDY	#$6A
				JSR	NUMSUB
				STA	FACE
				JMP	OUT
ALIENER			LDA	#$02
				STA	MAXTEXT
				JSR	CLEAR2
				LDY	#$5A
				JSR	NUMSUB
				PHA
				LDA	#$77	
				STA	SSTOREH
				LDA	#$00
				STA	STRACK
				STA	SSECTOR
				LDA	#$19
				STA	READNUM
				JSR	SREADIT	
				LDA	#$00
				STA	ROUND
				STA	MONSPRD
				STA	CHRSPRD
				PLA
				JMP	$775B	
GOUT			JMP	OUT
NUMSUB			LDA	#$82
				JSR	INPUT
				LDA	TEXTBUF
				CMP	#$8D
				BEQ	GOUT
				JSR	CONVERT
				TXA
				ASL	A
				ASL	A	
				ASL	A
				ASL	A
				STA	SCRATCH
				LDA	TEXTBUF+1
				JSR	CONVERT
				CPX	#$0A
				BCC	NORMAL
				DEX
NORMAL			TXA	
				ORA	SCRATCH
				RTS
WIDTHS			DFB	$11,$0F,$0D
				DFB	$0B,$09
TEXTER			TYA
				ASL	A
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				LDA	TEXTS+1,Y
				STA	POINTH
				JMP	TEXTOUT
TEXTS			DA	TEXT0
				DA	TEXT1
				DA	TEXT2
TEXT0			DFB	$0E,$02,$5A
				DFB	$10,$32,$0B
				DFB	$0D,$0F,$8D
				DFB	$0E,$02,$62
				DFB	$1D,$32,$12
				DFB	$0F,$16,$16
				DFB	$8D,$0E,$02
				DFB	$6A,$0B,$32
				DFB	$16,$13,$0F
				DFB	$18,$8D,$0E
				DFB	$02,$72,$0F
				DFB	$32,$22,$13
				DFB	$1E,$8D,$FF
TEXT1			DFB	$0E,$02,$5A
				DFB	$1D,$12,$0F
				DFB	$16,$16,$0A
				DFB	$30,$01,$2C
				DFB	$05,$32,$33
				DFB	$0A,$8D,$FF
TEXT2			DFB	$0E,$02,$5A
				DFB	$22,$1A,$18
				DFB	$1E,$2F,$8D
				DFB	$0E,$02,$62
				DFB	$23,$1A,$18
				DFB	$1E,$2F,$8D
				DFB	$0E,$02
				DFB	$6A,$10,$0B
				DFB	$0D,$0F,$2F
				DFB	$8D,$FF
TEXT3			DFB	$0D,$02,$5A
				DFB	$13,$18,$1D
				DFB	$0F,$1C,$1E
				DFB	$0A,$0E,$13
				DFB	$1D,$15,$0A
				DFB	$2C,$0A,$1A
				DFB	$1C,$0F,$1D
				DFB	$1D,$0A,$0B
				DFB	$0A,$15,$0F
				DFB	$23,$8D,$FF
