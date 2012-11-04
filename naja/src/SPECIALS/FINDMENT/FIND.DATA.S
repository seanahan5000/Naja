*** Add compressed person to data tables

GROUPS_LOW		DFB	<GROUP17,<GROUP15,<GROUP13
				DFB	<GROUP11,<GROUP9

GROUPS_HIGH		DFB	>GROUP17,>GROUP15,>GROUP13
				DFB	>GROUP11,>GROUP9

*------------------------------------------------------
* Faces byte, Picture number, equipment data (4 bytes)
* 44 pieces of equipment per group is maximum

GROUP17			DFB	$3F,Sword,$08,$00,$00,$AD					;BLUE BEAM DAGGER
				DFB	$3F,Pistol,$0C,$00,$00,$A7				;FLY PISTOL
				DFB	$3F,Pistol,$0C,$01,$00,$A5				;LIGHT PISTOL
				DFB	$3F,Pistol,$0C,$02,$08,$A1				;MEDIUM PISTOL
				DFB	$3F,Helmet,$05,$00,$00,$DF				;BENDER-C HELMET
				DFB	$3F,Helmet,$05,$01,$80,$DF				;BENDER-B HELMET
				DFB	$3F,Shield,$06,$01,$00,$A6				;5% SHIELD
				DFB	$3F,Shield,$06,$02,$00,$A6				;10% SHIELD
				DFB	$3F,Cmpres,$21,$03,$00,$50				;ATOM COMPRESSOR
				DFB	$3F,RSword,$18,$00,$00,$20				;ROBO-DAGGER
*DFB $3F,RBlast,$1C,$00,$00,$20    ;ROBO-BLASTER C
*DFB $3F,RBlast,$1C,$01,$00,$20    ;ROBO-BLASTER B
*DFB $3F,RBlast,$1C,$02,$00,$20    ;ROBO-BLASTER A
				DFB	$3F,CompCube,$43,$F3,$10,$00				;COMPRESSED PERSON
				DFB	$3F,CompCube,$43,$F3,$10,$00				;COMPRESSED PERSON
				DFB	$3F,CompCube,$43,$F3,$10,$00				;COMPRESSED PERSON
				DFB	$3F,DCard,$03,$14,$00,$DF					;DATA CARD B2
				DFB	$3F,DCard,$03,$1C,$00,$DF					;DATA CARD B3
				DFB	$3F,DCard,$03,$24,$00,$DF					;DATA CARD B4

GROUP15			DFB	All,Sword,$08,$00,$00,$AD					;BLUE BEAM DAGGER
				DFB	All,Pistol,$0C,$00,$00,$A7				;FLY PISTOL
				DFB	All,Pistol,$0C,$01,$00,$A5				;LIGHT PISTOL
				DFB	All,Pistol,$0C,$02,$08,$A1				;MEDIUM PISTOL
				DFB	All,Helmet,$05,$00,$00,$DF				;BENDER-C HELMET
				DFB	All,Helmet,$05,$01,$80,$DF				;BENDER-B HELMET
				DFB	All,Shield,$06,$01,$00,$A6				;5% SHIELD
				DFB	All,Shield,$06,$02,$00,$A6				;10% SHIELD
				DFB	All,Cmpres,$21,$03,$00,$50				;ATOM COMPRESSOR
				DFB	All,RSword,$18,$00,$00,$20				;ROBO-DAGGER
				DFB	All,RBlast,$1C,$00,$00,$20				;ROBO-BLASTER C
				DFB	All,RBlast,$1C,$01,$00,$20				;ROBO-BLASTER B
				DFB	All,RBlast,$1C,$02,$00,$20				;ROBO-BLASTER A
				DFB	All,DCard,$03,$14,$00,$DF					;DATA CARD B2
				DFB	All,DCard,$03,$1C,$00,$DF					;DATA CARD B3
				DFB	All,DCard,$03,$24,$00,$DF					;DATA CARD B4

