                LST OFF
                ERR ($310)-$AA

                USE EQUATES/ALIEN.MACROS
                PUT EQUATES/ALIEN.EQ
                PUT EQUATES/ALIEN.EQ.13

                LST ON
                DSK ALIEN.DATA.13
                LST OFF
                ORG $0000

                PUT DATA/TABLE.3
                PUT DATA/DATA.3
                DS  \,$EE
