*-------------------------------

SENTENCE_PRET	JSR	SENTENCE
PERIOD_RETURN	JSR	PERIOD
RETURN			JSR	NARLINE
				INC	TLINE
				BNE	CLEAR_TEXT		;Always

*-------------------------------

SENTENCE_PRD	JSR	SENTENCE
PERIOD			CPX	#lastTextCol+1
				BCS	:EXIT
				LDA	#$2D
				STA	TEXTBUF,X
				INX
				INX
				INX
:EXIT			RTS

*-------------------------------

CLEAR_TLINE1	LDA	#1
CLEAR_TLINE		STA	TLINE
CLEAR_TEXT		LDX	#30				;Must not change Y register
				LDA	#$0A
:LOOP1			STA	TEXTBUF,X
				DEX
				BPL	:LOOP1
				INX
				LDA	#$8D	
				STA	TEXTBUF+31
				RTS

TLINE			DB	0

*-------------------------------

NARLINE			LDY	TLINE
				LDA	LINEYS,Y
				TAY
				LDA	#$5D
				JMP	LINE

LINEYS			DB	$81,$8A,$93
				DB	$9C,$A5,$AE
				DB	$B7

*-------------------------------

WORD1_INC		JSR	WORD1
				INX
				RTS

WORD1_PRDRET	JSR	WORD1
				JMP	PERIOD_RETURN

WORD1_RET		JSR	WORD1
				JMP	RETURN

WORD2_INC		JSR	WORD2
				INX
				RTS

WORD2_PRDRET	JSR	WORD2
				JMP	PERIOD_RETURN

WORD2_RET		JSR	WORD2
				JMP	RETURN

WORD2			PHA
				JSR	WORD1
				PLA
				TAY
				INX
WORD1			CPY	#xMonsName
				BCS	:SKIPA
				TYA
				PHA
				LSR
				LSR
				LSR
				AND	#%11111110
				TAY
				LDA	BLOCK_LIST,Y
				STA	SCREENL
				LDA	BLOCK_LIST+1,Y
				STA	SCREENH
				LDY	#0
				PLA
				AND	#%00001111
				BEQ	:LOOP2
				STA	TEMP
:LOOP1			LDA	(SCREENL),Y
				CMP	#$80
				INY
				BCC	:LOOP1
				DEC	TEMP
				BNE	:LOOP1
:LOOP2			LDA	(SCREENL),Y
				CMP	#$80
				AND	#%01111111
				STA	TEXTBUF,X
				INY
				INX
				BCC	:LOOP2
				RTS

:SKIPA			TYA
				SEC
				SBC	#xMonsName
				ASL
				TAY
				LDA	SPECIAL_WORDS+1,Y
				PHA
				LDA	SPECIAL_WORDS,Y
				PHA
				RTS

SPECIAL_WORDS	DW	MONS_NAME-1
				DW	CHAR_NAME-1
				DW	DAMAGE_OUT-1
				DW	RETURN-1
				DW	PERIOD-1
				DW	BACKSPACE-1

*-------------------------------

DAMAGE_OUT		LDA	TOTAL_DAMAGEL
				BNE	:SKIPA
				LDY	TOTAL_DAMAGEH
				BEQ	:SKIPB
:SKIPA			PHA
				LDA	TOTAL_DAMAGEH
				PHA
				LDA	#2
				JSR	LEFT_DIGITS
				RTS
:SKIPB			LDY	#xNo
				BNE	WORD1			;Always

*-------------------------------

CHAR_NAME		LDY	#0
:LOOP1			LDA	(CHARDL),Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#10
				BNE	:LOOP1
:LOOP2			DEX
				LDA	TEXTBUF,X
				CMP	#$0A
				BEQ	:LOOP2
				INX
				RTS

*-------------------------------

MONS_NAME		LDY	#monTOPVIEW
				LDA	(MONS_PTR),Y
				BMI	MNAME_IDENTIF
				LDY	#monNUMBER
				LDA	(MONS_PTR),Y
				TAY
				LDA	ALTYPE1,Y
MNAME_UNIDENT	ROL
				ROL
				ROL
				AND	#%00000011
				CMP	#%00000011
				BNE	:SKIPA
				LDA	#0
:SKIPA			CLC
				ADC	#xUnknown
				TAY
				JMP	WORD1

MNAME_IDENTIF	LDY	#aName
:LOOP1			LDA	(ALIEN_PTR),Y
				STA	TEXTBUF,X
				INX
				INY
				CPY	#aName+16
				BNE	:LOOP1
:LOOP2			DEX
				LDA	TEXTBUF,X
				CMP	#$0A
				BEQ	:LOOP2
				INX
				RTS

*-------------------------------

BACKSPACE		DEX
				LDA	#$0A
				STA	TEXTBUF,X
				RTS

*-------------------------------

