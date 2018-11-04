                LST OFF
                ERR ($310)-$AA

                USE EQUATES/ALIEN.MACROS
                PUT EQUATES/ALIEN.EQ
                PUT EQUATES/ALIEN.EQ.17

                LST ON
                DSK ALIEN.DATA.17
                LST OFF
                ORG $0000

                PUT DATA/TABLE.1
                PUT DATA/DATA.1A
                PUT DATA/DATA.1B
                DS  \,$EE
