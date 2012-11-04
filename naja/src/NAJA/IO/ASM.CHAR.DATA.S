
FAKE_GROUP		=	1

		do FAKE_GROUP
				PUT	FAKE.GROUP.S
		else
				DS	6*128
		fin
				DS	14*128
				
				PUT	/NAJA/BOOT/T7.SECTOR.A.S
				
				SAV	CHAR.DATA
