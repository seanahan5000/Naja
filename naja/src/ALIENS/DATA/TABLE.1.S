SHELL_17
				DB	END_17-BEGIN_17	;Number of monsters (52)
				DW	DATA_17-SHELL_17
				DW	RARITY_17-SHELL_17

BEGIN_17
				DB	pSPACE_MAN
				DB	pAIR_SWIMMER
				DB	pSHIELD
				DB	pONE_EYE
				DB	pHANGING_BOT
				DB	pBTWN_LEGS
				DB	pRAG_ALIEN
				DB	pPER_ALIEN
				DB	pROBOT
				DB	pCEIL_SWINGER
				DB	pWIERD_ALIEN
				DB	pSTARBURST
				DB	pTRUNK
				DB	pTREE_ALIEN
				DB	pWIERD_ALIEN
				DB	pFROG_BOT
				DB	pTWISTER
				DB	$FF			;Barackade
				DB	pWORMS
				DB	pPROBOT
				DB	pARMOR_ALIEN
				DB	pHORNED_DOG
				DB	pPINK_WINGS
				DB	pSQUINTER
				DB	pPLATFORM
				DB	pCROSS_BOW
				DB	pHOLSTER
				DB	pOILER
				DB	pSLEEPY
				DB	pHANGING_BOT
				DB	pBLOW_DART
				DB	pAIR_SWIMMER
				DB	pLITTLE_BUG
				DB	pCEILING_FAN
				DB	pRUUIKS_MEN			; if not index $23, change RUUIK.S
				DB	pBIRD_INSECT
				DB	pCLAPPER
				DB	pCLUBBER
				DB	pSPACE_SHIP
				DB	pWORMS
				DB	pGAS_CLOUD
				DB	pSIX_ARM
				DB	pSTRINGY_HAND
				DB	pFINGERS
				DB	pPEEKER
				DB	pSTINKY
				DB	pPARTICLE_MAN
				DB	pBARACKADER
				DB	pPROBOT
				DB	pHOLSTER
				DB	pROBIEN
				DB	pSTICKY
END_17

DATA_17			DW	A
				DW	B
				DW	C
				DW	D
				DW	E
				DW	F
				DW	G
				DW	H
				DW	I
				DW	J
				DW	K
				DW	L
				DW	M
				DW	N
				DW	O
				DW	P
				DW	Q
				DW	R
				DW	S
				DW	T
				DW	U
				DW	V
				DW	W
				DW	X
				DW	Y
				DW	Z
				DW	AA
				DW	BB
				DW	CC
				DW	DD
				DW	EE
				DW	FF
				DW	GG
				DW	HH
				DW	II
				DW	JJ
				DW	KK
				DW	LL
				DW	MM
				DW	NN
				DW	OO
				DW	PP
				DW	QQ
				DW	RR
				DW	SS
				DW	TT
				DW	UU
				DW	VV
				DW	WW
				DW	XX
				DW	YY
				DW	ZZ

				DW	DATA_END_17

RARITY_17
* A -
				DB	$58,$12
				DB	$30,$26
				DB	$04,$06,$07
				DB	$FE,$99,$FF
* B -
				DB	$54,$11
				DB	$30,$13
				DB	$99,$FE,$99
				DB	$FF
* C -
				DB	$50,$24
				DB	$30,$00
				DB	$99,$FF
* D -
				DB	$50,$12
				DB	$30,$00
				DB	$01,$06,$07
				DB	$FF
* E -
				DB	$98,$13
				DB	$30,$25
				DB	$99,$FE,$99
				DB	$FF
* F -
				DB	$50,$12
				DB	$16,$00
				DB	$01,$04,$07
				DB	$FF
* G -
				DB	$50,$12
				DB	$30,$00
				DB	$01,$04,$06
				DB	$FF
* H -
				DB	$50,$11
				DB	$30,$00
				DB	$99,$FF
* I -
				DB	$90,$14
				DB	$30,$00
				DB	$99,$FF
* J -
				DB	$68,$13
				DB	$12,$32
				DB	$0C,$16,$FE
				DB	$0C,$0D,$11
				DB	$FF
* K -
				DB	$68,$12
				DB	$12,$16
				DB	$17,$FE,$0F
				DB	$FF
* L -
				DB	$68,$13
				DB	$12,$32
				DB	$0A,$16,$FE
				DB	$0A,$0D,$11
				DB	$FF
