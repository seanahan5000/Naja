
#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <stdio.h>
#include "Dos33.h"

//------------------------------------------------------------------------------

enum Operation
{
	None	= 0,
	Create	= 1,
	Catalog	= 2,
	Delete	= 3,
	Bsave	= 4
};


int main(int argc,char* argv[])
{
	int result = -1;
	bool fileNameRequired = false;
	const char* fileName = NULL;
	const char* diskName = NULL;
	Operation op = None;
	UINT32 address = 0xFFFFFFFF;

	argc -= 1;
	argv += 1;

	if (argc == 0)
		goto usage;

	while (argc--)
	{
		char* str = *argv++;

		if (str[0] == '-')
		{
			if (_stricmp(str, "-d") == 0 || _stricmp(str, "-disk") == 0)
			{
				if (argc-- == 0)
				{
					printf("Missing disk name\n");
					return -1;
				}
				str = *argv++;

				if (diskName)
				{
					printf("Only one disk name allowed\n");
					return -1;
				}

				diskName = str;
			}
			else if (_stricmp(str, "-create") == 0)
			{
				if (op != None)
				{
					printf("-create cannot be used with other operations\n");
					goto usage;
				}
				op = Create;
			}
			else if (_stricmp(str, "-catalog") == 0)
			{
				if (op != None)
				{
					printf("-catalog cannot be used with other operations\n");
					goto usage;
				}
				op = Catalog;
			}
			else if (_stricmp(str, "-delete") == 0)
			{
				if (op != None)
				{
					printf("-delete cannot be used with other operations\n");
					goto usage;
				}
				op = Delete;
				fileNameRequired = true;
			}
			else if (_stricmp(str, "-bsave") == 0)
			{
				if (op != None)
				{
					printf("-delete cannot be used with other operations\n");
					goto usage;
				}
				op = Bsave;
				fileNameRequired = true;
			}
			else if (_stricmp(str, "-a") == 0 || _stricmp(str, "-addr") == 0)
			{
				if (argc-- == 0)
				{
					printf("Missing address value\n");
					goto usage;
				}
				str = *argv++;

				sscanf(str, "%x", &address);
			}
			else
			{
				printf("Unknown option \"%s\"\n\n", str);
				goto usage;
			}
		}
		else if (fileName)
		{
			printf("More than one file name specified\n");
			goto usage;
		}
		else
		{
			fileName = str;
		}
	}

	if (fileNameRequired)
	{
		if (!fileName)
		{
			printf("Missing file name\n");
			goto usage;
		}
	}
	else if (fileName)
	{
		printf("Unexpected file name\n");
		goto usage;
	}

	if (op == None)
	{
		printf("No operation specified\n");
		goto usage;
	}

	if (op == Bsave && address == 0xFFFFFFFF)
	{
		printf("Missing bsave address\n");
		goto usage;
	}

	if (!diskName)
	{
		printf("Missing disk name\n");
		goto usage;
	}

    Dos33* diskImage;
    diskImage = new Dos33();

	if (!diskImage->Open(diskName, (op == Create)))
	{
		printf("Unable to open/create disk image file\n");
		goto error;
	}

	switch (op)
	{
		case Create:
			printf("Initializing %s\n", diskName);
			diskImage->Format();
			break;

		case Catalog:
			diskImage->Catalog();
			break;

		case Delete:
			diskImage->Delete(fileName);
			break;

		case Bsave:
		{
			FILE* file = fopen(fileName, "rb");
			if (!file)
			{
				printf("Unable to open \"%s\"\n", fileName);
				return -1;
			}

			fseek(file, 0, SEEK_END);
			INT32 size = ftell(file);
			fseek(file, 0, SEEK_SET);
			UINT8* fileData = (UINT8*)malloc(size);
			INT32 bytesRead = (INT32)fread(fileData, 1, size, file);
			fclose(file);
			if (bytesRead != size)
			{
				printf("Error reading source file\n");
				free(fileData);
				goto error;
			}

			diskImage->Bsave(fileName, address, size, fileData);
			free(fileData);
			break;
		}
	}
	result = 0;

error:
	if (diskImage)
		delete diskImage;

	return result;

usage:
	printf("\n");
	printf("dos33 -create -d[isk] <disk-name>\n");
	printf("dos33 -catalog -d[isk] <disk-name>\n");
	printf("dos33 -delete <file-name> -d[isk] <disk-name>\n");
	printf("dos33 -bsave <file-name> -a[ddr] <hex-address> -d[isk] <disk-name>\n");
	return -1;
}

//------------------------------------------------------------------------------
