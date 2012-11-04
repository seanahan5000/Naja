@echo off

set ROOT=%~dp0\..
set BUILD=%ROOT%\build
set SRC=%ROOT%\src
set OBJ=%ROOT%\obj
set BIN=%ROOT%\bin
set ASM=asm6502 -root %SRC% -objbase ..\obj -base

if not exist %OBJ% mkdir %OBJ%
if not exist %BIN% mkdir %BIN%

%ASM% NAJA\BOOT				NDOS.BOOT1.S
%ASM% NAJA\BOOT				PR.INFO.S
%ASM% NAJA\BOOT				SCREEN.III.S
%ASM% NAJA\IO				NDOS.525.S
%ASM% NAJA\IO				ASM.NCOMMONS.S
%ASM% MOTHER\HALL			ASM.HALL.S
%ASM% TRACC					ASM.CAMP.S
%ASM% NAJA\IO				ASM.CHAR.DATA.S
%ASM% NAJA\BOOT				ASM.TITLE.S
%ASM% MOTHER\GROUP.ASSEMBLY	ASM.GROUP.S
%ASM% MOTHER\ENROLLTEST		ASM.ENTEST.S
%ASM% MOTHER\ENERGY			ASM.ENERGY.S
%ASM% MOTHER\ARSENAL		ASM.ARSENAL.S
%ASM% MOTHER\ROBOT.REPAIR	ASM.REPAIR.S
%ASM% MOTHER\INFIRMARY		ASM.INFIRMARY.S

a2nib -create -volume 0 -disk %BIN%\boot.nib
a2nib %OBJ%\NDOS.BOOT1		-t 00 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\PR.INFO			-t 00 -s 02 -disk %BIN%\boot.nib
a2nib %OBJ%\SCREEN.III		-t 00 -s 03 -disk %BIN%\boot.nib
a2nib %OBJ%\NDOS.525		-t 00 -s 04 -disk %BIN%\boot.nib
a2nib %OBJ%\NCOMMONS		-t 00 -s 08 -disk %BIN%\boot.nib
a2nib %OBJ%\CAMP.B000		-t 02 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\CAMP.E000		-t 03 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\CAMP.D000.M2	-t 05 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\CAMP.D000.M1	-t 06 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\TITLE.PAGE		-t 07 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\MTUNNELS		-t 0C -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\MCONTROL		-t 0E -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\MTESSINFO		-t 0F -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\CHAR.DATA		-t 10 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\NDOS.525W		-t 10 -s 0E -disk %BIN%\boot.nib
a2nib %OBJ%\GROUP.ASSEMBLY	-t 11 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\ENROLL.TEST		-t 13 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\INFIRMARY		-t 17 -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\ENERGY.CENTER	-t 18 -s 08 -disk %BIN%\boot.nib
a2nib %OBJ%\ARSENAL			-t 1B -s 00 -disk %BIN%\boot.nib
a2nib %OBJ%\ROBOT.REPAIR	-t 1F -s 00 -disk %BIN%\boot.nib
