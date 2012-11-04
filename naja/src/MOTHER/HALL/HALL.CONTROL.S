LINENUM			=	$00
ROW				=	$00
SECTOR			=	$00
YTOP			=	$00
WHO2DEL			=	$07
TOPLINE			=	$07
LINECNT			=	$0B
SORCLIN			=	$0B
YCOUNT			=	$0F
LINSORC			=	$0C
COLUMN			=	$10
LEFTCOL			=	$10
PICKED1			=	$10
LEFTOTL			=	$11
RITECOL			=	$11
ENDLINE			=	$11
BEGROW			=	$12
TOCNT			=	$12
ENDROW			=	$13
FROMCNT			=	$13

COUNTER			=	ZBLOCK_A0+0
WHICHT			=	ZBLOCK_A0+1
FLAG12			=	ZBLOCK_A0+2
TDELAY			=	ZBLOCK_A0+3		;+4 ;Used only by guard scanner
BDELAY			=	ZBLOCK_A0+5		;+6 ;Used only by guard scanner


TRANS_SOUND		JMP	TRANS_NOISE
CALL_WRITERS	JMP	WRITE_DISPTCH
MOMFILES_ADR	DW	MOTHER_FILES	;Only used by Booter and Tesback

PCHECK			LDA	#$01
				BNE	PCOM			;Always
PCHECK2			LDA	#$02
PCOM			STA	FLAG12
				LDX	XPOS
				DEX
				LDA	OFFSETS,X
				BMI	:SKIPC
				TAY
				LDA	COUNTS,X	
				STA	COUNTER
				INX
:LOOP1			LDA	OFFSETS,X
				BPL	:SKIPA
				INX
				BNE	:LOOP1			;Always
:SKIPA			STA	TEMP
:LOOP2			LDA	DATA,Y
				CMP	YPOS
				BNE	:SKIPB
				LDA	DATA+1,Y
				CMP	#$AA
				BEQ	GOSUBS
				CMP	DIRECTN
				BEQ	GOSUBS
:SKIPB			LDA	COUNTER
				INC	COUNTER
				CMP	#$1A
				BEQ	:SKIPC
				TYA
				CLC
				ADC	#$02
				TAY
				CMP	TEMP
				BNE	:LOOP2
:SKIPC			LDA	#$00			;Nothing found
				RTS

GOSUBS			LDY	COUNTER
				LDA	TYPES,Y
				BPL	:SKIPA
				AND	#$7F
				TAY
				LDA	#$0C
:SKIPA			ASL
				TAX
				LDA	:JUMPS-14+1,X
				PHA
				LDA	:JUMPS-14,X
				PHA
				RTS

:JUMPS			DW	DELETE-1
				DW	GUARD-1
				DW	TESPORT-1
				DW	TRANSPORT-1
				DW	DOOR_TEXTS-1
				DW	LOAD_SUB-1

PICHERE			DB	$FF

OFFSETS			DB	$00,$04,$FF
				DB	$08,$0E,$14
				DB	$1C,$1E,$28
				DB	$2A,$FF,$32

COUNTS			DB	$00,$02,$FF
				DB	$04,$07,$0A
				DB	$0E,$0F,$14
				DB	$15,$FF,$19

TYPES			DB	$0A,$0B,$0A
				DB	$80,$0B,$81
				DB	$0A,$07,$82
				DB	$0B,$08,$0B
				DB	$0B,$0B,$83
				DB	$09,$0B,$0A
				DB	$84,$0B,$0B
				DB	$85,$0B,$0B
				DB	$0B,$0A

DATA			DB	$05,$F0
				DB	$0A,$FF
				DB	$07,$FF
				DB	$0A,$AA
				DB	$07,$0F
				DB	$08,$AA
				DB	$0C,$F0
				DB	$03,$00
				DB	$08,$AA
				DB	$09,$00
				DB	$05,$00
				DB	$05,$FF
				DB	$0B,$0F
				DB	$0C,$00
				DB	$05,$AA
				DB	$01,$00
				DB	$03,$00
				DB	$05,$0F
				DB	$07,$AA
				DB	$08,$00
				DB	$01,$FF
				DB	$09,$AA
				DB	$0A,$00
				DB	$0B,$0F
				DB	$0C,$00
				DB	$0C,$FF

