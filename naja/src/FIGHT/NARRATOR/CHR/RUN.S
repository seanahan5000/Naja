*** Any status or mind control that would prevent the
***   character from giving the retreat signal has
***   already been filtered out and narrated.

**** MAKE SURE THE GROUP CAN RUN !!!!!
CHR_RUN			JSR	CLEAR_TLINE1
				LDY	#59				;S>59 CName.Gives.The.Retreat.RET
				JSR	SENTENCE_PRET	;     Signal
				JSR	DELAYER
				JSR	CLRBOX
				JSR	MONS_OPENROWS
				JSR	CHAR_OPENROWS
				LDA	#$7F			;Retreat
				STA	CHAR_ADVFLAG
				JMP	RUN_RESOLVER
