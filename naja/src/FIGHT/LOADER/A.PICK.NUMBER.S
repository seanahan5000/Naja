********************************
*
********************************

PICK_NUMBER		LDX	#0
				STX	ALIEN_NUMBER
:LOOP1			LDY	ALIEN1,X
				CPY	#$FF
				BEQ	:EXIT
				LDA	OPTIONS1
				AND	HMANY_BITS,X
				BEQ	:SKIPA
				JSR	POINTEM

				LDY	#1
				LDA	(DATPNTL),Y
				PHA
				AND	#%00001111
				STA	TEMP+1
				INC	TEMP+1
				PLA
				LSR
				LSR
				LSR
				LSR
				STA	TEMP
:LOOP2			JSR	RNDMIZE
				LDA	RANDOM1
				AND	#%00001111
				CMP	TEMP
				BCC	:LOOP2
				CMP	TEMP+1
				BCS	:LOOP2

				LDX	ALIEN_NUMBER
				STA	HMANY1,X
:SKIPA			INC	ALIEN_NUMBER
				LDX	ALIEN_NUMBER
				CPX	#3
				BNE	:LOOP1
:EXIT			RTS

HMANY_BITS		DB	Xhmany1,Xhmany2,Xhmany3
