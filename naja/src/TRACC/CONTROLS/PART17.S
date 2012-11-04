				DW	EVATOR			;0
				DW	ROTCUBE			;1
				DW	SHIPSND			;2
				DW	IN1WAY			;3
				DW	NET				;4
				DW	AIRLOCK			;5
				DW	VPORT			;6
				DW	DSIGN			;7
				DW	DCCOMP			;8
				DW	WPFOUND			;9
				DW	THRONE			;A
				DW	KILROY			;B
				DW	ORBGRD			;C
				DW	AUTOEN			;D
				DW	DUMMY			;E NEVER USED
				DW	ISDOOR			;F
				DW	NOTDOOR			;10

FACE1			DB	$C2,$11,$04
				DB	$23,$0B,$0D
				DB	$84,$11,$04
				DB	$26,$08,$0D
				DB	$12,$12,$FF
FACE2			DB	$C2,$0A,$04
				DB	$84,$0A,$04
				DB	$12,$12,$FF
FACE3			DB	$C1,$11,$04
				DB	$83,$11,$04
				DB	$24,$11,$05
				DB	$25,$11,$06
				DB	$26,$11,$06
				DB	$27,$11,$06
				DB	$28,$11,$06
				DB	$29,$11,$06
				DB	$2A,$11,$06
				DB	$2B,$11,$06
				DB	$2C,$11,$06
				DB	$2D,$11,$06
				DB	$2E,$11,$05
				DB	$CF,$11,$04
				DB	$D0,$09,$08
				DB	$91,$11,$04
				DB	$12,$12,$FF
FACE4			DB	$C1,$03,$04
				DB	$C1,$0F,$04
				DB	$83,$03,$04
				DB	$83,$0F,$04
				DB	$4B,$0D,$03
				DB	$2C,$09,$01
				DB	$CF,$0E,$03
				DB	$30,$11,$09
				DB	$51,$03,$04
				DB	$11,$05,$04
				DB	$12,$12,$FF
FACE5			DB	$C1,$09,$07
				DB	$22,$0A,$10
				DB	$22,$0E,$10
				DB	$23,$0E,$0F
				DB	$24,$0F,$0F
				DB	$24,$10,$10
				DB	$25,$0C,$10
				DB	$26,$0D,$10
				DB	$C8,$09,$0A
				DB	$28,$10,$10
				DB	$49,$01,$07
				DB	$C9,$01,$04
				DB	$29,$08,$0B
				DB	$09,$11,$07
				DB	$2A,$02,$10
				DB	$8B,$01,$04
				DB	$2C,$05,$10
				DB	$2D,$06,$10
				DB	$2E,$02,$10
				DB	$2E,$03,$0F
				DB	$2F,$04,$0F
				DB	$30,$04,$10
				DB	$30,$08,$10
				DB	$91,$09,$07
				DB	$12,$12,$FF
FACE6			DB	$83,$0D,$00
				DB	$24,$01,$0E
				DB	$24,$02,$0E
				DB	$44,$08,$04
				DB	$44,$0A,$04
				DB	$84,$0D,$00
				DB	$25,$01,$0E
				DB	$25,$02,$0E
				DB	$26,$01,$0E
				DB	$26,$02,$0E
				DB	$26,$0A,$0D
				DB	$26,$0B,$01
				DB	$26,$0C,$0D
				DB	$46,$0F,$04
				DB	$06,$11,$04
				DB	$27,$01,$0E
				DB	$27,$02,$0E
				DB	$27,$0F,$0C
				DB	$27,$10,$0C
				DB	$28,$01,$0E
				DB	$28,$02,$0E
				DB	$28,$07,$01
				DB	$28,$0A,$0D
				DB	$28,$0B,$01
				DB	$28,$0C,$0D
				DB	$28,$0E,$0C
				DB	$28,$0F,$0C
				DB	$28,$10,$0C
				DB	$28,$11,$0C
				DB	$29,$01,$0E
				DB	$29,$02,$0E
				DB	$29,$0F,$0C
				DB	$29,$10,$0C
				DB	$2A,$0A,$0D
				DB	$2A,$0B,$01
				DB	$2A,$0C,$0D
				DB	$2B,$08,$02
				DB	$2B,$09,$02
				DB	$2B,$0A,$02
				DB	$CC,$01,$04
				DB	$2C,$07,$02
				DB	$2C,$0B,$02
				DB	$2D,$07,$02
				DB	$2D,$0B,$02
				DB	$8E,$01,$04
				DB	$2E,$07,$02
				DB	$2E,$0B,$02
				DB	$2F,$08,$02
				DB	$2F,$09,$02
				DB	$2F,$0A,$02
FACE7			DB	$12,$12,$FF

TEXTS			DW	CRITICAL_TEXT
				DW	RUNDOWN_TEXT
				DW	CURED_TEXT
				DW	CONTAG_TEXT
				DW	TEXT3

VPort			=	0
DCComp			=	1
Throne			=	2
OrbPed			=	3

*** DestH,SectL,SectH,Length
FILE_TABLE		DB	$99,$99,$99,$99				;VPort
				DB	$99,$99,$99,$99				;DCComp
				DB	$99,$99,$99,$99				;Throne
				DB	$99,$99,$99,$99				;OrbPed

LINER			TYA
				ASL
				TAY
				LDA	LINES,Y
				STA	POINTL
				LDA	LINES+1,Y
				STA	POINTH
				JMP	LINEOUT
LINES			DW	HOLEDAT
				DW	BOXDATA
				DW	BLKLINE
				DW	EBOX
				DW	BLKLIN2
				DW	EBOX2
				DW	NET_EDGES

