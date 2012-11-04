PASS_FAIL		LDY	#profrace
				LDA	(CHARDL),Y
				LSR
				LSR
				LSR
				LSR
				TAY
				LDA	PROFSET,Y
				JSR	TOTALER
				SEC
				LDX	#3
				LDY	#experience+3
:LOOP1			LDA	LEVTOTL,X
				SED
				SBC	(CHARDL),Y
				CLD
				STA	LEVTOTL,X
				DEY
				DEX
				BPL	:LOOP1
				BCC	:SKIPA			;Passes
				LDX	#3
:LOOP2			LDA	LEVTOTL,X
				CLC					;Fails
				BNE	:EXIT
				DEX
				BPL	:LOOP2
:SKIPA			SEC					;Passes
:EXIT			RTS

PROFSET			DB	$00,$00,$01
				DB	$02,$01,$FF
				DB	$01

TOTALER			ASL
				TAY
				LDA	SETS,Y
				STA	TEMP
				LDA	SETS+1,Y
				STA	TEMP+1
				LDX	#3
				LDA	#0
:LOOP1			STA	LEVTOTL,X
				DEX
				BPL	:LOOP1
				LDY	#level
				LDA	(CHARDL),Y
				STA	LEVCNT
				INY
				LDA	(CHARDL),Y
				STA	LEVCNT+1
:LOOP2			LDA	LEVCNT
				STA	LEVHOLD
				LDA	LEVCNT+1
				STA	LEVHOLD+1
				JSR	CVERTER
				DEX
				TXA
				ASL
				TAY
				LDX	#1
:LOOP3			LDA	(TEMP),Y
				STA	ONERANK,X
				INY
				INX
				CPX	#3
				BNE	:LOOP3
				CLC
:LOOP4			LDA	LEVTOTL,X
				SED
				ADC	ONERANK,X
				CLD
				STA	LEVTOTL,X
				DEX
				BPL	:LOOP4
				LDA	LEVCNT+1
				SEC
				SED
				SBC	#$01
				STA	LEVCNT+1
				LDA	LEVCNT
				SBC	#$00
				STA	LEVCNT
				CLD
				LDA	LEVCNT+1
				BNE	:LOOP2
				LDA	LEVCNT
				BNE	:LOOP2
				RTS

DOCOTAB			LDY	#0
				LDX	#0
:LOOP1			TYA
				STA	CONTAB,X
				INY
				TXA
				SED
				CLC
				ADC	#$01
				CLD
				TAX
				CPY	#51
				BNE	:LOOP1
				RTS

CVERTER			LDA	LEVHOLD
				BEQ	NOT2HI
TOHI			LDX	#$31
				RTS
NOT2HI			LDA	LEVHOLD+1	
				CMP	#$50
				BCS	TOHI
				TAY
				LDA	CONTAB,Y
				TAX
				RTS

LEVTOTL			DB	0,0,0,0
LEVCNT			DB	0,0
LEVHOLD			DB	0,0
ONERANK			DB	0,0,0,0

SETS			DW	WARAND
				DW	CYBPHY
				DW	JUICER

WARAND			DB	$00,$20
				DB	$00,$20
				DB	$00,$30
				DB	$00,$40
				DB	$00,$50
				DB	$00,$60
				DB	$00,$70
				DB	$00,$90
				DB	$01,$00
				DB	$01,$20
				DB	$01,$30
				DB	$01,$50
				DB	$01,$70
				DB	$01,$90
				DB	$02,$10
				DB	$02,$30
				DB	$02,$50
				DB	$02,$80
				DB	$03,$00
				DB	$03,$30
				DB	$03,$50
				DB	$03,$80
				DB	$04,$10
				DB	$04,$40
				DB	$04,$70
				DB	$05,$00
				DB	$05,$30
				DB	$05,$70
				DB	$06,$00
				DB	$06,$30
				DB	$06,$70
				DB	$07,$10
				DB	$07,$50
				DB	$07,$90
				DB	$08,$30
				DB	$08,$70
				DB	$09,$10
				DB	$09,$60
				DB	$10,$00
				DB	$10,$50
				DB	$10,$90
				DB	$11,$40
				DB	$11,$90
				DB	$12,$40
				DB	$12,$90
				DB	$13,$40
				DB	$13,$90
				DB	$14,$50
				DB	$15,$00

CYBPHY			DB	$00,$10
				DB	$00,$10
				DB	$00,$20
				DB	$00,$20
				DB	$00,$30
				DB	$00,$30
				DB	$00,$40
				DB	$00,$50
				DB	$00,$60
				DB	$00,$60
				DB	$00,$70
				DB	$00,$80
				DB	$00,$90
				DB	$01,$00
				DB	$01,$20
				DB	$01,$30
				DB	$01,$40
				DB	$01,$50
				DB	$01,$70
				DB	$01,$80
				DB	$02,$00
				DB	$02,$10
				DB	$02,$30
				DB	$02,$50
				DB	$02,$60
				DB	$02,$80
				DB	$03,$00
				DB	$03,$20
				DB	$03,$40
				DB	$03,$60
				DB	$03,$80
				DB	$04,$00
				DB	$04,$20
				DB	$04,$40
				DB	$04,$70
				DB	$04,$90
				DB	$05,$20
				DB	$05,$40
				DB	$05,$70
				DB	$05,$90
				DB	$06,$20
				DB	$06,$40
				DB	$06,$70
				DB	$07,$00
				DB	$07,$30
				DB	$07,$60
				DB	$07,$90
				DB	$08,$20
				DB	$08,$50

JUICER			DB	$00,$10
				DB	$00,$20
				DB	$00,$20
				DB	$00,$30
				DB	$00,$40
				DB	$00,$50
				DB	$00,$60
				DB	$00,$70
				DB	$00,$80
				DB	$00,$90
				DB	$01,$00
				DB	$01,$10
				DB	$01,$30
				DB	$01,$40
				DB	$01,$60
				DB	$01,$80
				DB	$01,$90
				DB	$02,$10
				DB	$02,$30
				DB	$02,$50
				DB	$02,$70
				DB	$02,$90
				DB	$03,$10
				DB	$03,$30
				DB	$03,$60
				DB	$03,$80
				DB	$04,$10
				DB	$04,$30
				DB	$04,$60
				DB	$04,$90
				DB	$05,$10
				DB	$05,$40
				DB	$05,$70
				DB	$06,$00
				DB	$06,$30
				DB	$06,$70
				DB	$07,$00
				DB	$07,$30
				DB	$07,$70
				DB	$08,$00
				DB	$08,$40
				DB	$08,$70
				DB	$09,$10
				DB	$09,$50
				DB	$09,$90
				DB	$10,$30
				DB	$10,$70
				DB	$11,$10
				DB	$11,$50
