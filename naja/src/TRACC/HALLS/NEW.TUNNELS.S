
MAP_DATA		DW	MAP_FACE_0
				DW	MAP_FACE_1
				DW	MAP_FACE_2
				DW	MAP_FACE_3
				DW	MAP_FACE_4
				DW	MAP_FACE_5

				DW	#17*0
				DW	#17*1
				DW	#17*2
				DW	#17*3
				DW	#17*4
				DW	#17*5
				DW	#17*6
				DW	#17*7
				DW	#17*8
				DW	#17*9
				DW	#17*10
				DW	#17*11
				DW	#17*12
				DW	#17*13
				DW	#17*14
				DW	#17*15
				DW	#17*16



MAP_SIZE		=	ZBLOCK+$0
MAP_FACE		=	ZBLOCK+$1			; must be sequential
MAP_X			=	ZBLOCK+$2			; must be sequential
MAP_Y			=	ZBLOCK+$3			; must be sequential
MAP_DIR			=	ZBLOCK+$4			; must be sequential
MAP_PTR_L		=	ZBLOCK+$5			; must be sequential
MAP_PTR_H		=	ZBLOCK+$6			; must be sequential

MAP_INDEX		DS	1					;*** ZPAGE INSTEAD?
MAP_BUFFER		DS	24					;*** HOW MUCH SPACE NEEDED?

DATA_TEMP		=	$00
DATA_LEFT		=	$01
DATA_CENTER		=	$02
DATA_RIGHT		=	$03


;*** WOULD IT BE MORE EFFICIENT IF DATA WAS STORED NN.EE.SS.WW ? ***
	;*** EASIER TO TEST NORTH USING BIT INSTRUCTION ***

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

				LDX	MAP_INDEX

				; Wl.Sl.El.Nl  Wc.Sc.Ec.Nc  Wr.Sr.Er.Nr
				;						^^
				;		Wl.Nl.Wc.Nc  Er.Nr.Ec.Nc
				;				 ^^           ^^

				;
				; build Wl.Nl.Wc.Nc from Wl.Sl.El.Nl and Wc.Sc.Ec.Nc
				;
				LDA	DATA_LEFT		; Wl.Sl.El.Nl
				ASL
				ASL
				ASL
				ASL					; El.Nl.00.00
				EOR	DATA_CENTER		; XX.XX.Ec.Nc
				AND	#$F0			; XX.XX.00.00
				EOR	DATA_CENTER		; El.Nl.Ec.Nc
				STA	DATA_TEMP

				LDA	DATA_CENTER		; Wc.Sc.Ec.Nc
				LSR
				LSR
				LSR
				LSR					; 00.00.Wc.Sc
				EOR	DATA_LEFT		; Wl.Sl.XX.XX
				AND	#$0F			; 00.00.XX.XX
				EOR	DATA_LEFT		; Wl.Sl.Wc.Sc
				EOR	DATA_TEMP
				AND	#$CC			; XX.00.XX.00
				EOR	DATA_TEMP			; Wl.Nl.Wc.Nc
				STA	MAP_BUFFER,X
				INX

				;
				; build Er.Nr.Ec.Nc from Wc.Sc.Ec.Nc and Wr.Sr.Er.Nr
				;
				LDA	DATA_RIGHT		; Wr.Sr.Er.Nr
				ASL
				ASL
				ASL
				ASL					; Er.Nr.00.00
				EOR	DATA_CENTER		; XX.XX.Ec.Nc
				AND	#$F0			; XX.XX.00.00
				EOR	DATA_CENTER		; Er.Nr.Ec.Nc
				STA	MAP_BUFFER,X
				INX

				AND	#$03			; stop if not an opening
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
				STY	SAVED_STATE,X
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
				STY	MAP_PTR_MOD_H+2
				STA	MAP_SIZE
				RTS

LOAD_MAP_DATA	LDY	MAP_X
				LDA	(MAP_PTR_L),Y
				LDX	MAP_DIR
				BEQ	:2
				STA	DATA_TEMP
:1				LSR	DATA_TEMP
				ROR
				LSR	DATA_TEMP
				ROR
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
				ADD	MAP_DIR			; (carry always clear)
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

FACE_DATA		;*** FILL IN DATA ***


