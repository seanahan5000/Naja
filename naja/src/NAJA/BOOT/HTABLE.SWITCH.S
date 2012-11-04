********************************
*
*  HTABLE and SWITCH
*  (TEXTOUT <$980-$9FF> PUT AT $AE80)
*
********************************

LOBYTES			=	$0800
HIBYTES			=	$08C0

				ORG	$AE00

				STA	$C05F			;Clear double hires
				STA	$C05A			;Disable VBL interupt
				STA	$C058			;Disable mouse interupts
				STA	$C00E			;Normal character set
				STA	$C00C			;40 column
				STA	$C008			;Use main pages 0,1
				STA	$C002			;Use main 48K
				STA	$C000			;Page 2 switches page 1 and 2

MAKEHIRES		LDY	#$00
				STY	HOLD3
:LOOP1			LDA	HOLD3
				LSR
				AND	#$03
				STA	HOLD2
				LDA	HOLD3
				AND	#$18
				BCC	:SKIPA
				ADC	#$7F
:SKIPA			STA	HOLD1
				ASL
				ASL
				ORA	HOLD1
				STA	HOLD1
				CLC
				LDX	#$08
:LOOP2			LDA	HOLD1
				STA	LOBYTES,Y
				LDA	HOLD2
				STA	HIBYTES,Y
				ADC	#$04
				STA	HOLD2
				INY
				DEX
				BNE	:LOOP2
				INC	HOLD3
				CPY	#$C0
				BCC	:LOOP1
				RTS

HOLD1			DS	1
HOLD2			DS	1
HOLD3			DS	1
