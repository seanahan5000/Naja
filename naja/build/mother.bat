@echo off

set ROOT=d:\misc\dev\naja\src
set BUILD=d:\misc\dev\naja\build
set ASMB=asm6502 -bin -root %ROOT% -base
set ASM=asm6502 -root %ROOT% -base

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
a2nib %ROOT%\NAJA\IO\CHAR.DATA		-t 00 -s 00 -disk mother.nib
a2nib %ROOT%\NAJA\BOOT\PR.INFO		-t 00 -s 0C -disk mother.nib
%ASM% NAJA\IO		NDOS.525.S
a2nib %ROOT%\NAJA\IO\NDOS.525W		-t 00 -s 0E -disk mother.nib
a2nib %ROOT%\MOTHER\HALL\MTESSINFO	-t 01 -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\HALL\MTUNNELS	-t 02 -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\HALL\MCONTROL	-t 04 -s 00 -disk mother.nib
a2nib %ROOT%\TRACC\CAMP.B000		-t 05 -s 00 -disk mother.nib
a2nib %ROOT%\TRACC\CAMP.E000		-t 05 -s 0B -disk mother.nib
a2nib %ROOT%\TRACC\CAMP.D000.M1		-t 07 -s 0B -disk mother.nib
a2nib %ROOT%\TRACC\CAMP.D000.M2		-t 08 -s 04 -disk mother.nib

a2nib %ROOT%\MOTHER\ENERGY\ENERGY.CENTER		  -t 09 -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\INFIRMARY\INFIRMARY			  -t 0B -s 08 -disk mother.nib
a2nib %ROOT%\MOTHER\GROUP.ASSEMBLY\GROUP.ASSEMBLY -t 0D -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\ENROLLTEST\ENROLL.TEST		  -t 0F -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\ARSENAL\ARSENAL				  -t 13 -s 00 -disk mother.nib
a2nib %ROOT%\MOTHER\ROBOT.REPAIR\ROBOT.REPAIR	  -t 17 -s 00 -disk mother.nib

%ASMB% NAJA\IO		NDOS.525.S		-list %BUILD%\NDOS.525.LST