*-------------------------------
*
*-------------------------------

TESPORT			JSR	LOST_IN_GROUP
				BCC	:SKIPA
				LDA	#0
				RTS
:SKIPA			JSR	STEP_SUB
				LDX	#mTesseract
				JSR	SLOAD_FILE
				JMP	TESS_BEGIN

*-------------------------------
*
*-------------------------------

STATTER			LDA	GRPNUMB
				BEQ	:SKIPA
				JSR	LOST_IN_GROUP
				BCC	:SKIPB
:SKIPA			JMP	RDKEY
:SKIPB			LDA	#$FF
				STA	PICHERE
				JMP	CAMP_VECTOR

*-------------------------------
*
*-------------------------------

LOST_IN_GROUP	LDA	#0
				STA	COUNT
:LOOP1			JSR	POINTIT
				LDY	#status
				LDA	(CHARDL),Y
				SEC
				AND	#%00111100
				CMP	#%00000100		;intracc, compressd, inlimbo, lost
				BEQ	:EXIT
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	:LOOP1
				CLC
:EXIT			RTS

*-------------------------------
*
*-------------------------------

LOAD_SUB		STY	:MOD1+1
				JSR	CLEAR2
				STA	SCNDARY
				JSR	CLEAR1
				STA	PRIMARY
				LDA	#$FF
				STA	PICHERE
:MOD1			LDX	#$FF			;Modified
				JSR	SLOADER_FILE
				LDA	SSTOREH
				STA	:MOD2+2
:MOD2			JMP	$FF00			;Modified


MOTHER_FILES	DB	$80				;Infirmary
				DW	$00B8
				DB	$08

				DB	$80				;Group Assembly
				DW	$00D0
				DB	$09

				DB	$80				;Energy Center
				DW	$0090
				DB	$1C

				DB	$80				;Enrollment/Testing
				DW	$00F0
				DB	$11

				DB	$80				;Arsenal
				DW	$0130
				DB	$10

				DB	$80				;Robot Repair
				DW	$0170
				DB	$0C

				DB	$9E				;mWriter
				DW	$000E
				DB	$02

				DB	$60				;mHallsPicts
				DW	$0020
				DB	$20

				DB	$70				;mPictures
				DW	$0030
				DB	$10

				DB	$90				;mTesseract
				DW	$0010
				DB	$06

				DB	$80				;mInfoSeller
				DW	$0016
				DB	$06

*--------------------------------------
* On Entry:
*   X: Code # of write routine to call
*--------------------------------------

WRITE_DISPTCH	LDA	:TABLE+1,X
				PHA
				LDA	:TABLE,X
				PHA
				RTS

:TABLE			DW	WRITE_GROUP-1			;0
				DW	WRITE_MEMBERS-1			;2
				DW	WRITE_NEWCHAR-1			;4
				DW	WRITE_OPEN-1			;6
				DW	WRITE_STOCK-1			;8

*---------------------------------------------------
* Assume that when either of these routines are
*   called, LEGALS contains at least one character
*   that needs to be written out to the disk.
*---------------------------------------------------

WRITE_GROUP		JSR	RESET_CHRLIST
WRITE_MEMBERS	JSR	PRE_WRITE
				LDX	#0
				STX	COUNT
:LOOP1			LDA	LEGALS,X
				BNE	:SKIPC
				TXA
				JSR	POINTIT
				LDY	#disklocation
				LDA	(CHARDL),Y
				STA	SECT_HOLD
				EOR	#$80
				STA	TEMP
:LOOP2			INX
				CPX	GRPNUMB
				BEQ	:SKIPA
				LDA	LEGALS,X
				BNE	:LOOP2
				TXA
				JSR	POINTIT
				LDA	(CHARDL),Y
				CMP	TEMP
				BNE	:LOOP2
				LDA	#$FF			;Two chars in current sector
				STA	LEGALS,X
				JSR	TRANSUB
				LDA	COUNT
				JSR	POINTIT
				JMP	:SKIPB