TEXT3			DB	$0E,$03,$2D
				DB	$19,$1F,$1E
				DB	$0A,$19,$10
				DB	$0A,$0F,$18
				DB	$0F,$1C,$11
				DB	$23,$8D,$FF
SHIPSND			NOP	
IN1WAY			NOP	
WPFOUND			NOP	
KILROY			NOP	
AUTOEN			NOP
DUMMY			LDA	#$00			;PERMANENT 
				RTS
**************
THRONE			LDA	#$00
				STA	CAMP_HERE		;This has to be fixed
				LDX	#Throne
				JSR	SLOAD_FILE
				JMP	$9000
**************
DCCOMP			LDA	#$00
				STA	CAMP_HERE		;This has to be fixed
				LDA	PROGON
				CMP	#$DC
				BEQ	NODCLOD
				LDX	#DCComp
				JSR	SLOAD_FILE
NODCLOD			JMP	$9000
**************
AIRLOCK			NOP					;FALL THROUGH
VPORT			LDA	#$00
				STA	CAMP_HERE		;This has to be fixed
				LDA	PROGON
				CMP	#$EB
				BEQ	ISINMEM
				LDX	#VPort
				JSR	SLOAD_FILE
				LDA	#$EB
				STA	PROGON
				LDA	#$00
				STA	PICKON
ISINMEM			LDY	COUNT
*LDA TYPE,Y      ;FIX THIS LATER
				JMP	$9000	
**************
ROTCUBE			LDA	FLAG12
				CMP	#$02
				BEQ	NOTING
				JSR	RNDMIZE
				LDA	RANDOM1
				AND	#$03
				TAY
				LDA	DRECTS,Y
				STA	DIRECTN
				JSR	GETNSEW
NOTING			LDA	#$00
				RTS
DRECTS			DB	$00,$0F,$F0
				DB	$FF
**************
ISDOOR			LDX	#$00
				BEQ	DOORCOM
NOTDOOR			LDX	#$08	
DOORCOM			LDA	#$00
				STA	COUNT
DCOM2			LDY	COUNT
				LDA	PLACES,Y
				TAY
				LDA	DOORS,X
				STA	F5,Y
				INX
				LDA	COUNT
				INC	COUNT
				CMP	#$07
				BNE	DCOM2
				JSR	GETNSEW
				LDA	#$00
				RTS
PLACES			DB	$16,$2B,$3A
				DB	$4E,$5F,$74
				DB	$83,$98
DOORS			DB	$3B,$BC,$E3
				DB	$F2,$F8,$B0
				DB	$FB,$B3
				DB	$3F,$FC,$F3
				DB	$F3,$FC,$F0
				DB	$FF,$F3
**************
ORBGRD			LDA	XPOS	
				CMP	#$08
				BNE	NOTORB
				LDA	DIRECTN
				CMP	#$0F
				BNE	NOTORB
				LDA	YPOS	
				CMP	#$0E
				BEQ	MAYBGRD
				CMP	#$10
				BEQ	MAYBORB
				BNE	NOTORB
MAYBGRD			LDA	ORBHERE
				BNE	NOTORB
*LDA TRACER+2     ;FIX THIS LATER
				AND	#$40
				BNE	NOTORB
				JSR	PICK_HALLTYPE
********************************
				DO	0
********************************
				LDA	#$90
				STA	SSTOREH
				LDA	#$1D
				STA	STRACK
				LDA	#$02
				STA	SSECTOR
				LDA	#$0E
				STA	READNUM
				STA	ORBHERE
				JSR	SREADIT
********************************
				FIN
********************************
				LDA	#$00
				STA	CAMP_HERE		;This has to be fixed
				JMP	$9000
NOTORB			LDA	#$00
				RTS
MAYBORB			LDA	PROGON	
				CMP	#$B7
				BEQ	NORBLOD
				LDA	CAMP_HERE		;This has to be fixed
				AND	#$78
				STA	CAMP_HERE		;This has to be fixed
				LDX	#OrbPed
				JSR	SLOAD_FILE
NORBLOD			JMP	$9C00
**************
EVATOR			LDA	#$40
				STA	PAGE
				JSR	CLEAR2
				JSR	NOSCAN
				LDA	#BLACK1
				STA	COLOR
				LDA	XPOS
				SBC	#$02
				ASL
				TAY
				PHA
				JSR	LINER
				LDA	#WHITE1
				STA	COLOR
				PLA
				TAY
				INY
				JSR	LINER
				STA	SCNDARY	
				JSR	MOVETO1
				STA	PRIMARY
				LDA	XPOS
				CMP	#$03
				BNE	FARELEV
				JSR	SET_CAMPFILES
				LDX	#cElevator
				JSR	SLOAD_FILE
				LDA	CAMP_HERE
				AND	#bit_Diagnose!$FF				;! means XOR
				STA	CAMP_HERE
				LDA	#$00						;Elevator 123 flag
				JMP	$9000
FARELEV			BIT	UNSTROB
:LOOP1			LDA	KEYBRD
				BPL	:LOOP1
				JSR	CPARER1
				BNE	FARELEV
				JMP	RDKEY
**************
DSIGN			JSR	HGR
********************************
				DO	0
********************************
				JSR	NOSCAN
				LDA	DOORED
				BEQ	DOORER
				JMP	NODOORD
