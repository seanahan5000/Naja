*========================*
*                        *
*    SHELL 9 CONTROL     *
*                        *
*       10/25/88         *
*                        *
*========================*

SHELLNUM		=	5
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
				PUT	CONTROLS/PART9
				SAV	CONTROL9
