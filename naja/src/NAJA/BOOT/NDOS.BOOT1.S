
NO_TITLE		=	0

				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/NDOS.VARS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/MHALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS

LOAD_BASE		=	$8000

; boot sector at $800
	; read the next 15 sectors to LOAD_BASE+$0100 to LOAD_BASE+$0FFF
	; (need to apply sector interleave on reads)

				ORG	$0800
				
				DB	$01
				
BOOT			CMP	#$01			; ACC holds sector read + 1
				BNE	:1
				;*** CHECK FOR SLOT 6? ***
				LDA	#>LOAD_BASE+$0100
				STA	$27				; next sector dst H
				LDA	#$00
				STA	$00
:1				LDY	$00
				INY
				CPY	#16
				BEQ	RELOCATE
				STY	$00
				LDA	INTERLEAVE,Y
				STA	$3D				; physical sector
				TAY
				INY
				STY	$0800
				JMP	$C65C			; must not have altered X reg
				
; virtual to physical interleave
INTERLEAVE		DB	$00,$02,$04,$06,$08,$0A,$0C,$0E
				DB	$01,$03,$05,$07,$09,$0B,$0D,$0F

RELOCATE		LDX	#0
:1				LDA	$0800,X
				STA	LOAD_BASE,X
				INX
				BNE	:1
				
				JMP	CLEAR_SCREEN
				
				ORG	*-$0800+LOAD_BASE
				
CLEAR_SCREEN	LDX	#0
				TXA
:1				STA	$2000,X
				INX
				BNE	:1
				INC	:1+2
				LDY	:1+2
				CPY	#$40
				BNE	:1	
				
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
				
SHUFFLE_PAGES	LDX	#0
:1				LDA	LOAD_BASE+$0200,X
:2				STA	$0200,X
				INX
				BNE	:1
				INC	:1+2
				INC	:2+2
				LDA	:2+2
				CMP	#$10
				BNE	:1
				
; call NDOS to read rest of NCOMMONS,MTUNNELS,CAMP
				
LOAD_FILES		LDA	#side_MS
				STA	DISK_SIDE
				LDA	#0
				STA	SHELL
				
				; load first file (NCommons) manually because
				;	SET_FILE_TABL and FLOADER_FILE code
				;	haven't been loaded yet
				
				LDA	#%11000000		; FLOADER flags (drive is on, leave on)
				STA	ON_OFF_FLAG
				LDA	#$00
				STA	SSTOREL
				LDA	BOOT_TABLE+0
				STA	SSTOREH
				LDX	BOOT_TABLE+1
				LDY	BOOT_TABLE+2
				LDA	BOOT_TABLE+3
				JSR	READ_VECTOR
				
				LDX	#<BOOT_TABLE
				LDY	#>BOOT_TABLE
				JSR	SET_FILE_TABL
				
				LDA	$C083			;Bank 2
				LDA	$C083
				
				LDX	#$01			; Camp.B000
				JSR	FLOADER_FILE
				LDX	#$02			; Camp.Main
				JSR	FLOADER_FILE
				LDX	#$03			; Camp.D000.M2
				JSR	FLOADER_FILE
				
				LDA	$C08B			;Bank 1
				LDA	$C08B
				
				LDX	#$04			; Camp.D000.M1
				JSR	FLOADER_FILE
				
			do NO_TITLE
				JMP	FINISH_BOOT
			fin
				
				LDA	#$5F
				PHA
				LDA	#$FF
				PHA
				LDX	#$05			; Title.Page
				JMP	FLOAD_FILE
				
			;do NO_TITLE
				; NOTE: BOOT_TABLE is needed for both title and no_title
				; builds, but FINISH_BOOT and INIT_GAME are only needed
				; for no_title.  Space could be saved by eliminating them
				; for title build.

				PUT	NDOS.BOOT2
			;fin
				
				DS	\,$00
				ERR	*-LOAD_BASE-$0200
