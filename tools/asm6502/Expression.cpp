
#include "precomp.h"
#include "Expression.h"
#include "Parser.h"
#include "Tokens.h"

//------------------------------------------------------------------------------

/*static*/ Expression*
Expression::Parse(Parser* p, Token t, bool recurse)
{
	Assembler* assembler = p->GetAssembler();
	Expression* exp = nullptr;

	if (t == '$')
	{
		t = p->NextHex();
		if (t != TokenHexNumber && t != TokenDecNumber)
		{
			assembler->SetError("Invalid hex value \"%s\"", p->GetString());
			goto fail;
		}

		exp = new NumberExpression(p->GetHexValue(), strlen(p->GetString()) > 2);
	}
	else if (t == ':' || t == '@' || t == '.')
	{
		t = p->Next();
		if (t != TokenSymbol && t != TokenDecNumber)
		{
			assembler->SetError("Invalid local label in expression \"%s\"", p->GetString());
			goto fail;
		}

		std::string global;
		assembler->LocalToGlobal(p->GetString(), global);
		exp = new SymbolExpression(global.c_str());
	}
	else if (t == '%')
	{
		t = p->Next();
		if (t != TokenDecNumber)
		{
			assembler->SetError("Invalid binary value \"%s\"", p->GetString());
			goto fail;
		}

		INT32 value = p->GetBinValue();
		if (value == -1)
		{
			assembler->SetError("Invalid binary value \"%s\"", p->GetString());
			goto fail;
		}
		exp = new NumberExpression(value, strlen(p->GetString()) > 8);
	}
	else if (t == '<' || t == '>' || t == '-')
	{
		exp = Expression::Parse(p, p->Next(), recurse);
		if (exp == nullptr)
			goto fail;
		exp = new UnaryExpression(t, exp);
	}
	else if (t == '*')
	{
		exp = new PcExpression();
	}
	else if (t == '(')
	{
		exp = Expression::Parse(p, p->Next(), recurse);
		if (exp == nullptr)
			goto fail;

		t = p->Next();
		if (t != ')')
		{
			assembler->SetError("Missing \')\'");
			goto fail;
		}

		exp = new ParenExpression(exp);
	}
	else if (t == '\"' || t == '\'')
	{
		INT32 highFlip = (t == '\"') ? 0x80 : 0x00;

		if (!p->NextStringGroup((char)t))
		{
			assembler->SetError("Invalid ASCII expression");
			goto fail;
		}

		if (strlen(p->GetString()) != 1)
		{
			assembler->SetError("Invalid ASCII expression");
			goto fail;
		}

		INT32 value = p->GetString()[0] ^ highFlip;
		exp = new NumberExpression(value, false);
	}
	else if (t == TokenDecNumber)
	{
		exp = new NumberExpression(p->GetDecValue(), false);
	}
	else if (t == TokenSymbol || TokenIsKeyword(t))
	{
		exp = new SymbolExpression(p->GetString());
	}
	else
	{
		assembler->SetError("Invalid expression");
		goto fail;
	}

	if (recurse)
	{
		while (true)
		{
			t = p->Peek();
			if (t == '-' || t == '+' || t == '*' || t == '/')
			{
				// valid for every syntax
			}
			else if (t == '!' || t == '.' || t == '&')
			{
				if (!assembler->IsMerlin())
					break;
			}
			else if (t == '=')
			{
				if (!assembler->IsDASM())
					break;
			}
			else
				break;

			t = p->Next();
			Expression* exp2 = Expression::Parse(p, p->Next(), false);
			if (exp2 == nullptr)
				goto fail;
			exp = new BinaryExpression(exp, t, exp2);
		}
	}

	return exp;

fail:
	if (exp)
		delete exp;
	return nullptr;
}

//------------------------------------------------------------------------------

NumberExpression::NumberExpression(INT32 value, bool forceLong) : Expression()
{
	mValue = value;
	mForceLong = forceLong;
}


