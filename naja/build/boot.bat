@echo off

set ROOT=d:\misc\dev\naja\src
set BUILD=d:\misc\dev\naja\build
set OBJDIR=%BUILD%\obj
set ASM=asm6502 -root %ROOT% -objbase ..\build\obj -base

if not exist %OBJDIR% mkdir %OBJDIR%

%ASM% NAJA\BOOT				NDOS.BOOT1.S	-list %BUILD%\NDOS.BOOT1.LST
%ASM% NAJA\BOOT				PR.INFO.S
%ASM% NAJA\BOOT				SCREEN.III.S
%ASM% NAJA\IO				NDOS.525.S
%ASM% NAJA\IO				ASM.NCOMMONS.S
%ASM% MOTHER\HALL			ASM.HALL.S
%ASM% TRACC					ASM.CAMP.S
%ASM% NAJA\IO				ASM.CHAR.DATA.S
%ASM% NAJA\BOOT				ASM.TITLE.S		-list %BUILD%\TITLE.PAGE.LST
%ASM% MOTHER\GROUP.ASSEMBLY	ASM.GROUP.S
%ASM% MOTHER\ENROLLTEST		ASM.ENTEST.S
%ASM% MOTHER\ENERGY			ASM.ENERGY.S
%ASM% MOTHER\ARSENAL		ASM.ARSENAL.S
%ASM% MOTHER\ROBOT.REPAIR	ASM.REPAIR.S
%ASM% MOTHER\INFIRMARY		ASM.INFIRMARY.S

a2nib -create -volume 0 -disk boot.nib
a2nib %OBJDIR%\NDOS.BOOT		-t 00 -s 00 -disk boot.nib
a2nib %OBJDIR%\PR.INFO			-t 00 -s 02 -disk boot.nib
a2nib %OBJDIR%\SCREEN.III		-t 00 -s 03 -disk boot.nib
a2nib %OBJDIR%\NDOS.525			-t 00 -s 04 -disk boot.nib
a2nib %OBJDIR%\NCOMMONS			-t 00 -s 08 -disk boot.nib
a2nib %OBJDIR%\CAMP.B000		-t 02 -s 00 -disk boot.nib
a2nib %OBJDIR%\CAMP.E000		-t 03 -s 00 -disk boot.nib
a2nib %OBJDIR%\CAMP.D000.M2		-t 05 -s 00 -disk boot.nib
a2nib %OBJDIR%\CAMP.D000.M1		-t 06 -s 00 -disk boot.nib
a2nib %OBJDIR%\TITLE.PAGE		-t 07 -s 00 -disk boot.nib
a2nib %OBJDIR%\MTUNNELS			-t 0C -s 00 -disk boot.nib
a2nib %OBJDIR%\MCONTROL			-t 0E -s 00 -disk boot.nib
a2nib %OBJDIR%\MTESSINFO		-t 0F -s 00 -disk boot.nib
a2nib %OBJDIR%\CHAR.DATA		-t 10 -s 00 -disk boot.nib
a2nib %OBJDIR%\NDOS.525W		-t 10 -s 0E -disk boot.nib
a2nib %OBJDIR%\GROUP.ASSEMBLY	-t 11 -s 00 -disk boot.nib
a2nib %OBJDIR%\ENROLL.TEST		-t 13 -s 00 -disk boot.nib
a2nib %OBJDIR%\INFIRMARY		-t 17 -s 00 -disk boot.nib
a2nib %OBJDIR%\ENERGY.CENTER	-t 18 -s 08 -disk boot.nib
a2nib %OBJDIR%\ARSENAL			-t 1B -s 00 -disk boot.nib
a2nib %OBJDIR%\ROBOT.REPAIR		-t 1F -s 00 -disk boot.nib
