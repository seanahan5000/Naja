@echo off

set ROOT=%~dp0\..
set BUILD=%ROOT%\build
set SRC=%ROOT%\src
set OBJ=%ROOT%\obj
set BIN=%ROOT%\bin
set ASM=asm6502 -root %SRC% -objbase ..\obj -base

if not exist %OBJ% mkdir %OBJ%
if not exist %BIN% mkdir %BIN%

%ASM% FIGHT\LOADER			ASM.LOADER.S   -list FIGHT.LOADER.LST
%ASM% FIGHT\COMMAND			ASM.COMMAND.S
%ASM% FIGHT\NARRATOR		ASM.NARRATOR.S
%ASM% FIGHT\AWARDER			ASM.AWARDER.S
%ASM% FIGHT\DEAD			ASM.DEAD.S

%ASM% TRACC                 ASM.13.S
%ASM% TRACC					ASM.11.S
REM %ASM% TRACC				ASM.9.S

%ASM% TRACC					ASM.CAMP.S
%ASM% TRACC					ASM.TUNNELS.S
%ASM% TRACC\EDITOR			SELECT.OPTION.S
%ASM% TRACC\EDITOR			EDITOR.S
%ASM% SPECIALS\ELEVATOR		THE.ELEVATOR.S
%ASM% SPECIALS\FINDMENT		FINDMENT.S

REM ---------------------------------------
REM Boot and Mothership
REM ---------------------------------------

%ASM% NAJA\BOOT             NDOS.BOOT1.S
%ASM% NAJA\BOOT             PR.INFO.S
%ASM% NAJA\BOOT             SCREEN.III.S
%ASM% NAJA\IO               NDOS.525.S      -sym %BIN%\ndos.sym
%ASM% NAJA\IO               ASM.NCOMMONS.S  -sym %BIN%\ncom.sym
%ASM% MOTHER\HALL           ASM.HALL.S      -sym %BIN%\hall.sym
%ASM% TRACC                 ASM.CAMP.S      -sym %BIN%\camp.sym
%ASM% NAJA\IO               ASM.CHAR.DATA.S
%ASM% NAJA\BOOT             ASM.TITLE.S
%ASM% MOTHER\GROUP.ASSEMBLY ASM.GROUP.S     -sym %BIN%\group.sym
%ASM% MOTHER\ENROLLTEST     ASM.ENTEST.S
%ASM% MOTHER\ENERGY         ASM.ENERGY.S
%ASM% MOTHER\ARSENAL        ASM.ARSENAL.S
%ASM% MOTHER\ROBOT.REPAIR   ASM.REPAIR.S
%ASM% MOTHER\INFIRMARY      ASM.INFIRMARY.S

set A2NIB=a2nib -disk %BIN%\boot.nib
%A2NIB% -create -volume 0

rem *** check all -c values ***

%A2NIB% %OBJ%\NDOS.BOOT1		-t 00 -s 00 -c 02
%A2NIB% %OBJ%\PR.INFO           -t 00 -s 02 -c 01
%A2NIB% %OBJ%\SCREEN.III        -t 00 -s 03 -c 01
%A2NIB% %OBJ%\NDOS.525          -t 00 -s 04 -c 04
%A2NIB% %OBJ%\NCOMMONS          -t 00 -s 08 -c 18
%A2NIB% %OBJ%\CAMP.B000         -t 02 -s 00 -c 10
%A2NIB% %OBJ%\CAMP.E000         -t 03 -s 00 -c 20
%A2NIB% %OBJ%\CAMP.D000.M2      -t 05 -s 00 -c 10
%A2NIB% %OBJ%\CAMP.D000.M1      -t 06 -s 00 -c 10
%A2NIB% %OBJ%\TITLE.PAGE        -t 07 -s 00 -c 40
rem *** track B not used
%A2NIB% %OBJ%\MTUNNELS          -t 0C -s 00 -c 20
%A2NIB% %OBJ%\MCONTROL          -t 0E -s 00 -c 10
%A2NIB% %OBJ%\MTESSINFO         -t 0F -s 00 -c 10
%A2NIB% %OBJ%\CHAR.DATA         -t 10 -s 00 -c 0E
%A2NIB% %OBJ%\NDOS.525W         -t 10 -s 0E -c 02
%A2NIB% %OBJ%\GROUP.ASSEMBLY    -t 11 -s 00 -c 20
%A2NIB% %OBJ%\ENROLL.TEST       -t 13 -s 00 -c 40
%A2NIB% %OBJ%\INFIRMARY         -t 17 -s 00 -c 18
%A2NIB% %OBJ%\ENERGY.CENTER     -t 18 -s 08 -c 28
%A2NIB% %OBJ%\ARSENAL           -t 1B -s 00 -c 40
%A2NIB% %OBJ%\ROBOT.REPAIR      -t 1F -s 00 -c 40

