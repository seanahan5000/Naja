
#pragma once

#include "Tokenizer.h"
#include "Assembler.h"

class Expression;
class Statement;

//------------------------------------------------------------------------------

struct ConditionalState
{
	bool IsEnabled() { return enableCount > 0; }
	INT32 enableCount;
	bool satisfied;
};

class Parser
{
public:
	Parser(Assembler* assembler);
	~Parser();

	Assembler* GetAssembler() { return mAssembler; }

	Token Peek();
	__forceinline Token Next() { return mTokenizer->NextToken(false); }
	__forceinline Token NextHex() { return mTokenizer->NextToken(true); }
	__forceinline bool NextFileName() { return mTokenizer->NextFileName(); }
	__forceinline bool NextStringGroup(char terminator)
	{
		return mTokenizer->NextGroup(false, terminator, true);
	}
	__forceinline bool NextParenGroup() { return mTokenizer->NextParenGroup(); }
	__forceinline char* GetString() { return mTokenizer->GetTokenString(); }
	INT32 GetHexValue();
	INT32 GetDecValue();
	INT32 GetBinValue();

	void ParseLine(const char* string);

	Expression* ParseExpression(Token t);
	Expression* ParseExpression()
	{
		return ParseExpression(Next());
	}

	bool ParseAndResolveExpression(Token t, INT32* value);
	bool ParseAndResolveExpression(INT32* value)
	{
		return ParseAndResolveExpression(Next(), value);
	}

	bool ExpandVars(const char* inString, char* outString, INT32 outSize);

	bool ConditionalsComplete() { return mConditionalStack.empty(); }

	void SetTokenError(char expected)
	{
		if (expected == 0)
		{
			mAssembler->SetError("Unexpected token \"%s\"", mTokenizer->GetTokenString());
		}
		else
		{
			mAssembler->SetError("Expected token \"%c\", got \"%s\"",
								expected, mTokenizer->GetTokenString());
		}
	}

	void SetTokenError(char expected1, char expected2)
	{
		mAssembler->SetError("Expected \"%c\" or \"%c\", got \"%s\"",
								expected1, expected2, mTokenizer->GetTokenString());
	}

	bool PushConditional();
	bool PullConditional();
	void SetConditionalSatisfied(bool sat) { mConditional.satisfied = sat; }
	void EnableConditional() { ++mConditional.enableCount; }
	void DisableConditional() { --mConditional.enableCount; }
	bool ConditionalSatisfied() { return mConditional.satisfied; }

protected:
	bool ParseLabel(bool firstColumn, char* label, INT32 labelMax, bool* isLocal);

	Assembler* mAssembler;
	Tokenizer* mTokenizer;

	ConditionalState mConditional;
	std::stack<ConditionalState> mConditionalStack;
};

//------------------------------------------------------------------------------