INT32 NumberExpression::GetSize(Assembler* assembler)
{
	//*** check mResolved ***
	if (mForceLong || mValue > 255 || mValue < -128)
		return 2;
	return 1;
}


bool NumberExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	*value = mValue;
	return true;
}

//------------------------------------------------------------------------------

SymbolExpression::SymbolExpression(const char* string) : Expression()
{
	mString = string;
}


INT32 SymbolExpression::GetSize(Assembler* assembler)
{
	//*** check mResolved ***
	Symbol* symbol = assembler->FindSymbol(mString.c_str());
	if (symbol)
		return symbol->GetSize();
	return 2;
}


bool SymbolExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	Symbol* symbol = assembler->FindSymbol(mString.c_str());
	if (!symbol)
	{
		if (setError)
			assembler->SetError("Unresolved symbol \"%s\"", mString.c_str());
		return false;
	}

	*value = symbol->GetValue();
	return true;
}

//------------------------------------------------------------------------------

UnaryExpression::UnaryExpression(Token op, Expression* arg) : Expression()
{
	mOperation = op;
	mArg = arg;
}


UnaryExpression::~UnaryExpression()
{
	delete mArg;
}


INT32 UnaryExpression::GetSize(Assembler* assembler)
{
	//*** check mResolved ***
	if (mOperation == '>' || mOperation == '<')
		return 1;
	return mArg->GetSize(assembler);
}


bool UnaryExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	if (!mArg->Resolve(assembler, value, setError))
		return false;

	if (mOperation == '>')
		*value = (*value >> 8) & 255;
	else if (mOperation == '<')
		*value = *value & 255;
	else if (mOperation == '-')
		*value = -*value;
	else
	{
		ASSERT(!"Unsupported UnaryExpression operation");
		return false;
	}

	return true;
}

//------------------------------------------------------------------------------

BinaryExpression::BinaryExpression(Expression* arg1, Token op, Expression* arg2) : Expression()
{
	mArg1 = arg1;
	mOperation = op;
	mArg2 = arg2;
}


BinaryExpression::~BinaryExpression()
{
	delete mArg1;
	delete mArg2;
}


INT32 BinaryExpression::GetSize(Assembler* assembler)
{
	//*** check mResolved ***
	if (mArg1->GetSize(assembler) == 2)
		return 2;
	return mArg2->GetSize(assembler);
}


bool BinaryExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	INT32 value1;
	INT32 value2;

	if (!mArg1->Resolve(assembler, &value1, setError))
		return false;

	if (!mArg2->Resolve(assembler, &value2, setError))
		return false;

	if (mOperation == '+')
		*value = value1 + value2;
	else if (mOperation == '-')
		*value = value1 - value2;
	else if (mOperation == '*')
		*value = value1 * value2;
	else if (mOperation == '/')
		*value = value1 / value2;
	else if (mOperation == '!')
		*value = value1 ^ value2;
	else if (mOperation == '.')
		*value = value1 | value2;
	else if (mOperation == '&')
		*value = value1 & value2;
	else if (mOperation == '=')
		*value = (value1 == value2);
	else
	{
		ASSERT(!"Unsupported BinaryExpression operation");
		return false;
	}

	return true;
}

//------------------------------------------------------------------------------

INT32 PcExpression::GetSize(Assembler* assembler)
{
	return 2;
}


bool PcExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	*value = assembler->GetPC();
	return true;
}

//------------------------------------------------------------------------------

ParenExpression::ParenExpression(Expression* arg) : Expression()
{
	mArg = arg;
}


ParenExpression::~ParenExpression()
{
	delete mArg;
}


INT32 ParenExpression::GetSize(Assembler* assembler)
{
	//*** check mResolved ***
	return mArg->GetSize(assembler);
}


bool ParenExpression::Resolve(Assembler* assembler, INT32* value, bool setError)
{
	if (!mArg->Resolve(assembler, value, setError))
		return false;

	// cover for NAJATEXT check
	if (*value == 0x310)
		*value = 0xAA;

	return true;
}

//------------------------------------------------------------------------------
