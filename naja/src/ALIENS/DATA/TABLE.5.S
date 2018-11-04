SHELL_9
				DB	END_9-BEGIN_9	;Number of monsters (18)
				DW	DATA_9-SHELL_9
				DW	RARITY_9-SHELL_9

BEGIN_9
				DB	pTIME_WARP
				DB	pCORE_ALIEN
				DB	pBLACK_ALIEN
				DB	pGODZILLA
				DB	pONE_ARM_BLOB
				DB	pRICOCHET
				DB	pGREEN_HEAD
				DB	pTELEPORTER
				DB	pTANK_HUMAN
				DB	pFOUR_SWORDS
				DB	pAIRLOCK
				DB	pTHROWER
				DB	$FF
				DB	pINVERSE
				DB	pANTISIPATOR
				DB	pRABBIT_EARS
				DB	pRUNNING_BOT
				DB	pINFORMER
END_9

DATA_9			DW	TIMEWARP
				DW	MINDSLAV
				DW	PLASMAN
				DW	BLASTBRE
				DW	ASYMETRI
				DW	RICOCHET
				DW	CEREBROM
				DW	BLINKER
				DW	LEVITATR
				DW	MECHANIC
				DW	AIRLOCK
				DW	THROWER
				DW	LATCHER
				DW	INVERSE
				DW	ANTICIP
				DW	SNARC
				DW	ASSASSIN
				DW	INFORMER

				DW	DATA_END_9

RARITY_9
* A - Time Warp
				DB	UNKNOWN_ALIEN+ALL_FACES
				DB	$11,$05
				DB	$99,$FF
* B - Najan Mind Slave
				DB	ALIEN_FORM+ALL_FACES
				DB	$44,$18
				DB	$99,$FF
* C - Plasmanoid
				DB	ALIEN_FORM+ALL_FACES
				DB	$15,$15
				DB	$07,$0A,$0E
				DB	$0F,$11,$FF
* D - Blast Breather
				DB	ALIEN_FORM+ALL_FACES
				DB	$14,$18
				DB	$03,$07,$0A
				DB	$0E,$0F,$11
				DB	$FF
* E - Asymmetric Alien
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$15
				DB	$03,$07,$0A
				DB	$0E,$0F,$11
				DB	$FF
* F - Ricochet Missile
				DB	UNKNOWN_ROBOT+ALL_FACES
				DB	$59,$15
				DB	$99,$FF
* G - Cerebromorph
				DB	ALIEN_FORM+ALL_FACES
				DB	$15,$15
				DB	$03,$0A,$0E
				DB	$0F,$11,$FF
* H - "Blinker"
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$15
				DB	$99,$FF
* I - Man In Levitator
				DB	UNKNOWN_ROBOT+ALL_FACES
				DB	$12,$18
				DB	$03,$07,$0A
				DB	$0E,$0F,$11
				DB	$FF
* J - Mechanico 450
				DB	ROBOT_FORM+ALL_FACES
				DB	$15,$22
				DB	$03,$07,$0E
				DB	$0F,$11,$FF
* K - Portable Airlock
				DB	ROBOT_FORM+ALL_FACES
				DB	$11,$05
				DB	$03,$07,$0A
				DB	$0E,$0F,$10
				DB	$11,$FF
* L - "Thrower"
				DB	ALIEN_FORM+ALL_FACES
				DB	$13,$09
				DB	$99,$FF
* M - "Latcher"
				DB	ALIEN_FORM
				DB	$13,$00
				DB	$99,$FF
* N - Inversion Alien
				DB	ALIEN_FORM+ALL_FACES
				DB	$15,$12
				DB	$03,$07,$0A
				DB	$0F,$11,$FF
* O - Anticipator
				DB	ALIEN_FORM+ALL_FACES
				DB	$15,$12
				DB	$03,$07,$0A
				DB	$0E,$11,$FF
* P - Snarc
				DB	ALIEN_FORM+ALL_FACES
				DB	$11,$09
				DB	$03,$07,$0A
				DB	$0E,$0F,$11
				DB	$FF
* Q - Alien Assassin
				DB	ALIEN_FORM+ALL_FACES
				DB	$15,$22
				DB	$03,$07,$0A
				DB	$0E,$0F,$FF
* R - Informer
				DB	ALIEN_FORM+ALL_FACES
				DB	$24,$22
				DB	$99,$FF
