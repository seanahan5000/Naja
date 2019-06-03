
#include "precomp.h"
#include "Assembler.h"
#include "SourceFile.h"
#include "Parser.h"
#include "Statement.h"
#include "StringUtils.h"
#include "ClassUtils.h"

//------------------------------------------------------------------------------

static void NormalizeSlashes(std::string& str)
{
	for (size_t i = 0; i < str.size(); ++i)
	{
		if (str[i] == '/')
			str[i] = '\\';
	}
}


static bool EndsWith(const char* string, const char* endsWith)
{
	size_t strLength = strlen(string);
	size_t endsLength = strlen(endsWith);

	if (endsLength > strLength)
		return false;

	return strcmp(string + strLength - endsLength, endsWith) == 0;
}

//------------------------------------------------------------------------------

Assembler::Assembler()
	: mOutBuffer(16384)
{
	mLineList.reserve(8192);

	mSyntax = SyntaxMerlin;
	mParser = nullptr;
	mMacroDef = nullptr;
	mWriteAsBin = false;

	mParser = nullptr;
	mVars = nullptr;
	mSymbols = nullptr;
	mMacroDef = nullptr;
	mMacros = nullptr;
}


Assembler::~Assembler()
{
	ASSERT(mLineList.size() == 0);
	ASSERT(mFileList.size() == 0);
	ASSERT(mMacroDef == nullptr);

	//*** clear out macro hash table objects ***

	delete mParser;
	delete mSymbols;
	delete mVars;
}

//------------------------------------------------------------------------------

void Assembler::AssembleBegin()
{
	mErrorMsg.clear();
	mErrorCount = 0;
	mInWritePhase = false;
	mInName.clear();
}


bool Assembler::AssembleParse(const char* inName)
{
	bool result = false;

	mInName = inName;

	if (!mParser)
	{
		mParser = new Parser(this);
		mVars = new StringHash();
		mSymbols = new StringHash();
		mLocalBase.clear();

		mInDummy = false;

		mMacroDef = nullptr;
		mMacros = new StringHash();

		mReadState.file = nullptr;
	}

	if (!IncludeFile(inName))
		goto exit;

	printf("Assembling %s%s\n", mSourceDir.c_str(), mInName.c_str());

	mInWritePhase = false;
	SetOrg(0x8000);		// Merlin default

	while (mReadState.file != nullptr)
	{
		do {
			while (mReadState.curLineIndex < mReadState.endLineIndex)
			{
				LineRecord lineRec;
				lineRec.fileIndex = mReadState.fileIndex;
				lineRec.lineIndex = mReadState.curLineIndex;
				lineRec.statement = nullptr;
				mLineList.push_back(lineRec);

				const char* line = mReadState.file->GetLine(mReadState.curLineIndex++);
				mParser->ParseLine(line);

				if (HasError())
				{
					PrintError(&lineRec);
					if (++mErrorCount >= 64)
						goto exit;

					if (!mReadState.file)
						break;
				}
			}

			mReadState.curLineIndex = mReadState.startLineIndex;

		} while (--mReadState.loopCount > 0);

		mReadState = mReadStateStack.top();
		mReadStateStack.pop();
	}

	if (mErrorCount > 0)
		goto exit;

	if (!mParser->ConditionalsComplete())
	{
		SetError("Incomplete conditional");
		goto exit;
	}

	if (InMacroDef())
	{
		SetError("Incomplete macro definition");
		goto exit;
	}

	if (InDummy())
	{
		SetError("Incomplete DUMMY section definition");
		goto exit;
	}

	result = true;

exit:
	if (HasError())
		PrintError(nullptr);

	return result;
}


