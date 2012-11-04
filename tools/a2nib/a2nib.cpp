
#include <windows.h>
#include <stdio.h>
#include "DiskImage.h"

int main(int argc,char* argv[])
{
	const char* fileName = NULL;
	const char* diskName = NULL;
	INT32 volume = -1;
	INT32 track = -1;
	INT32 sector = -1;
	bool create = false;
	
	argc -= 1;
	argv += 1;
	
	if (argc == 0)
		goto usage;
	
	while (argc--)
	{
		char* str = *argv++;
		
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
		else if (stricmp(str,"-v") == 0 || stricmp(str,"-volume") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing volume value\n");
				return -1;
			}
			str = *argv++;
			
			sscanf(str,"%x",&volume);
			if (volume < 0 || volume > 6)
			{
				printf("Invalid volume value\n");
				return -1;
			}
		}
		else if (stricmp(str,"-t") == 0 || stricmp(str,"-track") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing track value\n");
				return -1;
			}
			str = *argv++;
			
			sscanf(str,"%x",&track);
			if (track < 0 || track >= 35)
			{
				printf("Invalid track value\n");
				return -1;
			}
		}
		else if (stricmp(str,"-s") == 0 || stricmp(str,"-sector") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing sector value\n");
				return -1;
			}
			str = *argv++;
			
			sscanf(str,"%x",&sector);
			if (sector < 0 || sector >= 16)
			{
				printf("Invalid sector value\n");
				return -1;
			}
		}
		else if (stricmp(str,"-c") == 0 || stricmp(str,"-create") == 0)
		{
			create = true;
		}
		else if (str[0] == '-')
		{
			printf("Unknown option \"%s\"\n\n",str);
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
	
	if (create)
	{
		if (volume == -1)
		{
			printf("Missing volume value\n");
			return -1;
		}
		if (track != -1)
			printf("Track value ignored on create\n");
		if (sector != -1)
			printf("Sector value ignored on create\n");
		if (fileName)
			printf("Source file name ignored on create\n");
	}
	else
	{
		if (track == -1)
		{
			printf("Missing track value\n");
			return -1;
		}
		
		if (sector == -1)
		{
			printf("Missing sector value\n");
			return -1;
		}
		
		if (!fileName)
		{
			printf("Missing source file name\n");
			return -1;
		}
	}
	
	if (!diskName)
	{
		printf("Missing disk name\n");
		return -1;
	}
	
	FILE* file = NULL;
	UINT8* fileData = NULL;
	INT32 fileDataSize = 0;
	NajaImage* diskImage = NULL;
	
	if (!create)
	{
		file = fopen(fileName,"rb");
		if (!file)
		{
			printf("Unable to open \"%s\"\n",fileName);
			return -1;
		}
		
		fseek(file,0,SEEK_END);
		INT32 size = ftell(file);
		fseek(file,0,SEEK_SET);
		fileDataSize = (size + 255) & ~255;
		fileData = (UINT8*)malloc(fileDataSize);
		memset(fileData,0,fileDataSize);
		if (fread(fileData,1,size,file) != size)
		{
			printf("Error reading source file\n");
			goto error;
		}
		fclose(file);
	}
	
	diskImage = new NajaImage();
	if (!diskImage->Open(diskName,create))
	{
		printf("Unable to open/create disk image file\n");
		goto error;
	}
	
	if (create)
	{
		printf("Initializing %s\n",diskName);
		diskImage->Initialize(volume);
	}
	else
	{
		VTS vts;
		vts.volume = volume;
		vts.track = track;
		vts.sector = sector;
		printf("Writing %s\n",fileName);
		if (!diskImage->Write(vts,fileData,fileDataSize))
		{
			printf("Write to disk image failed\n");
			goto error;
		}
	}
	
	if (fileData)
		free(fileData);
	if (diskImage)
		delete diskImage;
	return 0;
	
error:
	if (diskImage)
		delete diskImage;
	if (fileData)
		free(fileData);
	if (file)
		fclose(file);
	return -1;

usage:
	printf("a2nib -c[reate] -v[olume] <value> -d[isk] <disk-name>\n");
	printf("a2nib <file-name> -t[rack] <hex> -s[ector] <hex> -d[isk] <disk-name>\n");
	return -1;
}
