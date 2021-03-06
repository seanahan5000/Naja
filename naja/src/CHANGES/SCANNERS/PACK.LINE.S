* SOURCE_PTR,+1 pointing to unpacked source data
*         INDEX offsetting to first source data byte
*    LAST_INDEX equaling last valid column + 1
*
* RECORD_BYTE routine defined to "write" byte in acc.

PACK_LINE		LDA	#0
				STA	STRAY_INDEX
:1				JSR	GET_BYTE
				BCC	:6
				STA	BYTE1
				LDA	INDEX
				STA	OLD_INDEX
				JSR	GET_BYTE
				BCC	:5
				STA	BYTE2
				LDA	#-2
				STA	REPCOUNT
:2				JSR	GET_BYTE
				BCC	:31
				CMP	BYTE1
				BNE	:3
				DEC	REPCOUNT
				JSR	GET_BYTE
				BCC	:31
				CMP	BYTE2
				BNE	:3
				DEC	REPCOUNT
				BNE	:2				;Always
:3				DEC	INDEX
:31				LDA	REPCOUNT
				CMP	#-3
				BCS	:4
				JSR	FLUSH_STRAYS
				LDA	REPCOUNT
				JSR	RECORD_BYTE
				LDA	BYTE1
				JSR	RECORD_BYTE
				LDA	BYTE2
				JSR	RECORD_BYTE
				JMP	:1
:4				LDA	OLD_INDEX
				STA	INDEX
:5				LDA	BYTE1
				JSR	RECORD_STRAY
				JMP	:1
:6				JMP	FLUSH_STRAYS

GET_BYTE		LDY	INDEX
				CPY	LAST_INDEX
				CLC
				BEQ	:1
				LDA	(SOURCE_PTR),Y
				INC	INDEX
				SEC
:1				RTS

RECORD_STRAY	LDX	STRAY_INDEX
				STA	STRAY_BUFFER,X
				INC	STRAY_INDEX
				RTS

FLUSH_STRAYS	LDA	STRAY_INDEX
				BEQ	:2
				JSR	RECORD_BYTE
				LDA	#0
:1				PHA
				TAX
				LDA	STRAY_BUFFER,X
				JSR	RECORD_BYTE
				PLA
				CLC
				ADC	#1
				CMP	STRAY_INDEX
				BNE	:1
				LDA	#0
				STA	STRAY_INDEX
:2				RTS

REPCOUNT		DB	0
BYTE1			DB	0
BYTE2			DB	0
OLD_INDEX		DB	0
STRAY_INDEX		DB	0
STRAY_BUFFER	DS	40
