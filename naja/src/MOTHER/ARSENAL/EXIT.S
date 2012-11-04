*-------------------------------
*
*-------------------------------

ARSOUT			LDA	PAGE
				CMP	#$40
				BEQ	AROKAY
				JSR	MOVETO2
				STA	SCNDARY
AROKAY			LDA	STCKDIF
				BEQ	ARSKIPT
				LDX	#67
AOLOOP			LDA	PISTSTK,X
				STA	$9C8B,X
				DEX
				BPL	AOLOOP
				LDX	#wStock
				JSR	CALL_WRITERS
ARSKIPT			LDX	#mPictures
				JSR	SLOAD_FILE
				JSR	CLEAR1
				LDA	#$08
				STA	XPOS
				LDA	#$08
				STA	YPOS
				LDA	#$0F
				STA	DIRECTN
				LDA	#$20
				STA	PAGE
				LDA	#WHITE1
				STA	COLOR
				JSR	GETNSEW
				STA	PRIMARY
				JSR	NOSCAN
				JMP	RDKEY

*-------------------------------
