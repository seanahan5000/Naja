HALL_CLEAR		LDX	#0
				TXA
:1				STA	$2000,X
				STA	$2100,X
				STA	$2200,X
				STA	$2300,X
				STA	$2400,X
				STA	$2500,X
				STA	$2600,X
				STA	$2700,X
				STA	$2800,X
				STA	$2900,X
				STA	$2A00,X
				STA	$2B00,X
				STA	$2C00,X
				STA	$2D00,X
				STA	$2E00,X
				STA	$2F00,X
				STA	$3000,X
				STA	$3100,X
				STA	$3200,X
				STA	$3300,X
				STA	$3400,X
				STA	$3500,X
				STA	$3600,X
				STA	$3700,X
				STA	$3800,X
				STA	$3900,X
				STA	$3A00,X
				STA	$3B00,X
				STA	$3C00,X
				STA	$3D00,X
				STA	$3E00,X
				STA	$3F00,X
				INX
				BNE	:1
				RTS
