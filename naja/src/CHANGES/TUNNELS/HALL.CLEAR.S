HALL_CLEAR		LDA	PAGE
				CMP	#$40
				BEQ	CLEAR2
CLEAR1			LDA	#$80
				LDX	#0
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

CLEAR2			LDA	#$80
				LDX	#0
:1				STA	$4000,X
				STA	$4100,X
				STA	$4200,X
				STA	$4300,X
				STA	$4400,X
				STA	$4500,X
				STA	$4600,X
				STA	$4700,X
				STA	$4800,X
				STA	$4900,X
				STA	$4A00,X
				STA	$4B00,X
				STA	$4C00,X
				STA	$4D00,X
				STA	$4E00,X
				STA	$4F00,X
				STA	$5000,X
				STA	$5100,X
				STA	$5200,X
				STA	$5300,X
				STA	$5400,X
				STA	$5500,X
				STA	$5600,X
				STA	$5700,X
				STA	$5800,X
				STA	$5900,X
				STA	$5A00,X
				STA	$5B00,X
				STA	$5C00,X
				STA	$5D00,X
				STA	$5E00,X
				STA	$5F00,X
				INX
				BNE	:1
				RTS
