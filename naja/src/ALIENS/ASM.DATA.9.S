                LST OFF
                ERR ($310)-$AA

                USE EQUATES/ALIEN.MACROS
                PUT EQUATES/ALIEN.EQ
                PUT EQUATES/ALIEN.EQ.9

                LST ON
                DSK ALIEN.DATA.9
                LST OFF
                ORG $0000

                PUT DATA/TABLE.5
                PUT DATA/DATA.5
                DS  \,$EE
