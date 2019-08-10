@echo off

set ROOT=%~dp0..\..\..
set BUILD=%ROOT%\build
set SRC=%ROOT%\src
set OBJ=%ROOT%\obj
set BIN=%ROOT%\bin
set ASM=asm6502 -root %SRC% -objbase ..\obj -srcbase

if not exist %OBJ% mkdir %OBJ%
if not exist %BIN% mkdir %BIN%

%ASM% TRACC\HALLS.NEW   ASM.HALLS.S    -list HALLS.LST -sym %BIN%\halls.sym

dos33 -create -d %BIN%\HALLS.DSK
dos33 -bsave  -d %BIN%\HALLS.DSK %OBJ%\HALLS -a 6000
