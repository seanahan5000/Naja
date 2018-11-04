SHELL_11
				DB	END_11-BEGIN_11	;Number of monsters (23)
				DW	DATA_11-SHELL_11
				DW	RARITY_11-SHELL_11

BEGIN_11
				DB	pDUAL_HEAD
				DB	pCENTAUR
				DB	pSWAMP_THING
				DB	pALIEN_ON
				DB	pLIGHT_ALIEN
				DB	pPUNKER
				DB	pEARS
				DB	pWANDERING
				DB	pKAMAKAZE
				DB	pREFLEX_ALIEN
				DB	pSHIFTER
				DB	pGREMLIN
				DB	pWIND_TUNNEL
				DB	pDRILLER
				DB	pINVISIBLE
				DB	pCOOLER
				DB	pHEATER
				DB	pGLOWER
				DB	pPOISON_SUIT
				DB	pFUNGUS
				DB	pQUEEN_INSECT
				DB	pHOT_HEAD
				DB	pINSECT2
END_11

DATA_11			DW	DUALTRON
				DW	CENTAUR
				DW	SLIME
				DW	TALUMA
				DW	SPECTROM
				DW	SPIKE
				DW	SOLICIAN
				DW	WANDERIN
				DW	INTRUDER
				DW	SPEEDO
				DW	SHIFTER
				DW	GREMLIN
				DW	AIRCIRCU
				DW	DRILLER
				DW	INVISIBL
				DW	COOLER
				DW	THERMAL
				DW	INFRAFLO
				DW	GASSER
				DW	FUNGUS
				DW	QUEEN
				DW	HOTHEAD
				DW	FIGHTBUG

				DW	DATA_END_11

RARITY_11
* A - Dualtronic Robot
				DB	ROBOT_FORM+ALL_FACES
				DB	$13,$17
				DB	$02,$FF

* B - Centaurian Robot
				DB	ROBOT_FORM+ALL_FACES
				DB	$13,$17
				DB	$01,$FF

* C - Slime Creature
				DB	ALIEN_FORM+ALL_FACES
				DB	$14,$17
				DB	$14,$FF

* D - Taluma And Mount
				DB	ALIEN_FORM+ALL_FACES
				DB	$25,$17
				DB	$06,$0B,$0C,$FF

* E - Spectramite
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$17
				DB	$06,$07,$0B,$0C,$FF

* F - "Spike"
				DB	ALIEN_FORM+ALL_FACES
				DB	$23,$17
				DB	$05,$07,$0B,$0C,$FF

* G - Solician
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$17
				DB	$05,$06,$0B,$0C,$FF

* H - Wanderin Thought
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$13,$10
				DB	$99,$FF

* I - Intruder Missile
				DB	UNKNOWN_ROBOT+ALL_FACES
				DB	$35,$12
				DB	$99,$FF

* J - "Speedo"
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$12
				DB	$0B,$FF

* K - Shifter
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$12
				DB	$05,$06,$07,$0C,$FF

* L - Adharan Gremlin
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$12
				DB	$05,$06,$07,$0B,$FF

* M - Air Circulator
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$06
				DB	$10,$FF

* N - Station Driller
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$06
				DB	$02,$FF

* O - Invisible Alien
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$16,$07
				DB	$99,$FF

* P - Cooling Unit
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$07
				DB	$0D,$FF

* Q - Thermal Unit
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$07
				DB	$16,$FF

* R - Infra-Flourinoid
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$08
				DB	$06,$0B,$0C,$FF

* S - "Gasser"
				DB	ALIEN_FORM+ALL_FACES
				DB	$24,$08
				DB	$99,$FF

* T - TRACC Fungus
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$08
				DB	$03,$FF

* U - Queen Insect
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$10
				DB	$17,$FF

* V - Hameler Hot Head
				DB	ALIEN_FORM+ALL_FACES
				DB	$35,$12
				DB	$11,$FF

* W - Fighter Insect
				DB	ALIEN_FORM+ALL_FACES
				DB	$88,$00
				DB	$15,$FF
