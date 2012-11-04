*-------------------------------

FROM_MAINBUFF	JSR	POINTAT_RARE
				LDY	#0
:1				LDA	(DATPNTL),Y
				STA	RARE_BUFFER,Y
				CMP	#$FF
				BEQ	:2
				INY
				BNE	:1				;Always
:2				JSR	POINTAT_ALIEN
				LDY	#63
:3				LDA	(DATPNTL),Y
				STA	ALIEN_BUFFER,Y
				DEY
				BPL	:3
				JSR	POINTAT_GROUP
				LDY	#0
:6				LDA	(DATPNTL),Y
				STA	GROUP_BUFFER,Y
				CMP	#$DD
				BEQ	:4
				INY
				BNE	:6				;Always
:4				LDA	(DATPNTL),Y
				STA	GROUP_BUFFER,Y
				CMP	#$FF
				BEQ	:5
				INY
				BNE	:4				;Always
:5				RTS

*-------------------------------

TO_MAINBUFF		JSR	POINTAT_RARE
				LDY	#0
:1				LDA	RARE_BUFFER,Y
				STA	(DATPNTL),Y
				CMP	#$FF
				BEQ	:2
				INY
				BNE	:1				;Always
:2				JSR	POINTAT_ALIEN
				LDY	#63
:3				LDA	ALIEN_BUFFER,Y
				STA	(DATPNTL),Y
				DEY
				BPL	:3
				JSR	POINTAT_GROUP
				LDY	#0
:6				LDA	GROUP_BUFFER,Y
				STA	(DATPNTL),Y
				CMP	#$DD
				BEQ	:4
				INY
				BNE	:6				;Always
:4				LDA	GROUP_BUFFER,Y
				STA	(DATPNTL),Y
				CMP	#$FF
				BEQ	:5
				INY
				BNE	:4				;Always
:5				RTS

*-------------------------------

POINTAT_RARE	LDA	MAIN_BUFFER+3
				STA	DATPNTL
				LDA	MAIN_BUFFER+4
				CLC
				ADC	#>MAIN_BUFFER
				STA	DATPNTH
				LDX	NUMBER
				LDY	#0
				BEQ	:SKIPB			;Always
:LOOP1			INY
				BNE	:SKIPA
				INC	DATPNTH
:SKIPA			LDA	(DATPNTL),Y
				CMP	#$FF
				BNE	:LOOP1
				INY
				BNE	:SKIPB
				INC	DATPNTH
:SKIPB			DEX
				BNE	:LOOP1
				TYA
				CLC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:EXIT
				INC	DATPNTH
:EXIT			RTS

*-------------------------------

POINTAT_TV		JSR	POINTAT_GROUP
				LDY	#0
:0				LDA	(DATPNTL),Y
				INY
				CMP	#$DD
				BNE	:0
:1				LDA	(DATPNTL),Y
				INY
				CMP	#$FF
				BNE	:1
				LDA	(DATPNTL),Y
				STA	TV_DIMENS
				INY
				LDA	(DATPNTL),Y
				STA	TV_OFFSET
				TYA
				SEC
				ADC	DATPNTL
				STA	DATPNTL
				BCC	:2
				INC	DATPNTH
:2				RTS

*-------------------------------

POINTAT_GROUP	JSR	POINTAT_ALIEN
				LDA	DATPNTL
				CLC
				ADC	#64
				STA	DATPNTL
				BCC	:1
				INC	DATPNTH
:1				RTS

*-------------------------------

POINTAT_ALIEN	LDA	MAIN_BUFFER+1
				STA	DATPNTL
				LDA	#>MAIN_BUFFER
				CLC
				ADC	MAIN_BUFFER+2
				STA	DATPNTH
				LDY	NUMBER
				DEY
				TYA
				ASL
				TAY
				LDA	(DATPNTL),Y
				PHA
				INY
				LDA	(DATPNTL),Y
				CLC
				ADC	#>MAIN_BUFFER
				LDY	SHELL_NUMBER
				SEC
				SBC	DOFF_SECTL-1,Y
				STA	DATPNTH
				PLA
				STA	DATPNTL
				RTS

DOFF_SECTL		DB	S_DATA17-S_DATA12
				DB	S_DATA15-S_DATA12
				DB	S_DATA13-S_DATA12
				DB	S_DATA11-S_DATA12
				DB	S_DATA9-S_DATA12

*-------------------------------

LOADSUB			JSR	LOAD_SAVE
				JSR	SLOAD
				LDX	MAIN_BUFFER
				STX	MAXNUMB
				RTS

*-------------------------------

SAVESUB			JSR	LOAD_SAVE
				JMP	DO_WRITE

*-------------------------------

LOAD_SAVE		LDA	#>MAIN_BUFFER
				STA	SSTOREH
				LDY	SHELL_NUMBER
				LDX	DATA_SECTL-1,Y
				LDA	DATA_SECTH-1,Y
				TAY
				LDA	#$20
				RTS

DATA_SECTL		DB	<S_DATA17
				DB	<S_DATA15
				DB	<S_DATA13
				DB	<S_DATA11
				DB	<S_DATA9

DATA_SECTH		DB	>S_DATA17
				DB	>S_DATA15
				DB	>S_DATA13
				DB	>S_DATA11
				DB	>S_DATA9

*-------------------------------
