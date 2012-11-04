_AttackType		MAC
				LDA	FBYTE1
				AND	#%10000000
				EOM

_FromRows1or2	MAC
				LDA	FBYTE1
				AND	#%00001000
				EOM

_CheatAim		MAC
				LDA	FBYTE1
				AND	#%00000100
				EOM

_CheatSwing		MAC
				LDA	FBYTE2
				AND	#%10000000
				EOM

_FrontRowRush	MAC
				LDA	FBYTE2
				AND	#%00000111
				EOM

_RunWhenOut		MAC
				LDA	FBYTE3
				AND	#%10000000
				EOM

_AimAtFront2	MAC
				LDA	FBYTE3
				AND	#%01000000
				EOM

_FidgetOdds		MAC
				LDA	FBYTE3
				LSR
				LSR
				LSR
				LSR
				AND	#%00000011
				EOM

_BlocksShots_	MAC
				LDY	#aFightParams+3	;FBYTE4
				LDA	(ALIEN_PTR),Y
				ROL
				ROL
				ROL
				AND	#%00000011
				EOM

_AimAccuracy_	MAC
				LDY	#aFightParams+3	;FBYTE4
				LDA	(ALIEN_PTR),Y
				LSR
				LSR
				AND	#%00000111
				EOM

_ShotsAtATime	MAC
				LDA	FBYTE4
				AND	#%00000011
				EOM

_FrcRunAfter	MAC
				LDA	FBYTE5
				LSR
				LSR
				LSR
				AND	#%00011111
				EOM

_NoRunUntil		MAC
				LDA	FBYTE5
				AND	#%00000111
				EOM
