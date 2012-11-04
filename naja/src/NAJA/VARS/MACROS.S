				ERR	($310)-$AA

PLOTAT			MAC
				SETXY	]1;]2
				USR	]3
				EOM

SETXY			MAC
				DB	]1/7,]1/7*-7+]1,]2
				EOM

LINEAT			MAC
				DB	>]1,<]1,]2
				EOM
