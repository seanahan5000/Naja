
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
		mValue = value;
	}

	void SetValue(const char* value)
	{
		mValue = value;
	}

	const char* GetValue()
	{
		return mValue.c_str();
	}

protected:
	std::string mValue;
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
	const char* GetRootDir() { return mRootDir.c_str(); }
	const char* GetSourceDir() { return mSourceDir.c_str(); }
	const char* GetObjectDir() { return mObjectDir.c_str(); }
	void SetDiskFile(const char* fileName);
	std::string BuildFullSourcePath(const char* fileName);
	std::string BuildFullObjectPath(const char* fileName);

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
	bool InMacroDef() { return mMacroDef != nullptr; }
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

	void SetLocalBase(const char* localBase) { mLocalBase = localBase; }
	void LocalToGlobal(const char* symbol, std::string& global);

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
	std::string CleanDirName(const char* dirName);

	Syntax mSyntax;

	std::string mRootDir;
	std::string mSourceDir;
	std::string mObjectDir;
	std::string mOutFileName;
	std::string mInName;

	std::vector<SourceFile*> mFileList;
	FileReadState mReadState;
	std::stack<FileReadState> mReadStateStack;

	std::vector<LineRecord> mLineList;

	Parser* mParser;
	StringHash* mVars;
	StringHash* mSymbols;
	std::string mLocalBase;

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
