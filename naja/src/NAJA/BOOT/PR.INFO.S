********************************
*
*  PR.INFO
*
********************************

				ORG	$0200
				DS	$30,$EE
ROFFS			DFB	$00,ORN-HUMAN,STILICX-HUMAN	
				DFB	XXTYS-HUMAN,DENEB-HUMAN	
HUMAN			DFB	$12,$1F,$17
				DFB	$0B,$18,$0A
				DFB	$0A,$8D
ORN				DFB	$19,$1C,$18
				DFB	$0A,$0A,$0A
				DFB	$0A,$8D
STILICX			DFB	$1D,$1E,$13
				DFB	$16,$13,$0D
				DFB	$22,$8D
XXTYS			DFB	$22,$22,$1E
				DFB	$23,$1D,$0A
				DFB	$0A,$8D
DENEB			DFB	$0E,$0F,$18
				DFB	$0F,$0C,$0A
				DFB	$0A,$8D
POFFS			DFB	$00,ANDROID-WARRIOR,CYBERN-WARRIOR
				DFB	JUICER-WARRIOR,PHYSIC-WARRIOR,MUTANT-WARRIOR
				DFB	EMEDIC-WARRIOR,GENIUS-WARRIOR,ROBOT-WARRIOR	
WARRIOR			DFB	$21,$0B,$1C
				DFB	$1C,$13,$19
				DFB	$1C,$0A,$0A
				DFB	$8D
ANDROID			DFB	$0B,$18,$0E
				DFB	$1C,$19,$13
				DFB	$0E,$0A,$0A
				DFB	$8D
CYBERN			DFB	$0D,$23,$0C
				DFB	$0F,$1C,$18
				DFB	$0B,$1E,$0F
				DFB	$8D
JUICER			DFB	$14,$1F,$13
				DFB	$0D,$0F,$1C
				DFB	$0A,$0A,$0A
				DFB	$8D
PHYSIC			DFB	$1A,$12,$23
				DFB	$1D,$13,$0D
				DFB	$13,$0B,$18
				DFB	$8D
MUTANT			DFB	$17,$1F,$1E
				DFB	$0B,$18,$1E
				DFB	$0A,$0A,$0A
				DFB	$8D
EMEDIC			DFB	$0F,$2C,$17
				DFB	$0F,$0E,$13
				DFB	$0D,$0A,$0A
				DFB	$8D
GENIUS			DFB	$11,$0F,$18
				DFB	$13,$1F,$1D
				DFB	$0A,$0A,$0A
				DFB	$8D
ROBOT			DFB	$1C,$19,$0C
				DFB	$19,$1E,$0A
				DFB	$0A,$0A,$0A
				DFB	$8D
NONE			DFB	$18,$19,$18
				DFB	$0F,$0A,$0A
				DFB	$0A,$8D	
