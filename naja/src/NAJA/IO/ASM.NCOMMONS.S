				ERR	($310)-$AA
				LST	OFF
				TR	ON

				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/MISC.VARS
				PAGE
				PUT	NCOMMONS.HTBL
				PAGE
				PUT	NCOMMONS.MAIN
				PAGE
				PUT	NCOMMONS.STAT
				ERR	*-$16B0
				PAGE
				PUT	NCOMMONS.EQUI
				PAGE
				PUT	NCOMMONS.NDOS
				PAGE
				SAV	NCOMMONS
