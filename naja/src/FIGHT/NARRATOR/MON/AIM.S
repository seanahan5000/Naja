MON_AIM			_CheatAim
				BEQ	:2
				JSR	AIM_SUB
				LDY	#monCRNTCMD+1
				BCS	:1
				DEY					;Nothing to aim at so
				LDA	#cmdPARRY		;  change aim to parry
:1				STA	(MONS_PTR),Y
:2				JMP	MCOM