APOSTROPHE_S	LDA	#$28			;apostrophe
				STA	TEXTBUF,X
				INX
				LDA	#$1D			;s
				STA	TEXTBUF,X
				INX
				INX
				RTS

*--------------------------------------
* On Entry:
*   A: Letter to check
*   Y: Position in TEXTBUF to remove
*       if letter check is NOT a vowel
*--------------------------------------

VOWEL_CHECK		STY	:MOD1+1
				LDY	#4
:LOOP1			CMP	VOWELS,Y
				BEQ	:EXIT
				DEY
				BPL	:LOOP1
:MOD1			LDY	#$FF			;Modified
				LDA	#$EE
				STA	TEXTBUF,Y
:EXIT			RTS

VOWELS			USR	(AEIOU)-

*-------------------------------

SENTENCE_INC	JSR	SENTENCE
				INX
				RTS

SENTENCE_RET	JSR	SENTENCE
				JMP	RETURN

SENTENCE		STX	TEMP+1
				TYA
				LDX	#<SENT_LIST1
				LDY	#>SENT_LIST1
				CMP	#40
				BCC	:SKIPB
				SBC	#40				;Carry assumed set
				LDX	#<SENT_LIST2
				LDY	#>SENT_LIST2
:SKIPB			STX	:MOD1+1
				STX	:LOOP2+1
				STY	:MOD1+2
				STY	:LOOP2+2
				TAX

				LDY	#0
:LOOP1			STY	COUNTER
				TYA
				SEC
:MOD1			ADC	$FFFF,Y			;Modified
				TAY
				DEX
				BPL	:LOOP1
				STY	:MOD2+1
				LDX	TEMP+1
				INC	COUNTER
				LDY	COUNTER
:LOOP2			LDA	$FFFF,Y					;Modified
				TAY
				PHA
				JSR	WORD1
				PLA
				CMP	#xRETURN
				BEQ	:SKIPA
				INX
:SKIPA			INC	COUNTER
				LDY	COUNTER
:MOD2			CPY	#$FF			;Modified
				BNE	:LOOP2
				DEX
				RTS

SENT_LIST1
:0				DB	5,xBut,xNo,xOne,xIs,xAffected
:1				DB	1,99						;******************** OPEN
:2				DB	1,99						;******************** OPEN
:3				DB	1,99						;******************** OPEN
:4				DB	4,xRicochets,xOff,xThe,xWall

*>>>> Used only in ENERGY
:5				DB	8,xCharsName,xReleases,xA,xHarmless,xRETURN
				DB	xBolt,xOf,xEnergy

:6				DB	4,xAbsorbed,xBy,xThe,xWall
:7				DB	3,xIn,xThe,xWay
:8				DB	6,xIt,xIsnt,xRETURN,xQuick,xEnough,xAnd

*>>>> Used only in MON SHOOT
:9				DB	12,xBut,xIts,xBlocked,xAnd,xHits,xThe,xRETURN
				DB	xMonsName,xFor,x9999,xRETURN
				DB	xDamage
:10				DB	5,xThat,xRicochets,xOff,xThe,xWall

*>>> Used only in CHAR_SHOOT (robot restrainer)
:11				DB	13,xCharsName,xDoesnt,xHave,xEnough,xRETURN
				DB	xEnergy,xTo,xTransmit,xA,xRobot,xRETURN
				DB	xRestraining,xMessage
:12				DB	8,xCharsName,xTransmits,xA,xRobot,xRETURN
				DB	xRestraining,xMessage,xThat
:13				DB	9,xIs,xIntercepted,xBy,xCharsName,xRETURN
				DB	xBut,xHas,xNo,xEffect
:14				DB	5,xIs,xAbsorbed,xBy,xThe,xWall
:15				DB	5,xIs,xNot,xReceived,xBy,xAnyone
:16				DB	3,xReaches,xThe,xMonsName
:17				DB	3,xBut,xIs,xIgnored
:18				DB	3,xAnd,xIs,xObeyed

*>>>> Used only in MONS SWING
:19				DB	13,xCharsName,xBut,xThe,xBlow,xIs,xSo,xRETURN
				DB	xWeak,xThat,xIt,xCauses,xNo,xDamage

:20				DB	7,xCharsName,xBut,xIt,xIsnt,xQuick,xRETURN,xEnough
:21				DB	1,99						;******************** OPEN
:22				DB	6,xThe,xRETURN,xAttack,xAnd,xIs,xNot

:23				DB	1,99						;******************** OPEN

*>>>> Used only in ENERGY (light)
:24				DB	1,99						;******************** OPEN
:25				DB	5,xMonsName,xIs,xRETURN,xNot,xAffected

*>>>> Used only in CHAR_SWING
:26				DB	14,xMonsName,xBut,xThe,xBlow,xRETURN
				DB	xIs,xSo,xWeak,xThat,xIt,xCauses,xRETURN
				DB	xNo,xDamage
