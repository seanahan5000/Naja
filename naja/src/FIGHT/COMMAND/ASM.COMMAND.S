				ERR	($310)-$AA
				TR	ON
				EXP	OFF
				LST	OFF

				USE	/NAJA/VARS/MACROS
				PUT	/NAJA/VARS/ZPAGE
				PUT	/NAJA/VARS/NDOS.VARS
				PUT	/NAJA/VARS/NCOM.VARS
				PUT	/NAJA/VARS/MISC.VARS
				PUT	/NAJA/VARS/CONSTANTS
				PUT	/NAJA/VARS/THALL.VARS
				PUT	/NAJA/VARS/CAMP.VARS
				PUT	/NAJA/VARS/FIGHT.CONSTS
				PUT	/NAJA/VARS/FIGHT.ZPAGE

				ORG	$6300
				DSK	/FIGHT/FIGHT.COMMAND

				PUT	/FIGHT/COMMAND/EQUATES
				PAGE
				PUT	/FIGHT/COMMAND/CONTROL
				PAGE
*=========================================================+
*   Command:  SWING (0)                                   |
*  Mnemonic:  "SWN xF"                                    |
*      Time:  upTime                                      |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*      ------------                    ----------         |
*      U.L.H.S.0000                    WWW.PP.XXX         |
*                                                         |
*                                                         |
*  U (upper/lower):                WWW (weapon type):     |
*      0 = upper                       000 = empty hand   |
*      1 = lower                       001 = dagger       |
*                                      010 = sword        |
*  L (left/right):                     011 = whip         |
*      0 = left                        100 = rifle        |
*      1 = right                                          |
*                                                         |
*  H (hands used):                 PP (position offset):  |
*      0 = one hand                    00 = left          |
*      1 = two hands                   01 = center        |
*                                      10 = right         |
*  S (swing type):                     11 = all three     |
*      0 = vertical/horizontal                            |
*      1 = thrust                  XXX (x position):      |
*                                      001 through 101    |
*                                                         |
* NOTE: If swing type is 0 then position offset           |
*          determines if the swing is horizontal (11)     |
*          or vertical (00,01,10).                        |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.SWING
				PAGE
