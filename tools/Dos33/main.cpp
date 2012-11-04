
#include <windows.h>
#include <stdio.h>
#include "Dos33.h"

//------------------------------------------------------------------------------

enum Operation
{
	Nothing		= 0,
	Create		= 1,
	Catalog		= 2,
	Delete		= 3,
	Bsave		= 4
};


int main(int argc,char* argv[])
{
	int result = -1;
	bool fileNameNext = false;
	const char* fileName = NULL;
	const char* diskName = NULL;
	Operation op = Nothing;
	UINT32 address = -1;
	
	argc -= 1;
	argv += 1;
	
	if (argc == 0)
		goto usage;
	
	while (argc--)
	{
		char* str = *argv++;
		
		if (fileNameNext)
		{
			if (str[0] == '-')
			{
				printf("Filename required\n");
				goto usage;
			}
			
			fileName = str;
			fileNameNext = false;
			continue;
		}
		
		if (stricmp(str,"-d") == 0 || stricmp(str,"-disk") == 0)
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
		else if (stricmp(str,"-create") == 0)
		{
			if (op != Nothing)
			{
				printf("-create cannot be used with other operations\n");
				goto usage;
			}
			op = Create;
		}
		else if (stricmp(str,"-catalog") == 0)
		{
			if (op != Nothing)
			{
				printf("-catalog cannot be used with other operations\n");
				goto usage;
			}
			op = Catalog;
		}
		else if (stricmp(str,"-delete") == 0)
		{
			if (op != Nothing)
			{
				printf("-delete cannot be used with other operations\n");
				goto usage;
			}
			op = Delete;
			fileNameNext = true;
		}
		else if (stricmp(str,"-bsave") == 0)
		{
			if (op != Nothing)
			{
				printf("-delete cannot be used with other operations\n");
				goto usage;
			}
			op = Bsave;
			fileNameNext = true;
		}
		else if (stricmp(str,"-a") == 0 || stricmp(str,"-addr") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing address value\n");
				goto usage;
			}
			str = *argv++;
			
			sscanf(str,"%x",&address);
		}
		else if (str[0] == '-')
		{
			printf("Unknown option \"%s\"\n\n",str);
			goto usage;
		}
	}
	
	if (fileNameNext)
	{
		printf("Missing file name\n");
		goto usage;
	}
	
	if (op == Nothing)
	{
		printf("No operation specified\n");
		goto usage;
	}
	
	if (op == Delete || op == Bsave)
	{
		if (!fileName)
		{
			printf("Missing file name\n");
			goto usage;
		}
	}
	
	if (op == Bsave && address == -1)
	{
		printf("Missing bsave address\n");
		goto usage;
	}
	
	if (!diskName)
	{
		printf("Missing disk name\n");
		goto usage;
	}
	
	Dos33* diskImage = new Dos33();
	if (!diskImage->Open(diskName,true/*(op == Create)*/))	//***
	{
		printf("Unable to open/create disk image file\n");
		goto error;
	}
	
	switch (op)
	{
		case Create:
			printf("Initializing %s\n",diskName);
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
			diskImage->Format();		//***
			
			FILE* file = fopen(fileName,"rb");
			if (!file)
			{
				printf("Unable to open \"%s\"\n",fileName);
				return -1;
			}
			
			fseek(file,0,SEEK_END);
			INT32 size = ftell(file);
			fseek(file,0,SEEK_SET);
			UINT8* fileData = (UINT8*)malloc(size);
			INT32 bytesRead = (INT32)fread(fileData,1,size,file);
			fclose(file);
			if (bytesRead != size)
			{
				printf("Error reading source file\n");
				free(fileData);
				goto error;
			}
			
			diskImage->Bsave(fileName,address,size,fileData);
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
