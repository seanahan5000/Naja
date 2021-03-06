DRAW_ROSTER		LDA	EXAMFLG
				BNE	ROSTOUT
				JSR	CLEAR1	
				LDY	#$0B	
				JSR	TEXTER
				LDA	#GREEN	
				STA	COLOR
				LDY	#$02
				JSR	LINER
				STA	PRIMARY
				LDA	#$00
				STA	REDRAW
				LDA	#$FF
				STA	EXAMFLG
				LDA	#$0D	
				STA	LINENUM
				LDA	#$00
				STA	SECOUNT
NEXTRLN			LDY	SECOUNT
				JSR	POINTR2
				LDY	#$09
NAMBACK			LDA	(CHARPTR),Y
				AND	#$3F
				STA	CHARBUF,Y
				DEY
				BPL	NAMBACK
				LDY	#$0A
				LDA	(CHARPTR),Y
				STA	CHARBUF+13
				INY
				INY
				INY
				LDA	(CHARPTR),Y
				STA	CHARBUF+10
				LDA	#$00
				JSR	ROSTER_LINE
				INC	SECOUNT
				LDA	SECOUNT
				CMP	GCOUNT
				BNE	NEXTRLN
ROSTOUT			JSR	DOTTER
				RTS

ROSTER_LINE		STA	CHARDL
				LDA	#>CHARBUF
				STA	CHARDH
				LDY	#$00			;CLEAR TEXT BUFFER TO SPACES
				LDA	#$0A
CLEARER			STA	TEXTBUF,Y
				INY
				CPY	#$2E
				BNE	CLEARER
				LDA	#$8D
				STA	TEXTBUF,Y
				LDX	#$00	
				LDY	#$00
				JSR	NAMEIT
				LDA	#$0A
				STA	TEXTBUF,X
				LDY	#$0D	
				LDA	(CHARDL),Y
				PHA
				AND	#$F0
				CMP	#$80
				BNE	NOTBOT
				PLA
				LDY	#$8B
				JMP	RBCOLUM	
NOTBOT			PLA
				AND	#$0F			;KEEP ONLY RACE INFORMATION
				TAX					;TRANSFER IT TO X
				LDA	RACEOFF,X		;LOAD OFFSET FOR THAT RACE FROM TABLE
				TAY
RBCOLUM			LDX	#RACECOL-1		;LOAD X WITH BEGINNING RACE COLUMN
MORRACE			LDA	RACEDAT,Y		;MOVE RACE DATA
				STA	TEXTBUF,X		;TO TEXT BUFFER
				INY
				INX
				CPX	#RACEND			;UNTIL ENDING RACE COLUMN REACHED
				BNE	MORRACE
				LDY	#$0D	
				LDA	(CHARDL),Y
				LSR					;SHIFT PROFESSION DATA TO LOW NIBBLE
				LSR
				LSR
				LSR
				TAX					;TRANSFER IT TO X
				LDA	PROFOFF,X		;LOAD OFFSET FOR THAT PROF FROM TABLE
				TAY
				CPX	#$09
				BNE	PBCOLUM
				LDY	#$5A
PBCOLUM			LDX	#PROFCOL-1		;LOAD X WITH BEGINNING PROF COLUMN
MORPROF			LDA	PROFDAT,Y		;MOVE PROFESSION DATA
				STA	TEXTBUF,X		;TO TEXT BUFFER
				INY
				INX
				CPX	#PROFEND		;UNTIL ENDING PROF COLUMN REACHED
				BNE	MORPROF
				LDX	#$1E	
				LDY	#$0B
LEVMORE			LDA	(CHARPTR),Y
				JSR	SPLIT
				LDA	FEEDERH
				STA	TEXTBUF,X
				INX
				LDA	FEEDERL
				STA	TEXTBUF,X
				INX
				INY
				CPY	#$0D
				BNE	LEVMORE
				LDX	#$1E	
GAPSIT			LDA	TEXTBUF,X
				BNE	STATLOD
				LDA	#$0A
				STA	TEXTBUF,X
				INX
				CPX	#$21	
				BNE	GAPSIT
STATLOD			LDA	#$08	
				LDY	LINENUM
				JSR	LINE
				JSR	STATUSR
				LDA	#$E0
				LDY	LINENUM
				JSR	LINE
				LDA	LINENUM
				CLC
				ADC	#$08
				STA	LINENUM
				RTS
