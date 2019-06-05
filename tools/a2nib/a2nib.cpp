
#include <windows.h>
#include <stdio.h>
#include "DiskImage.h"

// always build new dos images now
#define NEW_DOS

int main(int argc, char* argv[])
{
	const char* fileName = nullptr;
	const char* diskName = nullptr;
	INT32 volume = -1;
	INT32 track = -1;
	INT32 sector = -1;
	INT32 count = 0;
	bool createMode = false;
	bool readMode = false;

	argc -= 1;
	argv += 1;

	if (argc == 0)
		goto usage;

	while (argc--)
	{
		char* str = *argv++;

		if (_stricmp(str, "-disk") == 0)
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
		else if (_stricmp(str, "-volume") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing volume value\n");
				return -1;
			}
			str = *argv++;

			sscanf(str, "%x", &volume);
			if (volume < 0 || volume > 6)
			{
				printf("Invalid volume value\n");
				return -1;
			}
		}
		else if (_stricmp(str, "-t") == 0 || _stricmp(str, "-track") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing track value\n");
				return -1;
			}
			str = *argv++;

			sscanf(str, "%x", &track);
			if (track < 0 || track >= 35)
			{
				printf("Invalid track value\n");
				return -1;
			}
		}
		else if (_stricmp(str, "-s") == 0 || _stricmp(str, "-sector") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing sector value\n");
				return -1;
			}
			str = *argv++;

			sscanf(str, "%x", &sector);
			if (sector < 0 || sector >= 16)
			{
				printf("Invalid sector value\n");
				return -1;
			}
		}
		else if (_stricmp(str, "-c") == 0 || _stricmp(str, "-count") == 0)
		{
			if (argc-- == 0)
			{
				printf("Missing sector count value\n");
				return -1;
			}
			str = *argv++;

			sscanf(str, "%x", &count);
			if (count < 0)
			{
				printf("Invalid sector count value\n");
				return -1;
			}
		}
		else if (_stricmp(str, "-create") == 0)
		{
			createMode = true;
		}
		else if (_stricmp(str, "-read") == 0)
		{
			readMode = true;
		}
		else if (str[0] == '-')
		{
			printf("Unknown option \"%s\"\n\n", str);
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

	if (createMode)
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

		if (readMode && count == 0)
		{
			printf("Count required when reading\n");
			return -1;
		}
	}

	if (!diskName)
	{
		printf("Missing disk name\n");
		return -1;
	}

	FILE* file = nullptr;
	UINT8* fileData = nullptr;
	INT32 fileDataSize = 0;
	DiskImage* diskImage = nullptr;
	INT32 result = -1;

	if (!createMode)
	{
		if (readMode)
		{
			fileDataSize = count * 256;
			fileData = (UINT8*)malloc(fileDataSize);
		}
		else
		{
			file = fopen(fileName, "rb");
			if (!file)
			{
				printf("Unable to open \"%s\"\n", fileName);
				return -1;
			}

			fseek(file, 0, SEEK_END);
			INT32 size = ftell(file);
			fseek(file, 0, SEEK_SET);
			fileDataSize = (size + 255) & ~255;
			fileData = (UINT8*)malloc(fileDataSize);
			memset(fileData, 0, fileDataSize);
			if (fread(fileData, 1, size, file) != size)
			{
				printf("Error reading source file\n");
				goto exit;
			}
			fclose(file);

			if (count > 0 && fileDataSize > count * 256)
			{
				printf("\n### Source file too large for sector count (0x%x > 0x%x)\n\n",
					fileDataSize, count * 256);
				goto exit;
			}
		}
	}

#ifdef NEW_DOS
	diskImage = new Naja2Image();
#else
	diskImage = new NajaImage();
#endif
	if (!diskImage->Open(diskName, createMode))
	{
		printf("Unable to open/create disk image file\n");
		goto exit;
	}

	if (createMode)
	{
		printf("Initializing %s\n", diskName);
		diskImage->Initialize(volume);
	}
	else
	{
		VTS vts;
		vts.volume = volume;
		vts.track = track;
		vts.sector = sector;
		if (readMode)
		{
			printf("Reading into %s\n", fileName);

			if (!diskImage->Read(vts, fileData, fileDataSize))
			{
				printf("Reading from disk image failed\n");
				goto exit;
			}

			file = fopen(fileName, "wb+");
			if (!file)
			{
				printf("Unable to create \"%s\" for write\n", fileName);
				goto exit;
			}

			if (fwrite(fileData, 1, fileDataSize, file) != fileDataSize)
			{
				printf("Error writing to file\n");
				goto exit;
			}
		}
		else
		{
			printf("Writing %s\n", fileName);
			if (!diskImage->Write(vts, fileData, fileDataSize))
			{
				printf("Writing to disk image failed\n");
				goto exit;
			}
		}
	}

	result = 0;

exit:
	delete diskImage;

	if (fileData)
		free(fileData);
	if (file)
		fclose(file);

	return result;

usage:
	printf("a2nib -create -volume <value> -d[isk] <disk-name>\n");
	printf("a2nib [-read] <file-name> -t[rack] <hex> -s[ector] <hex> [-c[ount] <hex>] -disk <disk-name>\n");
	return -1;
}