:27				DB	8,xCharsName,xStarts,xTo,xSwing,xBut,xRETURN
				DB	xStops,xAbruptly
:28				DB	3,xA,xWall,xIs

:29				DB	5,xCharsName,xRuns,xOut,xOf,xEnergy

*>>>> Used only in CHAR SHOOT
:30				DB	12,xBut,xRETURN
				DB	xIt,xIs,xSo,xWeak,xThat,xIt,xCauses,xRETURN
				DB	xNo,xDamage
:31				DB	3,xHits,xThe,xMonsName
:32				DB	7,xCharsName,xIs,xHit,xRETURN
				DB	xFor,x9999,xDamage

:33				DB	12,xBut,xIt,xIs,xRETURN
				DB	xSo,xWeak,xThat,xIt,xCauses,xNo,xRETURN
				DB	xDamage
:34				DB	3,xAnd,xHits,xCharsName
:35				DB	6,xThat,xIs,xAbsorbed,xBy,xThe,xWall

*>>>> Used in CHAR SHOOT and MONS SHOOT
:36				DB	4,xFor,xRETURN,x9999,xDamage

:37				DB	3,xIs,xNo,xLonger

*>>>> Used only in EXCHANGE
:38				DB	3,xCharsName,xExchanges,xEquipment

:39				DB	4,xMonsName,xIs,xHit,xBut



SENT_LIST2
*>>>> Used only in IDENTIFY
:40				DB	3,xCharsName,xScans,xThe
:41				DB	6,xBut,xFails,xTo,xIdentify,xRETURN,xAnything
:42				DB	4,xCharsName,xScans,xThe,xMonsName
:43				DB	5,xBut,xFails,xTo,xIdentify,xIt
:44				DB	6,xAnd,xIdentifies,xIt,xAs,xBeing,xAn

*>>>> Used only in THROW
*>>>> (grenade)
:45				DB	7,xCharsName,xThrows,xA,xSonic,xRETURN
				DB	xGrenade,xThat
:46				DB	5,xThat,xFails,xTo,xRETURN,xDetonate
:47				DB	9,xAnd,xRETURN
				DB	xHits,xThe,xMonsName,xFor,xRETURN
				DB	x9999,xDamage
:48				DB	5,xBut,xThe,xRETURN,xMonsName,xIs
:49				DB	4,xNo,xOne,xIs,xAffected
*>>>> (boomerang)
:50				DB	10,xCharsName,xThrows,xA,xGyro,xRETURN
				DB	xBoomerang,xThat,xArcs,xToward,xThe
:51				DB	8,xMonsName,xAnd,xHits,xIt,xRETURN
				DB	xFor,x9999,xDamage
:52				DB	4,xThe,xGyro,xBoomerang,xReturns
:53				DB	12,xCharsName,xThrows,xA,xGyro,xRETURN
				DB	xBoomerang,xThat,xCrashes,xTo,xThe,xRETURN
				DB	xFloor
:54				DB	1,99						;******************** OPEN

*>>>> Used For Running
:55				DB	6,xThe,xAlien,xHas,zSuccessfully,xRETURN,zRetreated
:56				DB	6,xThe,zAliens,xHave,zSuccessfully,xRETURN,zRetreated
:57				DB	6,xThe,zGroup,xHas,zSuccessfully,xRETURN,zRetreated
:58				DB	6,zAttempt,xTo,xRetreat,xRETURN,xIs,zUnsuccessful
:59				DB	6,xCharsName,xGives,xThe,xRetreat,xRETURN,xSignal

:60				DB	1,99						;******************** OPEN
:61				DB	1,99						;******************** OPEN

*>>>> Used only in THROW (immobilizer)
:62				DB	6,xCharsName,xThrows,xAn,xRETURN
				DB	xImmobilizer,xThat
:63				DB	4,xFails,xTo,xRETURN,xActivate
:64				DB	3,xEnvelops,xRETURN,xAnEmptySquar
:65				DB	4,xEnvelops,xRETURN,xThe,xMonsName
:66				DB	8,xBut,xDoes,xRETURN
				DB	xNot,xSeem,xTo,xImmobilize,xIt

*>>>> Used only in CHAR_SHOOT (brain jammer)
:67				DB	13,xCharsName,xDoesnt,xHave,xEnough,xRETURN
				DB	xEnergy,xTo,xSend,xOut,xBrain,xRETURN
				DB	xJamming,xWaves
:68				DB	9,xCharsName,xSends,xOut,xBrain,xRETURN
				DB	xJamming,xWaves,xThat,xVibrate
:69				DB	3,xInto,xThe,xWall
:70				DB	6,xCharsName,xBut,xHave,xNo,xRETURN
				DB	xEffect
:71				DB	8,xInto,xThe,xMonsName,xBut,xRETURN
				DB	xHave,xNo,xEffect
:72				DB	3,xInto,xThe,xMonsName

*-------------------------------
