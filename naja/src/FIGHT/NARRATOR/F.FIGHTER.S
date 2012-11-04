dLeft			=	%00100000
dRight			=	%00010000
dLeftRight		=	dLeft.dRight
dForward		=	%00001000
dBackward		=	%00000100
dHLeft			=	%00000010
dHRight			=	%00000001
dHLeftRight		=	dHLeft.dHRight


INIT_MCOMMAND	JSR	COPY_FBYTES
				LDY	#monFLAGS
				LDA	(MONS_PTR),Y
				AND	#runningbit
				BNE	:1
				LDA	(MONS_PTR),Y
				AND	#runtestedbit!$FF	;Clear runtested bit
				STA	(MONS_PTR),Y
:1				LDA	SUPRISED_FLAG	;See if alien is suprised
				BPL	:2
				LDA	#$36			;  yes, parry for 36 time units
				JMP	POST_MPARRY
:2				LDA	ROUND
				BEQ	PICK_MCOMMAND
				RTS

PICK_MCOMMAND	JSR	DIRECTION_SUB
				LDY	#monFLAGS		;See if run possibility
				LDA	(MONS_PTR),Y	;  has been tested
				AND	#runtestedbit
				BNE	NOT_STARTING
				LDA	(MONS_PTR),Y	;  no, flag that it now has
				ORA	#runtestedbit
				STA	(MONS_PTR),Y
				_NoRunUntil			;See if it's too soon to run
				CMP	ROUND
				BEQ	:1
				BCS	NOT_STARTING
:1				_FrcRunAfter		;  no, see if must run now
				CMP	#$1F
				BEQ	NOT_STARTING
				CMP	ROUND
				BCC	FORCE_RUN
				BEQ	FORCE_RUN
				LDY	#aRetreatOdds	;  no, see if wants to run now
				LDA	(ALIEN_PTR),Y
				TAY
				JSR	FINAL_ODDS
				BCC	NOT_STARTING

FORCE_RUN		LDY	#monFLAGS		;  yes, flag alien as running
				LDA	(MONS_PTR),Y
				ORA	#runningbit
				STA	(MONS_PTR),Y

NOT_STARTING	LDY	#monFLAGS		;Round is not just starting so
				LDA	(MONS_PTR),Y	;  see if alien is running
				AND	#runningbit
				BEQ	NOT_RUNNING

				LDA	DIRCTN_BYTE		;  yes, see if they can move backwards
				AND	#dBackward
				BEQ	:1
				JMP	MOVE_BACKWARD	;  yes, move backwards
:1				LDA	DIRCTN_BYTE		;  no, see if left AND right possible
				AND	#dLeftRight
				CMP	#dLeftRight
				BNE	:2
				JMP	SMART_RETREAT	;  yes, retreat smartly
:2				JMP	FIDGET_LR		;  no, move left or right if possible

NOT_RUNNING		LDY	#monLASTCMD		;Alien is not running so
				LDA	(MONS_PTR),Y	;  see if last command was an aim
				AND	#%00001111
				CMP	#cmdAIM
				BNE	PREV_NOT_AIM
				LDY	#monSHOTS		;  yes, make sure alien still has
				LDA	(MONS_PTR),Y	;       shots left to take
				BEQ	PREV_NOT_AIM
				STA	TEMP
				_ShotsAtATime
				TAX
				LDA	#0
				SEC
:1				ROL
				DEX
				BPL	:1
				CMP	TEMP
				BCC	:2
				LDA	TEMP
:2				PHA
				JSR	HALF_UP			;Shots take half an upper time each
				LDX	#cmdSHOOT
				JSR	POST_MCOMMAND	;Give the shoot command
				PLA
				STA	(MONS_PTR),Y
				RTS

PREV_NOT_AIM	JSR	CALC_ROW		;Previous command was not aim so
				CMP	#1				;  see if alien's in front row
				BEQ	IN_FRONT_ROW
				JMP	NOT_IN_FRONT

IN_FRONT_ROW	_AttackType			;Alien's in front row so see
				BEQ	FRONT_PH		;  what type of attack it uses
				JMP	FRONT_EL

FRONT_PH		LDY	#monSWINGS
				LDA	(MONS_PTR),Y	;See if has swings left
				BEQ	:4
				JSR	GET_HITABLES	;  yes, see if someone to swing at
				BEQ	:1
				JMP	PICK_SWINGEE	;  yes, pick a person
:1				LDA	DIRCTN_BYTE		;No one to swing at so
				AND	#dHLeftRight	;  see if someone to move towards
				BEQ	:2
				JMP	TO_TARGET		;  yes, move towards them
:2				LDY	#monSHOTS		;No one to move towards so
				LDA	(MONS_PTR),Y	;  see if any shots left
				BEQ	:3
				JMP	AIM_OR_FIDGET	;  yes, then go aim if possible
