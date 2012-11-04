EDIT_EDATA		LDX	CURSOR
				JSR	FIND_ENTRY
				LDA	ENTRY_TYPE
				ASL
				TAX
				LDA	:EDITS+1,X
				PHA
				LDA	:EDITS,X
				PHA
				RTS
:EDITS			DW	TRANSFER-1
				DW	EDIT_NAME-1
				DW	EDIT_0_99-1
				DW	EDIT_0_255-1
				DW	EDIT_0_9999-1
				DW	0
				DW	EDIT_YESNO-1
				DW	EDIT_SOMEVERY-1
				DW	EDIT_SIZE-1
				DW	EDIT_BLASTX-1
				DW	EDIT_BLASTY-1
				DW	EDIT_INTNSITY-1
				DW	EDIT_STATUS-1
				DW	EDIT_ATTACK-1
				DW	EDIT_RUSHDEL-1
				DW	EDIT_PERCENT-1
				DW	EDIT_AIM-1
				DW	EDIT_SHOTS-1
				DW	EDIT_RUNAFTER-1
				DW	EDIT_RUNUNTIL-1


*-------------------------------
*
*-------------------------------

EDIT_NAME		JSR	DRAW_NAME
				LDA	#16
				STA	MAXTEXT
				LDA	DATA_XCRD
				LDY	ENTRY_YCRD
				JSR	INPUT
				LDA	TEXTBUF
				CMP	#$8D
				BEQ	:5
				JSR	CONVERT_STR
				LDY	#0
:2				LDA	TEXTBUF,Y
				BMI	:4
				STA	ALIEN_BUFFER,Y
				INY
				BNE	:2				;Always
:3				LDA	#$0A
				STA	ALIEN_BUFFER,Y
				INY
:4				CPY	#16
				BNE	:3
				RTS
:5				JMP	DRAW_NAME

*-------------------------------
*
*-------------------------------

CONVERT_STR		LDY	#0
:1				LDA	TEXTBUF,Y
				CMP	#$8D
				BEQ	:2
				JSR	CONVERT
				TXA
				STA	TEXTBUF,Y
				INY
				BNE	:1				;Always
:2				RTS

*-------------------------------
*
*-------------------------------

EDIT_0_9999		LDA	#4
				STA	MAXTEXT
				JSR	DRAW_0_9999
				JSR	INPUT_SUB
				BCC	:1
				LDY	ENTRY_OFFSET
				LDA	IN_BYTE1
				STA	ALIEN_BUFFER,Y
				LDA	IN_BYTE2
				STA	ALIEN_BUFFER+1,Y
:1				JMP	DRAW_0_9999

EDIT_0_99		LDA	#2
				STA	MAXTEXT
				JSR	DRAW_0_99
				JSR	INPUT_SUB
				BCC	:1
				LDY	ENTRY_OFFSET
				LDA	IN_BYTE2
				STA	ALIEN_BUFFER,Y
:1				JMP	DRAW_0_99

EDIT_0_255		LDA	#3
				STA	MAXTEXT
				JSR	DRAW_0_255
				JSR	INPUT_SUB
				BCC	:2
				LDX	#$FF
				LDA	IN_BYTE1
				CMP	#$02
				BCC	:1
				BNE	:7
				LDA	IN_BYTE2
				CMP	#$56
				BCS	:7
:1
				LDX	IN_BYTE1
				LDA	#0
				STA	IN_BYTE1
				TXA
				BEQ	:3
:4				LDA	#100
				JSR	ADDER
				DEX
				BNE	:4
:3
				LDA	IN_BYTE2
				LSR
				LSR
				LSR
				LSR
				BEQ	:5
				TAX
:6				LDA	#10
				JSR	ADDER
				DEX
				BNE	:6
:5
				LDA	IN_BYTE2
				AND	#%00001111
				JSR	ADDER

				LDX	IN_BYTE1
:7				LDY	ENTRY_OFFSET
				TXA
				STA	ALIEN_BUFFER,Y
:2				JMP	DRAW_0_255

ADDER			CLC
				ADC	IN_BYTE1
				STA	IN_BYTE1
				RTS

*-------------------------------
*
*-------------------------------

INPUT_SUB		LDA	DATA_XCRD
				LDY	ENTRY_YCRD
				JSR	INPUT
				JSR	CONVERT_STR
				LDA	DATA_XCRD
				LDY	ENTRY_YCRD
				JSR	LINE
				LDA	TEXTBUF
				CMP	#$8D
				CLC
				BEQ	:6

				LDY	#0
:1				LDA	TEXTBUF,Y
				CMP	#$8D
				BEQ	:2
				INY
				BNE	:1				;Always
:2				CPY	#4
				BEQ	:41

				LDX	#4
:3				LDA	TEXTBUF,Y
				STA	TEXTBUF,X
				DEX
				DEY
				BPL	:3

				LDA	#0
:4				STA	TEXTBUF,X
				DEX
				BPL	:4

:41				LDX	#0
				LDY	#0
:5				LDA	TEXTBUF,X
				INX
				ASL
				ASL
				ASL
				ASL
				STA	IN_BYTE1,Y
				LDA	TEXTBUF,X
				INX
				AND	#%00001111
				ORA	IN_BYTE1,Y
				STA	IN_BYTE1,Y
				INY
				CPY	#2
				BNE	:5

:6				RTS

IN_BYTE1		DB	0				;Must be consecutive
IN_BYTE2		DB	0				;  in this order

*-------------------------------
