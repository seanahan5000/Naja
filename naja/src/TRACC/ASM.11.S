*========================*
*                        *
*    SHELL 11 CONTROL    *
*                        *
*       10/25/88         *
*                        *
*========================*

SHELLNUM		=	3
				LST	OFF
				ERR	($310)-$AA
				EXP	OFF
				LSTDO	OFF
				TR	ON

				USE	/NAJA/VARS/MACROS
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/THALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS

				DUMMY	$A000
				PUT	CONTROLS/COMMON
				PUT	CONTROLS/PART11
				SAV	CONTROL11