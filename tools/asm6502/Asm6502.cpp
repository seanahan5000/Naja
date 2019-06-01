
#include "precomp.h"
#include "Assembler.h"

int main(int argc, char* argv[])
{
	bool setRoot = false;
	bool setBase = false;
	char* listName = NULL;
	char* symName = NULL;
	char* fileName = NULL;
	Assembler* assembler = new Assembler();

	argc -= 1;
	argv += 1;

	if (argc == 0)
		goto usage;

	while (argc--)
	{
		char* str = *argv++;
		if (_stricmp(str, "-root") == 0)
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
		else if (_stricmp(str, "-srcbase") == 0 || _stricmp(str, "-base") == 0)
		{
			if (argc == 0)
			{
				printf("Missing srcbase directory\n");
				return -1;
			}

			str = *argv++;
			--argc;
			assembler->SetSourceDir(str);
			setBase = true;
		}
		else if (_stricmp(str, "-objbase") == 0)
		{
			if (argc == 0)
			{
				printf("Missing objbase directory\n");
				return -1;
			}

			str = *argv++;
			--argc;
			assembler->SetObjectDir(str);
			setBase = true;
		}
		else if (_stricmp(str, "-list") == 0)
		{
			if (argc == 0)
			{
				printf("Missing list directory\n");
				return -1;
			}

			str = *argv++;
			--argc;
			listName = str;
		}
		else if (_stricmp(str, "-sym") == 0)
		{
			if (argc == 0)
			{
				printf("Missing sym directory\n");
				return -1;
			}

			str = *argv++;
			--argc;
			symName = str;
		}
		else if (_stricmp(str, "-bin") == 0)
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

	assembler->Assemble(fileName, NULL, listName, symName);
	return 0;

usage:
	printf("\nasm6502 [-bin] [-list <filename>] [-sym <filename>] [-root <directory> -srcbase <directory> [-objbase <directory>]] <filename>\n\n");
	return -1;
}
