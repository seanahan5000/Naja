*-------------------------------
*
*-------------------------------

REPLACE			LDA	#$EE	
				STA	PARTALL
				LDA	#$1C
				JSR	PICK_A_ROBOT
				JSR	WHOSE_CREDITS
				JSR	PACSUB
				LDA	THE_ROBOT
				JSR	POINTIT
				JSR	REVERSE
				JSR	TOTALUP
				JSR	ROSTAT2
				LDX	PICK
				LDA	ON1,X
				ORA	#$0F
				STA	ON1,X
				LDY	#$23
				JSR	TEXTER
				LDA	#7
				JSR	SET_LEGALS
				LDX	#$FF
				LDY	#e2_SLOT
				LDA	(CHARDL),Y
				CMP	#$FF
				BEQ	:1
				STX	LEGALS+scrnHEAD
:1				LDA	LWEAPON
				CMP	#$06
				BNE	:2
				STX	LEGALS+scrnWEAPONL
:2				LDA	RWEAPON
				CMP	#$06
				BNE	:3
				STX	LEGALS+scrnWEAPONR
:3				LDX	#-1
:4				INX
				LDA	LEGALS,X
				BNE	:4
				STX	CURSOR
				JSR	CURFLIP
				JSR	VIEWER
				JSR	GBOXSUB
				JSR	CURFLIP
				JSR	PPEOR
				JSR	BTRANS
				JSR	CHURSIT
				LDA	CURSOR
				ASL
				ASL
				LDX	#0
				TAY
RELOOPB			LDA	BODTOT,Y
				STA	THE_PRICE,X
				INY
				INX
				CPX	#$04	
				BNE	RELOOPB
				JSR	GTRADE2
				LDA	CURSOR
				JSR	DRAW_SCREEN
				JSR	DELABLE
				JSR	TOPLEVL
				LDX	PICK
				LDA	#$FF	
				STA	ON1,X	
				JSR	VIEWER
				JSR	MINISUB
				LDA	CURSOR
				AND	#%11111110
				CMP	#scrnWEAPONL
				BNE	NOWEPO
				LDA	CURSOR
				PHA
				JSR	WEPONLY
				JSR	CREATE_PART
				LDA	THE_ROBOT
				JSR	POINTIT
				LDY	#e5_ROBRGT+3
				PLA
				LSR
				BCS	:1
				LDY	#e3_ROBLFT+3
:1				LDX	#3
:2				LDA	ROBOTBUF,Y
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:2
				JMP	PARTOUT

NOWEPO			JSR	ZOOMUP
				JSR	BOXCURS
				LDA	SAMFLAG
				BEQ	:1
				JMP	OPTIONS
:1				JSR	TOSLOT
				JSR	CREATE_PART
				LDA	THE_ROBOT
				JSR	POINTIT

PARTPRO			LDX	SCRPICK
				CPX	#scrnPROGRAM
				BNE	:1
				LDY	#e15_PROGRAM+1
				LDA	ROBOTBUF+e15_PROGRAM+1
				STA	(CHARDL),Y
				LDY	#level+1
				LDA	ROBOTBUF+level+1
				STA	(CHARDL),Y
:1

PARTENR			LDY	#energymax+2
:1				LDA	ROBOTBUF,Y
				STA	(CHARDL),Y
				DEY
				CPY	#energymax-1
				BNE	:1
				SEC
:2				LDA	(CHARDL),Y
				SED
				SBC	ROBOTBUF+3,Y
				CLD
				DEY
				CPY	#energylev-1
				BNE	:2
				BCS	:4
				LDY	#energylev+2
:3				LDA	ROBOTBUF+3,Y
				STA	(CHARDL),Y
				DEY
				CPY	#energylev-1
				BNE	:3
:4