:SKIPA			LDA	COUNT
				JSR	POINTIT
				JSR	SECTOR_LOAD		;Only one character in current sector
:SKIPB			JSR	TRANSUB
				JSR	CODE_DECODE
				LDA	#$9D
				STA	SSTOREH
:ERROR			LDA	SECT_HOLD
				AND	#%01111111
				TAX
				CLC					;Don't self-destruct when done
				JSR	$9E00			;<- Actual writing routine
				BCS	:ERROR			;Handle unlikely write error
				JSR	CODE_DECODE
:SKIPC			INC	COUNT
				LDX	COUNT
				CPX	GRPNUMB
				BNE	:LOOP1

				LDX	#0				;Destroy write routine
:LOOP3			LDA	$6738,X			;bogus address
				STA	$9E00,X
				LDA	$6921,X			;bogus address
				STA	$9F00,X
				INX
				BNE	:LOOP3
				JMP	DRIVE_OFF

*----------------------------------------
* On Entry:
*   CHARDL,H: Pointing to character data
*----------------------------------------

WRITE_NEWCHAR	JSR	PRE_WRITE
				JSR	SECTOR_LOAD
				JSR	TRANSUB
				JSR	CODE_DECODE
				LDX	SECT_HOLD
				SEC					;Self-destruct when done
				JSR	$9E00			;<- Actual writing routine
				PHP
				JSR	DRIVE_OFF
				PLP
				BCS	WRITE_NEWCHAR	;Handle unlikely write error
				RTS

*-------------------------------
*
*-------------------------------

WRITE_OPEN		JSR	PRE_WRITE		;Also writes orb status data
				LDA	#$0A
				JSR	SECTOR_LOAD_A
				LDX	#10
:LOOP1			LDA	OPENBUF,X
				STA	$9D80,X
				DEX
				BPL	:LOOP1
				LDX	#31
:LOOP2			LDA	SPECIALS_DATA,X
				STA	$9DCF,X
				DEX
				BPL	:LOOP2
				BMI	WRITE_COM		;Always

*-------------------------------
*
*-------------------------------

WRITE_STOCK		JSR	PRE_WRITE
				LDA	#$0A
				JSR	SECTOR_LOAD_A
				LDX	#67
:LOOP1			LDA	$9C8B,X			;Arsenal must use this address
				STA	$9D8B,X
				DEX
				BPL	:LOOP1

WRITE_COM		JSR	CODE_DECODE
:ERROR			LDX	#$0A
				SEC					;Self-destruct when done
				JSR	$9E00			;<- Actual writing routine
				BCS	:ERROR			;Handle unlikely write error
				JMP	DRIVE_OFF

*-------------------------------

PRE_WRITE		JSR	DRIVE_ON
				JSR	CHECK_WRITPRO
				LDX	#mWriter
				JSR	FLOADER_FILE
CODE_DECODE		LDX	#0
:LOOP1			LDA	$9E00,X
				EOR	$6100,X
				STA	$9E00,X
				LDA	$9F00,X
				EOR	$6200,X
				STA	$9F00,X
				INX
				BNE	:LOOP1
				RTS

*-------------------------------

SECTOR_LOAD		LDY	#disklocation
				LDA	(CHARDL),Y
				AND	#%01111111
				STA	SECT_HOLD
SECTOR_LOAD_A	ORA	#<charTrack
				TAX
				LDY	#>charTrack
				LDA	#$9D
				STA	SSTOREH
				LDA	#1
				JMP	FLOADER

*-------------------------------

TRANSUB			LDY	#disklocation
				LDA	(CHARDL),Y
				AND	#%10000000
				STA	:MOD1+1
				LDY	#$7F
:LOOP1			LDA	(CHARDL),Y
:MOD1			STA	$9D00,Y			;Modified
				DEY
				BPL	:LOOP1
				RTS

*-------------------------------

SECT_HOLD		DB	0
