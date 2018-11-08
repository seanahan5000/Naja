                LST OFF
                ERR ($310)-$AA

                USE EQUATES/ALIEN.MACROS
                PUT EQUATES/ALIEN.EQ
                PUT EQUATES/ALIEN.EQ.11

                LST ON
                DSK ALIEN.DATA.11
                LST OFF
                ORG $0000

                PUT DATA/TABLE.4
                PUT DATA/DATA.4
                DS  \,$EE
