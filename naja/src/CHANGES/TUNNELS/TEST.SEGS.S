				LST	OFF
				TR	ON

PAGE			=	$E6
HBUFFER			=	$1F02

DATA_PTR		=	$00				;$01
PTR				=	$00				;$01
PATCH_NUMBER	=	$02

MaxDepth		=	4

				ORG	$8000

				JMP	INSTALL_DRAW
				JMP	TEST_HALLS
				JMP	OPEN_DOOR

INSTALL_DRAW
				SEI
				LDA	$C083			;R/W RAM $D000,b2
				LDA	$C083
				STA	$C009			;use aux zpage/stack

				LDX	#0
:1				LDA	$6000,X
				STA	$FA00,X
				LDA	$6100,X
				STA	$FB00,X
				LDA	$6200,X
				STA	$FC00,X
				LDA	$6300,X
				STA	$FD00,X
				LDA	$6400,X
				STA	$FE00,X
				INX
				BNE	:1

				LDA	#$20
				STA	:2+2
				LDA	#$D0
				STA	:3+2
				LDX	#0
:2				LDA	$2000,X			;Modified
:3				STA	$D000,X			;Modified
				INX
				BNE	:2
				INC	:2+2
				INC	:3+2
				LDA	:3+2
				CMP	#$F5
				BNE	:2

				STA	$C008			;use main zpage/stack
				LDA	$C082			;R ROM, no write
				CLI

				STA	$C05F			;Clear double hires
				STA	$C05A			;Disable VBL interupt
				STA	$C058			;Disable mouse interupts
				STA	$C00E			;Normal character set
				STA	$C00C			;40 column
				STA	$C008			;Use main pages 0,1
				STA	$C002			;Use main 48K
				STA	$C000			;Page 2 switches page 1 and 2
				STA	$C050			;TEMP???
				STA	$C057			;TEMP???
				JMP	$1000

*-------------------------------

TEST_HALLS		LDX	#0
:1				LDA	HBUFFER,X
				CMP	#$FF
				BEQ	:2
				INX
				CPX	#MaxDepth*2+2
				BNE	:1
:2				DEX
				TXA
				LSR
				STA	DEPTH
				STX	SEG_COUNT

:3				JSR	HALLWAY_SUB
				DEC	SEG_COUNT
				DEC	SEG_COUNT
				DEC	DEPTH
				BPL	:3
				RTS

*-------------------------------

DOOR_HALLS		LDX	#0
:1				LDA	HBUFFER,X
				CMP	#$FF
				BEQ	:2
				INX
				CPX	#MaxDepth*2
				BNE	:1
:2				DEX
				TXA
				LSR
				STA	DEPTH
				INC	DEPTH
				STX	SEG_COUNT

:3				JSR	HALLWAY_SUB
				DEC	SEG_COUNT
				DEC	SEG_COUNT
				DEC	DEPTH
				BPL	:3
				RTS

SEG_COUNT		DB	0
DEPTH			DB	0

*-------------------------------

* - if A4L
*      - draw A4L
* - if NOT A4L
*      - if B4L
*           - draw P4L
*           - draw B4L
*      - if NOT B4L
*           - if C4 or A(4+1)L
*                - draw P4L

* - if A4R
*      - draw A4R
* - if NOT A4R
*      - if B4R
*           - draw P4R
*           - draw B4R
*      - if NOT B4R
*           - if C4 or A(4+1)R
*                - draw P4R

* - if C4
*      - draw C4
*           - if A4L
*                - draw E4L
*           - if A4R
*                - draw E4R

*-------------------------------

HALLWAY_SUB
RIGHT_SIDE		LDX	SEG_COUNT
				LDA	HBUFFER,X
				TAY
				AND	#%11100000
				BEQ	:1
				JSR	DRAW_RSIDE
				JMP	:4
:1				TYA
				AND	#%00000111
				BEQ	:2
				JSR	DRAW_RPILLAR
				JSR	DRAW_RFRONT
				JMP	:4
:2				LDA	HBUFFER+1,X
				CMP	#$FF
				BEQ	:3
				LDA	HBUFFER+2,X
				AND	#%11100000
				BEQ	:4
				LDA	DEPTH
				CMP	#MaxDepth
				BEQ	:4
:3				JSR	DRAW_RPILLAR
:4

LEFT_SIDE		LDX	SEG_COUNT
				LDA	HBUFFER-1,X
				TAY
				AND	#%11100000
				BEQ	:1
				JSR	DRAW_LSIDE
				JMP	:4
:1				TYA
				AND	#%00000111
				BEQ	:2
				JSR	DRAW_LPILLAR
				JSR	DRAW_LFRONT
				JMP	:4
