
; main entry point

HALL_DRIVER
                LDX #<MAP_DATA
                LDY #>MAP_DATA
                LDA #17
                JSR SET_MAP_DATA

                ;***

                RTS


MAP_DATA        DW  F1  ; MAP_FACE_0
                DW  F2  ; MAP_FACE_1
                DW  F3  ; MAP_FACE_2
                DW  F4  ; MAP_FACE_3
                DW  F5  ; MAP_FACE_4
                DW  F6  ; MAP_FACE_5

                DW  #17*0
                DW  #17*1
                DW  #17*2
                DW  #17*3
                DW  #17*4
                DW  #17*5
                DW  #17*6
                DW  #17*7
                DW  #17*8
                DW  #17*9
                DW  #17*10
                DW  #17*11
                DW  #17*12
                DW  #17*13
                DW  #17*14
                DW  #17*15
                DW  #17*16

SHELL17
F1
                HEX 3DFDDFFFF0
                HEX 4C03303230
                HEX 00EC000300
                HEX CF0F30C330
                HEX 0000EFBFB0
                HEX CF0F22C010
                HEX 03EF000EB0
                HEX CF0233F330
                HEX 0000BFC000
                HEX C300C03330
                HEX 00000FF0F0
                HEX C000F023B0
                HEX 000000F000
                HEX C000F233F0
                HEX 003C030E00
                HEX C08CBF03F0
                HEX 003008FF00
                HEX C03CB3C0F0
                HEX 0208033000
                HEX CF00FF20B0
                HEX 00C0000BC0
                HEX 4C80FE0C30
                HEX 03C0000300
                HEX C000FF0330
                HEX 30000300C0
                HEX E000F300F0
                HEX 0FC00CEFA0
                HEX F0C0FCF030
                HEX 003FC303C0
                HEX F000323C90
                HEX 203FCFF000
                HEX F0EEC00CF0
                HEX 0FC03FF3C0
                HEX E0BB883030
                HEX 3FFFF7FFF0

F2
                HEX 3FFFF7FFF0
                HEX F30C3BFFF0
                HEX 000020C0C0
                HEX E208CC0030
                HEX 0F2F8FFFF0
                HEX C3CCF00210
                HEX 0FFC0003F0
                HEX F0B0F00FB0
                HEX 0003CFFC00
                HEX F0FC000FF0
                HEX 0F00EAF2A0
                HEX C3FF3C3FF0
                HEX 0C00000000
                HEX CFFF3C3EF0
                HEX 300033F3E0
                HEX 7FFFE8C0F0
                HEX 000000CF00
                HEX F3CFFFF3F0
                HEX 0FBCFFC000
                HEX C000003FF0
                HEX 3B3FF2F000
                HEX C3CC3C0FF0
                HEX 000000EC00
                HEX C3883F0FF0
                HEX 3C3BF0FC00
                HEX C3CE2F0BF0
                HEX 0F0030FC00
                HEX C3CBCF0BF0
                HEX 002FCCFCA0
                HEX C3F0F20810
                HEX 3F0C03FFC0
                HEX C388B8CCF0
                HEX 3B0383AF80
                HEX C3CCF00030
                HEX 377FDF7FF0

F3
                HEX 3DFFFFFDF0
                HEX C33000CC30
                HEX 0FBEFEFBC0
                HEX F00FFF00F0
                HEX 0000300000
                HEX 700FFF00D0
                HEX 0FBC88FBC0
                HEX C000F00030
                HEX 0EECECEEC0
                HEX F3CE0B3CF0
                HEX 0000EC0000
                HEX F3CCF33CF0
                HEX 0F3C88F3C0
                HEX C3C3FC3C10
                HEX 0CC0300CF0
                HEX FC33FCC3F0
                HEX 03CFCFCF00
                HEX F0800022F0
                HEX 03CFCFCF00
                HEX FC33FCC3F0
                HEX 0CC0300CF0
                HEX C3C3FC3C30
                HEX 0F3C88F3C0
                HEX F3CCF33CF0
                HEX 0000EC0000
                HEX F3CE0B3CF0
                HEX 0EECECEEC0
                HEX C000F00030
                HEX 0FBC88FBC0
                HEX 700FFF00D0
                HEX 0000300000
                HEX F00FFF00F0
                HEX 0FFEFEFFC0
                HEX C380002C30
                HEX 3DBAAAB9F0