:3				JMP	FIDGET_SUB		;  no, wait for a while
:4				LDY	#monSHOTS		;No swings left so
				LDA	(MONS_PTR),Y	;  see if any shots left
				BEQ	:5
				JMP	AIM_OR_FIDGET	;  yes, try to aim if possible
:5				JMP	RUN_OR_FIDGET	;  no, run or fidget

FRONT_EL		LDY	#monSHOTS		;See if has shots left
				LDA	(MONS_PTR),Y
				BEQ	:3
				JSR	AIM_SUB			;  yes, see if can aim at something
				BCC	:1
				JMP	DO_AIM			;  yes, do the aim
:1				LDY	#monSWINGS		;  no, see if has swings left
				LDA	(MONS_PTR),Y
				BEQ	:2
				JSR	GET_HITABLES	;  yes, see if someone to swing at
				BEQ	:2
				JMP	PICK_SWINGEE	;  yes, pick a person
:2				JMP	FIDGET_SUB		;No one to swing at, then FIDGET
:3				LDY	#monSWINGS		;No shots left so
				LDA	(MONS_PTR),Y	;  see if has swings left
				BEQ	:6
				JSR	GET_HITABLES	;  yes, see if someone to swing at
				BEQ	:4
				JMP	PICK_SWINGEE	;  yes, pick a person
:4				LDA	DIRCTN_BYTE		;  no, see if someone to move towards
				AND	#dHLeftRight
				BEQ	:5
				JMP	TO_TARGET		;  yes, move towards them
:5				JMP	FIDGET_SUB		;  no, wait for a while
:6				JMP	RUN_OR_FIDGET	;No swings left so run or fidget

NOT_IN_FRONT	_FrontRowRush
				CMP	#7				;If front row rush = 7 then
				BEQ	NO_RUSH			;  the monster never rushes front
				CMP	ROUND			;If > to round number then
				BEQ	:1				;  not rushing yet
				BCS	NO_RUSH
:1

RUSH_STARTED	LDY	#monSHOTS		;See if has any shots
				LDA	(MONS_PTR),Y	;  and/or swing left
				LDY	#monSWINGS
				ORA	(MONS_PTR),Y
				BEQ	:4
				LDA	DIRCTN_BYTE		;  yes, see if moving forward possible
				AND	#dForward
				BEQ	:1
				JMP	MOVE_FORWARD	;  yes, then move forward
:1				LDA	DIRCTN_BYTE		;  no, check other directions
				AND	#dLeftRight
				BEQ	:3
				CMP	#dLeftRight
				BEQ	:2
				JMP	MOVE_LORR		;Move left XOR right
:2				JMP	SMART_ADVANCE	;Move left or right intelligently
:3				JMP	AIM_IF_CLOSE	;Can't move so try to aim
:4				JMP	RUN_OR_FIDGET	;No shots or swing so try to run

NO_RUSH			LDY	#monSHOTS		;Not rushing front row so see
				LDA	(MONS_PTR),Y	;  if alien has any shots and/or
				LDY	#monSWINGS		;  swings left to take
				ORA	(MONS_PTR),Y
				BEQ	:1
				JMP	AIM_IF_CLOSE	;  yes, aim if possible
:1				_RunWhenOut			;  no, see if alien runs when
				BEQ	:2				;      out of attacks
				JMP	FORCE_RUN		;  yes, start running
:2				JMP	FIDGET_SUB		;  no, then wait a while


AIM_IF_CLOSE	LDY	#monSHOTS
				LDA	(MONS_PTR),Y
				BEQ	FIDGET_SUB		;If out of shots then FIDGET
				_FromRows1or2
				BEQ	AIM_OR_FIDGET
				JSR	CALC_ROW
				CMP	#3				;If must be in front 2 rows to
				BCS	FIDGET_SUB		;  shoot and isn't then FIDGET

AIM_OR_FIDGET	JSR	AIM_SUB
				BCC	FIDGET_SUB		;FIDGET if nothing to aim at

DO_AIM			PHA					;Post the aim command even
				JSR	TUPCALC			;  if the monsters cheat-aims
				LDX	#cmdAIM			;  because that will be caught
				JSR	POST_MCOMMAND	;  by the narrator
				PLA
				STA	(MONS_PTR),Y
				RTS

RUN_OR_FIDGET	_RunWhenOut
				BEQ	FIDGET_SUB		;If runs when attacks are gone
				JMP	FORCE_RUN		;  force monster to start running

FIDGET_SUB		_FidgetOdds
				BEQ	FIDGET_PARRY	;If never fidgets then parry
				JSR	ODDS_0123		;See if monster fidgets this time
				BCC	FIDGET_PARRY	;  no, then just parry