*=========================================================+
*   Command:  SHOOT (1)                                   |
*  Mnemonic:  "SHT ##"                                    |
*      Time:  upTime                                      |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                        Byte 2            |
*      ------------                   -----------         |
*      U.L.H.^.0001                   T.^.NN.MMMM         |
*                                                         |
*  U (upper/lower):               T (type of shot):       |
*      0 = upper                      0 = normal blaster  |
*      1 = lower                      1 = special weapon  |
*                                                         |
*  L (left/right):                NN.MMMM (# of shots):   |
*      0 = left                       00.0001 to 01.1001  |
*      1 = right                                          |
*                                                         |
*  H (hands used):                                        |
*      0 = one hand                                       |
*      1 = two hands                                      |
*                                                         |
*---------------------------------------------------------+
* Pre-Command:  AIM (6)                                   |
*    Mnemonic:  "AIM xy"                                  |
*        Time:  upTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*       ---------                      ---------          |
*       ^^^^.0110                      XXXX.YYYY          |
*                                                         |
*                                  XXXX (x position):     |
*                                     0001 through 0101   |
*                                                         |
*                                  YYYY (y position):     |
*                                     0110 through 1010   |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.SHOOT
				PAGE
*=========================================================+
*   Command:  ENERGY (2)                                  |
*  Mnemonic:  "ENR   "                                    |
*      Time:  upTime                                      |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                        Byte 2            |
*       ----------                   -----------          |
*       TT.^^.0010                   ^.WWW.^.DDD          |
*                                                         |
*  TT (type of energy):            WWW (width of area):   |
*      00 = heat                       001 through 101    |
*      01 = electrical                                    |
*      10 = light              DDD (depth of area - 1):   |
*                                      000 through 100    |
*                                                         |
*---------------------------------------------------------+
* Pre-Command:  AIM (6)                                   |
*    Mnemonic:  "AIM xy"                                  |
*        Time:  upTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*       ---------                      ---------          |
*       IIII.0110                      XXXX.YYYY          |
*                                                         |
*  IIII (energy table index):      XXXX (x position):     |
*     0000 through 1111               0001 through 0101   |
*                                                         |
*                                  YYYY (y position):     |
*                                     0110 through 1010   |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.ENERGY
				PAGE
*=========================================================+
*   Command:  THROW (3)                                   |
*  Mnemonic:  "THW xy"                                    |
*      Time:  uploTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*      ------------                    ---------          |
*      U.L.0.B.0011                    XXXX.YYYY          |
*                                                         |
*  U (upper/lower):                XXXX (x position):     |
*      0 = upper                      0001 through 0101   |
*      1 = lower                                          |
*                                  YYYY (y position):     |
*  L (left/right):                    0110 through 1010   |
*      0 = left                                           |
*      1 = right                                          |
*                                                         |
*  B (boomerang flag):                                    |
*     0 = non-boomerang                                   |
*     1 = boomerang                                       |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.THROW
				PAGE
*=========================================================+
*   Command:  USE (4)                                     |
*  Mnemonic:  "USE hh"                                    |
*      Time:  upupTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*      -----------                      ---------         |
*      U.L.DD.0100                      NNNN.MMMM         |
*                                                         |
*  U (upper/lower):           NNNN.MMMM (heal amount):    |
*      0 = upper                  0000.0001 to 0101.0000  |
*      1 = lower                                          |
*                                                         |
*  L (left/right):                                        |
*      0 = left                                           |
*      1 = right                                          |
*                                                         |
*  DD (direction):                                        |
*     00 = north                                          |
*     01 = east                                           |
*     10 = south (himself)                                |
*     11 = west                                           |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.USE
				PAGE
*=========================================================+
*   Command:  MOVE (7)                                    |
*  Mnemonic:  "MOV xy"                                    |
*      Time:  loloTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*       ---------                      ---------          |
*       ^^^^.0111                      XXXX.YYYY          |
*                                                         |
*                                  XXXX (x position):     |
*                                     0001 through 0101   |
*                                                         |
*                                  YYYY (y position):     |
*                                     0110 through 1010   |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.MOVE
				PAGE
*=========================================================+
*   Command:  IDENTIFY (8)                                |
*  Mnemonic:  "IDN xy"         (one square)               |
*             "IDN   "         (entire area)              |
*      Time:  upupTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*       ---------                      ----------         |
*       ^^^^.1000                      A.XXX.YYYY         |
*                                                         |
*                                  A (area type):         |
*                                     0 = a square        |
*                                     1 = the area        |
*                                                         |
*                                  XXXX (x position):     |
*                                      001 through 101    |
*                                                         |
*                                  YYYY (y position):     |
*                                     0110 through 1010   |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.IDENTIFY
				PAGE
*=========================================================+
*   Command:  EXCHANGE (9)                                |
*  Mnemonic:  "EXC hh"                                    |
*      Time:  upupTime                                    |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                         Byte 2           |
*      ------------                     --------          |
*      U.L.U.L.1001                     ^^^^^^^^          |
*                                                         |
*  U (upper/lower):                                       |
*      0 = upper                                          |
*      1 = lower                                          |
*                                                         |
*  L (left/right):                                        |
*      0 = left                                           |
*      1 = right                                          |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.EXCHANGE
				PAGE
*=========================================================+
*   Command:  PARRY (10)                                  |
*  Mnemonic:  "PAR ##"                                    |
*      Time:  oneTime                                     |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                          Byte 2          |
*       ---------                       ---------         |
*       ^^^^.1010                       NNNN.MMMM         |
*                                                         |
*                               NNNN.MMMM (time units):   |
*                                 0000.0001 to 0111.0010  |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.PARRY
				PAGE
*=========================================================+
*   Command:  RUN (11)                                    |
*  Mnemonic:  "RUN   "                                    |
*      Time:  loloTime (allTime)                          |
*---------------------------------------------------------+
*                                                         |
*         Byte 1                          Byte 2          |
*       ---------                        --------         |
*       ^^^^.1011                        ^^^^^^^^         |
*                                                         |
*=========================================================+

				PUT	/FIGHT/COMMAND/C.RUN
				PAGE
				PUT	/FIGHT/COMMAND/C.END
				PAGE
				PUT	/FIGHT/COMMAND/C.BACK1
				PAGE
				PUT	/FIGHT/COMMAND/C.REDO
				PAGE
				PUT	/FIGHT/COMMAND/C.OTHER
				PAGE
				PUT	/FIGHT/COMMAND/C.FLIP
				PAGE
				PUT	/FIGHT/COMMAND/C.DELAY

				PAGE
				PUT	/FIGHT/COMMAND/COMMANDS
				PAGE
				PUT	/FIGHT/COMMAND/CURSORS
				PAGE
				PUT	/FIGHT/COMMAND/HANDS
				PAGE
				PUT	/FIGHT/COMMAND/GET.MULTIPLE
				PAGE
				PUT	/FIGHT/COMMAND/TEXT.DIGITS
				PAGE
				PUT	/FIGHT/COMMAND/ENERGY.SUBS
				PAGE
				PUT	/FIGHT/COMMAND/MISC.SUBS
				PAGE
				PUT	/FIGHT/COMMAND/STATS
				PAGE
				PUT	/FIGHT/COMMAND/SCREEN.SUBS
				PAGE
				PUT	/FIGHT/COMMAND/DATA
