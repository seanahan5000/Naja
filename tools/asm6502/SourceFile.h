
#pragma once

class Assembler;

//------------------------------------------------------------------------------

class SourceFile
{
public:
	static SourceFile* Create(Assembler* assembler, const char* fileName);
	~SourceFile();

	const char* GetName() { return mFileName.c_str(); }
	char* GetLine(INT32 line) { return mBuffer + mOffsets[line]; }
	size_t GetLineCount() { return mOffsets.size(); }

protected:
	SourceFile(Assembler* assembler, const char* fileName);

	std::string mFileName;
	char* mBuffer;
	std::vector<UINT32> mOffsets;
};

//------------------------------------------------------------------------------
