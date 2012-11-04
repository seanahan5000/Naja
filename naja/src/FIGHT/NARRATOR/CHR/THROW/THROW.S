*-------------------------------

CHR_THROW		JSR	GET_EP_ENUSE
				ROR
				LDX	ETABLE
				CPX	#$FF
				BEQ	:EXIT
				LDX	ETABLE+1		;Assume that a truly
				CPX	#$01			;   throwable object
				BEQ	:1				;   has been selected
				CPX	#$06
				BEQ	:2
				JMP	GRENADE
:1				JMP	BOOMERANG
:2				JMP	IMMOBILIZER
:EXIT			JMP	CCOM

*-------------------------------

TAKE_N_BREAK	LDY	EQUIP_OFFSET
				LDA	(CHARDL),Y
				ORA	#eq_broken		;Break the item
				STA	(CHARDL),Y		;Take the item and put it
				LDX	EQUIP_INDEX		;  in a list of equipment to
				JSR	TAKE_ITEM		;  be found after battle
				BCC	:1				;If that list is full then
				JSR	REMOVE_ITEM		;  permanently take it
:1				JMP	TAKDELCLRCCOM

*-------------------------------

*** ALIENS THAT ARE SPECIAL WITH THROWING
***   1) SPACE_WARP (IMMOBILIZERS)
***   2) PLASMANOID (ALL THROWN)
***
***   3) HOT_HEAD (GRENADES/IMMOBILIZERS)
***
***   4) PUDDLE CREATURE (GRENADES)
***
***   5) SHOVELER (ALL THROWN)
***   6) STICKY (ALL THROWN)
***
***   7) STICKY (ALL THROWN)
