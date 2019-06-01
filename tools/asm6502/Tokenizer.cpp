
#include "precomp.h"
#include "StringUtils.h"
#include "Tokenizer.h"
#include "Tokens.h"
#include "Assembler.h"	// just for Syntax enum

//------------------------------------------------------------------------------

#define OPCODE(_op)	#_op,
#define OP(_mode, _hex)
#define OPEND()
static const char* sOpcodeList[] = {
#include "Opcodes.h"
};

const INT32 kOpcodeCount = sizeof(sOpcodeList) / sizeof(sOpcodeList[0]);

//------------------------------------------------------------------------------

#define MERLIN	1
#define	DASM	2
#define IIGS	4

struct KeywordEntry
{
	const char* keyword;
	UINT32 flags;
};

#define KEYWORD(_word, _flags)	{ #_word, _flags },
static const KeywordEntry sKeywordList[] = {
#include "Keywords.h"
};

const INT32 kKeywordCount = sizeof(sKeywordList) / sizeof(sKeywordList[0]);

//------------------------------------------------------------------------------

Tokenizer::Tokenizer(UINT32 syntax)
{
	INT32 i;

	mStringBuffer[0] = 0;
	mTokenString[0] = 0;

	mTokenHash = new StringHash();

	// add single character symbol tokens (must exclude '_')
	const char* cp = "!@#$%^&*()-=+[{]}\\|;:\'\",<.>/?";
	char str[2] = {0, 0};
	while ((str[0] = *cp++) != 0)
		mTokenHash->Add(str, (void*)str[0]);

	// add single letter tokens
	mTokenHash->AddNoCase("A", (void*)'A');
	mTokenHash->AddNoCase("X", (void*)'X');
	mTokenHash->AddNoCase("Y", (void*)'Y');
	if (syntax == SyntaxDASM || syntax == SyntaxIIGS)
	{
		mTokenHash->AddNoCase("B", (void*)'B');
		mTokenHash->AddNoCase("W", (void*)'W');
	}
	if (syntax == SyntaxDASM)
		mTokenHash->AddNoCase("U", (void*)'U');

	// add opcode tokens
	for (i = 0; i < kOpcodeCount; ++i)
		mTokenHash->AddNoCase(sOpcodeList[i], (void*)(kFirstOpcodeToken + i));

	// add keyword tokens
	for (i = 0; i < kKeywordCount; ++i)
	{
		if (sKeywordList[i].flags & syntax)
		{
			mTokenHash->AddNoCase(sKeywordList[i].keyword,
									(void*)(kFirstKeywordToken + i));
		}
	}
}


Tokenizer::~Tokenizer()
{
	if (mTokenHash)
		delete mTokenHash;
}


void
Tokenizer::SetString(const char* string)
{
	strncpy(mStringBuffer, string, sizeof(mStringBuffer));
	mStringBuffer[sizeof(mStringBuffer) - 1] = 0;
	mTokenString[0] = 0;
	mPosition = 0;
}


void
Tokenizer::SkipWhiteSpace()
{
	char c;
	INT32 i;

	i = mPosition;
	while ((c = mStringBuffer[i]) != 0)
	{
		if (c != ' ' && c != '\t')
			break;
		++i;
	}
	mPosition = i;
}


Token
Tokenizer::NextToken(bool hexHint)
{
	char c;
	INT32 i;

	SkipWhiteSpace();

	INT32 length = 0;
	i = mPosition;
	while ((c = mStringBuffer[i]) != 0)
	{
		if (isdigit(c) || isalpha(c) || c == '_')
		{
			mTokenString[length++] = c;
			++i;
			continue;
		}

		if (c == ' ' || c == '\t')
			break;

		if (length == 0)
		{
			if (c == ';')
			{
				i = strlen(mStringBuffer);
				break;
			}

			mTokenString[length++] = c;
			++i;
		}

		break;
	}

	mTokenString[length] = 0;

	if (length == 0)
		return TokenNULL;

	mPosition = i;

	if (!hexHint)
	{
		Token t = (Token)(INT32)mTokenHash->Find(mTokenString);
		if (t != 0)
			return t;
	}

	bool sawDigit = false;
	bool sawHex = false;
	char* cp = mTokenString;
	while ((c = *cp++) != 0)
	{
		if (c == '_' || (c >='G' && c <= 'Z') || (c >='g' && c <= 'z'))
			return TokenSymbol;

		if (isdigit(c))
			sawDigit = true;
		else if ((c >='A' && c <= 'F') || (c >='a' && c <= 'f'))
			sawHex = true;
	}

	// String consists entirely of the letters A to F,
	//	so it could be a hex number or a symbol.  Use
	//	hint to pick one.
	if (hexHint)
	{
		if (!sawDigit && !sawHex)
		{
			Token t = (Token)(INT32)mTokenHash->Find(mTokenString);
			if (t != 0)
				return t;
			else
				return TokenSymbol;
		}
		return TokenHexNumber;
	}

	if (sawDigit && !sawHex)
		return TokenDecNumber;

	return TokenSymbol;
}


bool
Tokenizer::NextFileName()
{
	char c;
	INT32 i;
	bool quoted;

	SkipWhiteSpace();

	INT32 length = 0;
	i = mPosition;

	if (mStringBuffer[i] == '\"')
	{
		quoted = (mStringBuffer[i] == '\"');
		++i;
	}
	else
		quoted = false;

	while ((c = mStringBuffer[i]) != 0)
	{
		if (isdigit(c) || isalpha(c) || c == '_' || c == '.' || c == '/')
		{
			mTokenString[length++] = c;
			++i;
			continue;
		}
		if (quoted && c == '\"')
			++i;
		break;
	}

	mTokenString[length] = 0;

	if (length == 0)
		return false;

	mPosition = i;
	return true;
}


bool
Tokenizer::NextGroup(bool skipWhite, char terminator, bool mustFindTerm)
{
	char c;
	INT32 i;

	if (skipWhite)
		SkipWhiteSpace();

	INT32 length = 0;
	i = mPosition;
	while (true)
	{
		c = mStringBuffer[i];
		if (c == 0)
		{
			if (mustFindTerm || length == 0)
				return false;
			else
				break;
		}
		++i;
		if (c == terminator)
			break;
		mTokenString[length++] = c;
	}

	mTokenString[length] = 0;

	mPosition = i;
	return true;
}

//------------------------------------------------------------------------------
