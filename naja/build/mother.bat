@echo off

set ROOT=d:\misc\dev\naja\src
set BUILD=d:\misc\dev\naja\build
set OBJDIR=%BUILD%\obj
set ASMB=asm6502 -bin -root %ROOT% -objbase ..\build\obj -base
set ASM=asm6502 -root %ROOT% -objbase ..\build\obj -base

if not exist %OBJDIR% mkdir %OBJDIR%

%ASMB% NAJA\BOOT	SCREEN.III.S
%ASMB% NAJA\IO		MBOOT.S			-list %BUILD%\MBOOT.LST
%ASMB% NAJA\IO		FAKE.GROUP.S
%ASMB% NAJA\IO		ASM.NCOMMONS.S	-list %BUILD%\NCOMMONS.LST

%ASM% NAJA\IO				ASM.CHAR.DATA.S
%ASM% NAJA\BOOT				PR.INFO.S
%ASM% TRACC					ASM.CAMP.S

%ASM% MOTHER\HALL			ASM.HALL.S		-list %BUILD%\MCONTROL.LST
%ASM% MOTHER\GROUP.ASSEMBLY	ASM.GROUP.S
%ASM% MOTHER\ENROLLTEST		ASM.ENTEST.S
%ASM% MOTHER\ENERGY			ASM.ENERGY.S
%ASM% MOTHER\ARSENAL		ASM.ARSENAL.S
%ASM% MOTHER\ROBOT.REPAIR	ASM.REPAIR.S
%ASM% MOTHER\INFIRMARY		ASM.INFIRMARY.S

a2nib -create -volume 0 -disk mother.nib
a2nib %OBJDIR%\CHAR.DATA		-t 00 -s 00 -disk mother.nib
a2nib %OBJDIR%\PR.INFO			-t 00 -s 0C -disk mother.nib
%ASM% NAJA\IO		NDOS.525.S
a2nib %OBJDIR%\NDOS.525W		-t 00 -s 0E -disk mother.nib
a2nib %OBJDIR%\MTESSINFO		-t 01 -s 00 -disk mother.nib
a2nib %OBJDIR%\MTUNNELS			-t 02 -s 00 -disk mother.nib
a2nib %OBJDIR%\MCONTROL			-t 04 -s 00 -disk mother.nib
a2nib %OBJDIR%\CAMP.B000		-t 05 -s 00 -disk mother.nib
a2nib %OBJDIR%\CAMP.E000		-t 05 -s 0B -disk mother.nib
a2nib %OBJDIR%\CAMP.D000.M1		-t 07 -s 0B -disk mother.nib
a2nib %OBJDIR%\CAMP.D000.M2		-t 08 -s 04 -disk mother.nib

a2nib %OBJDIR%\ENERGY.CENTER	-t 09 -s 00 -disk mother.nib
a2nib %OBJDIR%\INFIRMARY		-t 0B -s 08 -disk mother.nib
a2nib %OBJDIR%\GROUP.ASSEMBLY	-t 0D -s 00 -disk mother.nib
a2nib %OBJDIR%\ENROLL.TEST		-t 0F -s 00 -disk mother.nib
a2nib %OBJDIR%\ARSENAL			-t 13 -s 00 -disk mother.nib
a2nib %OBJDIR%\ROBOT.REPAIR		-t 17 -s 00 -disk mother.nib

%ASMB% NAJA\IO		NDOS.525.S	-list %BUILD%\NDOS.525.LST
