MOVE			JSR	UNDERS
				JSR	CLRBOX
				LDY	#$07
				JSR	TEXTER
				LDA	#$00
				STA	PASTMOV
				STA	LETBACK+1
MOVE2			LDA	COMCNT
				BEQ	FAILS2
				LDY	COMPNTR
				LDA	COMMAND-2,Y
				AND	#$0F
				CMP	#$07
				BNE	FAILS2
				LDA	LETBACK+1
				CMP	#"B"
				BEQ	PS2
				LDY	#$08
				JSR	TEXTER
				LDA	#"B"
				BNE	PS2				;Always
FAILS2			LDA	LETBACK+1
				CMP	#"B"
				BNE	FSKIP2
				LDY	#$08
				JSR	TEXTER
FSKIP2			LDA	#$FF			;Called by USE too
PS2				STA	LETBACK+1
				LDA	#$00
				LDX	#$03
CLRLEGS			STA	LEGCURS,X
				DEX
				BPL	CLRLEGS
				LDY	PLANNER
				LDA	XYSPOTS,Y
				LDX	#$FF
				PHA
				AND	#$F0
				CMP	#$10
				BNE	NOD
				STX	LEGCURS+3
NOD				CMP	#$50
				BNE	NOB
				STX	LEGCURS+1
NOB				PLA
				PHA
				AND	#$0F
				CMP	#$01
				BNE	NOC	
				LDY	LETCANC+1
				CPY	#"C"
				BEQ	NOC
				STX	LEGCURS+2
NOC				CMP	#$05
				BNE	NOA
				STX	LEGCURS
NOA				LDX	#$03
				PLA
CURLP			STA	CURCORD,X
				DEX
				BPL	CURLP
				INC	CURCORD
				LDA	CURCORD+1
				CLC
				ADC	#$10
				STA	CURCORD+1	
				LDA	LETCANC+1
				CMP	#"C"
				BEQ	:1
				DEC	CURCORD+2
:1				LDA	CURCORD+3
				SEC
				SBC	#$10
				STA	CURCORD+3
				LDY	PASTMOV
PICFRST			LDA	LEGCURS,Y
				BEQ	PICKED1
				INY
				CPY	#$04
				BNE	PICFRST
				LDY	#$00
				BEQ	PICFRST			;Always
PICKED1			STY	CURSOR
				JSR	GROUP_CURSOR2
BLINKGB			LDA	#$10
				JSR	WAIT
				LDA	#$F0
				JSR	WAIT2
				BMI	GOTKEYX
				JSR	GROUP_CURSOR2
				LDA	#$00
				JSR	WAIT2
				JSR	GROUP_CURSOR2
MENTKEY			LDA	KEYBRD
				BPL	BLINKGB
GOTKEYX			BIT	UNSTROB
				JSR	CHECK_LEFT
				BEQ	CCWISE
				JSR	CHECK_RIGHT
				BEQ	CWISE
LETBACK			CMP	#"B"
				BEQ	GOBACK
LETCANC			CMP	#"L"
				BEQ	GOEND
				JSR	CHECK_ENTER
				BEQ	GOENTER
				BNE	MENTKEY
CCWISE			JSR	GROUP_CURSOR2
CC1				DEC	CURSOR
				BPL	CC2
				LDA	#$03
				STA	CURSOR
CC2				LDY	CURSOR
				LDA	LEGCURS,Y
				BNE	CC1
				JSR	GROUP_CURSOR2
				JMP	MENTKEY
CWISE			JSR	GROUP_CURSOR2
C1				INC	CURSOR
				LDA	CURSOR
				CMP	#$04
				BCC	C2
				LDA	#$00
				STA	CURSOR
C2				LDY	CURSOR
				LDA	LEGCURS,Y
				BNE	C1
				JSR	GROUP_CURSOR2
				JMP	MENTKEY
GOBACK			JSR	GROUP_CURSOR2
				LDY	PLANNER
				LDA	XYSPOTS,Y
				JSR	FROM11B
				JSR	GROUP_CURSOR1
				LDA	#$60
				STA	NOBAKS
				JSR	BACK1
				LDA	#$20
				STA	NOBAKS
				JMP	MOVE2
GOEND			NOP
				JSR	GROUP_CURSOR2
GOEND2			JSR	UNDERS
				JSR	CLRBOX
				JSR	OPTIONS
				JMP	GETOP2
GOENTER			NOP
				LDA	CURSOR
				STA	PASTMOV
				JSR	GROUP_CURSOR2
				LDY	CURSOR
				LDA	CURCORD,Y
				LDX	PLANNER
				STA	XYSPOTS,X
				LDY	XYSPOTS,X
				LDX	#cmdMOVE
				LDA	TIMES+timeMOVE
				JSR	GENERAL_POST
				LDX	COMCNT
				LDA	TIMLEFT
				STA	CTIMTAB,X
				LDY	PLANNER
				LDA	XYSPOTS,Y
				JSR	FROM11B
				JSR	GROUP_CURSOR1
				LDA	COMCNT
				CMP	#$0F
				BEQ	GOEND2
				LDA	TIMLEFT
				CMP	TIMES+timeMOVE
				BCC	GOEND2
				JMP	MOVE2

LEGCURS			DS	4
XYSPOTS			DS	7
CURCORD			DS	4


UNDERS			LDA	PLANNER
				ASL
				ASL
				ASL
				ASL
				ASL
				STA	COUNTER	
				CMP	COMPNTR
				BEQ	UNDOUT
UND2			LDY	COUNTER	
				LDA	COMMAND,Y
				INC	COUNTER	
				CMP	#$07
				BNE	DONTDRW
				INY
				LDA	COMMAND,Y
				JSR	FROM11B
				JSR	GROUP_CURSOR1
DONTDRW			INC	COUNTER	
				LDA	COUNTER	
				CMP	COMPNTR
				BNE	UND2
UNDOUT			RTS