REM ---------------------------------------
REM TRACC shell 17
REM ---------------------------------------

%ASM% ALIENS                    ASM.DATA.17.S
%ASM% ALIENS                    ASM.PICS.17.S

%ASM% TRACC                     ASM.17.S

set A2NIB=a2nib -disk %BIN%\tracc1.nib
%A2NIB% -create -volume 1

%A2NIB% %OBJ%\ALIEN.DATA.17     -t 00 -s 00 -c 1C
%A2NIB% %OBJ%\ALIEN.PICS.17     -t 02 -s 00 -c 7B

%A2NIB% %OBJ%\CONTROL17         -t 1B -s 00 -c 10
%A2NIB% %OBJ%\LOADER17          -t 22 -s 00 -c 0D

call :TRACC_COMMON

REM ---------------------------------------
REM TRACC shell 15
REM ---------------------------------------

%ASM% ALIENS                    ASM.DATA.15.S
%ASM% ALIENS                    ASM.PICS.15.S

%ASM% TRACC                     ASM.15.S

set A2NIB=a2nib -disk %BIN%\tracc2.nib
%A2NIB% -create -volume 2

%A2NIB% %OBJ%\ALIEN.DATA.15     -t 00 -s 00 -c 13
%A2NIB% %OBJ%\ALIEN.PICS.15     -t 02 -s 00 -c 6E

%A2NIB% %OBJ%\CONTROL15         -t 1B -s 00 -c 10

call :TRACC_COMMON

REM ---------------------------------------
REM TRACC shell 13
REM ---------------------------------------

%ASM% ALIENS                    ASM.DATA.13.S -list ALIEN.DATA.13.LST
%ASM% ALIENS                    ASM.PICS.13.S -list ALIEN.PICS.13.LST

%ASM% TRACC                     ASM.13.S -list CONTROL13.LST

set A2NIB=a2nib -disk %BIN%\tracc3.nib
%A2NIB% -create -volume 3

%A2NIB% %OBJ%\ALIEN.DATA.13     -t 00 -s 00 -c 10
%A2NIB% %OBJ%\ALIEN.PICS.13     -t 02 -s 00 -c 49

%A2NIB% %OBJ%\CONTROL13         -t 1B -s 00 -c 10

call :TRACC_COMMON

REM ---------------------------------------
REM Write common TRACC files
REM ---------------------------------------

:TRACC_COMMON

%A2NIB% %OBJ%\FIGHT.LOADER      -t 0A -s 00 -c 11
%A2NIB% %OBJ%\FIGHT.COMMAND     -t 0B -s 01 -c 3D
%A2NIB% %OBJ%\FIGHT.NARRATOR    -t 0F -s 00 -c 4D
%A2NIB% %OBJ%\AWARDER           -t 14 -s 00 -c 0E
%A2NIB% %OBJ%\DEAD.GROUP        -t 15 -s 00 -c 10
%A2NIB% %OBJ%\FINDMENT          -t 16 -s 00 -c 08
%A2NIB% %OBJ%\ELEVATOR          -t 17 -s 00 -c 0C

%A2NIB% %OBJ%\CAMP.7800         -t 1C -s 00 -c 1F
%A2NIB% %OBJ%\CAMP.B000         -t 1E -s 00 -c 0B
%A2NIB% %OBJ%\TUNNELS           -t 1F -s 00 -c 18

%A2NIB% %OBJ%\ALIEN.EDITOR      -t 20 -s 08 -c 18
%A2NIB% %OBJ%\SELECT.OPTION     -t 22 -s 0D -c 03

exit /B

REM ---------------------------------------
