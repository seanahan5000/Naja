				TR	ON
MLI				MAC
				JSR	$BF00
				DB	]1
				DW	]2
				EOM

OPEN			=	$C8
READ			=	$CA
CLOSE			=	$CC

End_Of_File		=	$4C


NDOS_RW			=	$8400
start_track		=	0
start_sector	=	0

				ORG	$1000

				JMP	BEGIN

SIDE			DB	0				;#4099
FILE_NAME		DS	64,0			;#4100

BEGIN			LDA	#0
				STA	QUIT

				LDA	#start_track
				STA	TRACK
				LDA	#start_sector
				STA	SECTOR
				LDA	#$40
				STA	READNUM

				MLI	OPEN;OPEN_PARMS
				BCS	:ERROR
				LDA	REF_NUM
				STA	READ_REF
				STA	CLOSE_REF

:LOOP1			MLI	READ;READ_PARMS
				LDX	ACTUAL_LENGTH+1
				CPX	#$40
				BEQ	:SKIPB
				DEC	QUIT
				LDA	ACTUAL_LENGTH
				BEQ	:SKIPA
				INX
:SKIPA			STX	READNUM
:SKIPB			LDA	TRACK
				STA	$7A
				LDA	SECTOR
				STA	$7B
				LDA	READNUM
				STA	$7C
				LDA	#$00
				STA	$12
				STA	$14
				LDA	#$20
				STA	$13
				LDA	SIDE
				STA	$15
				JSR	NDOS_RW
				BIT	QUIT
				BMI	:SKIPC
				LDA	TRACK
				CLC
				ADC	#4
				STA	TRACK
				BNE	:LOOP1			;Always

:SKIPC			MLI	CLOSE;CLOSE_PARMS
				BCC	:EXIT
:ERROR			BRK
:EXIT			RTS

QUIT			DB	0
TRACK			DB	0
SECTOR			DB	0
READNUM			DB	0


OPEN_PARMS		DB	3
				DW	FILE_NAME
				DW	$7800
REF_NUM			DB	0

READ_PARMS		DB	4
READ_REF		DB	0
				DW	$2000			;Read destination
				DW	$4000			;Wanted read length
ACTUAL_LENGTH	DW	0				;Actual read length

CLOSE_PARMS		DB	1
CLOSE_REF		DB	0

				SAV	SAVE.LONG
