				LST	OFF
TBLPNTL			EQU	$0D	
TBLPNTH			EQU	$0E	
DIRHOLD			EQU	$60	
ALIEN1			EQU	$61
HMANY1			EQU	$64
ALTYPE1			EQU	$67
ALIENID			EQU	$6A				;***???
SSTOREH			EQU	$B2	
STRACK			EQU	$BA	
SSECTOR			EQU	$BB	
READNUM			EQU	$BC	
COUNT			EQU	$C0	
PAGE			EQU	$E6
SRANGE			EQU	$F0
DIRECTN			EQU	$F3	
MXRANGE			EQU	$F4
MOVETO2			EQU	$0331	
RNDMIZE			EQU	$0368	
RANDOM1			EQU	$0383	
FREAD			EQU	$071E	
EXPANDR			EQU	$0C60	
CHANNEL			EQU	$78E5	
POSITN			EQU	$A040
SCNDARY			EQU	$C055	
				ORG	$9000
				LDA	DIRECTN
				STA	DIRHOLD
				LDA	MXRANGE	
				STA	SRANGE
				LDA	#$40
				STA	PAGE
				JSR	MOVETO2
				LDA	#$03
				STA	COUNT
PICLOOP			LDY	COUNT
				JSR	PICKER
				DEC	COUNT	
				BPL	PICLOOP
				STA	SCNDARY
				LDX	#$C0	
MOVLOOP			LDA	MONDATA-1,X
				STA	$9FFF,X
				LDA	MONDTOP-1,X
				STA	$A07F,X
				DEX
				BNE	MOVLOOP
				LDX	#$08
				LDA	#$FF
SETLOOP			STA	ALIEN1,X
				DEX
				BPL	SETLOOP
				LDA	#$35	
				STA	ALIEN1
				LDA	#$01
				STA	HMANY1
				LDA	#$81	
				STA	ALTYPE1
				LDA	#$00
				STA	ALIENID
				JSR	RNDMIZE
				BIT	RANDOM1
				BPL	GOLOAD	
				LDA	POSITN	
				CLC
				ADC	#$10
				STA	POSITN
GOLOAD			LDA	#$77
				STA	SSTOREH
				LDA	#$00
				STA	STRACK
				STA	SSECTOR
				LDA	#$18
				STA	READNUM
				JSR	FREAD	
				JMP	CHANNEL
PICKER			TYA
				ASL	A
				TAY
				LDA	PICS,Y
				STA	TBLPNTL
				LDA	PICS+1,Y
				STA	TBLPNTH
				JMP	EXPANDR
PICS			DW	GPIC0
				DW	GPIC1
				DW	GPIC2
				DW	GPIC3
MONDATA			DFB	$19,$1C,$0C	
				DFB	$0A,$11,$1F	
				DFB	$0B,$1C,$0E	
				DFB	$0A,$1C,$19	
				DFB	$0C,$19,$1E	
				DFB	$0A,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$02,$50,$05	
				DFB	$EE,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$EE,$EE,$EE
				DFB	$EE,$85,$00	
				DFB	$DD,$DD,$DD	
				DFB	$DD,$DD,$DD	
				DFB	$DD,$DD,$DD	
				DFB	$DD,$DD,$DD	
				DFB	$DD,$DD,$DD	
				DFB	$DD,$DD,$DD	
				DFB	$DD	
				DFB	$18,$FF	
MONDTOP			DFB	$80	
				DFB	$80	
				DFB	$7C,$7E,$4F	
				DFB	$37,$77,$6E	
				DFB	$5C	
				DFB	$00,$01,$03	
				DFB	$03,$02,$01	
				DFB	$03	
				DFB	$80	
				DFB	$78,$7C,$4E	
				DFB	$36,$3A,$5C	
				DFB	$6E	
				DFB	$01,$03,$07	
				DFB	$07,$07,$03	
				DFB	$01	
				DFB	$80	
				DFB	$80	
				DFB	$80	
				DFB	$40,$80	
				DFB	$0D,$0E,$1C	
				DFB	$60,$7C,$00
				DFB	$7F	
				DFB	$40,$40,$60
				DFB	$1D,$7F,$00	
				DFB	$7F	
				DFB	$0D,$03,$01	
				DFB	$00,$01,$00
				DFB	$07	
				DFB	$80	
				DFB	$80	
				DFB	$00,$78,$74	
				DFB	$2C,$3C,$58	
				DFB	$60	
				DFB	$40,$7F,$7F	
				DFB	$00,$00,$00
				DFB	$01	
				DFB	$7F,$7F,$7F	
				DFB	$80	
				DFB	$7E,$7E,$7E	
				DFB	$60,$1C,$30
				DFB	$0E	
				DFB	$7F,$7F,$7F	
				DFB	$18,$67,$37	
				DFB	$40	
				DFB	$7B,$7B,$7B	
				DFB	$00,$01,$00
				DFB	$03	
				DFB	$0F,$7F,$7F	
				DFB	$80	
				DFB	$00,$3F,$5F	
				DFB	$68,$78,$30
				DFB	$48	
				DFB	$40,$80	
				DFB	$03,$07,$0E	
				DFB	$1C,$38,$50
				DFB	$00	
				DFB	$00,$60,$6E	
				DFB	$67,$00,$7F	
				DFB	$40
				DFB	$67,$66,$61	
				DFB	$00,$60,$C3	
				DFB	$1C,$1E,$1F	
				DFB	$00,$1A,$0F	
				DFB	$08	
				DFB	$07,$1B,$5C	
				DFB	$38,$74,$6C	
				DFB	$1C	
				DFB	$00,$00,$03	
				DFB	$07,$0E,$0E	
				DFB	$0F	
				DFB	$78,$78,$48	
				DFB	$48,$78,$48	
				DFB	$30	
				DFB	$80	
				DFB	$80	
				DFB	$5F,$6E,$60
				DFB	$80	
				DFB	$07,$0E,$1A	
				DFB	$1B,$80	
				DFB	$05,$07,$80
				DFB	$78,$70,$80
				DFB	$07,$03,$80
				DFB	$30,$30,$00
				DFB	$78,$80	

				PUT	GUARD.DATA
				SAV	GUARD