bool Assembler::AssembleWrite(
	const char* outName,
	const char* listName,
	const char* symName)
{
	FILE* listFile = nullptr;
	FILE* symFile = nullptr;
	bool result = false;

	if (outName)
	{
		mOutFileName = outName;
	}
	else
	{
		mOutFileName = BuildFullObjectPath(mInName.c_str());

		size_t size = mOutFileName.size();
		if (size > 1)
		{
			if (mOutFileName[size - 2] == '.')
			{
				char c = (char)toupper(mOutFileName[size - 1]);
				if (c == 'S' || c == 'A')
					mOutFileName.resize(size - 2);
				else
					mOutFileName += ".bin";
			}
		}
	}

	if (listName)
	{
		listFile = fopen(listName, "wt+");
		if (!listFile)
		{
			SetError("Unable to open list file \"%s\"", listName);
			goto exit;
		}
	}

	if (symName)
	{
		symFile = fopen(symName, "wt+");
		if (!symFile)
		{
			SetError("Unable to open sym file \"%s\"", symName);
			goto exit;
		}
	}

	ASSERT(!mInWritePhase);
	mInWritePhase = true;
	SetOrg(0x8000);			// Merlin default

	mOutBuffer.Clear();
	for (size_t i = 0; i < mLineList.size(); ++i)
	{
		Statement* statement = mLineList[i].statement;
		INT32 writeOffset = mOutBuffer.GetSize();

		if (statement)
		{
			mPC = statement->GetPC();

			statement->Write(this);

			if (HasError())
			{
				PrintError(&mLineList[i]);
				if (++mErrorCount >= 64)
					break;
			}
		}

		if (listFile)
		{
			SourceFile* file = mFileList[mLineList[i].fileIndex];
			const char* line = file->GetLine(mLineList[i].lineIndex);
			if (statement)
			{
				UINT8* p = mOutBuffer.GetPtr() + writeOffset;
				INT32 count = mOutBuffer.GetSize() - writeOffset;
				if (count == 0)
					fprintf(listFile, "              ");
				else
				{
					fprintf(listFile, "%04X: ", statement->GetPC());

					if (count == 1)
						fprintf(listFile, "%02X      ", *p);
					else if (count == 2)
						fprintf(listFile, "%02X %02X   ", *p, *(p + 1));
					else
						fprintf(listFile, "%02X %02X %02X", *p, *(p + 1), *(p + 2));
				}
			}
			else
				fprintf(listFile, "              ");

			fprintf(listFile, "  %s\n", line);
		}
	}

	if (HasError())
		goto exit;

	if (mOutBuffer.GetSize() != 0 && !mOutFileName.empty())
	{
		if (!FlushToFile(mOutFileName.c_str()))
			goto exit;
	}

	// dump symbols to file for use in debuggers
	if (symFile)
	{
		INT32 count = mSymbols->GetEntryCount();
		HashEntry** entries = new HashEntry*[count];
		mSymbols->GetEntries(entries);

		// dumb bubble-sort of entries
		bool didSwap;
		do
		{
			didSwap = false;
			for (INT32 i = 0; i < count - 1; ++i)
			{
				Symbol* symbol1 = (Symbol*)(entries[i]->object);
				Symbol* symbol2 = (Symbol*)(entries[i + 1]->object);
				if (symbol1->GetValue() > symbol2->GetValue())
				{
					HashEntry* tempEntry = entries[i];
					entries[i] = entries[i + 1];
					entries[i + 1] = tempEntry;
					didSwap = true;
				}
			}
		} while (didSwap);

		// dump entries to file, skipping z-page addresses
		for (INT32 i = 0; i < count; ++i)
		{
			Symbol* symbol = (Symbol*)(entries[i]->object);
			if (symbol->GetValue() >= 0x100)
			{
#if 0
				INT32 len = strlen(entries[i]->string);
				fprintf(symFile, "%s", entries[i]->string);
				for (INT32 j = 0; j < 22 - len; ++j)
					fprintf(symFile, " ");
				fprintf(symFile, "= $%04X\n", symbol->GetValue());
#else
				// skip local symbols
				if (EndsWith(entries[i]->string, "__"))
					continue;

				// print symbols in AppleWin format
				fprintf(symFile, "%04X %s\n", symbol->GetValue(), entries[i]->string);
#endif
			}
		}
	}

	result = true;

exit:
	if (HasError())
		PrintError(nullptr);

	if (listFile)
		fclose(listFile);

	if (symFile)
		fclose(symFile);

	return result;
}


void Assembler::AssembleEnd()
{
	for (size_t i = 0; i < mLineList.size(); ++i)
	{
		if (mLineList[i].statement)
			delete mLineList[i].statement;
	}

	mLineList.clear();

	for (size_t i = 0; i < mFileList.size(); ++i)
		delete mFileList[i];

	mFileList.clear();

	if (mMacroDef)
	{
		delete mMacroDef;
		mMacroDef = nullptr;
	}
}


bool Assembler::Assemble(
	const char* inName,
	const char* outName,
	const char* listName,
	const char* symName)
{
	bool result = false;

	AssembleBegin();

	if (AssembleParse(inName))
	{
		if (AssembleWrite(outName, listName, symName))
			result = true;
	}

	AssembleEnd();
	return result;
}


void Assembler::AddStatement(Statement* statement)
{
	ASSERT(mLineList[mLineList.size() - 1].statement == nullptr);
	mLineList[mLineList.size() - 1].statement = statement;
}

//------------------------------------------------------------------------------

