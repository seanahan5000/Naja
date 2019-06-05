
#pragma once

#include "Tokens.h"

class StringHash;

//------------------------------------------------------------------------------

class Tokenizer
{
public:
	Tokenizer(UINT32 syntax);
	~Tokenizer();

	void SetString(const char* string);
	Token NextToken(bool hexHint = false);
	bool NextFileName();
	bool NextGroup(bool skipWhite, char terminator, bool mustFindTerm);
	bool NextMacroArg() { return NextGroup(true, ';', false); }
	bool NextParenGroup() { return NextGroup(false, ')', true); }

	char* GetTokenString() { return mTokenString; }

	INT32 GetPosition() { return mPosition; }
	void SetPosition(INT32 position) { mPosition = position; }

protected:
	void SkipWhiteSpace();

	StringHash* mTokenHash;
	char mStringBuffer[1024];
	char mTokenString[256];
	INT32 mPosition;
};

//------------------------------------------------------------------------------