GROUP13			DFB	All,Sword,$08,$00,$00,$AD					;BLUE BEAM DAGGER
				DFB	All,Pistol,$0C,$00,$00,$A7				;FLY PISTOL
				DFB	All,Pistol,$0C,$01,$00,$A5				;LIGHT PISTOL
				DFB	All,Pistol,$0C,$02,$08,$A1				;MEDIUM PISTOL
				DFB	All,Helmet,$05,$00,$00,$DF				;BENDER-C HELMET
				DFB	All,Helmet,$05,$01,$80,$DF				;BENDER-B HELMET
				DFB	All,Shield,$06,$01,$00,$A6				;5% SHIELD
				DFB	All,Shield,$06,$02,$00,$A6				;10% SHIELD
				DFB	All,Cmpres,$21,$03,$00,$50				;ATOM COMPRESSOR
				DFB	All,RSword,$18,$00,$00,$20				;ROBO-DAGGER
				DFB	All,RBlast,$1C,$00,$00,$20				;ROBO-BLASTER C
				DFB	All,RBlast,$1C,$01,$00,$20				;ROBO-BLASTER B
				DFB	All,RBlast,$1C,$02,$00,$20				;ROBO-BLASTER A
				DFB	All,DCard,$03,$14,$00,$DF					;DATA CARD B2
				DFB	All,DCard,$03,$1C,$00,$DF					;DATA CARD B3
				DFB	All,DCard,$03,$24,$00,$DF					;DATA CARD B4

GROUP11			DFB	All,Sword,$08,$00,$00,$AD					;BLUE BEAM DAGGER
				DFB	All,Pistol,$0C,$00,$00,$A7				;FLY PISTOL
				DFB	All,Pistol,$0C,$01,$00,$A5				;LIGHT PISTOL
				DFB	All,Pistol,$0C,$02,$08,$A1				;MEDIUM PISTOL
				DFB	All,Helmet,$05,$00,$00,$DF				;BENDER-C HELMET
				DFB	All,Helmet,$05,$01,$80,$DF				;BENDER-B HELMET
				DFB	All,Shield,$06,$01,$00,$A6				;5% SHIELD
				DFB	All,Shield,$06,$02,$00,$A6				;10% SHIELD
				DFB	All,Cmpres,$21,$03,$00,$50				;ATOM COMPRESSOR
				DFB	All,RSword,$18,$00,$00,$20				;ROBO-DAGGER
				DFB	All,RBlast,$1C,$00,$00,$20				;ROBO-BLASTER C
				DFB	All,RBlast,$1C,$01,$00,$20				;ROBO-BLASTER B
				DFB	All,RBlast,$1C,$02,$00,$20				;ROBO-BLASTER A
				DFB	All,DCard,$03,$14,$00,$DF					;DATA CARD B2
				DFB	All,DCard,$03,$1C,$00,$DF					;DATA CARD B3
				DFB	All,DCard,$03,$24,$00,$DF					;DATA CARD B4

GROUP9			DFB	All,Sword,$08,$00,$00,$AD					;BLUE BEAM DAGGER
				DFB	All,Pistol,$0C,$00,$00,$A7				;FLY PISTOL
				DFB	All,Pistol,$0C,$01,$00,$A5				;LIGHT PISTOL
				DFB	All,Pistol,$0C,$02,$08,$A1				;MEDIUM PISTOL
				DFB	All,Helmet,$05,$00,$00,$DF				;BENDER-C HELMET
				DFB	All,Helmet,$05,$01,$80,$DF				;BENDER-B HELMET
				DFB	All,Shield,$06,$01,$00,$A6				;5% SHIELD
				DFB	All,Shield,$06,$02,$00,$A6				;10% SHIELD
				DFB	All,Cmpres,$21,$03,$00,$50				;ATOM COMPRESSOR
				DFB	All,RSword,$18,$00,$00,$20				;ROBO-DAGGER
				DFB	All,RBlast,$1C,$00,$00,$20				;ROBO-BLASTER C
				DFB	All,RBlast,$1C,$01,$00,$20				;ROBO-BLASTER B
				DFB	All,RBlast,$1C,$02,$00,$20				;ROBO-BLASTER A
				DFB	All,DCard,$03,$14,$00,$DF					;DATA CARD B2
				DFB	All,DCard,$03,$1C,$00,$DF					;DATA CARD B3
				DFB	All,DCard,$03,$24,$00,$DF					;DATA CARD B4