void Assembler::SetOrg(INT32 pc)
{
	if (mInWritePhase)
	{
		if (!InDummy())
		{
			if (mOutBuffer.GetSize() == 0)
				mWriteOrg = pc;
		}
	}
	else
		mPC = pc;
}


bool Assembler::IncludeFile(const char* fileName)
{
	mReadStateStack.push(mReadState);
	mReadState.file = SourceFile::Create(this, fileName);
	if (!mReadState.file)
		return false;
	mReadState.fileIndex = mFileList.size();
	mFileList.push_back(mReadState.file);
	mReadState.startLineIndex = 0;
	mReadState.curLineIndex = 0;
	mReadState.endLineIndex = mReadState.file->GetLineCount();
	mReadState.loopCount = 1;
	mReadState.isMacro = false;
	return true;
}


void Assembler::StartMacroDef(const char* name)
{
	if (InMacroDef())
	{
		SetError("Nested macro definitions not allowed");
		return;
	}

	mMacroDef = new MacroDef();
	mMacroDef->fileIndex = mReadState.fileIndex;
	mMacroDef->startLineIndex = mReadState.curLineIndex;
	mMacroDef->endLineIndex = -1;
	mMacros->Add(name, mMacroDef);
}


void Assembler::EndMacroDef()
{
	if (!InMacroDef())
	{
		SetError("End of macro without start");
		return;
	}

	mMacroDef->endLineIndex = mReadState.curLineIndex - 1;
	mMacroDef = nullptr;
}


bool Assembler::StartMacroExpand(const char* name)
{
	MacroDef* macroDef = (MacroDef*)mMacros->Find(name);
	if (!macroDef)
		return false;

	mReadStateStack.push(mReadState);
	mReadState.file = mFileList[macroDef->fileIndex];
	mReadState.fileIndex = macroDef->fileIndex;
	mReadState.startLineIndex = macroDef->startLineIndex;
	mReadState.curLineIndex = macroDef->startLineIndex;
	mReadState.endLineIndex = macroDef->endLineIndex;
	mReadState.loopCount = 1;
	mReadState.isMacro = true;
	return true;
}


void Assembler::StartDummy(INT32 org)
{
	if (InDummy())
	{
		SetError("Nested DUMMY sections not allowed");
		return;
	}

	mInDummy = true;
	mDummySaveOrg = mPC;
	mPC = org;
}


void Assembler::EndDummy()
{
	if (!InDummy())
	{
		if (!IsDASM())
			SetError("DEND without DUMMY section");
		return;
	}

	mInDummy = false;
	mPC = mDummySaveOrg;
	mDummySaveOrg = -1;
}


void Assembler::StartLoop(INT32 loopCount)
{
	mReadStateStack.push(mReadState);
	// mReadState.file, fileIndex remain the same
	mReadState.startLineIndex = mReadState.curLineIndex;
	// mReadState.curLineIndex, endLineIndex remain the same
	mReadState.loopCount = loopCount;
	mReadState.isMacro = false;
}


void Assembler::EndLoop()
{
	mReadState.endLineIndex = mReadState.curLineIndex - 1;
	mReadStateStack.top().curLineIndex = mReadState.curLineIndex;
}


void Assembler::SetVar(const char* name, const char* value)
{
	Var* var = (Var*)mVars->Find(name);
	if (!var)
	{
		var = new Var(value);
		mVars->Add(name, var);
	}
	var->SetValue(value);
}


bool Assembler::GetVar(const char* name, const char** value)
{
	Var* var = (Var*)mVars->Find(name);
	if (!var)
		return false;

	*value = var->GetValue();
	return true;
}

//------------------------------------------------------------------------------

std::string Assembler::BuildFullSourcePath(const char* fileName)
{
	std::string fullPath = mRootDir;

	if (fileName[0] != '\\' && fileName[0] != '/')
		fullPath += mSourceDir;

	fullPath += fileName;

	NormalizeSlashes(fullPath);
	return fullPath;
}


std::string Assembler::BuildFullObjectPath(const char* fileName)
{
	std::string fullPath = mRootDir;

	if (fileName[0] != '\\' && fileName[0] != '/')
	{
		if (!mObjectDir.empty())
			fullPath += mObjectDir;
		else
			fullPath += mSourceDir;
	}

	fullPath += fileName;

	NormalizeSlashes(fullPath);
	return fullPath;
}


std::string Assembler::CleanDirName(const char* dirName)
{
	std::string cleanName = dirName;

	// must have trailing slash
	size_t size = cleanName.size();
	if (size > 0)
	{
		char c = cleanName[size - 1];
		if (c == '/' || c == '\\')
			return cleanName;
	}

	cleanName += '\\';
	return cleanName;
}