DOORER			JSR	MOVETO2
				LDA	#RED
				STA	COLOR
				LDY	#$06
				JSR	LINER
				LDA	#<WRITPIC
				STA	TBLPNTL
				LDA	#>WRITPIC
				STA	TBLPNTH
				JSR	EXPANDR
				LDA	#$00
				STA	COUNT
ROLOOP			JSR	POINTIT
				LDY	#$0D
				LDA	(CHARDL),Y
				AND	#$F0
				CMP	#$10
				BEQ	GOTROID
				INC	COUNT
				LDA	COUNT
				CMP	GRPNUMB
				BNE	ROLOOP
				BEQ	NOASK	
GOTROID			JSR	QUESTIN	
				LDA	#$00
				STA	MAXTEXT
				JSR	INPUT2
REKEYER			LDA	TEXTBUF
				CMP	#$D9
				BEQ	DYES
				CMP	#$CE
				BEQ	DNO
				CMP	#$8D
				BNE	NORETTN
				JSR	CHAROUT
NORETTN			JSR	RECALL
				JMP	REKEYER
DYES			LDA	#$40
				STA	PAGE
				LDA	#$FF
				STA	DOORED
				LDY	#$00
				JSR	TEXTER
				LDY	#$06
				JSR	LINER
				STA	SCNDARY
				LDA	#$20
				STA	PAGE
				JSR	MOVETO1
				STA	PRIMARY
				JMP	NOASK
DNO				JSR	CHAROUT
				JSR	QUESTIN
				JMP	NOASK
NODOORD			LDA	#RED
				STA	COLOR
				LDY	#$06
				JSR	LINER
				LDY	#$00
				JSR	TEXTER
NOASK			PLA
				PLA
NOKEY			LDA	KEYBRD
				BPL	NOKEY
				JSR	CPARER1
				BEQ	GORD
				BIT	UNSTROB
				JMP	NOKEY
GORD			JMP	RDKEY
TOWORD			DB	$0A,$1E,$19
				DB	$8D
QUESTIN			LDY	#$01
				JSR	TEXTER
				LDY	#$09
ANLOOP			LDA	(CHARDL),Y
				STA	TEXTBUF,Y
				DEY
				BPL	ANLOOP
				LDY	#$09
SPLOOP			LDA	TEXTBUF,Y
				CMP	#$0A
				BNE	GOTASP
				DEY
				BPL	SPLOOP
GOTASP			INY
				LDX	#$00	
TOLOOP			LDA	TOWORD,X	
				STA	TEXTBUF,Y
				INY
				INX
				CPX	#$04
				BNE	TOLOOP
				JSR	LINE2
				LDY	#$02
				JMP	TEXTER

OLINE			DB	$00,$39,$2F
				DB	$00,$DB,$2F
				DB	$00,$DB,$51
				DB	$00,$39,$51
				DB	$00,$39,$30
				DB	$00,$D9,$30
				DB	$00,$D9,$50
				DB	$00,$3B,$50
				DB	$00,$3B,$30
				DB	$FF
TEXT0			DB	$09,$04,$34
				DB	$1E,$12,$13
				DB	$1D,$0A,$17
				DB	$0B,$1C,$15
				DB	$1D,$0A,$1E
				DB	$12,$0F,$0A
				DB	$0C,$19,$1C
				DB	$0E,$0F,$1C
				DB	$0A,$19,$10
				DB	$8D,$0A,$06
				DB	$3D,$0F,$17
				DB	$1A,$0F,$1C
				DB	$19,$1C,$0A
				DB	$1C,$1F,$1F
				DB	$13,$15,$28
				DB	$1D,$0A,$1C
				DB	$19,$23,$0B
				DB	$16,$8D,$11
				DB	$03,$46,$0E
				DB	$19,$17,$0B
				DB	$13,$18,$8D
				DB	$FF
TEXT1			DB	$09,$01,$7E
				DB	$0E,$19,$0A
				DB	$23,$19,$1F
				DB	$0A,$21,$0B
				DB	$18,$1E,$0A
				DB	$8D,$FF
TEXT2			DB	$09,$01,$86
				DB	$1E,$1C,$0B
				DB	$18,$1D,$16
				DB	$0B,$1E,$0F
				DB	$0A,$1E,$12
				DB	$0F,$0A,$21
				DB	$1C,$13,$1E
				DB	$13,$18,$11
				DB	$33,$0A,$8D
				DB	$FF
