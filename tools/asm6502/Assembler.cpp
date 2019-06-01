
#include "precomp.h"
#include "Assembler.h"
#include "SourceFile.h"
#include "Parser.h"
#include "Statement.h"
#include "StringUtils.h"
#include "ClassUtils.h"

//------------------------------------------------------------------------------

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
	: mLineList(8192), mOutBuffer(16384)
{
	mSyntax = SyntaxMerlin;
	mParser = NULL;
	mRootDir[0] = 0;
	mSourceDir[0] = 0;
	mObjectDir[0] = 0;
	mMacroDef = NULL;
	mWriteAsBin = false;
}


Assembler::~Assembler()
{
	ASSERT(mLineList.GetCount() == 0);
	ASSERT(mFileList.GetCount() == 0);
	ASSERT(mMacroDef == NULL);

	//*** clear out macro hash table objects ***
	//*** delete mSymbols ***
	//*** delete mVars ***

	if (mParser)
		delete mParser;
}

//------------------------------------------------------------------------------

bool
Assembler::Assemble(const char* inName,
                    const char* outName,
                    const char* listName,
                    const char* symName)
{
	FILE* listFile = NULL;
	FILE* symFile = NULL;
	bool result = false;

	mError[0] = 0;

	if (outName)
		strcpy(mOutFileName, outName);
	else
	{
		BuildFullObjectPath(mOutFileName, inName);
		INT32 len = strlen(mOutFileName);
		if (len > 1)
		{
			char* sp = mOutFileName + len - 2;
			if (*sp++ == '.')
			{
				char c = toupper(*sp);
				if (c == 'S' || c == 'A')
					*(sp - 1) = 0;
				else
					strcat(mOutFileName, ".bin");
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

	mParser = new Parser(this);
	mVars = new StringHash();
	mSymbols = new StringHash();
	mLocalBase[0] = 0;

	mInDummy = false;

	mMacroDef = NULL;
	mMacros = new StringHash();

	mReadState.file = NULL;
	if (!IncludeFile(inName))
		goto exit;

	printf("Assembling %s%s\n", mSourceDir, inName);

	mInWritePhase = false;
	SetOrg(0x8000);		// Merlin default

	INT32 errorCount = 0;
	while (mReadState.file != NULL)
	{
		do {
			while (mReadState.curLineIndex < mReadState.endLineIndex)
			{
				LineRecord lineRec;
				lineRec.fileIndex = mReadState.fileIndex;
				lineRec.lineIndex = mReadState.curLineIndex;
				lineRec.statement = NULL;
				mLineList.Add(lineRec);

				const char* line = mReadState.file->GetLine(mReadState.curLineIndex++);
				mParser->ParseLine(line);

				if (HasError())
				{
					PrintError(&lineRec);
					if (++errorCount >= 64)
						goto exit;

					if (!mReadState.file)
						break;
				}
			}

			mReadState.curLineIndex = mReadState.startLineIndex;

		} while (--mReadState.loopCount > 0);

		mReadState = mReadStateStack.Pull();
	}

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

	mInWritePhase = true;
	SetOrg(0x8000);			// Merlin default

	mOutBuffer.Clear();
	for (INT32 i = 0; i < mLineList.GetCount(); ++i)
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
				if (++errorCount >= 64)
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

	if (mOutBuffer.GetSize() != 0 && mOutFileName[0])
	{
		if (!FlushToFile(mOutFileName))
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
		PrintError(NULL);

	for (INT32 i = 0; i < mLineList.GetCount(); ++i)
	{
		if (mLineList[i].statement)
			delete mLineList[i].statement;
	}
	mLineList.Clear();

	for (INT32 i = 0; i < mFileList.GetCount(); ++i)
		delete mFileList[i];
	mFileList.Clear();

	if (mMacroDef)
	{
		delete mMacroDef;
		mMacroDef = NULL;
	}

	if (listFile)
		fclose(listFile);
	if (symFile)
		fclose(symFile);
	return result;
}


void
Assembler::AddStatement(Statement* statement)
{
	ASSERT(mLineList[mLineList.GetCount() - 1].statement == NULL);
	mLineList[mLineList.GetCount() - 1].statement = statement;
}

//------------------------------------------------------------------------------

void
Assembler::SetOrg(INT32 pc)
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


bool
Assembler::IncludeFile(const char* fileName)
{
	mReadStateStack.Push(mReadState);
	mReadState.file = SourceFile::Create(this, fileName);
	if (!mReadState.file)
		return false;
	mReadState.fileIndex = mFileList.GetCount();
	mFileList.Add(mReadState.file);
	mReadState.startLineIndex = 0;
	mReadState.curLineIndex = 0;
	mReadState.endLineIndex = mReadState.file->GetLineCount();
	mReadState.loopCount = 1;
	mReadState.isMacro = false;
	return true;
}


void
Assembler::StartMacroDef(const char* name)
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


void
Assembler::EndMacroDef()
{
	if (!InMacroDef())
	{
		SetError("End of macro without start");
		return;
	}

	mMacroDef->endLineIndex = mReadState.curLineIndex - 1;
	mMacroDef = NULL;
}


bool
Assembler::StartMacroExpand(const char* name)
{
	MacroDef* macroDef = (MacroDef*)mMacros->Find(name);
	if (!macroDef)
		return false;

	mReadStateStack.Push(mReadState);
	mReadState.file = mFileList[macroDef->fileIndex];
	mReadState.fileIndex = macroDef->fileIndex;
	mReadState.startLineIndex = macroDef->startLineIndex;
	mReadState.curLineIndex = macroDef->startLineIndex;
	mReadState.endLineIndex = macroDef->endLineIndex;
	mReadState.loopCount = 1;
	mReadState.isMacro = true;
	return true;
}


void
Assembler::StartDummy(INT32 org)
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


void
Assembler::EndDummy()
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


void
Assembler::StartLoop(INT32 loopCount)
{
	mReadStateStack.Push(mReadState);
	// mReadState.file, fileIndex remain the same
	mReadState.startLineIndex = mReadState.curLineIndex;
	// mReadState.curLineIndex, endLineIndex remain the same
	mReadState.loopCount = loopCount;
	mReadState.isMacro = false;
}


void
Assembler::EndLoop()
{
	mReadState.endLineIndex = mReadState.curLineIndex - 1;
	mReadStateStack.Top().curLineIndex = mReadState.curLineIndex;
}


void
Assembler::SetVar(const char* name, const char* value)
{
	Var* var = (Var*)mVars->Find(name);
	if (!var)
	{
		var = new Var(value);
		mVars->Add(name, var);
	}
	var->SetValue(value);
}


bool
Assembler::GetVar(const char* name, const char** value)
{
	Var* var = (Var*)mVars->Find(name);
	if (!var)
		return false;

	*value = var->GetValue();
	return true;
}

//------------------------------------------------------------------------------

void
Assembler::BuildFullSourcePath(char* fullPath, const char* fileName)
{
	strcpy(fullPath, mRootDir);
	if (fileName[0] != '\\' && fileName[0] != '/')
		strcat(fullPath, mSourceDir);

	strcat(fullPath, fileName);

	for (INT32 i = 0; i < sizeof(fullPath); ++i)
	{
		if (fullPath[i] == '/')
			fullPath[i] = '\\';
	}
}


void
Assembler::BuildFullObjectPath(char* fullPath, const char* fileName)
{
	strcpy(fullPath, mRootDir);
	if (fileName[0] != '\\' && fileName[0] != '/')
	{
		if (mObjectDir[0] != 0)
			strcat(fullPath, mObjectDir);
		else
			strcat(fullPath, mSourceDir);
	}

	strcat(fullPath, fileName);

	for (INT32 i = 0; i < sizeof(fullPath); ++i)
	{
		if (fullPath[i] == '/')
			fullPath[i] = '\\';
	}
}


void
Assembler::SetRootDir(const char* dirName)
{
	strcpy(mRootDir, dirName);

	// remove trailing slash
	INT32 length = strlen(dirName);
	if (length > 0)
	{
		char c = mRootDir[length - 1];
		if (c == '/' || c == '\\')
			mRootDir[length - 1] = 0;
	}
}


/*protected*/ void
Assembler::CleanDirName(char* cleanName, const char* dirName)
{
	// must have leading slash
	if (dirName[0] != '/' && dirName[0] != '\\')
	{
		cleanName[0] = '\\';
		cleanName[1] = 0;
		strcat(cleanName, dirName);
	}
	else
		strcpy(cleanName, dirName);

	// and must have trailing slash
	INT32 length = strlen(cleanName);
	if (length)
	{
		char c = cleanName[length - 1];
		if (c == '/' || c == '\\')
			return;
	}
	strcat(cleanName, "\\");
}


void
Assembler::SetSourceDir(const char* dirName)
{
	CleanDirName(mSourceDir, dirName);
}


void
Assembler::SetObjectDir(const char* dirName)
{
	CleanDirName(mObjectDir, dirName);
}


bool
Assembler::FlushToFile(const char* fileName)
{
	FILE* file = fopen(fileName, "wb+");
	if (!file)
	{
		SetError("Output file \"%s\" not found", mOutFileName);
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


void
Assembler::SetDiskFile(const char* fileName)
{
	// if there's already output data,
	//	save it using the previous file name
	if (mOutBuffer.GetSize() != 0 && mOutFileName[0])
		FlushToFile(mOutFileName);

	BuildFullObjectPath(mOutFileName, fileName);
}


bool
Assembler::SaveFile(const char* fileName)
{
	char fullPath[1024];
	BuildFullObjectPath(fullPath, fileName);
	return FlushToFile(fullPath);
}

//------------------------------------------------------------------------------

void
Assembler::WriteByte(UINT8 b)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(1);
	*p++ = b;
	mOutBuffer.Consume(1);
}


void
Assembler::WriteByteByte(UINT8 b1, UINT8 b2)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(2);
	*p++ = b1;
	*p++ = b2;
	mOutBuffer.Consume(2);
}


void
Assembler::WriteByteWord(UINT8 b, UINT16 w)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(3);
	*p++ = b;
	*p++ = w & 255;
	*p++ = w >> 8;
	mOutBuffer.Consume(3);
}


void
Assembler::WriteBytes(UINT8* bp, INT32 count)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(count);
	memcpy(p, bp, count);
	p += count;
	mOutBuffer.Consume(count);
}


void
Assembler::WritePattern(UINT8 b, INT32 count)
{
	if (InDummy())
		return;

	UINT8* p = mOutBuffer.MakeAvailable(count);
	memset(p, b, count);
	p += count;
	mOutBuffer.Consume(count);
}

//------------------------------------------------------------------------------

bool
Assembler::LocalToGlobal(const char* symbol, char* buffer, INT32 bufferSize)
{
//	if (!mLocalBase[0])
//	{
//		buffer[0] = 0;
//		SetError("Local label found before any non-local");
//		return false;
//	}

	_snprintf(buffer, bufferSize, "%s_%s__", mLocalBase, symbol);
	buffer[bufferSize - 1] = 0;
	return true;
}


bool
Assembler::AddLabelSymbol(const char* label, bool local)
{
	char buffer[256];
	if (local)
	{
		LocalToGlobal(label, buffer, sizeof(buffer));
		label = buffer;
	}

	Symbol* symbol = new Symbol(mPC, false);
	return mSymbols->Add(label, symbol);
}


bool
Assembler::AddEquateSymbol(const char* equate, INT32 value, bool forceLong)
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

void
Assembler::SetError(char* format, ...)
{
	if (mError[0] == 0)
	{
		va_list args;
		va_start(args, format);
		_vsnprintf(mError, sizeof(mError), format, args);
		mError[sizeof(mError) - 1] = 0;
	}
}


void
Assembler::PrintError(LineRecord* lineRec)
{
	if (lineRec)
	{
		printf("\nERROR line %d,  file \"%s\": %s\n", lineRec->lineIndex + 1,
											mFileList[lineRec->fileIndex]->GetName(),
											GetError());
		printf("%s\n", mFileList[lineRec->fileIndex]->GetLine(lineRec->lineIndex));
	}
	else
		printf("\nERROR: %s\n", GetError());
	ClearError();
}

//------------------------------------------------------------------------------
