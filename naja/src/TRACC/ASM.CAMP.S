				TR	ON
				EXP	OFF
				LST	OFF

				USE	/NAJA/VARS/MACROS
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/THALL.VARS
				PUT	/NAJA/VARS/TCTRL.VARS

*-------------------------------
* REFORMAT ZPAGE

rYHOLD1			=	$C0
rYHOLD2			=	$C1
rYSORC			=	$C2
rYDEST			=	$C3
rARRCURS		=	$C4
rSOURCE			=	$C5
rFLPFLAG		=	$C6
rSTART			=	rFLPFLAG
rCOUNTX			=	$C7
rCOUNTY			=	$C8
rSWFLAG			=	$C9
rLINECNT		=	rSWFLAG
rSCRACH2		=	$CA
*

MCURSOR			=	$CC
CURHOLD			=	$CD
LEFHOLD			=	$CE
RITHOLD			=	$CF

*-------------------------------
* TRADE ZPAGE

tVPNTL			=	$C0
tVPNTH			=	$C1
tLPNTL			=	$C2
tLPNTH			=	$C3
tSMAN			=	$C4
tDMAN			=	$C5
tSEMENT			=	$C6
tDEMENT			=	$C7
tSEOFF			=	$C8
tDEOFF			=	$C9
tLLINE			=	$CA
tRLINE			=	$CB

*-------------------------------

LINENUM			=	$00
SCRATCH			=	$06
ENDLINE			=	$06
BEGLINE			=	$07
ALINE			=	$12
BLINE			=	$13
COLUMN			=	$14

OFFSET			=	$00
COUNTER			=	$03				;TEMP

COUNT1			EQU	$01
COUNT2			EQU	$02
COUNT3			EQU	$08
MAXBACK			EQU	$0A
MAXCARY			EQU	$0B	
ELECT			EQU	$10
PHYSIC			EQU	$11
OTHER			EQU	$14	
DYTOP			EQU	$15
DYBOT			EQU	$16
SYTOP			EQU	$17
SYBOT			EQU	$18

*--------------------------------
* Used only in DIVIDE_12 routine
*--------------------------------
divDVND			=	$14				;$15
divQUOT			=	$16				;$17
divADD			=	$18				;$19


TBUFFER			EQU	$0210

Swing			=	0
Shot			=	1
Use				=	2
Heal			=	3
Round			=	4
Throw			=	5


*-------------------------------
				ORG	$9D00
				PUT	CAMP/LOADER17
				DS	\,$EE

				ORG	$D900
				PUT	CAMP/FIGHT.COMMONS
				PUT	CAMP/TRACC.ONLY
				DS	\,$EE
				DS	512
				ERR	*-$E000

				ORG	$DC00
				PUT	CAMP/TRACC.TEXT.T
				DS	\,$EE
				ERR	*-$E000
				SAV	LOADER17
*-------------------------------


*-------------------------------
				ORG	$D000
				PUT	CAMP/ENUSE.TABLES
				PUT	CAMP/C.TRADE1
				PUT	CAMP/C.TRADE2
				DS	\,$EE
				ERR	*-$D900
				SAV	CAMP.D000.M1
*-------------------------------


*-------------------------------
				ORG	$D000
				PUT	CAMP/TRACC.TEXT.M
				DS	\,$EE
				ERR	*-$DC00
				SAV	CAMP.D000.M2
*-------------------------------


				ORG	$E000
CAMP_VECTOR		JMP	CAMPER
DYIN_VECTOR		JMP	KILLED_HIM
DEAD_VECTOR		JMP	FORCE_CAMP
CALC_ALL		JSR	CALC_STATS
				JSR	CALC_SHIELDIN
				JMP	CALC_POWRUSE

				JMP	$FFFF
				JMP	$FFFF
DEBUG_VECTOR	JMP	dBUGGER

				PUT	CAMP/MISC.COMMONS
				PUT	CAMP/KEY.COMMONS
				PUT	CAMP/SCAN.COMMONS
				PUT	CAMP/DRAIN.INFLICT
				PUT	CAMP/ENRGY.COMMONS
				PUT	CAMP/CAMP.COMMONS

				PUT	CAMP/T.CAMP
				PUT	CAMP/C.ISTATS
				PUT	CAMP/I.MOVER

TRADE_SUB1		JSR	BANK_2			;These 3 routines are used
				STX	CRDHEAD+11		;   by TRADE to access the text
				JMP	BANK_1			;   in bank 2 when calling
TRADE_SUB2		PHA
				JSR	BANK_2			;   from bank 1
				PLA
				STA	ORBOX2+8
				STA	ORBOX2+11
				JMP	BANK_1
TRADE_SUB3		JSR	BANK_2
				LDA	TLEAVE+2
				STA	TCANCEL+2
				JMP	BANK_1
TRADE_SUB4		JSR	BANK_2
				STX	TLEAVE+2
				JMP	BANK_1
TRADE_SUB5		JSR	BANK_2
				JSR	FLUSH_NAME
				JMP	BANK_1
USE_SUB1		JSR	BANK_2
				STX	TEXT1
				STY	TEXT1+1
				JMP	BANK_1