* M -
				DB	$48,$13
				DB	$26,$00
				DB	$0A,$0C,$11
				DB	$FF
* N -
				DB	$48,$12
				DB	$32,$00
				DB	$99,$FF
* O -
				DB	$48,$12
				DB	$16,$00
				DB	$0B,$FF
* P -
				DB	$88,$37
				DB	$25,$00
				DB	$99,$FF
* Q -
				DB	$48,$13
				DB	$26,$00
				DB	$0A,$0C,$0D
				DB	$FF
* R -
				DB	UNKNOWN_ALIEN
				DB	$00,$00
				DB	$FF
* S -
				DB	$60,$36
				DB	$26,$00
				DB	$99,$FF
* T -
				DB	$A0,$11
				DB	$26,$00
				DB	$99,$FF
* U -
				DB	$24,$14
				DB	$26,$24
				DB	$99,$FE,$99
				DB	$FF
* V -
				DB	$64,$13
				DB	$12,$14
				DB	$0A,$0C,$FE
				DB	$1C,$1F,$21
				DB	$22,$FF
* W -
				DB	$64,$12
				DB	$26,$14
				DB	$0B,$18,$1A
				DB	$FE,$18,$FF
* X -
				DB	$64,$23
				DB	$26,$14
				DB	$17,$1A,$FE
				DB	$17,$FF
* Y -
				DB	$E0,$12
				DB	$26,$00
				DB	$99,$FF
* Z -
				DB	$60,$11
				DB	$26,$00
				DB	$17,$18,$FF
* AA -
				DB	$46,$11
				DB	$25,$04
				DB	$1D,$FE,$1D
				DB	$28,$FF
* BB -
				DB	$86,$12
				DB	$25,$04
				DB	$1F,$21,$22
				DB	$16,$FE,$25
				DB	$FF
* CC -
				DB	$46,$24
				DB	$25,$04
				DB	$1B,$FE,$1B
				DB	$28,$FF
* DD -
				DB	$84,$13
				DB	$25,$00
				DB	$99,$FF
* EE -
				DB	$44,$12
				DB	$25,$00
				DB	$1C,$21,$22
				DB	$16,$FF
* FF -
				DB	$44,$11
				DB	$13,$00
				DB	$99,$FF
* GG -
				DB	$44,$17
				DB	$14,$00
				DB	$1C,$1F,$22
				DB	$16,$FF
* HH -
				DB	$44,$13
				DB	$25,$00
				DB	$1C,$1F,$21
				DB	$16,$FF
* II -
				DB	$42,$48
				DB	$69,$00
				DB	$99,$FF
* JJ -
				DB	$43,$12
				DB	$27,$26
				DB	$2A,$2B,$FE
				DB	$2E,$FF
* KK -
				DB	$43,$23
				DB	$27,$20
				DB	$1C,$FE,$33
				DB	$FF
* LL -
				DB	$43,$12
				DB	$27,$14
				DB	$99,$FE,$99
				DB	$FF
* MM -
				DB	$C3,$13
				DB	$18,$07
				DB	$99,$FE,$99
				DB	$FF
* NN -
				DB	$43,$23
				DB	$18,$07
				DB	$1B,$1D,$FE
				DB	$2F,$32,$FF
* OO -
				DB	$03,$59
				DB	$04,$03
				DB	$99,$FE,$99
				DB	$FF
* PP -
				DB	$42,$24
				DB	$27,$00
				DB	$24,$2B,$FF
* QQ -
				DB	$42,$12
				DB	$27,$00
				DB	$24,$2A,$FF
* RR -
				DB	$41,$12
				DB	$26,$00
				DB	$34,$FF
* SS -
				DB	$41,$11
				DB	$07,$00
				DB	$99,$FF
* TT -
				DB	$41,$13
				DB	$20,$00
				DB	$24,$FF
* UU -
				DB	$41,$23
				DB	$26,$00
				DB	$28,$32,$FF
* VV -
				DB	$41,$55
				DB	$26,$00
				DB	$99,$FF
* WW -
				DB	$81,$11
				DB	$20,$00
				DB	$99,$FF
* XX -
				DB	$41,$12
				DB	$14,$00
				DB	$2F,$28,$FF
* YY -
				DB	$C1,$12
				DB	$26,$00
				DB	$25,$FF
* ZZ -
				DB	$41,$11
				DB	$14,$00
				DB	$2C,$FF
