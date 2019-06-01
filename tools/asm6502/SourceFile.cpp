
#include "precomp.h"
#include "SourceFile.h"
#include "Assembler.h"

//------------------------------------------------------------------------------

SourceFile::SourceFile(Assembler* assembler, const char* fileName)
	: mOffsets(256)
{
	mFileName = _strdup(fileName);
	mBuffer = NULL;

	char fullPath[1024];
	assembler->BuildFullSourcePath(fullPath, fileName);

	// must opened as binary, not text
	strcat(fullPath, ".S");
	FILE* file = fopen(fullPath, "rb");
	if (!file)
	{
		fullPath[strlen(fullPath) - 2] = 0;
		file = fopen(fullPath, "rb");
	}

	if (!file)
	{
		assembler->SetError("Input file \"%s\" not found", fullPath);
		return;
	}

	fseek(file, 0, SEEK_END);
	long fileSize = ftell(file);
	fseek(file, 0, SEEK_SET);

	// Use fileSize + 1 to make room for last terminator
	//	if file doesn't end with a '\r' or '\n'.
	mBuffer = (char*)malloc(fileSize + 1);
	fread(mBuffer, 1, fileSize, file);
	fclose(file);

	char* sp = mBuffer;
	char* ep = mBuffer + fileSize;
	char* start = sp;
	while (sp != ep)
	{
		char c = *sp++;
		if (c == '\r' || c == '\n')
		{
			mOffsets.Add(start - mBuffer);
			*(sp - 1) = 0;		// replace '\r' with zero terminator
			if (c == '\r' && *sp == '\n')
				sp++;
			start = sp;
		}
	}
	if (sp != start)
	{
		mOffsets.Add(start - mBuffer);
		*sp = 0;
	}

	mOffsets.Trim();
}


/*static*/ SourceFile*
SourceFile::Create(Assembler* assembler, const char* fileName)
{
	SourceFile* file = new SourceFile(assembler, fileName);
	if (file->mBuffer == NULL)
	{
		delete file;
		file = NULL;
	}
	return file;
}


SourceFile::~SourceFile()
{
	free((void*)mFileName);
	free(mBuffer);
}

//------------------------------------------------------------------------------