WRITPIC			DB	$34,$4B,$0A
				DB	$1D,$FE,$09
				DB	$00,$FE,$06
				DB	$0F,$FE,$14
				DB	$00,$18,$18
				DB	$FE,$05,$00
				DB	$FE,$06,$1E
				DB	$FE,$09,$00
				DB	$3C,$3C,$30
				DB	$30,$0C,$0C
				DB	$00,$00,$00
				DB	$3C,$3C,$00
				DB	$00,$0C,$0C
				DB	$FE,$09,$00
				DB	$19,$19,$60
				DB	$60,$79,$79
				DB	$00,$00,$00
				DB	$01,$01,$79
				DB	$79,$01,$01
				DB	$FE,$09,$00
				DB	$40,$40,$03
				DB	$03,$70,$70
				DB	$00,$00,$00
				DB	$73,$73,$70
				DB	$70,$73,$73
				DB	$FE,$09,$00
				DB	$01,$01,$66
				DB	$66,$07,$07
				DB	$00,$00,$00
				DB	$67,$67,$FE
				DB	$04,$61,$FE
				DB	$09,$00,$4F
				DB	$4F,$0F,$0F
				DB	$4F,$4F,$00
				DB	$00,$00,$4C
				DB	$4C,$4F,$4F
				DB	$4C,$4C,$FE
				DB	$06,$01,$00
				DB	$00,$00,$06
				DB	$06,$1E,$1E
				DB	$06,$06,$00
				DB	$00,$00,$1E
				DB	$1E,$06,$06
				DB	$1E,$1E,$FE
				DB	$04,$43,$4C
				DB	$4C,$FE,$05
				DB	$00,$0C,$0C
				DB	$3C,$3C,$FE
				DB	$05,$00,$3C
				DB	$3C,$00,$00
				DB	$1E,$1E,$18
				DB	$18,$06,$06
				DB	$00,$00,$00
				DB	$18,$18,$78
				DB	$78,$79,$79
				DB	$00,$00,$00
				DB	$79,$79,$61
				DB	$61,$79,$79
				DB	$FE,$06,$0C
				DB	$00,$00,$00
				DB	$33,$33,$30
				DB	$30,$43,$43
				DB	$00,$00,$00
				DB	$70,$70,$73
				DB	$73,$70,$70
				DB	$01,$01,$79
				DB	$79,$01,$01
				DB	$00,$00,$00
				DB	$06,$06,$01
				DB	$01,$66,$66
				DB	$00,$00,$00
				DB	$61,$61,$FE
				DB	$04,$67,$40
				DB	$40,$70,$70
				DB	$40,$40,$00
				DB	$00,$00,$0F
				DB	$0F,$43,$43
				DB	$0F,$0F,$00
				DB	$00,$00,$4F
				DB	$4F,$43,$43
				DB	$4F,$4F,$FE
				DB	$09,$00,$FE
				DB	$06,$1E,$00
				DB	$00,$00,$1E
				DB	$1E,$18,$18
				DB	$06,$06,$FE
				DB	$09,$00,$3C
				DB	$3C,$0C,$0C
				DB	$3C,$3C,$00
				DB	$00,$00,$FE
				DB	$06,$0C,$FE
				DB	$09,$00,$01
				DB	$01,$79,$79
				DB	$FE,$05,$00
				DB	$78,$78,$79
				DB	$79,$78,$78
				DB	$FE,$09,$00
				DB	$43,$43,$70
				DB	$70,$30,$30
				DB	$00,$00,$00
				DB	$30,$30,$70
				DB	$70,$33,$33
				DB	$FE,$09,$00
				DB	$FE,$04,$67
				DB	$60,$60,$00
				DB	$00,$00,$61
				DB	$61,$67,$67
				DB	$06,$06,$FE
				DB	$09,$00,$FE
				DB	$04,$43,$03
				DB	$03,$00,$00
				DB	$00,$FE,$04
				DB	$4C,$0F,$0F
				DB	$FE,$09,$00
				DB	$1E,$1E,$FE
				DB	$04,$06,$FE
				DB	$09,$00
********************************
				FIN
********************************
**************

NET				BIT	OPEN1
				BVS	NOOPE
				JMP	NO_SPECIAL
NOOPE			LDA	SRANGE
				PHA
				LDA	#$40
				STA	PAGE
				LDA	PICHERE
				CMP	#$01
				BEQ	NETHERE
				LDA	#$01
				STA	PICHERE
				JSR	CLEAR2
				LDA	#$01
				STA	SRANGE
				JSR	NOSCAN
				STA	SCNDARY
				JSR	CLOSE_NET
NETHERE			STA	SCNDARY
				BIT	UNSTROB
				JSR	BOXIN
				LDA	#$05
				STA	MAXTEXT
				LDA	#$8F
				LDY	#$A9
				JSR	INPUT
				LDY	#$05	
CHCKMOR			LDA	TEXTBUF,Y
				JSR	CONVERT
				TXA
				CMP	GDASH28,Y
				BNE	FAILER
				DEY
				BPL	CHCKMOR
				LDA	#$00
				PHA
				JMP	GOBOX
FAILER			LDA	#$FF
				PHA
GOBOX			JSR	SCROLLD
				PLA
				BEQ	PASSER
DOKEY			LDA	KEYBRD
				BPL	DOKEY
				PHA
				JSR	CLEAR1
				PLA
				JSR	CPARER2
				BEQ	GORDKEY
				BIT	UNSTROB
				JMP	DOKEY
PASSER			PLA
				PHA
				STA	SRANGE
				JSR	OPEN_NET
GORDKEY			PLA
				STA	SRANGE
				PLA
				PLA
				JMP	RDKEY

GDASH28			USR	(GN-28)-
				DB	$FF

CLOSE_NET		LDA	#WHITE1
				STA	COLOR
				LDY	#6				;Net edges
				JSR	LINER
				LDY	#0
				JSR	LINER	
				LDA	#GREEN
				STA	COLOR
				LDA	#$36
				STA	ALINE	
				LDA	#$A2
				STA	BLINE
				LDA	#0
				STA	A_COUNT
				LDA	#27
				STA	B_COUNT
DONET			LDY	ALINE
				LDX	A_COUNT
				JSR	NET_LINE
				LDA	YPNT
				STA	PITCH
				LDA	#$30
				STA	LENGTH
				JSR	SOUND
				LDY	BLINE
				LDX	B_COUNT
				JSR	NET_LINE
				LDA	#$FF	
				STA	PITCH
				LDA	#$10
				STA	LENGTH
				JSR	SOUND
				LDA	ALINE
				CLC
				ADC	#8
				STA	ALINE
				LDA	BLINE
				SEC
				SBC	#8
				STA	BLINE
				DEC	B_COUNT
				DEC	B_COUNT
				LDA	A_COUNT
				INC	A_COUNT
				INC	A_COUNT
				CMP	#$1A
				BNE	DONET
				RTS

