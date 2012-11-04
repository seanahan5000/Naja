*** BLOAD SCREEN.III at $0300
*** BLOAD NCOMMONS at $0980
*** BLOAD NDOS.525 at $2400
*** BLOAD HTABLER.HT1,$2E00

				LST	OFF
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/NDOS.VARS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/MHALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS

				ORG	$2000

				STA	$C05F			;Clear double hires
				STA	$C05A			;Disable VBL interupt
				STA	$C058			;Disable mouse interupts
				STA	$C00E			;Normal character set
				STA	$C00C			;40 column
				STA	$C008			;Use main pages 0,1
				STA	$C002			;Use main 48K
				STA	$C000			;Page 2 switches page 1 and 2

				STA	$C050			;TEMP???
				STA	$C057			;TEMP???

				LDX	#0
:LOOP0			LDA	$2E00,X
				STA	LOBYTES,X
				LDA	$2EC0,X
				STA	HIBYTES,X
				INX
				CPX	#192
				BNE	:LOOP0

				LDX	#$00
:LOOP1			LDA	$2400,X
				STA	$400,X
				LDA	$2500,X
				STA	$500,X
				LDA	$2600,X
				STA	$600,X
				LDA	$2700,X
				STA	$700,X
				DEX
				BNE	:LOOP1

				LDA	$C083			;Bank 2
				LDA	$C083

				LDA	#$C7
				STA	$03F2
				LDA	#$03
				STA	$03F3
				LDA	#$A6
				STA	$03F4

				LDA	#side_MS
				STA	DISK_SIDE
				LDA	#0
				STA	SHELL

				LDA	#0
				STA	GRPNUMB

				LDX	#<BOOT_TABLE
				LDY	#>BOOT_TABLE
				JSR	SET_FILE_TABL

				LDX	#$00
				JSR	SLOADER_FILE
				LDX	#$01
				JSR	FLOADER_FILE
				LDX	#$02
				JSR	FLOADER_FILE
				LDX	#$03
				JSR	FLOADER_FILE
				LDX	#$05
				JSR	FLOADER_FILE

				LDA	$C08B			;Bank 1
				LDA	$C08B

				LDX	#$04
				JSR	FLOADER_FILE

				LDA	#$9F
				STA	SSTOREH
				LDX	#<$000A
				LDY	#>$000A
				LDA	#1
				JSR	FLOAD
				LDX	#10
:LOOP2			LDA	$9F80,X
				STA	OPENBUF,X
				DEX
				BPL	:LOOP2

				LDX	#31
:LOOP3			LDA	$9FCF,X
				STA	SPECIALS_DATA,X
				DEX
				BPL	:LOOP3

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
				LDA	#$25			;These have been
				STA	DELAY_TIME
				LDA	#$01
				STA	DELAY_MODE
				JMP	RDKEY

BOOT_TABLE		DB	$02				;0  PRInfo
				DW	$000C
				DB	$01

				DB	$60				;1 MTunnels
				DW	$0020
				DB	$20

				DB	$A0				;2  MControl, Camp.B000
				DW	$0040
				DB	$1B

				DB	$E0				;3  Camp.Main
				DW	$005B
				DB	$20

				DB	$D0				;4 Camp.D000.M1
				DW	$007B
				DB	$09

				DB	$D0				;5  Camp.D000.M2
				DW	$0084
				DB	$0C

				SAV	MBOOT
