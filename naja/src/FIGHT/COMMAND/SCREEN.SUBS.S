SWAP			LDX	#$48
SWAP2			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#$17
SWAP1			LDA	(SCREENL),Y
				PHA
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				PLA
				STA	(DESTINL),Y
				INY
				CPY	#$28
				BNE	SWAP1
				INX
				CPX	#$7F
				BNE	SWAP2
				RTS

*-------------------------------

CLRBOXZ			LDA	#$21
				STA	ALTERD+1	
				JSR	CLRBOX
				LDA	#$25
				STA	ALTERD+1
				RTS

*-------------------------------

CLRBOX			LDX	#$80	
CLROOP2			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE	
				STA	SCREENH
				LDA	#$00
				LDY	#$0D
CLRLOOP			STA	(SCREENL),Y
				INY
ALTERD			CPY	#$25			;Modified
				BCC	CLRLOOP
				CPX	#$B7
				BCS	NEXTLIN
				CPY	#$27
				BNE	CLRLOOP
				LDA	(SCREENL),Y
				AND	#$70
				STA	(SCREENL),Y
NEXTLIN			INX
PRESTOP			CPX	#$BF
				BNE	CLROOP2
				RTS

*-------------------------------

CLRBOX2			LDX	#$48
CLOOPY			LDA	LOBYTES,X
				STA	SCREENL
				LDA	HIBYTES,X
				ORA	PAGE
				STA	SCREENH
				LDY	#$1D
				LDA	(SCREENL),Y
				AND	#$01
				STA	(SCREENL),Y
				INY
				LDA	#$00
CLOOPX			STA	(SCREENL),Y
				INY
				CPY	#$27
				BNE	CLOOPX
				LDA	(SCREENL),Y
				AND	#$70
				STA	(SCREENL),Y
				INX
				CPX	#$7F
				BNE	CLOOPY
				RTS

*-------------------------------

FLIPPER			LDX	#$02
:LOOP1			LDA	LOBYTES,X
				STA	SCREENL
				STA	DESTINL
				LDA	HIBYTES,X
				ORA	#$20
				STA	SCREENH
				EOR	#$60
				STA	DESTINH
				LDY	#$0F
:LOOP2			LDA	(SCREENL),Y
				PHA
				LDA	(DESTINL),Y
				STA	(SCREENL),Y
				PLA
				STA	(DESTINL),Y
				INY	
				CPY	#$28
				BNE	:LOOP2
				INX
				CPX	#$43
				BNE	:LOOP1
				RTS