NET_LINE		STX	COUNT
				STY	YPNT
				LDA	EXES,X
				STA	XPNT
				TAX
				TYA
				LDY	#0
				JSR	HPOSN
				LDA	#$16
				SEC
				SBC	XPNT
				LDX	#0
				LDY	YPNT
				JSR	HLIN

				LDX	COUNT
				LDA	NUMBER,X	
				BEQ	OUTN
				PHA
				LDA	#WHITE1
				STA	COLOR
				LDY	#0
				LDX	#$6F
				LDA	YPNT
				JSR	HPOSN
				PLA
				PHA
				CMP	#$01
				BEQ	ONLY1
				LDX	#0
				LDA	#$7B	
				STA	SCRATCH
				LDY	YPNT
				JSR	HLIN
				LDA	COUNT
				SEC
				SBC	#$0B	
				ASL
				CLC
				ADC	#$7D	
				TAX
				LDA	YPNT
				LDY	#0
				JSR	HPOSN
ONLY1			LDA	COUNT
				CMP	#$14	
				BCC	ALLREST
				LDA	#$A7	
				JMP	USE169
ALLREST			SEC
				SBC	#$05
				ASL
				ADC	#$7D	
USE169			STA	SCRATCH	
				LDY	YPNT
				LDX	#0
				JSR	HLIN
				PLA
				CMP	#$03
				BCC	OUTN
				LDX	#$9B	
				LDA	YPNT
				LDY	#0
				JSR	HPOSN
				LDA	COUNT
				CMP	#$10	
				BCS	ONE69
				SEC
				SBC	#$0D	
				ASL
				ASL
				CLC
				ADC	#$B3	
				JMP	USEIT2
ONE69			LDA	#$A7	
USEIT2			STA	SCRATCH
				LDY	YPNT
				LDX	#0
				JSR	HLIN
OUTN			LDA	#GREEN
				STA	COLOR
				RTS

NUMBER			DB	$00,$00,$00
				DB	$00,$00,$01
				DB	$01,$01,$01
				DB	$01,$01,$02
				DB	$02,$03,$03
				DB	$03,$03,$03
				DB	$03,$03,$02
				DB	$02,$02,$00
				DB	$00,$00,$00
				DB	$00

NET_EDGES		DB	$00,$50,$36
				DB	$00,$2F,$6C
				DB	$00,$50,$A2
				DB	$FE
				DB	$00,$C6,$36
				DB	$00,$E7,$6C
				DB	$00,$C6,$A2
				DB	$FF

EXES			DB	$51,$4D,$4B
				DB	$49,$47,$45
				DB	$41,$3F,$3D
				DB	$3B,$39,$35
				DB	$33,$31,$31
				DB	$33,$35,$39
				DB	$3B,$3D,$3F
				DB	$41,$45,$47
				DB	$49,$4B,$4D
				DB	$51

SOUND			LDY	#$00
BYTE			LDA	PCHECK,Y
				LDX	#$08
SHIFTS			LSR
				BNE	NEXTBIT
				STA	CLICK
				STA	CLICK
NEXTBIT			DEX
				BNE	SHIFTS	
				LDX	PITCH
DELAY			DEX
				BNE	DELAY
				INY
				DEC	LENGTH
				BNE	BYTE	
				RTS

BOXIN			LDA	#$20
				STA	PAGE
				JSR	CLEAR1
				LDA	#WHITE1
BOXIN2			STA	COLOR
				LDY	#$01	
				JSR	LINER	
				LDY	#$04
MORCODE			LDA	CODEWRD,Y
				STA	TEXTBUF,Y
				DEY
				BPL	MORCODE
				LDA	#$65
				LDY	#$A9
				JSR	LINE
				LDA	#$12
				STA	XCOORD
				LDA	#$03
				STA	SHIFT
				LDY	#$06
MORSIGN			LDA	NUMSIGN,Y
				STA	CHARTAB,Y
				DEY
				BPL	MORSIGN
				JSR	CHAROUT
				INC	XCOORD
				LDY	#$06
MORSGN2			LDA	NUMSIGN+7,Y
				STA	CHARTAB,Y
				DEY
				BPL	MORSGN2
				JSR	CHAROUT
BISTOP			JSR	SCROLLU
				LDA	#$40
				STA	PAGE
				RTS

CODEWRD			USR	(CODE)

NUMSIGN			DB	%01101100
				DB	%01101100
				DB	%01111111
				DB	%01101100
				DB	%01111111
				DB	%01101100
				DB	%01101100

				DB	%00000000
				DB	%00000000
				DB	%00000011
				DB	%00000000
				DB	%00000011
				DB	%00000000
				DB	%00000000

SCROLLU			LDA	#$B0
				STA	BEGLINE
MORUP1			LDA	#$A7
				STA	LINENUM
				LDX	BEGLINE
MORUP2			LDY	LINENUM
				LDA	LOBYTES,Y
				STA	SCREENL
				LDA	HIBYTES,Y
				ORA	#$20
				STA	SCREENH
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				LDY	#$0E
MORUP3			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	#$1A	
				BNE	MORUP3
				INX
				INC	LINENUM
				CPX	#$B1
				BNE	MORUP2
				LDA	#$60	
				JSR	WAIT
				LDA	BEGLINE
				DEC	BEGLINE
				CMP	#$A7
				BNE	MORUP1
				RTS

