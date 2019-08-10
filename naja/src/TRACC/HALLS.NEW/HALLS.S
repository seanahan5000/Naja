
GET_NSEW
				; save the starting point for later restore
				JSR	SAVE_STATE

				LDA	#$00
				STA	MAP_INDEX

:NEXT			JSR	MOVE_LEFT
				JSR	LOAD_MAP_DATA
				STA	DATA_LEFT
				JSR	MOVE_RIGHT
				JSR	LOAD_MAP_DATA
				STA	DATA_CENTER
				JSR	MOVE_RIGHT
				JSR	LOAD_MAP_DATA
				STA	DATA_RIGHT
				JSR	MOVE_LEFT

				; Nl.El.Sl.Wl  Nc.Ec.Sc.Wc  Nr.Er.Sr.Wr
				;			   ^^
				;		Nc.Wc.Nl.Wl  Nc.Ec.Nr.Er
				;		^^           ^^

				;
				; build Nc.Wc.Nl.Wl from Nl.El.Sl.Wl and Nc.Ec.Sc.Wc
				;

				LDA	DATA_CENTER		; Nc.Ec.Sc.Wc
				ASL
				ASL
				ASL
				ASL					; Sc.Wc.00.00
				EOR	DATA_LEFT		; XX.XX.Sl.Wl
				AND	#$F0			; XX.XX.00.00
				EOR	DATA_LEFT		; Sc.Wc.Sl.Wl
				STA	DATA_TEMP

				LDA	DATA_LEFT		; Wl.Sl.El.Nl
				ASL
				ASL					; Sl.El.Nl.00
				EOR	DATA_CENTER		; XX.XX.XX.Wc
				AND	#$0F			; 00.00.XX.Wc
				EOR	DATA_CENTER		; Nc.Ec.Nl.00
				EOR	DATA_TEMP		; XX.XX.XX.Wl
				AND	#$CC			; XX.00.XX.00
				EOR	DATA_TEMP		; Nc.Wc.Nl.Wl

				LDX	MAP_INDEX
				STA	MAP_BUFFER,X
				INX

				;
				; build Nc.Ec.Nr.Er from Nc.Ec.Sc.Wc and Nr.Er.Sr.Wr
				;

				LDA	DATA_RIGHT		; Nr.Er.Sr.Wr
				LSR
				LSR
				LSR
				LSR					; 00.00.Nr.Er
				EOR	DATA_CENTER		; Nc.Ec.XX.XX
				AND	#$0F			; 00.00.XX.XX
				EOR	DATA_CENTER		; Nc.Ec.Nr.Er
				STA	MAP_BUFFER,X
				INX

				AND	#$C0			; stop if not an opening
				BNE	:DONE

				STX	MAP_INDEX
				JSR	MOVE_FORWARD
				JMP	:NEXT

:DONE
				;*** store a terminator? ***
				STX	MAP_INDEX

				; restore starting point and save ending point
				; fall through

; swap MAP_FACE through MAP_PTR_H state

SWAP_STATE		LDX	#5
:1				LDY	MAP_FACE,X
				LDA	SAVED_STATE,X
				STA	MAP_FACE,X
				TYA
				STA	SAVED_STATE,X
				DEX
				BPL	:1
				RTS

; save MAP_FACE through MAP_PTR_H state

SAVE_STATE		LDX	#5
:1				LDA	MAP_FACE,X
				STA	SAVED_STATE,X
				DEX
				BPL	:1
				RTS

SAVED_STATE		DS	6

SET_MAP_DATA	STX	MAP_PTR_MOD_L+1
				STY	MAP_PTR_MOD_H+1
				STA	MAP_SIZE
				RTS

LOAD_MAP_DATA	LDY	MAP_X
				LDA	(MAP_PTR_L),Y		; NN.EE.SS.WW
				LDX	MAP_DIR
				BEQ	:2
				STA	DATA_TEMP
:1				ASL
				ADC	#0
				ASL
				ADC	#0
				DEX
				BNE	:1
:2				RTS

MOVE_LEFT		JSR	TURN_LEFT
				JSR	MOVE_FORWARD		; fall through

TURN_RIGHT		LDX	MAP_DIR
				INX
				TXA
				AND	#$03
				STA	MAP_DIR
				RTS

MOVE_RIGHT		JSR	TURN_RIGHT
				JSR	MOVE_FORWARD		; fall through

TURN_LEFT		LDX	MAP_DIR
				DEX
				TXA
				AND	#$03
				STA	MAP_DIR
				RTS

TURN_AROUND		LDX	MAP_DIR
				INX
				INX
				TXA
				AND	#$03
				STA	MAP_DIR
				RTS

MOVE_FORWARD	LDX	MAP_DIR
				DEX
				BPL	:ESW

:N				LDY	MAP_Y
				DEY
				BMI	CHANGE_FACE
				STY	MAP_Y

				LDA	MAP_PTR_L
				SEC
				SBC	MAP_SIZE
				STA MAP_PTR_L
				BCS	:N2
				DEC	MAP_PTR_H
:N2				RTS

