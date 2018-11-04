SHELL_15
				DB	END_15-BEGIN_15	;Number of monsters (35)
				DW	DATA_15-SHELL_15
				DW	RARITY_15-SHELL_15

BEGIN_15
				DB	pSNOW_JOB
				DB	pREPAIR_UNIT
				DB	pTWISTER
				DB	pPLATFORM
				DB	pSIX_ARM
				DB	pCEILING_FAN
				DB	pSCAVENGER
				DB	pSNOUT
				DB	pFIRE_MAN
				DB	pLEASHED_DOGS
				DB	pTENTICLE
				DB	pIN_WEB
				DB	pRAG_ALIEN
				DB	pROBIEN
				DB	pSTRINGY_HAND
				DB	pPOINTY_HEAD
				DB	pSPOOL_ALIEN
				DB	pOMEBA
				DB	pFURNACE
				DB	pLONG_ARM
				DB	pSLICER
				DB	pTREADED_BOT
				DB	pSTICKY
				DB	pMETAL_MITES
				DB	pSTAFF
				DB	pDIZZY
				DB	pBRANCHES
				DB	pSPOOR_PLANT
				DB	pLIZARD
				DB	pCONSTRICTOR
				DB	pLITTL_PLANES
				DB	pWATER_TOWER
				DB	pUNLOADER
				DB	pINSECT1
				DB	$FF
END_15

DATA_15			DW	SNOWJOB
				DW	REPAIR
				DW	TWISTER
				DW	PLATFORM
				DW	SIXARMED
				DW	CEILING
				DW	SCAVENGE
				DW	SNOUT
				DW	FIREMAN
				DW	LEASHDOG
				DW	TENTICLE
				DW	CAUGHTIN
				DW	RAGALIEN
				DW	ROBIEN
				DW	STRINGY
				DW	POINTY
				DW	SPOOLER
				DW	OMOEBA
				DW	FURNACE
				DW	LONGARM
				DW	SLICER
				DW	TREADBOT
				DW	STICKY
				DW	METALMIT
				DW	STAFF
				DW	DIZZY
				DW	BRANCHES
				DW	SPOOR
				DW	LIZARD
				DW	CONSTRIC
				DW	LITPLANE
				DW	WATTOWER
				DW	ENUNLOAD
				DW	INSECT
				DW	WEB

				DW	DATA_END_15

RARITY_15
* A - "Subzero"
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$11,$24
				DB	$03,$06,$FF

* B - Repair Unit 1000
				DB	ROBOT_FORM+FACE_4+FACE_6
				DB	$12,$24
				DB	$99,$FF

* C - "Twister"
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$14,$22
				DB	$01,$06,$FF

* D - Beta Centaurian
				DB	UNKNOWN_ROBOT+FACE_4+FACE_6
				DB	$12,$22
				DB	$04,$FF

* E - "Hexiclaw"
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$24,$22
				DB	$08,$FF

* F - (Tandem Tenticles)
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$13,$22
				DB	$01,$03,$FF

* G - Scavenger
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$35,$24
				DB	$04,$FF

* H - Mutant Insectoid
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$12,$24
				DB	$05,$FF

* I - K-60 Fire Unit
				DB	ROBOT_FORM+FACE_4+FACE_6
				DB	$24,$24
				DB	$99,$FF

* J - (Leashed Grunter)
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$22,$24
				DB	$99,$FF

* K - Tenticles
				DB	ALIEN_FORM+FACE_4+FACE_6
				DB	$11,$24
				DB	$99,$FF
*-------------------------------
* L - Ullda Nich
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$11,$22
				DB	$23,$FF

* M - Meern Mutation
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$12,$22
				DB	$0E,$0F,$10,$11,$15,$FF

* N - Robien Brain
				DB	UNKNOWN_ROBOT+FACE_1+FACE_5
				DB	$12,$22
				DB	$0D,$0F,$10,$11,$15,$FF

* O - Acruxite
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$13,$22
				DB	$0D,$0E,$10,$11,$15,$FF

* P - (Pointy Head)
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$33,$24
				DB	$0D,$0E,$0F,$11,$15,$FF

* Q - Nunki Blue Devil
				DB	UNKNOWN_ROBOT+FACE_1+FACE_5
				DB	$13,$24
				DB	$0D,$0E,$0F,$10,$15,$FF

* R - Amoeboid
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$12,$24
				DB	$99,$FF

* S - "Shoveler"
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$11,$24
				DB	$99,$FF

* T - Long Armed Epe
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$11,$24
				DB	$0E,$10,$FF

* U - Slicer Sphere
				DB	ALIEN_FORM+FACE_1+FACE_5
				DB	$11,$24
				DB	$0D,$0E,$0F,$10,$11,$FF

* V - Prototype 2000-7
				DB	ROBOT_FORM+FACE_1+FACE_5
				DB	$24,$24
				DB	$99,$FF
*-------------------------------
* W - (????????????????)
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$11,$21
				DB	$1A,$1D,$1E,$20,$21,$FF

* X - "Metal Mites"
				DB	ROBOT_FORM+FACE_2+FACE_3
				DB	$8C,$21
				DB	$99,$FF

* Y - Sceptarian
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$12,$22
				DB	$1E,$FF

* Z - "Dizzy"
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$11,$21
				DB	$17,$1D,$1E,$20,$21,$FF

* AA - Psilotis Pedetum
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$35,$22
				DB	$1C,$FF

* BB - Spoor Plant
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$12,$22
				DB	$1B,$FF

* CC - Adharan Lizard
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$22,$21
				DB	$17,$1A,$1E,$20,$21,$FF

* DD - Ankaa Strangler
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$25,$21
				DB	$17,$1A,$1D,$20,$21,$FF

* EE - Spica V Fighter
				DB	ROBOT_FORM+FACE_2+FACE_3
				DB	$55,$21
				DB	$99,$FF

* FF - Moikler
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$13,$21
				DB	$17,$1A,$1D,$1E,$21,$FF

* GG - Energy Unloader
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$46,$21
				DB	$17,$1A,$1D,$1E,$20,$FF

* HH - Worker Insect
				DB	ALIEN_FORM+FACE_2+FACE_3
				DB	$8A,$22
				DB	$99,$FF

* II - Ullda Nich Web
				DB	UNKNOWN_ALIEN
				DB	$11,$00
				DB	$0C,$FF