SCROLLD			LDA	#$A7
				STA	ENDLINE
MORDWN1			LDX	#$AF
MORDWN2			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	#$40
				STA	SCREENH
				INX
				LDA	LOBYTES,X
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$40
				STA	DESTINH
				DEX
				LDY	#$0E
MORDWN3			LDA	(SCREENL),Y
				STA	(DESTINL),Y
				INY
				CPY	#$1A	
				BNE	MORDWN3
				CPX	ENDLINE
				BEQ	NOMORDW
				DEX
				JMP	MORDWN2
NOMORDW			LDA	#$60
				JSR	WAIT
				LDA	ENDLINE
				INC	ENDLINE
				CMP	#$AF
				BEQ	LASTDWN
				JSR	CLRLINE
				JMP	MORDWN1
LASTDWN			LDA	DESTINL
				STA	SCREENL
				LDA	DESTINH
				STA	SCREENH
				JSR	CLRLINE
				RTS

CLRLINE			LDA	#$00
				LDY	#$0E
CLRLIN2			STA	(SCREENL),Y
				INY
				CPY	#$1A	
				BNE	CLRLIN2	
				RTS

OPEN_NET		LDA	SRANGE
				PHA
				LDA	#$20	
				STA	PAGE
				LDA	#$60
				STA	BISTOP
				LDA	#$00
				JSR	BOXIN2
				LDA	#$20
				STA	BISTOP
				LDA	#WHITE1
				STA	COLOR
				LDA	#$01
				STA	SRANGE
				JSR	NOSCAN
				LDY	#6				;Net edges
				JSR	LINER
				LDA	#$9E
				STA	ALINE
				LDA	#$3A
				STA	BLINE
DONET2			LDX	ALINE
				JSR	UN_NETLINE
				LDA	ALINE
				STA	PITCH
				LDA	#$30
				STA	LENGTH
				JSR	SOUND
				LDX	BLINE
				JSR	UN_NETLINE
				LDA	#$FF
				STA	PITCH
				LDA	#$10
				STA	LENGTH
				JSR	SOUND
				LDA	ALINE
				SEC
				SBC	#8
				STA	ALINE
				LDA	BLINE
				CLC
				ADC	#8
				STA	BLINE
				CMP	#$AA
				BNE	DONET2
				LDA	#BLACK1
				STA	COLOR
				LDY	#6				;Net edges
				JSR	LINER
				PLA
				STA	SRANGE
				LDA	#WHITE1
				STA	COLOR
				JSR	NOSCAN
				LDA	PRIMARY
				LDA	#$00
				STA	OPEN1
				RTS

UN_NETLINE		LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#39
:1				LDA	(SCREENL),Y
				STA	(DESTINL),Y
				DEY
				BPL	:1
				RTS

HOLEDAT			DB	$00,$5F,$AF
				DB	$00,$B8,$AF
				DB	$00,$BD,$B2
				DB	$00,$5A,$B2
				DB	$00,$5F,$AF
				DB	$FF
BOXDATA			DB	$00,$62,$A7
				DB	$00,$62,$B0
				DB	$00,$63,$B0
				DB	$00,$63,$A7
				DB	$00,$B4,$A7
				DB	$00,$B4,$B0
				DB	$00,$B5,$B0
				DB	$00,$B5,$A7
				DB	$FF
**************
ORBHERE			DB	$00
DOORED			DB	$00
OPEN1			DB	$FF
**************

SHELL17			DB	$3D,$FD,$DF
				DB	$FF,$F0,$4C
				DB	$03,$30,$32
				DB	$30,$00,$EC
				DB	$00,$03,$00
				DB	$CF,$0F,$30
				DB	$C3,$30,$00
				DB	$00,$EF,$BF
				DB	$B0,$CF,$0F
				DB	$22,$C0,$10
				DB	$03,$EF,$00
				DB	$0E,$B0,$CF
				DB	$02,$33,$F3
				DB	$30,$00,$00
				DB	$BF,$C0,$00
				DB	$C3,$00,$C0
				DB	$33,$30,$00
				DB	$00,$0F,$F0
				DB	$F0,$C0,$00
				DB	$F0,$23,$B0
				DB	$00,$00,$00
				DB	$F0,$00,$C0
				DB	$00,$F2,$33
				DB	$F0,$00,$3C
				DB	$03,$0E,$00
				DB	$C0,$8C,$BF
				DB	$03,$F0,$00
				DB	$30,$08,$FF
				DB	$00,$C0,$3C
				DB	$B3,$C0,$F0
				DB	$02,$08,$03
				DB	$30,$00,$CF
				DB	$00,$FF,$20
				DB	$B0,$00,$C0
				DB	$00,$0B,$C0
				DB	$4C,$80,$FE
				DB	$0C,$30,$03
				DB	$C0,$00,$03
				DB	$00,$C0,$00
				DB	$FF,$03,$30
				DB	$30,$00,$03
				DB	$00,$C0,$E0
				DB	$00,$F3,$00
				DB	$F0,$0F,$C0
				DB	$0C,$EF,$A0
				DB	$F0,$C0,$FC
				DB	$F0,$30,$00
				DB	$3F,$C3,$03
				DB	$C0,$F0,$00
				DB	$32,$3C,$90
				DB	$20,$3F,$CF
				DB	$F0,$00,$F0
				DB	$EE,$C0,$0C
				DB	$F0,$0F,$C0
				DB	$3F,$F3,$C0
				DB	$E0,$BB,$88
				DB	$30,$30,$3F
				DB	$FF,$F7,$FF
				DB	$F0