PARTDAM			LDY	#damagemax+1
:1				LDA	ROBOTBUF,Y
				STA	(CHARDL),Y
				DEY
				CPY	#damagemax-1
				BNE	:1
				LDA	#$75
				STA	SEVENX+1
				LDY	#damagemax+1
				SEC
				LDA	(CHARDL),Y
				SED
				LDY	#damagelev+1
				SBC	(CHARDL),Y
				STA	SCRATCH
				INY
				LDA	(CHARDL),Y
				LDY	#damagelev
				SBC	(CHARDL),Y
				CLD
				BCC	:2
				ORA	SCRATCH
				BEQ	:2
				LDA	#$50
				STA	SEVENX+1
:2				LDX	#$01
				LDY	#damagelev+1
:3				LDA	(CHARDL),Y
				STA	THE_PRICE+2,X
				LDA	#$00
				STA	THE_PRICE,X
				DEY
				DEX
				BPL	:3
				LDA	#$60
				STA	NOT78
				JSR	SEVENX
				LDA	#$EA
				STA	NOT78
				LDA	#$88
				STA	SEVENX+1
				LDY	#damagelev+1
				LDX	#$01
:4				LDA	THE_PRICE+2,X
				STA	(CHARDL),Y
				DEY
				DEX
				BPL	:4

PARTOTHER		LDY	#e1_HEAD+3
:1				LDA	ROBOTBUF,Y
				STA	(CHARDL),Y
				DEY
				CPY	#e1_HEAD-1
				BNE	:1

				LDY	#baselwreflex
:2				LDA	ROBOTBUF,Y
				STA	(CHARDL),Y
				DEY
				CPY	#basestrength-1
				BNE	:2

				LDY	#baseshielding
				LDA	ROBOTBUF+baseshielding
				STA	(CHARDL),Y
				INY
				LDA	ROBOTBUF+baseshielding+1
				STA	(CHARDL),Y

PARTOUT			JSR	CALC_ALL
				JSR	TAKE_RTOTNUM
				JMP	OPTIONS	

GTRADE2			LDA	#$60
				STA	NOT78
				JSR	SEVENX
				LDA	#$EA
				STA	NOT78
				LDX	#$03
:1				LDA	THE_PRICE,X
				STA	TRADEIN,X
				DEX
				BPL	:1
				RTS

ZOOMUP			LDA	#$00	
				STA	POINTER
				LDY	SCRPICK
				LDA	NUMCATS,Y
				STA	MAXMOD2+1
COLOOP1			LDX	POINTER
				LDA	POINTLV,X
				BEQ	COSKIP1
				CMP	#$15
				BCS	COSKIP3
				STA	MAXMOD1+1
				LDA	#$00
				STA	POINTLV,X
				TXA
				LDY	SCRPICK
				CLC
				ADC	BEGCATS,Y
				JSR	POINTAT
COLOOP2			LDX	POINTER
				INC	POINTLV,X
				JSR	BIGSUB
				JSR	UPDSUB
				LDA	SCRPICK
				CMP	#scrnMOVEMENT
				BNE	COSKIP2
				LDA	#$FF
				JSR	PLUGUP
				JSR	UPMOVE
				LDA	#$14
				JSR	PLUGUP
COSKIP2			LDX	POINTER
				LDA	POINTLV,X
MAXMOD1			CMP	#$FF
				BNE	COLOOP2
COSKIP1			INC	POINTER
				LDA	POINTER
MAXMOD2			CMP	#$FF
				BNE	COLOOP1
COSKIP3			LDY	SCRPICK
				LDA	BEGCATS,Y
				JMP	POINTAT

TOPLEVL			LDY	SCRPICK
				LDA	NUMCATS,Y
				CLC
				ADC	BEGCATS,Y
				STA	SCRATCH
				LDX	BEGCATS,Y
				LDY	#$00
PVLOOPB			LDA	SLOT,X
				STA	POINTLV,Y
				STA	DUPNTLV,Y
				INY
				INX
				CPX	SCRATCH
				BNE	PVLOOPB
				RTS
