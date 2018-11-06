                LST OFF
                ERR ($310)-$AA

                USE EQUATES/ALIEN.MACROS
                PUT EQUATES/ALIEN.EQ
                PUT EQUATES/ALIEN.EQ.15

                LST ON
                DSK ALIEN.DATA.15
                LST OFF
                ORG $0000

                PUT DATA/TABLE.2
                PUT DATA/DATA.2
                DS  \,$EE