F2				DB	$3F,$FF,$F7
				DB	$FF,$F0,$F3
				DB	$0C,$3B,$FF
				DB	$F0,$00,$00
				DB	$20,$C0,$C0
				DB	$E2,$08,$CC
				DB	$00,$30,$0F
				DB	$2F,$8F,$FF
				DB	$F0,$C3,$CC
				DB	$F0,$02,$10
				DB	$0F,$FC,$00
				DB	$03,$F0,$F0
				DB	$B0,$F0,$0F
				DB	$B0,$00,$03
				DB	$CF,$FC,$00
				DB	$F0,$FC,$00
				DB	$0F,$F0,$0F
				DB	$00,$EA,$F2
				DB	$A0,$C3,$FF
				DB	$3C,$3F,$F0
				DB	$0C,$00,$00
				DB	$00,$00,$CF
				DB	$FF,$3C,$3E
				DB	$F0,$30,$00
				DB	$33,$F3,$E0
				DB	$7F,$FF,$E8
				DB	$C0,$F0,$00
				DB	$00,$00,$CF
				DB	$00,$F3,$CF
				DB	$FF,$F3,$F0
				DB	$0F,$BC,$FF
				DB	$C0,$00,$C0
				DB	$00,$00,$3F
				DB	$F0,$3B,$3F
				DB	$F2,$F0,$00
				DB	$C3,$CC,$3C
				DB	$0F,$F0,$00
				DB	$00,$00,$EC
				DB	$00,$C3,$88
				DB	$3F,$0F,$F0
				DB	$3C,$3B,$F0
				DB	$FC,$00,$C3
				DB	$CE,$2F,$0B
				DB	$F0,$0F,$00
				DB	$30,$FC,$00
				DB	$C3,$CB,$CF
				DB	$0B,$F0,$00
				DB	$2F,$CC,$FC
				DB	$A0,$C3,$F0
				DB	$F2,$08,$10
				DB	$3F,$0C,$03
				DB	$FF,$C0,$C3
				DB	$88,$B8,$CC
				DB	$F0,$3B,$03
				DB	$83,$AF,$80
				DB	$C3,$CC,$F0
				DB	$00,$30,$37
				DB	$7F,$DF,$7F
				DB	$F0
F3				DB	$3D,$FF,$FF
				DB	$FD,$F0,$C3
				DB	$30,$00,$CC
				DB	$30,$0F,$BE
				DB	$FE,$FB,$C0
				DB	$F0,$0F,$FF
				DB	$00,$F0,$00
				DB	$00,$30,$00
				DB	$00,$70,$0F
				DB	$FF,$00,$D0
				DB	$0F,$BC,$88
				DB	$FB,$C0,$C0
				DB	$00,$F0,$00
				DB	$30,$0E,$EC
				DB	$EC,$EE,$C0
				DB	$F3,$CE,$0B
				DB	$3C,$F0,$00
				DB	$00,$EC,$00
				DB	$00,$F3,$CC
				DB	$F3,$3C,$F0
				DB	$0F,$3C,$88
				DB	$F3,$C0,$C3
				DB	$C3,$FC,$3C
				DB	$10,$0C,$C0
				DB	$30,$0C,$F0
				DB	$FC,$33,$FC
				DB	$C3,$F0,$03
				DB	$CF,$CF,$CF
				DB	$00,$F0,$80
				DB	$00,$22,$F0
				DB	$03,$CF,$CF
				DB	$CF,$00,$FC
				DB	$33,$FC,$C3
				DB	$F0,$0C,$C0
				DB	$30,$0C,$F0
				DB	$C3,$C3,$FC
				DB	$3C,$30,$0F
				DB	$3C,$88,$F3
				DB	$C0,$F3,$CC
				DB	$F3,$3C,$F0
				DB	$00,$00,$EC
				DB	$00,$00,$F3
				DB	$CE,$0B,$3C
				DB	$F0,$0E,$EC
				DB	$EC,$EE,$C0
				DB	$C0,$00,$F0
				DB	$00,$30,$0F
				DB	$BC,$88,$FB
				DB	$C0,$70,$0F
				DB	$FF,$00,$D0
				DB	$00,$00,$30
				DB	$00,$00,$F0
				DB	$0F,$FF,$00
				DB	$F0,$0F,$FE
				DB	$FE,$FF,$C0
				DB	$C3,$80,$00
				DB	$2C,$30,$3D
				DB	$BA,$AA,$B9
				DB	$F0