FACE_SUB1		JSR	BANK_2
				STX	ACCORD_SHELL
				STY	ACCORD_FACE
				LDX	#<ACCORD+3
				LDY	#>ACCORD+3
				JSR	FLUSH_NAME
				JMP	BANK_1
DEAD_SUB1		JSR	BANK_2
				STX	DYINTEXT
				STX	DEADTEXT
				STX	BROKTEXT
				STY	DYINTEXT+1
				STY	DEADTEXT+1
				STY	BROKTEXT+1
				JMP	BANK_1

LOADER_FLAG		DB	$00				;Used only by loader17

				PUT	DEBUGGER

				DS	$FFFF-151-*+1

DBL_TEXTER		PHA
				JSR	TEXTER
				PLA
				TAY
TEXTER			JSR	BANK_2
				TYA
				ASL	A
				TAY
				LDA	TEXTS,Y
				STA	POINTL
				INY
				LDA	TEXTS,Y
				STA	POINTH
				JSR	TEXTOUT
				JMP	BANK_1

SET_CAMPFILES	LDX	#<CAMP_FILES
				LDY	#>CAMP_FILES
				JMP	SET_FILE_TABL

CAMP_FILES
			do	ORIGINAL

				DB	$A0				; cCtrlCommon
				DW	$01B0
				DB	$04

				DB	$A4				; cControl17
				DW	$01B4
				DB	$0C

				DB	$A4				; cControl15
				DW	$01B4
				DB	$0C

				DB	$A4				; cControl13
				DW	$01B4
				DB	$0C

				DB	$A4				; cControl11
				DW	$01B4
				DB	$0C

				DB	$A4				; cControl9
				DW	$01B0			;*** change?
				DB	$0C

				DB	$98				; Findment
				DW	$0160
				DB	$08

				DB	$90				; Elevator
				DW	$0170
				DB	$0C

				DB	$78				; Reformat/Regenerate/Compress
				DW	$01C0
				DB	$0E

				DB	$86				; Diagnose
				DW	$01CE
				DB	$11

				DB	$FF				;*** UNUSED ***
				DW	$FFFF
				DB	$FF

				DB	$60				; Tunnels
				DW	$01F0
				DB	$18

				DB	$D9				; Tracc Camp A (cTraccCampA)
				DW	$0222
				DB	$07

				DB	$DC				; Tracc Camp B (cTraccCampB)
				DW	$0229
				DB	$04

				DB	$B0				; Tracc Camp C (cCampCommons)
				DW	$01E0
				DB	$0B

			else

				DB	$A0				; cCtrlCommon
				DW	$0110
				DB	$04

				DB	$A4				;Ctrl15
				DW	$0114
				DB	$0C

				DB	$A4				;Ctrl13
				DW	$0120
				DB	$0C

				DB	$A4				;Ctrl11
				DW	$0114
				DB	$0C

				DB	$A4				;Ctrl9
				DW	$0120
				DB	$0C

				DB	$FF				;UNUSED***
				DW	$FFFF
				DB	$FF

				DB	$98				;Findment
				DW	$0150
				DB	$08

				DB	$90				;Elevator
				DW	$0140
				DB	$0C

				DB	$78				;Reformat/Regenerate/Compress
				DW	$0160
				DB	$0E

				DB	$86				;Diagnose
				DW	$016E
				DB	$11

				DB	$FF				;*** UNUSED ***
				DW	$FFFF
				DB	$FF

				DB	$60				;Tunnels
				DW	$0190
				DB	$18

				DB	$D9				;Tracc Camp A
				DW	$0222
				DB	$07

				DB	$DC				;Tracc Camp B
				DW	$0229
				DB	$04

				DB	$B0				;Tracc Camp C
				DW	$0130
				DB	$0B

			fin

SPECIALS_DATA						;Was TRACER
DCARDS_FOUND	DB	0,0,0
ORBS_FOUND		DB	0
				DB	$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00,$00
				DB	$00,$00

BANK_1			LDA	$C08B
				LDA	$C08B
				RTS
BANK_2			LDA	$C083
				LDA	$C083
				RTS

SHELL			DB	$00
MAPSPOT			DW	$0000
BYTEWID			DB	$00
FACBYTE			DB	$00

				DW	$FA62
				DW	$C074

				SAV	CAMP.E000


*-------------------------------
				ORG	$B000
				PUT	CAMP/CREDITOR
				PUT	CAMP/I.TRANSFER
				PUT	CAMP/I.SEESTATS
				PUT	CAMP/I.SUBROUTINES
				DS	\,$EE
				DS	256
				ERR	*-$BB00
				SAV	CAMP.B000
*-------------------------------


*-------------------------------
				ORG	$7800
				PUT	CAMP/I.REGENERATE
*PUT CAMP/I.COMPRESSOR
				PUT	CAMP/C.REFORMAT
				DS	256,$EE
				DS	\,$EE
				ERR	*-$8600
				PUT	CAMP/I.DIAGNOSER
				PUT	CAMP/I.DIAG.DATA
				DS	\,$EE
				SAV	CAMP.7800
*-------------------------------
