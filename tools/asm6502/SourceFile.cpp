
#include "precomp.h"
#include "SourceFile.h"
#include "Assembler.h"

//------------------------------------------------------------------------------

SourceFile::SourceFile(Assembler* assembler, const char* fileName)
{
	mFileName = fileName;
	mBuffer = nullptr;

	mOffsets.reserve(256);

	std::string fullPath = assembler->BuildFullSourcePath(fileName);
	fullPath += ".S";

	// must be opened as binary, not text
	FILE* file = fopen(fullPath.c_str(), "rb");
	if (!file)
	{
		fullPath.resize(fullPath.size() - 2);
		file = fopen(fullPath.c_str(), "rb");
	}

	if (!file)
	{
		assembler->SetError("Input file \"%s\" not found", fullPath.c_str());
		return;
	}

	// TODO: error checks on file operations

	fseek(file, 0, SEEK_END);
	size_t fileSize = ftell(file);
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
			mOffsets.push_back(start - mBuffer);
			*(sp - 1) = 0;		// replace '\r' with zero terminator
			if (c == '\r' && *sp == '\n')
				sp++;
			start = sp;
		}
	}
	if (sp != start)
	{
		mOffsets.push_back(start - mBuffer);
		*sp = 0;
	}

	mOffsets.shrink_to_fit();
}


SourceFile* SourceFile::Create(Assembler* assembler, const char* fileName)
{
	SourceFile* file = new SourceFile(assembler, fileName);
	if (!file->mBuffer)
	{
		delete file;
		file = nullptr;
	}
	return file;
}


SourceFile::~SourceFile()
{
	free(mBuffer);
}

//------------------------------------------------------------------------------
