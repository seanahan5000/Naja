
ZBLOCK          =   $20

MAP_SIZE        =   ZBLOCK+$0
MAP_FACE        =   ZBLOCK+$1           ; must be sequential
MAP_X           =   ZBLOCK+$2           ; must be sequential
MAP_Y           =   ZBLOCK+$3           ; must be sequential
MAP_DIR         =   ZBLOCK+$4           ; must be sequential
MAP_PTR_L       =   ZBLOCK+$5           ; must be sequential
MAP_PTR_H       =   ZBLOCK+$6           ; must be sequential

DATA_TEMP       =   $00
DATA_LEFT       =   $01
DATA_CENTER     =   $02
DATA_RIGHT      =   $03
TEMP_PTR_L      =   $04
TEMP_PTR_H      =   $05
