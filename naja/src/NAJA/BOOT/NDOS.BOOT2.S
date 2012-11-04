
FINISH_BOOT		BIT	UNSTROB
				
				LDX	#<BOOT_TABLE
				LDY	#>BOOT_TABLE
				JSR	SET_FILE_TABL
				
				LDA	#side_MS
				STA	DISK_SIDE
				LDA	#0
				STA	SHELL
				
				LDX	#$06			; MTunnels
				JSR	SLOADER_FILE
				LDX	#$07			; MControl
				JSR	FLOADER_FILE

; set up character data, equipment, specials, possibly fake/restore

INIT_GAME		LDA	#$C7		;;;???
				STA	$03F2
				LDA	#$03
				STA	$03F3
				LDA	#$A6
				STA	$03F4		;;;???
				
;				LDA	#$06		;;;???
				LDA	#$00		;;;???
				STA	GRPNUMB
				STA	GRPCONT
				
				LDA	#$9F
				STA	SSTOREH
				LDX	#<charTrack+$0A
				LDY	#>charTrack+$0A
				LDA	#1
				JSR	FLOAD			; (shuts drive off when done)
				LDX	#10
:1				LDA	$9F80,X
				STA	OPENBUF,X
				DEX
				BPL	:1
				
				LDX	#31
:2				LDA	$9FCF,X
				STA	SPECIALS_DATA,X
				DEX
				BPL	:2
				
				LDX	MOMFILES_ADR
				LDY	MOMFILES_ADR+1
				JSR	SET_FILE_TABL
				
				LDA	#$FF
				STA	DIRECTN
				LDA	#$01
				STA	XPOS
				LDA	#$05
				STA	YPOS
				LDA	#$01
				STA	FACE
				LDA	#$04
				STA	BYTEWID
				LDA	#$06
				STA	SRANGE
				LDA	#WHITE1
				STA	COLOR
*LDA #$30
*STA PITCH
*LDA #$60
*STA LENGTH
*JSR SOUND
				LDA	#$20
				STA	PAGE
				JSR	GETNSEW
				JSR	SCANONE
*LDA #$A0
*STA PITCH
*LDA #$40
*STA LENGTH
*JSR SOUND
				LDA	#$25
				STA	DELAY_TIME
				LDA	#$01
				STA	DELAY_MODE
				JMP	RDKEY


BOOT_TABLE		DB	$10				;0 NCommons $1000-$1FFF
				DW	$0010
				DB	$10
				
				DB	$B0				;1 Camp.B000
				DW	$0020
				DB	$0B
				
				DB	$E0				;2 Camp.Main
				DW	$0030
				DB	$20
				
				DB	$D0				;3 Camp.D000.M2
				DW	$0050
				DB	$10
				
				DB	$D0				;4 Camp.D000.M1
				DW	$0060
				DB	$10
				
				DB	$60				;5 Title.Page
				DW	$0070
				DB	$40
				
				DB	$60				;6 MTunnels
				DW	$00C0
				DB	$20
				
				DB	$A0				;7 MControl
				DW	$00E0
				DB	$10

; T0
;	0: BOOT
;	1: BOOT
;	2: $200
;	3: $300
;	4: NDOS-$400
;	5: NDOS-$500
;	6: NDOS-$600
;	7: NDOS-$700
;	8: NCOMMONS-$800 (HTABLE)
;	9: NCOMMONS-$900 (HTABLE)
;	A: ...
;	B:
;	C:
;	D:
;	E: ...
;	F: NCOMMONS-$F00

; T1
;	NCOMMONS-$1000,$1FFF

; T2
;	Camp.B000-$B000,$BAFF

; T3-4
;	Camp.Main-$E000,$FFFF

; T5
;	Camp.D000.M1-$D000,$DFFF

; T6
;	Camp.D000.M2-$D000,$DFFF

; T7-A
;	TITLE.PAGE???? HOW LONG IS THIS???

; TB
;	<UNUSED>

; TC-D
;	MTUNNELS-$6000,$7FFF

; TE
;	MCONTROL-$A000,$AFFF

; TF
;	MTESSINFO-$8000,$8BFF

; T10
;	CHARACTER DATA

; T11-12
;	GROUP.ASSEMBLY

; T13-16
;	ENROLL.TEST

; T17-18.7
;	INFIRMARY

; T18.8-1A
;	ENERGY.CENTER

; T1B-1E
;	ARSENAL

; T1F-22
;	ROBOT.REPAIR
