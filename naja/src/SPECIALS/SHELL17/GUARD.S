
				LDX	#<GU_DATA
				LDY	#>GU_DATA
				JSR	SET_TLP_DATA

				LDA	DIRECTN
				STA	DIRHOLD
				LDA	MXRANGE			;***???
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

				JSR	MOVETO1			;***
				STA	PRIMARY			;***
				BIT	UNSTROB			;***

			;	LDX	#$C0
MOVLOOP		;	LDA	MONDATA-1,X
			;	STA	$9FFF,X
			;	LDA	MONDTOP-1,X
			;	STA	$A07F,X
			;	DEX
			;	BNE	MOVLOOP
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
			do 0
				BIT	RANDOM1
				BPL	GOLOAD
				LDA	POSITN
				CLC
				ADC	#$10
				STA	POSITN
GOLOAD
				LDA	#$77
				STA	SSTOREH
				LDA	#$00
				STA	STRACK
				STA	SSECTOR
				LDA	#$18
				STA	READNUM
				JSR	FREAD
				JMP	CHANNEL
			else
				LDA	#$FF
				RTS
			fin

GU_DATA			DW	0
				DW	0
				DW	GU_PICS

GU_PICS			DW	GPIC0
				DW	GPIC1
				DW	GPIC2
				DW	GPIC3

GUARD_DATA		USR	(ORB_GUARD_ROBOT_)-
				DS	48,0

				DB	$18,$FF

GUARD_TVIEW		DB	$85,$00

				DB	$80
				DB	$80
				DB	$7C,$7E,$4F,$37,$77,$6E,$5C
				DB	$00,$01,$03,$03,$02,$01,$03
				DB	$80
				DB	$78,$7C,$4E,$36,$3A,$5C,$6E
				DB	$01,$03,$07,$07,$07,$03,$01
				DB	$80

				DB	$80
				DB	$80
				DB	$40,$80
				DB	$0D,$0E,$1C,$60,$7C,$00,$7F
				DB	$40,$40,$60,$1D,$7F,$00,$7F
				DB	$0D,$03,$01,$00,$01,$00,$07
				DB	$80
				DB	$80

				DB	$00,$78,$74,$2C,$3C,$58,$60
				DB	$40,$7F,$7F,$00,$00,$00,$01
				DB	$7F,$7F,$7F,$80
				DB	$7E,$7E,$7E,$60,$1C,$30,$0E
				DB	$7F,$7F,$7F,$18,$67,$37,$40
				DB	$7B,$7B,$7B,$00,$01,$00,$03
				DB	$0F,$7F,$7F,$80
				DB	$00,$3F,$5F,$68,$78,$30,$48

				DB	$40,$80
				DB	$03,$07,$0E,$1C,$38,$50,$00
				DB	$00,$60,$6E,$67,$00,$7F,$40
				DB	$67,$66,$61,$00,$60,$C3
				DB	$1C,$1E,$1F,$00,$1A,$0F,$08
				DB	$07,$1B,$5C,$38,$74,$6C,$1C
				DB	$00,$00,$03,$07,$0E,$0E,$0F
				DB	$78,$78,$48,$48,$78,$48,$30

				DB	$80
				DB	$80
				DB	$5F,$6E,$60,$80
				DB	$07,$0E,$1A,$1B,$80
				DB	$05,$07,$80
				DB	$78,$70,$80
				DB	$07,$03,$80
				DB	$30,$30,$00,$78,$80

				DB	$FF
