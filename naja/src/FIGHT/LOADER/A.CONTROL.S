				JMP	FIGHT_LOADER
				JMP	SPECIAL_LOAD
				JMP	ALIEN_VIEWER	; debug-only

FIGHT_LOADER	LDX	#%11111111
				LDY	#%11110000
				LDA	#%00000000
				STA	TAKEN_COUNT
SPECIAL_LOAD	STX	OPTIONS1		;Calling routine must clear
				STY	OPTIONS2		;   TAKEN_COUNT if unused
				STA	FORCE_SUPRISE
				TXA
				AND	#Xalien1+Xalien2+Xalien3
				BEQ	:SKIPA
				JSR	PICK_ALIENS
:SKIPA			LDA	OPTIONS1
				AND	#Xhmany1+Xhmany2+Xhmany3
				BEQ	:SKIPB
				JSR	PICK_NUMBER
:SKIPB			LDA	OPTIONS2
				AND	#Xpicture		;Calling routine must setup
				BEQ	:SKIPC			;   DIRHOLD if skipping picture
				JSR	DRAW_PICTURE
:SKIPC			STA	SCNDARY
				LDA	#$00
				STA	CAMP_HERE
*** LOOK THROUGH SPECIALS TABLE
*** IF NONE FOUND, SKIP
				CLC					;TEMP
				BCC	NOSPECIAL		;TEMP
*** LOAD SPECIAL FILE
*JSR SPECIAL
				CLC					;TEMP
				BCC	NOEXIT

EXIT_EARLY		LDA	DIRHOLD
				STA	DIRECTN
				LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				LDA	#WHITE1
				STA	COLOR
				JSR	GETNSEW
				JSR	NOSCAN
				STA	PRIMARY
			do ORIGINAL
			else
				LDA	DISK_SIDE
				EOR	#side_T1!side_F1			;! means XOR
				STA	DISK_SIDE
			fin
				JMP	RDKEY

NOEXIT			JSR	DRIVE_ON
NOSPECIAL		LDX	#fLoader2
				JSR	FLOADER_FILE
				JSR	LOAD_DATA
				LDA	#0
				STA	ROUND
				STA	SUPRISED_FLAG
				STA	ATOTAL1
				STA	ATOTAL2
				STA	ATOTAL3
				JSR	MAKE_ALLMONS
				JSR	FIGHT_SCREEN
				JSR	SUPRISE_SUB
				LDA	#$62
				PHA
				LDA	#$FF
				PHA
				LDX	#fCommand
				JMP	FLOAD_FILE

OPTIONS1		DS	1
OPTIONS2		DS	1
FORCE_SUPRISE	DS	1
TWINS_FLAG		DS	1

;-----------------------------------------------------
; Debug-only code to cycle through all alien pictures
;-----------------------------------------------------

ALIEN_VIEWER	LDA	#$00
				STA	CAMP_HERE

				JSR	LOAD_TABLE		; drive is spinning

				LDA	#$01
				STA	ALIEN1
				BNE	:FIRST_ALIEN	; always

:NEXT_ALIEN		JSR	DRIVE_ON
:FIRST_ALIEN	JSR	DRAW_PICTURE
				PHP
				JSR	DRIVE_OFF
				PLP
				BCS	:NO_PICT

				STA	SCNDARY
				LDA	DIRHOLD
				STA	DIRECTN

:GET_KEY		LDA	KEYBRD
				BPL	:GET_KEY
				BIT	UNSTROB

				STA	PRIMARY

				CMP	#$9B			; escape
				BEQ	:EXIT

:NO_PICT		LDA	ALIEN1
				INC	ALIEN1
				CMP	DATA_BUFR+0		; # of aliens
				BNE	:NEXT_ALIEN

:EXIT			JMP	EXIT_EARLY

;-----------------------------------------------------