:2				LDA	HBUFFER+1,X
				CMP	#$FF
				BEQ	:3
				AND	#%11100000
				BEQ	:4
				LDA	DEPTH
				CMP	#MaxDepth
				BEQ	:4
:3				JSR	DRAW_LPILLAR
:4

CENTER			LDX	SEG_COUNT
				LDA	HBUFFER+1,X
				CMP	#$FF
				BNE	:2
				JSR	DRAW_CFRONT

				LDY	#0
				LDX	SEG_COUNT
				LDA	HBUFFER+2,X
				AND	#%11000000
				CMP	#%10000000
				BNE	:3
				INY
:3				STY	PATCH_NUMBER

				LDX	SEG_COUNT
				LDA	HBUFFER,X
				AND	#%11100000
				BEQ	:1
				AND	#%11000000
				CMP	#%10000000
				BNE	:4
				LDA	PATCH_NUMBER
				CLC
				ADC	#2
				STA	PATCH_NUMBER
:4				JSR	DRAW_RPATCH
:1
				LDA	PATCH_NUMBER
				AND	#%00000001
				STA	PATCH_NUMBER
				LDX	SEG_COUNT
				LDA	HBUFFER-1,X
				AND	#%11100000
				BEQ	:2
				AND	#%11000000
				CMP	#%10000000
				BNE	:5
				LDA	PATCH_NUMBER
				CLC
				ADC	#2
				STA	PATCH_NUMBER
:5				JSR	DRAW_LPATCH
:2
				RTS

*-------------------------------

DRAW_LSIDE		LDY	DEPTH
				LDX	SEG_COUNT
				LDA	HBUFFER-1,X
				AND	#%11000000
				CMP	#%10000000
				BNE	:1
				JMP	DRAW_DOOR
:1				JMP	DRAW_SEG

DRAW_LFRONT		LDA	DEPTH
				CLC
				ADC	#15
				TAY
				LDX	SEG_COUNT
				LDA	HBUFFER-1,X
				AND	#%00000011
				CMP	#%00000010
				BNE	:1
				JMP	DRAW_DOOR
:1				JMP	DRAW_SEG

DRAW_RSIDE		LDA	DEPTH
				CLC
				ADC	#5
				TAY
				LDX	SEG_COUNT
				LDA	HBUFFER,X
				AND	#%11000000
				CMP	#%10000000
				BNE	:1
				JMP	DRAW_DOOR
:1				JMP	DRAW_SEG

DRAW_RFRONT		LDA	DEPTH
				CLC
				ADC	#20
				TAY
				LDX	SEG_COUNT
				LDA	HBUFFER,X
				AND	#%00000011
				CMP	#%00000010
				BNE	:1
				JMP	DRAW_DOOR
:1				JMP	DRAW_SEG

DRAW_CFRONT		LDA	DEPTH
				CLC
				ADC	#10
				TAY
				LDX	SEG_COUNT
				LDA	HBUFFER+2,X
				AND	#%11000000
				CMP	#%10000000
				BNE	:1
				JMP	DRAW_DOOR
:1				JMP	DRAW_SEG

DRAW_LPILLAR	LDA	DEPTH
				CLC
				ADC	#25
				TAY
				JMP	DRAW_SEG

DRAW_RPILLAR	LDA	DEPTH
				CLC
				ADC	#30
				TAY
				JMP	DRAW_SEG

DRAW_LPATCH
				LDA	DEPTH
				ASL
				ASL
				CLC
				ADC	DEPTH
				CLC
				ADC	#60
				PHA
				TAY
				JSR	DRAW_SEG
				PLA
				SEC
				ADC	PATCH_NUMBER
				TAY
				JMP	DRAW_SEG

DRAW_RPATCH
				LDA	DEPTH
				ASL
				ASL
				CLC
				ADC	DEPTH
				CLC
				ADC	#85
				PHA
				TAY
				JSR	DRAW_SEG
				PLA
				SEC
				ADC	PATCH_NUMBER
				TAY
				JMP	DRAW_SEG

DRAW_OPENDOOR	LDY	#110
				JSR	DRAW_SEG
				LDY	#111
				JMP	DRAW_SEG

*-------------------------------

DRAW_DOOR		TYA
				CLC
				ADC	#35
				TAY
DRAW_SEG		SEI
				LDA	$C083			;R/W RAM $D000,b2
				LDA	$C083
				LDX	PAGE
				STA	$C009			;use aux zpage/stack
				STX	PAGE
				TYA
				JSR	$FA00
				STA	$C008			;use main zpage/stack
				CLI
				LDA	$C082			;R ROM, no write
				RTS

				PUT	DOOR.OPEN
				PUT	/CHANGES/HIRES.TABLES
				SAV	TEST.SEGS