F4
                HEX 3FFFDDFDF0
                HEX C030FC0330
                HEX 00CCC00000
                HEX C3BFBC0330
                HEX 3F0033FF30
                HEX 42EFB000D0
                HEX 3F00CC3300
                HEX C3BCECFFF0
                HEX 00CC33CCC0
                HEX C0303BAAB0
                HEX 3FEC0C3330
                HEX C0FC3AFBF0
                HEX 3F03F3CCC0
                HEX 43EAAC3B30
                HEX 003C0C3300
                HEX C33BACEC30
                HEX 3F33F30C00
                HEX C0EC3BEC30
                HEX 0FCC0C3330
                HEX FBB03B3BF0
                HEX 3030F30CC0
                HEX EEC3EC0E90
                HEX 0FC30CF330
                HEX F00EB33EF0
                HEX 3FF0F300C0
                HEX C03ECC3EF0
                HEX 00C3330330
                HEX C3BEB333B0
                HEX 3F0CCCECC0
                HEX 42EBECCFB0
                HEX 3F03333030
                HEX C3BC3B3FB0
                HEX 00CC0C00C0
                HEX C0300F3CF0
                HEX 3FFFFDF7F0

F5
                HEX 1FFFFDFFF0
                HEX C03C8000F0
                HEX 003FEFFFF0
                HEX C0F20003F0
                HEX 00FF3BFBC0
                HEX 43C8FC0FF0
                HEX 03FC000F00
                HEX CF20C3FEF0
                HEX 0F303FBC00
                HEX FFC00033F0
                HEX 3C8FFFCC00
                HEX FF2000E3F0
                HEX 3203FF0C00
                HEX FC3803F3F0
                HEX 0800FC0300
                HEX F03F0FF2D0
                HEX 23C03C0300
                HEX ECFF0FF3B0
                HEX 03003C0F20
                HEX F8FF0BC0F0
                HEX 0300FC0080
                HEX 7CFC02C3F0
                HEX 00C3FF0230
                HEX FCB0008FF0
                HEX 00CFFFC8F0
                HEX FCC0003FF0
                HEX 00FBF033C0
                HEX FBFC308F30
                HEX 03C000FF00
                HEX FF03F23C30
                HEX 0FBFB3FC00
                HEX FC0008F030
                HEX 3FFFEFF000
                HEX F00023C030
                HEX 3FFF7FFDF0

F6
                HEX 377FDF7FF0
                HEX C3CCF00030
                HEX 3B2F83F380
                HEX C3003C3CF0
                HEX 3BFFF3C000
                HEX 4C00C0FCD0
                HEX 0CFFBFC2F0
                HEX F20000BCE0
                HEX 00FFBFC000
                HEX FF03C0FCF0
                HEX 0033330380
                HEX FF3C3CFCE0
                HEX 00C0C0E000
                HEX FCFFFF08E0
                HEX 000C0CFEC0
                HEX FFC0030CE0
                HEX 000FFC0000
                HEX FFFFFF0CE0
                HEX 0000000000
                HEX 7FFFFF0CE0
                HEX 000888FEC0
                HEX F3EAAB08E0
                HEX 0C08882000
                HEX CBFFFFFCE0
                HEX 0300000380
                HEX FCFFFFFCF0
                HEX 030FBC0000
                HEX FFC3C3FCE0
                HEX 003F3F02F0
                HEX F30C30FCD0
                HEX 03F0C3C000
                HEX F03C3C3CF0
                HEX 0FC333F380
                HEX C033C00030
                HEX 3F7DFFFFF0
