SHELL_13
				DB	END_13-BEGIN_13	;Number of monsters (28)
				DW	DATA_13-SHELL_13
				DW	RARITY_13-SHELL_13

BEGIN_13
				DB	pMAGNET
				DB	pMISER
				DB	pROBED_SELLER
				DB	pSCREAMER
				DB	pTF_BAIT
				DB	pPROG_CHANGER
				DB	pSPARKLES
				DB	pCLOAKD_ALIEN
				DB	pGLASS_GUY
				DB	pACID_SPITTER
				DB	pSEVEN_CLAWS
				DB	pPHASOID
				DB	pFAKER
				DB	pTANGIBLE_GAS
				DB	pGREEN_PUDDLE
				DB	pDIODE_ROBOT
				DB	pEXPLODE
				DB	pCARNIVORE
				DB	pATOM_SHIFTER
				DB	pLITTLE_MEN
				DB	pTAILFIGHTER
				DB	pSHARP_SHOOTR
				DB	pCYLINDER_BOT
				DB	pWEB_THING
				DB	pINSECT2
				DB	pINSECT2
				DB	pTREE_HANGER
				DB	$FF
END_13

DATA_13			XXX	MAGNETIC
				XXX	MISER
				XXX	EBKALEE
				XXX	SCREECHR
				XXX	MAULER
				XXX	MEMPLACR
				XXX	SPARKLE
				XXX	ENCEPHAL
				XXX	TRANSPER
				XXX	ACIDSPIT
				XXX	ZETOC
				XXX	PHASOID
				XXX	PSEUDOMO
				XXX	TANGIBLE
				XXX	PUDDLE
				XXX	IONDIODE
				XXX	EXPLODER
				XXX	CARNIVOR
				XXX	ATOMARRA
				XXX	LITTLMEN
				XXX	BETEIGUE
				XXX	SHARPSHO
				XXX	TRIPEDIV
				XXX	PARASITE
				XXX	WORKER
				XXX	FIGHTER
				XXX	OKKARMAR
				XXX	OKKARPLA

				XXX	DATA_END_13

RARITY_13
* A - Magnetic Sweeper
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$04
				DB	$06,$10,$17,$FF

* B - "Miser"
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$04
				DB	$08,$14,$15,$16,$FF

* C - Ebkal'ee
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$05
				DB	$99,$FF

* D - "Screecher"
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$05
				DB	$09,$0A,$0C,$13,$18,$FF

* E - "Mauler"
				DB	ALIEN_FORM+ALL_FACES
				DB	$23,$05
				DB	$99,$FF

* F - Mem-Placer Robot
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$06
				DB	$01,$10,$17,$FF

* G - Sparkle
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$66,$06
				DB	$99,$FF

* H - Encephaloid
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$06
				DB	$02,$14,$15,$16,$FF

* I - Transperent
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$06
				DB	$04,$0A,$0C,$13,$18,$FF

* J - Acid Spitter
				DB	ALIEN_FORM+ALL_FACES
				DB	$12,$09
				DB	$04,$09,$0C,$13,$18,$FF

* K - Zetoc
				DB	ALIEN_FORM+ALL_FACES
				DB	$23,$09
				DB	$0E,$0F,$12,$FF

* L - Phasoid
				DB	ALIEN_FORM+ALL_FACES
				DB	$24,$09
				DB	$04,$09,$0A,$13,$18,$FF

* M - Pseudomort
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$10
				DB	$99,$FF

* N - Tangible Gas
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$11,$10
				DB	$0B,$0F,$12,$FF

* O - Puddle Creature
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$10
				DB	$0B,$0E,$12,$FF

* P - Ion Diode Robot
				DB	ROBOT_FORM+ALL_FACES
				DB	$13,$10
				DB	$01,$06,$17,$FF

* Q - Vegan Exploder
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$8C,$12
				DB	$99,$FF

* R - Carnivore
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$12
				DB	$0B,$0E,$0F,$FF

* S - Atom Arranger
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$12
				DB	$04,$09,$0A,$0C,$18,$FF

* T - Little Men
				DB	ALIEN_FORM+ALL_FACES
				DB	$68,$13
				DB	$02,$08,$15,$16,$FF

* U - Beteiguesen
				DB	ALIEN_FORM+ALL_FACES
				DB	$25,$14
				DB	$02,$08,$14,$16,$FF

* V - "Sharp Shooter"
				DB	ALIEN_FORM+ALL_FACES
				DB	$22,$13
				DB	$02,$08,$14,$15,$FF

* W - Triped IV Robot
				DB	ROBOT_FORM+ALL_FACES
				DB	$12,$14
				DB	$01,$06,$10,$FF

* X - Webbed Parasite
				DB	ALIEN_FORM+ALL_FACES
				DB	$24,$14
				DB	$04,$09,$0A,$0C,$13,$FF

* Y - Worker Insect
				DB	ALIEN_FORM+ALL_FACES
				DB	$45,$14
				DB	$1A,$FF

* Z - Fighter Insect
				DB	ALIEN_FORM+ALL_FACES
				DB	$45,$14
				DB	$19,$FF

* AA - Okkar Marsupial
				DB	ALIEN_FORM+ALL_FACES
				DB	$46,$10
				DB	$1C,$FF

* BB - Okkar Plant
				DB	ALIEN_FORM
				DB	$46,$00
				DB	$1B,$FF