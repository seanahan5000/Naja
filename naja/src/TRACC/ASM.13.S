*========================*
*                        *
*    SHELL 13 CONTROL    *
*                        *
*       10/25/88         *
*                        *
*========================*

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

			do	ORIGINAL
SHELLNUM		=	3
			else
SHELLNUM		=	2
			fin

				ORG	$A000
				PUT	CONTROLS/COMMON
				PUT	CONTROLS/PART13
				SAV	CONTROL13
