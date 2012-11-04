dBUF1			=	$BB00
dBUF2			=	dBUF1+40

dBUGGER			STA	dREGA
				STY	dREGY
				STX	dREGX
				PHP
				CLD
				PLA
				STA	dSTAT
				PLA					;return low
				TAX
				PLA					;return high
				TAY
				LDA	$00
				PHA
				LDA	$01
				PHA
				TXA
				SEC
				SBC	#2
				TAX
				BCS	:1
				DEY
:1				STX	$00
				STY	$01

				LDX	#79
				LDA	#" "
:2				STA	dBUF1,X
				DEX
				BPL	:2

				LDX	#0
				LDA	$01
				JSR	dBYTE
				LDA	$00
				JSR	dBYTE

				INX
				LDA	dREGA
				JSR	dBYTE
				INX
				LDA	dREGY
				JSR	dBYTE
				INX
				LDA	dREGX
				JSR	dBYTE
				INX

				LDA	$00
				CLC
				ADC	#3
				STA	$00
				BCC	:3
				INC	$01
:3

				LDY	#0
:4				LDA	($00),Y
				INC	$00
				BNE	:5
				INC	$01
:5				CMP	#0
				BEQ	:6
				STA	dBUF1,X
				STA	dBUF2,X
				INX
				CPX	#40
				BNE	:4
:6

				JSR	dSWAP
				CLD
				STA	$C053
				BIT	$C010
:7				BIT	$C000
				BPL	:7
				BIT	$C010
				STA	$C052
				LDX	$00
				LDY	$01
				PLA
				STA	$01
				PLA
				STA	$00
				TYA
				PHA
				TXA
				PHA

dSWAP			LDX	#39
:1				LDY	dBUF1,X
				LDA	$07D0,X
				STA	dBUF1,X
				TYA
				STA	$07D0,X
				LDY	dBUF2,X
				LDA	$0BD0,X
				STA	dBUF2,X
				TYA
				STA	$0BD0,X
				DEX
				BPL	:1
				LDY	dREGY
				LDX	dREGX
				LDA	dSTAT
				PHA
				LDA	dREGA
				PLP
				RTS

dBYTE			PHA
				LSR
				LSR
				LSR
				LSR
				JSR	:1
				PLA
				AND	#%00001111
:1				CLC
				ADC	#"0"
				CMP	#"9"+1
				BCC	:2
				ADC	#6				;carry set
:2				STA	dBUF1,X
				STA	dBUF2,X
				INX
				RTS

dREGA			DB	0
dREGY			DB	0
dREGX			DB	0
dSTAT			DB	0