FIDGET_LR		LDA	DIRCTN_BYTE		;  yes, then move left or right
				AND	#dLeftRight		;       if possible
				BEQ	FIDGET_PARRY	;If not possible then parry
				JMP	MOVE_LANDR

FIDGET_PARRY	JSR	TLWCALC
POST_MPARRY		LDX	#cmdPARRY
POST_MCOMMAND	LDY	#monCMDCOUNT
				STA	(MONS_PTR),Y
				INY					;#monCRNTCMD
				TXA
				STA	(MONS_PTR),Y
				INY					;#monCRNTCMD+1
				RTS


*-------------------------------
*
*-------------------------------

TO_TARGET		CMP	#dHLeftRight
				BEQ	RND_LEFTRIGHT
				AND	#dHLeft
				BNE	MOVE_LEFT
				BEQ	MOVE_RIGHT		;Always

MOVE_LANDR		CMP	#dLeftRight
				BEQ	RND_LEFTRIGHT
MOVE_LORR		AND	#dLeft
				BNE	MOVE_LEFT
				BEQ	MOVE_RIGHT		;Always

RND_LEFTRIGHT	JSR	RNDMIZE
				BMI	MOVE_LEFT

MOVE_RIGHT		LDA	#$10
				BNE	MOVE_UR			;Always
MOVE_BACKWARD	LDA	#$01
MOVE_UR			CLC
				BCC	MOVE_FBLR		;Always
MOVE_LEFT		LDA	#$10
				BNE	MOVE_LB			;Always
MOVE_FORWARD	LDA	#$01
MOVE_LB			SEC					;Fall through

*-------------------------------
* On Entry:
*    Carry Set: Subtract
*  Carry Clear: Add
*   A: Value to add or subtract
*-------------------------------

MOVE_FBLR		STA	TEMP
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				BCC	:1
				SBC	TEMP
				BNE	:2				;Always
:1				ADC	TEMP
:2									;Fall through

*-------------------------------
* Enter with A = new position
*-------------------------------

POST_MOVE		PHA
				JSR	PRE_FILLCHK1
				ORA	#%01000000
				LDX	#%10111111
				JSR	FILL_GRID
				JSR	TLWCALC
				LDX	#cmdMOVE
				JSR	POST_MCOMMAND
				PLA
				STA	(MONS_PTR),Y
				RTS


*-------------------------------
*
*-------------------------------

DIRECTION_SUB	LDA	#0
				STA	DIRCTN_BYTE
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y

BACKWARD		PHA					;See if moving backwards is possible
				AND	#%00001111
				CMP	#$0A
				BEQ	:1				;  it's always possible from back row
				PLA
				PHA
				CLC
				ADC	#$01
				JSR	TRY_IT
				BCS	:2
:1				LDA	DIRCTN_BYTE		;Set #dBackward bit if possible
				ORA	#dBackward
				STA	DIRCTN_BYTE
:2				PLA

FORWARD			PHA					;See if moving forwards is possible
				AND	#%00001111
				CMP	#$06
				BEQ	:1				;  it's never possible from front row
				PLA
				PHA
				SEC
				SBC	#$01
				JSR	TRY_IT
				BCS	:1
				LDA	DIRCTN_BYTE		;Set #dForward bit if possible
				ORA	#dForward
				STA	DIRCTN_BYTE
:1				PLA

LEFT_RIGHT		PHA					;See if moving left is possible
				CMP	#$20
				BCC	:1				;  it's never possible from left row
				SEC
				SBC	#$10
				LDX	#dLeft
				LDY	#dHLeft
				JSR	TRY_LR
				PLA
				PHA
:1				CLC					;See if moving right is possible
				ADC	#$10
				LDX	#dRight
				LDY	#dHRight
				JSR	TRY_LR
				PLA
				LDY	#monPOSITION
				STA	(MONS_PTR),Y
				RTS

TRY_LR			STX	:MOD1+1
				STY	:MOD2+1
				LDY	#monPOSITION
				STA	(MONS_PTR),Y
				JSR	TRY_IT
				BCS	:1
				LDA	DIRCTN_BYTE
:MOD1			ORA	#$00			;Modified
				STA	DIRCTN_BYTE
				JSR	GET_HITABLES
				BEQ	:1
				LDA	DIRCTN_BYTE
:MOD2			ORA	#$00			;Modified
				STA	DIRCTN_BYTE
:1				RTS

TRY_IT			JSR	PRE_FILLCHK1
				JMP	CHECK_GRID


*-------------------------------
*
*-------------------------------

PICK_SWINGEE	JSR	SWING_SUB2
				PHA
				JSR	TUPCALC
				LDX	#cmdSWING
				JSR	POST_MCOMMAND
				PLA
				STA	(MONS_PTR),Y
				RTS

