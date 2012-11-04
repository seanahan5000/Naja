				TR	ON
********************************
*
*  T7.SECTOR.A
*  (Character 21 data and full/empty
*  table and specials flags)
*
********************************

				ORG	$2000

				DS	128

				DB	$00				;Characters 1 and 2
				DB	$00				;3 and 4
				DB	$00				;5 and 6
				DB	$00				;7 and 8
				DB	$00				;9 and 10
				DB	$00				;11 and 12
				DB	$00				;13 and 14
				DB	$00				;15 and 16
				DB	$00				;17 and 18
				DB	$00				;19 and 20
				DB	$0F				;21 and Unusable

				DO	0
PISTSTK			DB	$7F,$7F,$00
				DB	$FF,$FF
RIFLSTK			DB	$7F,$18,$00
				DB	$FF
CANNSTK			DB	$FF,$FF
BEAMSTK			DB	$7F,$7F,$18
				DB	$00,$FF,$FF
				DB	$FF
MWEASTK			DB	$FF,$FF,$FF
				DB	$FF,$20,$99		;99 means ??
ATTASTK			DB	$08,$03,$FF
				DB	$FF,$FF
MARMSTK			DB	$06,$02,$FF
				DB	$FF
MEDISTK			DB	$7F,$7F,$07
				DB	$00,$FF,$FF
				DB	$00,$18,$99		;99 means ??
				DB	$99,$99,$99
				DB	$99,$99
SCANSTK			DB	$7F,$00,$FF
				DB	$FF,$FF,$FF
MISCSTK			DB	$7F,$FF,$FF
SHLDSTK			DB	$7F,$18,$06
				DB	$01,$FF,$FF
				DB	$FF,$FF,$FF
				DB	$FF,$FF,$FF
				FIN

PISTSTK			DB	$7F,$7F,$01
				DB	$04,$01
RIFLSTK			DB	$7F,$18,$01
				DB	$7F
CANNSTK			DB	$00,$7F
BEAMSTK			DB	$7F,$7F,$18
				DB	$01,$7F,$7F
				DB	$7F
MWEASTK			DB	$7F,$7F,$02
				DB	$01,$7F,$7F
ATTASTK			DB	$08,$03,$7F
				DB	$7F,$7F
MARMSTK			DB	$05,$7F,$7F
				DB	$06
MEDISTK			DB	$7F,$7F,$07
				DB	$01,$7F,$01
				DB	$7F,$01,$18
				DB	$7F,$7F,$7F
				DB	$7F,$7F
SCANSTK			DB	$7F,$01,$7F
				DB	$7F,$7F,$7F
MISCSTK			DB	$7F,$7F,$7F
SHLDSTK			DB	$7F,$18,$06
				DB	$01,$7F,$7F
				DB	$7F,$7F,$7F
				DB	$7F,$7F,$7F

*-------------------------------
* Specials flags (Will be expanded
*   later when more info available)

				DS	32

				SAV	T7.SECTOR.A
