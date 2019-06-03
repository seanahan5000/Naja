
#pragma once

#include "StringUtils.h"
#include "ClassUtils.h"

class SourceFile;
class Parser;
class Statement;
class StringHash;
class LineReader;

//------------------------------------------------------------------------------

class Symbol
{
public:
	Symbol(INT32 value, bool forceLong)
	{
		mValue = value;
		mForceLong = forceLong;
	}

	INT32 GetSize()
	{
		return (mForceLong || (UINT32)mValue > 255) ? 2 : 1;
	}

	INT32 GetValue() { return mValue; }

protected:
	INT32 mValue;
	bool mForceLong;
};

//------------------------------------------------------------------------------

class Var
{
public:
	Var(const char* value)
	{
		mValue = _strdup(value);
	}

	~Var()
	{
		free(mValue);
	}

	void SetValue(const char* value)
	{
		free(mValue);
		mValue = _strdup(value);
	}

	const char* GetValue()
	{
		return mValue;
	}

protected:
	char* mValue;
};

//------------------------------------------------------------------------------

static const int kMaxLabelSize = 31;

enum Syntax
{
	SyntaxMerlin	= 1,
	SyntaxDASM		= 2,
	SyntaxIIGS		= 4
};

struct FileReadState
{
	SourceFile* file;
	INT32 fileIndex;
	INT32 startLineIndex;
	INT32 curLineIndex;
	INT32 endLineIndex;		// exclusive
	INT32 loopCount;		// includes first pass
	bool isMacro;
};

struct LineRecord
{
	INT32 fileIndex;
	INT32 lineIndex;
	Statement* statement;
};

struct MacroDef
{
	INT32 fileIndex;
	INT32 startLineIndex;
	INT32 endLineIndex;
};

class Assembler
{
public:
	Assembler();
	~Assembler();

	void SetSaveAsBin(bool saveAsBin) { mWriteAsBin = saveAsBin; }
	void SetRootDir(const char* dirName);
	void SetSourceDir(const char* dirName);
	void SetObjectDir(const char* dirName);
	const char* GetRootDir() { return mRootDir; }
	const char* GetSourceDir() { return mSourceDir; }
	const char* GetObjectDir() { return mObjectDir; }
	void SetDiskFile(const char* fileName);
	void BuildFullSourcePath(char* fullPath, const char* fileName);
	void BuildFullObjectPath(char* fullPath, const char* fileName);

	bool Assemble(
		const char* inName,
		const char* outName,
		const char* listName,
		const char* symName);

	void AssembleBegin();
	bool AssembleParse(const char* inName);
	bool AssembleWrite(
		const char* outName,
		const char* listName,
		const char* symName);
	void AssembleEnd();

	void AddStatement(Statement* statement);

	bool IncludeFile(const char* fileName);

	void StartMacroDef(const char* name);
	void EndMacroDef();
	bool InMacroDef() { return mMacroDef != NULL; }
	bool StartMacroExpand(const char* name);
	bool InMacroExpand() { return mReadState.isMacro; }

	void StartDummy(INT32 org);
	void EndDummy();
	bool InDummy() { return mInDummy; }

	void StartLoop(INT32 loopCount);
	void EndLoop();

	void SetVar(const char* name, const char* value);
	bool GetVar(const char* name, const char** value);

	void SetError(const char* format, ...);
	bool HasError() { return !mErrorMsg.empty(); }
	const char* GetError() { return mErrorMsg.c_str(); }
	void ClearError() { mErrorMsg.clear(); }
	void PrintError(LineRecord* lineRec);

	void SetLocalBase(const char* localBase) { strcpy(mLocalBase, localBase); }
	bool LocalToGlobal(const char* symbol, char* buffer, INT32 bufferSize);

	bool AddLabelSymbol(const char* string, bool local = false);
	bool AddEquateSymbol(const char* string, INT32 value, bool forceLong);

	Symbol* FindSymbol(const char* string)
	{
		return (Symbol*)mSymbols->Find(string);
	}

	void SetSyntax(Syntax syntax) { mSyntax = syntax; }
	Syntax GetSyntax() { return mSyntax; }
	bool IsMerlin() { return mSyntax == SyntaxMerlin; }
	bool IsDASM() { return mSyntax == SyntaxDASM; }

	INT32 GetPC() { return mPC; }
	void SetOrg(INT32 pc);
	void AdvancePC(INT32 d) { mPC += d; }

	UINT8* WriteMakeAvailable(INT32 count) { return mOutBuffer.MakeAvailable(count); }
	void WriteConsume(INT32 count) { if (!InDummy()) mOutBuffer.Consume(count); }
	INT32 WriteGetSize() { return mOutBuffer.GetSize(); }
	void WriteByte(UINT8 b);
	void WriteByteByte(UINT8 b1, UINT8 b2);
	void WriteByteWord(UINT8 b, UINT16 w);
	void WriteBytes(UINT8* bp, INT32 count);
	void WritePattern(UINT8 b, INT32 count);
	bool SaveFile(const char* fileName);
	bool FlushToFile(const char* fileName);

protected:
	void CleanDirName(char* cleanName, const char* dirName);

	Syntax mSyntax;

	char mRootDir[1024];
	char mSourceDir[1024];
	char mObjectDir[1024];
	char mOutFileName[1024];
	std::string mInName;

	Array<SourceFile*> mFileList;
	FileReadState mReadState;
	Stack<FileReadState> mReadStateStack;

	Array<LineRecord> mLineList;

	Parser* mParser;
	StringHash* mVars;
	StringHash* mSymbols;
	char mLocalBase[kMaxLabelSize + 1];

	bool mInDummy;
	INT32 mPC;
	INT32 mDummySaveOrg;

	INT32 mWriteOrg;
	bool mInWritePhase;
	bool mWriteAsBin;

	MacroDef* mMacroDef;
	StringHash* mMacros;

	std::string mErrorMsg;
	INT32 mErrorCount;

	GrowBuffer mOutBuffer;
};

//------------------------------------------------------------------------------
