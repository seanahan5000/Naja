*** Statuses that would prevent this command from
***   being executed have already been filtered out.

CHR_USE			JSR	GET_ENERUSE
				LDA	ETABLE
				CMP	#$61			;Useable medical equipment
				BNE	:SKIPB
				LDX	#$00
				LDY	ETABLE+1
				DEY					;Cell regenerator = 1
				BEQ	:SKIPA
				DEX
				DEY					;Circuit repairer = 2
				BNE	:SKIPB
:SKIPA			STX	HEAL_TYPE
				JMP	HEALING

:SKIPB			CMP	#$63			;Useable miscellaneous
				BNE	:2
				LDA	ETABLE+1
				CMP	#$01			;Muscle
				BEQ	:1
				CMP	#$09			;Reflex
				BNE	:2
:1				JMP	DRUGS
:2				JMP	CCOM			;Just in case
