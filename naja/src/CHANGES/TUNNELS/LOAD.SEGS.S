				LST	OFF
				TR	ON

MLI				MAC
				JSR	$BF00
				DB	]1
				DW	]2
				EOM

Open			=	$C8
Read			=	$CA
Close			=	$CC
SetMark			=	$CE
GetMark			=	$CF

AUX_PTR			=	$00				;$01
FILE_BUFFER		=	$1800
BUFFER			=	$1F00

				ORG	$1000

LOAD_SEGS
				STA	$C05F			;Clear double hires
				STA	$C05A			;Disable VBL interupt
				STA	$C058			;Disable mouse interupts
				STA	$C00E			;Normal character set
				STA	$C00C			;40 column
				STA	$C008			;Use main pages 0,1
				STA	$C002			;Use main 48K
				STA	$C000			;Page 2 switches page 1 and 2

				MLI	Open;OPEN_PRAMS1
				BCS	:4
				LDA	OPEN_PRAMS1+5
				STA	READ_PRAMS1+1
				STA	CLOSE_PRAMS1+1

				LDA	#$00
				STA	AUX_PTR
				LDA	#$04
				STA	AUX_PTR+1
:1				MLI	Read;READ_PRAMS1
				STA	$C005			;WRITE AUX MEMORY
				LDY	#0
:2				LDA	BUFFER,Y
				STA	(AUX_PTR),Y
				INY
				BNE	:2
				STA	$C004			;WRITE MAIN MEMORY
				INC	AUX_PTR+1
				LDA	AUX_PTR+1		;TEMP***
				CMP	#$C0			;TEMP***
				BEQ	:3				;TEMP***
				LDA	READ_PRAMS1+6
				CMP	READ_PRAMS1+4
				BNE	:3
				LDA	READ_PRAMS1+7
				CMP	READ_PRAMS1+5
				BEQ	:1
:3				MLI	Close;CLOSE_PRAMS1
:4
				RTS

OPEN_PRAMS1		DB	3
				DW	PATHNAME1
				DW	FILE_BUFFER
				DB	0				;FREF

READ_PRAMS1		DB	4
				DB	0				;FREF
				DW	BUFFER
				DW	256
				DW	0				;ACTUAL LENGTH

CLOSE_PRAMS1	DB	1
				DB	0				;FREF

PATHNAME1		STR	"SEGMENT.DATA1"

				SAV	LOAD.SEGS