:ESW			DEX
				BPL	:SW

				LDX	MAP_X
				INX
				CPX	MAP_SIZE
				BEQ	CHANGE_FACE
				STA	MAP_X
				RTS

:SW				DEX
				BPL	:W

:S				LDY	MAP_Y
				INY
				CPY	MAP_SIZE
				BEQ	CHANGE_FACE
				STY	MAP_Y

				LDA	MAP_PTR_L
				CLC
				ADC	MAP_SIZE
				STA MAP_PTR_L
				BCC	:S2
				INC	MAP_PTR_H
:S2				RTS

:W				LDX	MAP_X
				DEX
				BMI	CHANGE_FACE
				STX	MAP_X
				RTS

CHANGE_FACE		LDA	MAP_X
				STA	FACE_TABLE+1
				LDA	MAP_Y
				STA	FACE_TABLE+2
				LDX	MAP_SIZE
				DEX
				STX	FACE_TABLE+3
				TXA
				SEC
				SBC	MAP_X
				STA	FACE_TABLE+4
				TXA
				SEC
				SBC	MAP_Y
				STA	FACE_TABLE+5

				LDA	MAP_FACE
				ASL
				ASL					; four entries per source face
				ADC	MAP_DIR			; (carry always clear)
				ASL					; two entries per direction
				TAX
				LDA	FACE_DATA+0,X
				TAY
				AND	#$03
				STA	MAP_DIR
				TYA
				LSR
				LSR
				STA	MAP_FACE
				LDA	FACE_DATA+1,X
				TAY
				LSR
				LSR
				LSR
				LSR
				TAX
				LDA	FACE_TABLE,X
				STA	MAP_X
				TYA
				AND	#$0F
				TAX
				LDA	FACE_TABLE,X
				STA	MAP_Y				; fall through

COMPUTE_MAP_PTR
MAP_PTR_MOD_L	LDA	#$FF
				STA	TEMP_PTR_L
MAP_PTR_MOD_H	LDA	#$FF
				STA	TEMP_PTR_H

				LDA	MAP_FACE
				ASL
				TAY
				LDA	(TEMP_PTR_L),Y
				STA	MAP_PTR_L
				INY
				LDA	(TEMP_PTR_L),Y
				STA	MAP_PTR_H

				LDA	MAP_Y
				ASL
				ADC	#6*2				; carry clear
				TAY
				LDA	(TEMP_PTR_L),Y
				ADC	MAP_PTR_L			; carry clear
				STA	MAP_PTR_L
				INY
				LDA	(TEMP_PTR_L),Y
				ADC	MAP_PTR_H
				STA	MAP_PTR_H
				RTS

; TODO: consider building table in ZPAGE
FACE_TABLE		DB	0				; 0: 0
				DB	0				; 1: MAP_X
				DB	0				; 2: MAP_Y
				DB	0				; 3: MAP_SIZE - 1 - 0
				DB	0				; 4: MAP_SIZE - 1 - MAP_X
				DB	0				; 5: MAP_SIZE - 1 - MAP_Y

;		+---+
;		| 0 |
;	+---+---+---+---+---+
;	| 4 | 1 | 2 | 3 | 4 |
;	+---+---+---+---+---+
;		| 5 |
;		+---+

north			=	0
east			=	1
south			=	2
west			=	3

FACE_DATA		DB	3 * 2 + south, $40		; north -> 3 south	size-x	0
				DB	2 * 2 + south, $50		; east  -> 2 south	size-y	0
				DB	1 * 2 + south, $10		; south -> 1 south	x		0
				DB	4 * 2 + south, $20		; west  -> 4 south	y		0

				DB	0 * 2 + north, $13		; north -> 0 north	x		size
				DB	2 * 2 + east,  $02		; east  -> 2 east 	0		y
				DB	5 * 2 + south, $10		; south -> 5 south	x		0
				DB	4 * 2 + west,  $32		; west  -> 4 west 	size	y

				DB	0 * 2 + west,  $34		; north -> 0 west 	size	size-x
				DB	3 * 2 + east,  $02		; east  -> 3 east 	0		y
				DB	5 * 2 + west,  $31		; south -> 5 west 	size	x
				DB	1 * 2 + west,  $32		; west  -> 1 west 	size	y

				DB	0 * 2 + south, $40		; north -> 0 south	size-x	0
				DB	4 * 2 + east,  $02		; east  -> 4 east 	0		y
				DB	5 * 2 + north, $43		; south -> 5 north	size-x	size
				DB	2 * 2 + west,  $32		; west  -> 2 west 	size	y

				DB	0 * 2 + east,  $01		; north -> 0 east 	0		x
				DB	1 * 2 + east,  $02		; east  -> 1 east 	0		y
				DB	5 * 2 + east,  $04		; south -> 5 east 	0		size-x
				DB	3 * 2 + west,  $32		; west  -> 3 west 	size	y

				DB	1 * 2 + north, $13		; north -> 1 north	x		size
				DB	2 * 2 + north, $23		; east  -> 2 north	y		size
				DB	3 * 2 + north, $43		; south -> 3 north	size-x	size
				DB	4 * 2 + north, $53		; west  -> 4 north	size-y	size
