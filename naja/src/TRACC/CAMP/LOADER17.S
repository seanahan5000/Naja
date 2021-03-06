				JSR	SET_CAMPFILES

				LDX	#cTunnels
				JSR	FLOADER_FILE
				LDX	#cCtrlCommon
				JSR	FLOADER_FILE
				LDA	#bit_RefRegCom
				STA	CAMP_HERE
				LDX	#cRefRegCom
				JSR	FLOADER_FILE

				LDA	LOADER_FLAG
				BNE	:SKIPA
				LDX	#cTraccCampA
				JSR	FLOADER_FILE
				JSR	BANK_2
				LDX	#cTraccCampB
				JSR	FLOADER_FILE
				JSR	BANK_1
				DEC	LOADER_FLAG
:SKIPA			LDX	#cControl17
				JSR	FLOAD_FILE

				LDA	#1
				STA	SHELL

				LDX	#$03
:LOOP1			LDA	SHELL_INFO,X
				STA	MAPSPOT,X
				DEX
				BPL	:LOOP1

				JSR	BEAMEUP

				LDA	#$02
				STA	FACE
				LDA	#$00
				LDX	#$07
:LOOP2			STA	CREDHI,X
				DEX
				BPL	:LOOP2
				STA	KILLHI
				STA	KILLLO
				LDA	GRPNUMB
				STA	GRPCONT

				LDA	#$00
				STA	TEMP_COUNT
:LOOP3			JSR	POINTIT
				JSR	CALC_ALL
				INC	TEMP_COUNT
				LDA	TEMP_COUNT
				CMP	GRPNUMB
				BNE	:LOOP3

				LDA	#6
				STA	SRANGE
				JSR	CALC_SRANGE

				LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				LDA	#WHITE1
				STA	COLOR
REGET			JSR	GETNSEW
				LDA	BUFFER+4
				CMP	#$FF
				BNE	NOREGET
				LDA	DIRECTN
				EOR	#$0F
				STA	DIRECTN
				JMP	REGET

NOREGET			JSR	NOSCAN
				LDA	#$20
				STA	PAGE
				JSR	$9003			;Spray routine
				STA	SCNDARY
				JSR	MOVETO1
				STA	PRIMARY
				LDX	GRPNUMB
				DEX
				STX	COUNT
RFLOOP1			LDA	COUNT
				JSR	POINTIT
				LDY	#position
				LDA	(CHARDL),Y
				BEQ	REFORM
				DEC	COUNT
				BPL	RFLOOP1
				LDA	#$00
				STA	COUNT
				STA	SCRATCH
RFLOOP3			LDA	COUNT
				STA	COUNTER
				INC	COUNTER
				JSR	POINTIT
				LDY	#position
				LDA	(CHARDL),Y
				AND	#$0F
				CMP	#$05
				BNE	NOFRONT
				INC	SCRATCH
NOFRONT			LDA	COUNTER
				CMP	GRPNUMB
				BEQ	NOREF
				LDY	#position
				LDA	(CHARDL),Y
				STA	TEMP
RFLOOP2			LDA	COUNTER
				JSR	POINTIT
				LDY	#position
				LDA	(CHARDL),Y
				CMP	TEMP
				BEQ	REFORM
				INC	COUNTER
				LDA	COUNTER
				CMP	GRPNUMB
				BNE	RFLOOP2
				LDA	GRPNUMB
				INC	COUNT
				SEC
				SBC	GRPNUMB
				CMP	#$01
				BNE	RFLOOP3
NOREF			LDA	SCRATCH
				BEQ	REFORM
				JSR	SORTER
				JMP	RDKEY
REFORM			JMP	REFORMAT

			do	ORIGINAL

; This only works for level 17 maps ***
BEAMEUP			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$7F
				LDX	#$00
NEXTCUT			CMP	CUTS+1,X
				BCC	VALID
				BEQ	VALID
				INX
				CPX	#$0E
				BNE	NEXTCUT
				BEQ	BEAMEUP
VALID			STA	SCRATCH
				LDA	CUTS+1,X
				SEC
				SBC	SCRATCH
				STA	OFFSET
				TXA
				ASL
				TAY
				LDA	ROWS,Y
				STA	XPOS
				LDA	ROWS+1,Y
				CLC
				ADC	OFFSET
				STA	YPOS
				LDA	#$00
				CPX	#$09
				BCC	NORSOU
				LDA	#$F0
NORSOU			STA	DIRECTN
				LDA	OFFSET
				BEQ	:SKIPA
				LDA	CUTS,X
				CLC
				ADC	OFFSET
				CMP	CUTS+1,X
				BEQ	:SKIPB
				JSR	RNDMIZE
				BIT	RANDOM1
				BVC	:SKIPB
:SKIPA			LDA	DIRECTN
				ORA	#$0F
				STA	DIRECTN
:SKIPB			BIT	DIRECTN
				BVC	:SKIPC
				LDX	XPOS
				LDY	YPOS
				STX	YPOS
				STY	XPOS
:SKIPC			RTS

CUTS			DB	$00,$07,$0D
				DB	$11,$15,$17
				DB	$1C,$1F,$23
				DB	$2A,$2C,$34
				DB	$38,$42,$44

ROWS			DB	$04,$0A
				DB	$07,$05
				DB	$09,$02
				DB	$09,$0E
				DB	$0A,$01
				DB	$0A,$0A
				DB	$0D,$08
				DB	$0E,$05
				DB	$10,$08
				DB	$02,$09
				DB	$05,$07
				DB	$08,$0D
				DB	$0A,$04
				DB	$0E,$09

			else
				
; hard-wired for level 15
BEAMEUP			LDA #$0B
				STA	XPOS
				LDA	#$01
				STA	YPOS
				LDA	#$0F
				STA	DIRECTN
				RTS

			fin

TEMP_COUNT		DB	$00