F4				DB	$3F,$FF,$DD
				DB	$FD,$F0,$C0
				DB	$30,$FC,$03
				DB	$30,$00,$CC
				DB	$C0,$00,$00
				DB	$C3,$BF,$BC
				DB	$03,$30,$3F
				DB	$00,$33,$FF
				DB	$30,$42,$EF
				DB	$B0,$00,$D0
				DB	$3F,$00,$CC
				DB	$33,$00,$C3
				DB	$BC,$EC,$FF
				DB	$F0,$00,$CC
				DB	$33,$CC,$C0
				DB	$C0,$30,$3B
				DB	$AA,$B0,$3F
				DB	$EC,$0C,$33
				DB	$30,$C0,$FC
				DB	$3A,$FB,$F0
				DB	$3F,$03,$F3
				DB	$CC,$C0,$43
				DB	$EA,$AC,$3B
				DB	$30,$00,$3C
				DB	$0C,$33,$00
				DB	$C3,$3B,$AC
				DB	$EC,$30,$3F
				DB	$33,$F3,$0C
				DB	$00,$C0,$EC
				DB	$3B,$EC,$30
				DB	$0F,$CC,$0C
				DB	$33,$30,$FB
				DB	$B0,$3B,$3B
				DB	$F0,$30,$30
				DB	$F3,$0C,$C0
				DB	$EE,$C3,$EC
				DB	$0E,$90,$0F
				DB	$C3,$0C,$F3
				DB	$30,$F0,$0E
				DB	$B3,$3E,$F0
				DB	$3F,$F0,$F3
				DB	$00,$C0,$C0
				DB	$3E,$CC,$3E
				DB	$F0,$00,$C3
				DB	$33,$03,$30
				DB	$C3,$BE,$B3
				DB	$33,$B0,$3F
				DB	$0C,$CC,$EC
				DB	$C0,$42,$EB
				DB	$EC,$CF,$B0
				DB	$3F,$03,$33
				DB	$30,$30,$C3
				DB	$BC,$3B,$3F
				DB	$B0,$00,$CC
				DB	$0C,$00,$C0
				DB	$C0,$30,$0F
				DB	$3C,$F0,$3F
				DB	$FF,$FD,$F7
				DB	$F0
F5				DB	$1F,$FF,$FD
				DB	$FF,$F0,$C0
				DB	$3C,$80,$00
				DB	$F0,$00,$3F
				DB	$EF,$FF,$F0
				DB	$C0,$F2,$00
				DB	$03,$F0,$00
				DB	$FF,$3F,$FB
				DB	$C0,$43,$C8
				DB	$FC,$0F,$F0
				DB	$03,$FC,$00
				DB	$0F,$00,$CF
				DB	$20,$C3,$FE
				DB	$F0,$0F,$30
				DB	$3F,$FC,$00
				DB	$FF,$C0,$00
				DB	$33,$F0,$3C
				DB	$8F,$FF,$CC
				DB	$00,$FF,$20
				DB	$00,$F3,$F0
				DB	$32,$03,$FF
				DB	$0C,$00,$FC
				DB	$38,$03,$F3
				DB	$F0,$08,$00
				DB	$FC,$03,$00
				DB	$F0,$3F,$0F
				DB	$F3,$D0,$23
				DB	$C0,$3C,$03
				DB	$00,$EC,$FF
				DB	$0F,$F3,$B0
				DB	$03,$00,$3C
				DB	$0F,$20,$FC
				DB	$FF,$0B,$C0
				DB	$F0,$03,$00
				DB	$FC,$00,$80
				DB	$7C,$FC,$02
				DB	$C3,$F0,$00
				DB	$C3,$FF,$02
				DB	$30,$FC,$F0
				DB	$00,$8F,$F0
				DB	$00,$CF,$FF
				DB	$C8,$F0,$FC
				DB	$C0,$00,$3F
				DB	$F0,$00,$FF
				DB	$F0,$33,$C0
				DB	$FB,$FC,$30
				DB	$8F,$30,$03
				DB	$C0,$00,$FF
				DB	$00,$FF,$03
				DB	$F2,$3C,$30
				DB	$0F,$BF,$F3
				DB	$FC,$00,$FC
				DB	$00,$08,$F0
				DB	$30,$3F,$FF
				DB	$EF,$F0,$00
				DB	$F0,$00,$23
				DB	$C0,$30,$3F
				DB	$FF,$7F,$FD
				DB	$F0
F6				DB	$37,$7F,$DF
				DB	$7F,$F0,$C3
				DB	$CC,$F0,$00
				DB	$30,$3B,$2F
				DB	$83,$F3,$80
				DB	$C3,$00,$3C
				DB	$3C,$F0,$3B
				DB	$FF,$F3,$C0
				DB	$00,$4C,$00
				DB	$C0,$FC,$D0
				DB	$0C,$FF,$BF
				DB	$C2,$F0,$F2
				DB	$00,$00,$BC
				DB	$E0,$00,$FF
				DB	$BF,$C0,$00
				DB	$FF,$03,$C0
				DB	$FC,$E0,$00
				DB	$33,$33,$03
				DB	$80,$FF,$3C
				DB	$3C,$FC,$E0
				DB	$00,$C0,$C0
				DB	$E0,$00,$FC
				DB	$FF,$FF,$08
				DB	$E0,$00,$0C
				DB	$0C,$FE,$C0
				DB	$FF,$C0,$03
				DB	$0C,$E0,$00
				DB	$0F,$FC,$00
				DB	$00,$FF,$FF
				DB	$FF,$0C,$E0
				DB	$00,$00,$00
				DB	$00,$00,$7F
				DB	$FF,$FF,$0C
				DB	$E0,$00,$08
				DB	$88,$FE,$C0
				DB	$F3,$EA,$AB
				DB	$08,$E0,$0C
				DB	$08,$88,$20
				DB	$00,$CB,$FF
				DB	$FF,$FC,$E0
				DB	$03,$00,$00
				DB	$03,$80,$FC
				DB	$FF,$FF,$FC
				DB	$E0,$03,$0F
				DB	$BC,$00,$00
				DB	$FF,$C3,$C3
				DB	$FC,$E0,$00
				DB	$3F,$3F,$02
				DB	$F0,$F3,$0C
				DB	$30,$FC,$D0
				DB	$03,$F0,$C3
				DB	$C0,$00,$F0
				DB	$3C,$3C,$3C
				DB	$F0,$0F,$C3
				DB	$33,$F3,$80
				DB	$C0,$33,$C0
				DB	$00,$30,$3F
				DB	$7D,$FF,$FF
				DB	$F0
