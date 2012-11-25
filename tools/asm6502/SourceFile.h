
#pragma once

#include "ClassUtils.h"

class Assembler;

//------------------------------------------------------------------------------

class SourceFile
{
public:
	static SourceFile* Create(Assembler* assembler, const char* fileName);
	~SourceFile();
	
	const char* GetName() { return mFileName; }
	char* GetLine(INT32 line) { return mBuffer + mOffsets[line]; }
	INT32 GetLineCount() { return mOffsets.GetCount(); }
	
protected:
	SourceFile(Assembler* assembler, const char* fileName);
	
	const char* mFileName;
	char* mBuffer;
	Array<UINT32> mOffsets;
};

//------------------------------------------------------------------------------