SWING_SUB		JSR	GET_HITABLES
				CLC
				BEQ	SWING_OUT
SWING_SUB2		JSR	RNDMIZE
				AND	#%00000111
				CMP	#5
				BCS	SWING_SUB2
				TAX
				LDA	HIT_MASKS,X
				AND	HITABLES
				BEQ	SWING_SUB2
				INX
				TXA
				SEC
SWING_OUT		RTS

*-------------------------------------------------------------
* Take byte that says where the alien can swing at and
*  adjust for the grid position of the alien.  Then check
*  which of those squares actually have characters (or images
*  if fooled) and set HITABLES accordingly.
*
* On Exit:
*   A: HITABLES
*   BNE/BEQ Valid
*-------------------------------------------------------------

GET_HITABLES	JSR	IMAGE_FOOLED
				LDY	#aSwingSquares
				LDA	(ALIEN_PTR),Y
				STA	TEMP
				LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				LSR
				LSR
				LSR
				LSR
				SEC
				SBC	#2
				BEQ	:3				;No alignment needed
				BCC	:2				;Go slide left
				TAX					;Slide right 1 to 3
:1				LSR	TEMP
				DEX
				BNE	:1
				BEQ	:3				;Always
:2				ASL	TEMP			;Slide left 1
:3
				LDA	#0
				LDX	#4
:4				LDY	MASTER_CGRID,X
				BPL	:5
				CPY	#$FF
				BEQ	:6
				BIT	IMAGE_FLAG
				BPL	:6
:5				ORA	HIT_MASKS,X
:6				DEX
				BPL	:4
				AND	TEMP
				AND	#%01111100
				STA	HITABLES
				RTS


*------------------------------------------
* Pick a square to aim at
*
* On Exit:
*   Carry Clear: No square found to aim at
*     Carry Set: Found square to aim at
*             A: Square that was found
*------------------------------------------

AIM_SUB			JSR	IMAGE_FOOLED
				LDX	#0
				LDY	#0
:1				LDA	MASTER_CGRID,X	;Make list of all squares that
				BPL	:2				;  contain characters
				CMP	#$FF
				BEQ	:3
				BIT	IMAGE_FLAG		;Is monster fooled by image generator?
				BPL	:3				;  no, omit from list
:2				TXA					;  yes, include in list
				STA	BUFFER_14,Y
				INY
:3				INX					;Loop until all aimable rows
				CPX	#25				;  have been checked
				BEQ	:4
				CPX	#10
				BCC	:1
				BNE	:1
				TYA
				BNE	:1
				_AimAtFront2
				BEQ	:1
:4				CLC
				TYA
				BEQ	:7
				STA	TEMP
:5				JSR	RNDMIZE			;Randomly pick a square from
				AND	#%00001111		;  the newly created list
				CMP	TEMP
				BCS	:5
				TAX
				LDA	BUFFER_14,X
				LDY	#6
				SEC
:6				DEY
				TAX					;Convert 0 to 24 index into
				SBC	#5				;  square coordinate form
				BCS	:6
				INX
				TXA
				ASL
				ASL
				ASL
				ASL
				STA	TEMP
				TYA
				ORA	TEMP
				SEC
:7				RTS


*-------------------------------
*
*-------------------------------

IMAGE_FOOLED	LDA	#susIMAGEN
				JSR	GET_SUSEPT
				JSR	ODDS_0123
				LDX	#0
				BCC	:2
				DEX
:2				STX	IMAGE_FLAG
				RTS

IMAGE_FLAG		DB	0


*---------------------------------
* Return the front-most row that
*   the monster occupies (1 to 5)
*---------------------------------

CALC_ROW		LDY	#monPOSITION
				LDA	(MONS_PTR),Y
				AND	#%00001111
				SEC
				SBC	#4
				SBC	TVIEW_HEIGHT
				RTS


*-------------------------------
* Move fight parameters bytes
*  into local variables
*-------------------------------

COPY_FBYTES		LDY	#aFightParams+4
				LDX	#4
:1				LDA	(ALIEN_PTR),Y
				LDA	BOGUS_FBYTES,X	;TEMP****
				STA	FBYTE1,X
				DEY
				DEX
				BPL	:1
				RTS

BOGUS_FBYTES	DB	%00000000		;TEMP***
				DB	%00000010
				DB	%10100000
				DB	%01001001
				DB	%11111000

*-------------------------------

HALF_UP			JSR	TUPCALC
				TAY
				LDX	#0
				JMP	AVERAGE_OF_2

*-------------------------------

BUFFER_14		DS	14				;Used in AIM_SUB
DIRCTN_BYTE		DB	0
HITABLES		DB	0