void Assembler::SetRootDir(const char* dirName)
{
	mRootDir = CleanDirName(dirName);
}


void Assembler::SetSourceDir(const char* dirName)
{
	mSourceDir = CleanDirName(dirName);
}


void Assembler::SetObjectDir(const char* dirName)
{
	mObjectDir = CleanDirName(dirName);
}


bool Assembler::FlushToFile(const char* fileName)
{
	FILE* file = fopen(fileName, "wb+");
	if (!file)
	{
		SetError("Output file \"%s\" not found", fileName);
		return false;
	}

	// Add DOS 3.3 BIN header
	if (mWriteAsBin)
	{
		UINT8 header[4];

		header[0] = (UINT8)mWriteOrg;
		header[1] = (UINT8)(mWriteOrg >> 8);

		INT32 length = mOutBuffer.GetSize();
		header[2] = (UINT8)length;
		header[3] = (UINT8)(length >> 8);

		fwrite(header, 1, sizeof(header), file);
	}

	fwrite(mOutBuffer.GetPtr(), 1, mOutBuffer.GetSize(), file);
	fclose(file);
	mOutBuffer.Clear();
	return true;
}


void Assembler::SetDiskFile(const char* fileName)
{
	// if there's already output data,
	//	save it using the previous file name
	if (mOutBuffer.GetSize() != 0 && mOutFileName[0])
		FlushToFile(mOutFileName.c_str());

	mOutFileName = BuildFullObjectPath(fileName);
}


bool Assembler::SaveFile(const char* fileName)
{
	std::string fullPath;
	fullPath = BuildFullObjectPath(fileName);
	return FlushToFile(fullPath.c_str());
}

//------------------------------------------------------------------------------

void Assembler::WriteByte(UINT8 b)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(1);
	*p++ = b;
	mOutBuffer.Consume(1);
}


void Assembler::WriteByteByte(UINT8 b1, UINT8 b2)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(2);
	*p++ = b1;
	*p++ = b2;
	mOutBuffer.Consume(2);
}


void Assembler::WriteByteWord(UINT8 b, UINT16 w)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(3);
	*p++ = b;
	*p++ = w & 255;
	*p++ = w >> 8;
	mOutBuffer.Consume(3);
}


void Assembler::WriteBytes(UINT8* bp, INT32 count)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(count);
	memcpy(p, bp, count);
	p += count;
	mOutBuffer.Consume(count);
}


void Assembler::WritePattern(UINT8 b, INT32 count)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(count);
	memset(p, b, count);
	p += count;
	mOutBuffer.Consume(count);
}

//------------------------------------------------------------------------------

void Assembler::LocalToGlobal(const char* symbol, std::string& global)
{
	global = mLocalBase.c_str();
	global += '_';
	global += symbol;
	global += "__";
}


bool Assembler::AddLabelSymbol(const char* label, bool local)
{
	std::string global;

	if (local)
	{
		LocalToGlobal(label, global);
		label = global.c_str();
	}

	Symbol* symbol = new Symbol(mPC, false);
	// TODO: fix leak of symbol on error
	return mSymbols->Add(label, symbol);
}


bool Assembler::AddEquateSymbol(const char* equate, INT32 value, bool forceLong)
{
	Symbol* symbol = new Symbol(value, forceLong);
	if (!mSymbols->Add(equate, symbol))
	{
		Symbol* dupe = (Symbol*)mSymbols->Find(equate);
		if (dupe->GetValue() != value)
			return false;

		printf("WARNING: Harmless duplicate equate \"%s\"\n", equate);
	}
	return true;
}

//------------------------------------------------------------------------------

void Assembler::SetError(const char* format, ...)
{
	if (mErrorMsg.empty())
	{
		char tempBuffer[1024];
		va_list args;
		va_start(args, format);
		_vsnprintf(tempBuffer, sizeof(tempBuffer), format, args);
		mErrorMsg = tempBuffer;
	}
}


void Assembler::PrintError(LineRecord* lineRec)
{
	if (lineRec)
	{
		printf("\nERROR line %d,  file \"%s\": %s\n",
			lineRec->lineIndex + 1, mFileList[lineRec->fileIndex]->GetName(), GetError());

		printf("%s\n", mFileList[lineRec->fileIndex]->GetLine(lineRec->lineIndex));
	}
	else
		printf("\nERROR: %s\n", GetError());

	ClearError();
}

//------------------------------------------------------------------------------
