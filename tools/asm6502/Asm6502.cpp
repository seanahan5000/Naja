
#include "precomp.h"

#include "Assembler.h"

#if 0
int main(int argc, char* argv[])
{
	Assembler* assembler = new Assembler();
	
#if 1
	char* curdir;
	char* file;

//	curdir = "MOTHER\\HALL";
//	file = "ASM.HALL.S";
	
//	curdir = "MOTHER\\ARSENAL";
//	file = "ASM.ARSENAL.S";
	
//	curdir = "MOTHER\\ROBOT.REPAIR";
//	file = "ASM.REPAIR.S";
	
	curdir = "TRACC";
	file = "ASM.CAMP.S";
	
//	curdir = "FIGHT\\NARRATOR";
//	file = "ASM.NARRATOR.S";
	
//	curdir = "FIGHT\\COMMAND";
//	file = "ASM.COMMAND.S";
	
//	curdir = "FIGHT\\LOADER";
//	file = "ASM.LOADER.S";
	
//	curdir = "ALIENS";
//	file = "ASM.DATA.S";
	
//	curdir = "ALIENS";
//	file = "ASM.PICS.S";
	
	assembler->SetRootDir("D:\\Misc\\Apple_II\\NAJA_SRC");
	assembler->SetCurrentDir(curdir);
	assembler->Assemble(file,
						"D:\\Misc\\Asm6502\\games\\out.bin",
						"D:\\Misc\\Asm6502\\games\\out.asm.lst");
#else
	
	assembler->Assemble("test.s","test.bin","test.s.lst");	//***
//	assembler->Assemble("test2.s","test2.bin","test2.s.lst");	//***
//	assembler->Assemble("riddle-pal.asm","riddle-pal.bin","riddle-pal.asm.lst");	//***
//	assembler->Assemble("dicombat.asm","dicombat.bin","dicombat.asm.lst");	//***

#endif
	
	delete assembler;
	return 0;
}
#endif


int main(int argc,char* argv[])
{
	bool setRoot = false;
	bool setBase = false;
	char* fileName = NULL;
	Assembler* assembler = new Assembler();
	
//	assembler->SetSyntax(SyntaxDASM);
//	assembler->Assemble("riddle-pal.asm","riddle.bin","riddle.lst");
	
//	assembler->SetSyntax(SyntaxDASM);
//	assembler->Assemble("RiverRaid.asm","RiverRaid.bin","RiverRaid.lst");
	
//	assembler->SetSyntax(SyntaxIIGS);
//	assembler->Assemble("kaboom.a","kaboom.bin","kaboom.lst");
	
//	assembler->SetSyntax(SyntaxDASM);
//	assembler->Assemble("test-dasm.s","test-dasm.bin","test-dasm.lst");
	
//	assembler->Assemble("test.s","test.bin","test.s.lst");
//	assembler->Assemble("test-merlin.s","test-merlin.bin","test-merlin.s.lst");
//	assembler->Assemble("test3.s","test3.bin","test3.s.lst");
//	return 0;
	//***
	
	argc -= 1;
	argv += 1;
	
	if (argc == 0)
		goto usage;
	
	while (argc--)
	{
		char* str = *argv++;
		if (stricmp(str,"-root") == 0)
		{
			if (argc == 0)
			{
				printf("Missing root directory\n");
				return -1;
			}
			
			str = *argv++;
			--argc;
			assembler->SetRootDir(str);
			setRoot = true;
		}
		else if (stricmp(str,"-base") == 0)
		{
			if (argc == 0)
			{
				printf("Missing base directory\n");
				return -1;
			}
			
			str = *argv++;
			--argc;
			assembler->SetCurrentDir(str);
			setBase = true;
		}
		else if (stricmp(str,"-bin") == 0)
		{
			assembler->SetSaveAsBin(true);
		}
		else if (str[0] == '-')
		{
			printf("Unknown option\n\n");
			goto usage;
		}
		else if (!fileName)
		{
			fileName = str;
		}
		else
		{
			printf("Only one input file allowed\n");
			return -1;
		}
	}
	
	if (/*!setRoot || !setBase ||*/ !fileName)
	{
		printf("\nMissing parameter\n");
		goto usage;
	}
	
	assembler->Assemble(fileName,NULL,//***NULL);
						"D:\\Misc\\Asm6502\\games\\out.asm.lst");
	return 0;
	
usage:
	printf("\nasm6502 [-bin] -root <directory> -base <directory> <filename>\n\n");
	return -1;
}
