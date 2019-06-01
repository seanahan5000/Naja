
#include "precomp.h"
#include "Parser.h"
#include "Tokenizer.h"
#include "Tokens.h"
#include "Statement.h"
#include "Expression.h"

//------------------------------------------------------------------------------

Parser::Parser(Assembler* assembler)
{
	mAssembler = assembler;
	mTokenizer = new Tokenizer(assembler->GetSyntax());
	mConditional.enableCount = 1;
	mConditional.satisfied = true;
	mConditionalIndex = 0;
}


Parser::~Parser()
{
	if (mTokenizer)
		delete mTokenizer;
}


Token
Parser::Peek()
{
	INT32 mark = mTokenizer->GetPosition();
	Token t = Next();
	mTokenizer->SetPosition(mark);
	return t;
}


void
Parser::ParseLine(const char* string)
{
	Token t;
	Statement* statement = NULL;
	char labelBuffer[kMaxLabelSize + 1];
	const char* label = NULL;

	labelBuffer[0] = 0;

	// check for empty, comment, or disabled line
	if (*string == 0 || *string == '*' || *string == ';')
		goto exit;

	char expandBuffer[1024];
	if (mAssembler->InMacroExpand())
	{
		if (!ExpandVars(string, expandBuffer, sizeof(expandBuffer)))
			goto error;
		string = expandBuffer;
	}

	mTokenizer->SetString(string);

	bool labelIsLocal = false;
	bool doAddLabelSymbol = true;
	bool hasLabel = *string != ' ' && *string != '\t';

	if (!mConditional.IsEnabled())
	{
		t = Next();
		if (t == TokenIF || t == TokenDO || t == TokenELIF ||
			t == TokenELSE || t == TokenENDIF || t == TokenFIN)
		{
			if (!hasLabel)
			{
				statement = new ConditionalStatement(t);
				goto exit;
			}
			mAssembler->SetError("Label not allowed on conditional");
			goto error;
		}
		goto exit;
	}

	if (!ParseLabel(hasLabel, labelBuffer, sizeof(labelBuffer), &labelIsLocal))
	{
		if (hasLabel || labelIsLocal)
		{
			mAssembler->SetError("Invalid label");
			goto error;
		}
	}
	label = labelBuffer[0] ? labelBuffer : NULL;

	t = Next();

	if (mAssembler->InMacroDef())
	{
		if (t == TokenEOM || t == TokenENDM)
			mAssembler->EndMacroDef();
		goto exit;
	}

	if (t == 0)
	{
		// do nothing
	}
	else if (TokenIsOpcode(t))
	{
		statement = new OpStatement(t);
	}
	else if (t == TokenDB || t == TokenDFB || t == TokenDDB ||
			 t == TokenDW || t == TokenDA || t == TokenDC)
	{
		statement = new DataStatement(t);
	}
	else if (t == TokenDS)
	{
		statement = new StorageStatement();
	}
	else if (t == TokenALIGN)
	{
		statement = new AlignStatement();
	}
	else if (t == TokenHEX)
	{
		statement = new HexStatement();
	}
	else if (t == TokenASC || t == TokenSTR)
	{
		statement = new AscStatement(t == TokenSTR);
	}
	else if (t == TokenUSR)
	{
		statement = new UsrStatement();
	}
	else if (t == '.')
	{
		t = Next();
		if (t == TokenBYTE)
			statement = new DataStatement(TokenDB);
		else if (t == TokenWORD)
			statement = new DataStatement(TokenDW);
		else
		{
			mAssembler->SetError("Invalid token after \'.\'");
			goto error;
		}
	}
	else if (t == TokenSUBROUTINE)
	{
		// do nothing
	}
	else
	{
		doAddLabelSymbol = false;

		if (t == TokenEQU || t == '=')
		{
			statement = new EquStatement();

			if (labelIsLocal)
			{
				mAssembler->SetError("Local label not allowed");
				goto error;
			}
		}
		else if (t == TokenORG)
		{
			statement = new OrgStatement();
		}
		else if (t == TokenIF || t == TokenDO || t == TokenELIF ||
				 t == TokenELSE || t == TokenENDIF || t == TokenFIN)
		{
			statement = new ConditionalStatement(t);
		}
		else if (t == TokenPUT || t == TokenUSE || t == TokenINCLUDE)
		{
			doAddLabelSymbol = true;
			statement = new IncludeStatement();
		}
		else if (t == TokenSAV)
		{
			statement = new SavStatement();
		}
		else if (t == TokenDSK)
		{
			statement = new DskStatement();
		}
		else if (t == TokenLST || t == TokenLSTDO ||
				 t == TokenTR || t == TokenEXP)
		{
			t = Next();
			if (t != TokenON && t != TokenOFF)
			{
				mAssembler->SetError("Invalid option \"%s\"", GetString());
				goto error;
			}
		}
		else if (t == TokenPAGE)
		{
			// do nothing
		}
		else if (t == TokenMAC)
		{
			if (mAssembler->IsDASM())
			{
				if (label)
				{
					mAssembler->SetError("Label not allowed");
					goto error;
				}

				t = Next();
				if (t == 0)
				{
					mAssembler->SetError("Missing macro label");
					goto error;
				}

				mAssembler->StartMacroDef(GetString());
			}
			else
				mAssembler->StartMacroDef(label);
		}
		else if (t == TokenEOM || t == TokenENDM)
		{
			mAssembler->SetError("Unexpected end of macro");
		}
		else if (t == TokenSEG)
		{
			bool dummySegment = false;

			t = Next();
			if (t == '.')
			{
				t = Next();
				if (t != 'U')
				{
					mAssembler->SetError("Missing segment type");
					goto error;
				}

				dummySegment = true;
				t = Next();
			}

			if (t == 0)
			{
				mAssembler->SetError("Missing segment name");
				goto error;
			}

			statement = new DummyStatement(dummySegment, 0);
		}
		else if (t == TokenDUM || t == TokenDUMMY)
		{
			INT32 value;

			if (!ParseAndResolveExpression(&value))
				goto error;

			statement = new DummyStatement(true, value);
		}
		else if (t == TokenDEND)
		{
			statement = new DummyStatement(false, 0);
		}
		else if (t == TokenLUP || t == TokenREPEAT)
		{
			if (label)
			{
				//*** DASM allows label, Merlin does not ***
				mAssembler->SetError("Label not allowed");
				goto error;
			}

			INT32 loopCount;
			if (!ParseAndResolveExpression(&loopCount))
				goto error;

			if (loopCount <= 0)
			{
				mAssembler->SetError("Invalid loop count");
				goto error;
			}

			mAssembler->StartLoop(loopCount);
		}
		else if (t == TokenREPEND || t == '-')
		{
			if (t == '-' && (Next() != '-' || Next() != '^'))
			{
				mAssembler->SetError("Invalid loop end");
				goto error;
			}

			if (label)
			{
				//*** DASM allows label, Merlin does not ***
				mAssembler->SetError("Label not allowed");
				goto error;
			}
			mAssembler->EndLoop();
		}
		else if (t == TokenERR)
		{
			statement = new ErrorStatement();
		}
		else if (t == TokenPROCESSOR || t == TokenMACHINE)
		{
			t = Next();
		}
		else if (mAssembler->StartMacroExpand(GetString()))
		{
			doAddLabelSymbol = true;

			char name[2] = { '1', 0 };
			while (true)
			{
				if (!mTokenizer->NextMacroArg())
					break;

				mAssembler->SetVar(name, GetString());
				++name[0];
			}
		}
		else
		{
			mAssembler->SetError("Unknown keyword \"%s\"", GetString());
			goto error;
		}
	}

	if (label && doAddLabelSymbol)
	{
		if (labelIsLocal)
		{
			if (!mAssembler->AddLabelSymbol(label, true))
			{
				mAssembler->SetError("Duplicate local label \"%s\"", label);
				goto error;
			}
		}
		else
		{
			mAssembler->SetLocalBase(label);
			if (!mAssembler->AddLabelSymbol(label, false))
			{
				mAssembler->SetError("Duplicate label \"%s\"", label);
				goto error;
			}
		}
	}

exit:
	if (statement)
	{
		statement->SetPC(mAssembler->GetPC());
		statement->Parse(this, label);

		t = Next();
		if (t != 0)
			this->SetTokenError(0);
		mAssembler->AddStatement(statement);
	}

error:;
}


bool
Parser::ExpandVars(const char* inString, char* outString, INT32 outSize)
{
	const char* sp = inString;
	char* dp = outString;
	char* ep = dp + outSize - 1;
	char c;

	while (true)
	{
		while (true)
		{
			c = *sp++;
			if (c == ']')
				break;

			*dp++ = c;
			if (dp == ep)
			{
				*dp++ = 0;
				mAssembler->SetError("Macro expansion overflow");
				return false;
			}

			if (c == 0)
				return true;
		}

		const char* start = sp;

		// special-case macro parameter variables
		c = *sp;
		if (c >= '1' && c <= '8')
		{
			++sp;
		}
		else
		{
			while (true)
			{
				if (!isalpha(c) && !isdigit(c) && c != '_')
					break;

				c = *++sp;
			}
		}

		char name[256];
		INT32 len = sp - start;
		if (len >= sizeof(name))
		{
			mAssembler->SetError("Variable name too large");
			return false;
		}

		memcpy(name, start, len);
		name[len] = 0;

		const char* varValue;
		if (!mAssembler->GetVar(name, &varValue))
		{
			mAssembler->SetError("Unknown variable");
			return false;
		}

		while (true)
		{
			if (dp == ep)
			{
				*dp++ = 0;
				mAssembler->SetError("Macro expansion overflow");
				return false;
			}

			c = *varValue++;
			if (c == 0)
				break;
			*dp++ = c;
		}
	}
}


//LABEL
//@LABEL
//:LABEL
//	@LABEL:
//	:LABEL:
bool
Parser::ParseLabel(bool firstColumn, char* label, INT32 labelMax, bool* isLocal)
{
	*label = 0;
	*isLocal = false;

	INT32 startMark = mTokenizer->GetPosition();

	Token t = Next();
	if (!t)
		return false;

	if (t == ':' || t == '@' || (firstColumn && t == '.'))
	{
		*isLocal = true;
		t = Next();
	}

	if (t != TokenSymbol)
	{
		// labels that match keywords cannot be indented
		if (!firstColumn || !TokenIsKeyword(t))
		{
			// only local labels can be just numbers
			if (t != TokenDecNumber || !*isLocal)
				goto fail;
		}
	}

	strncpy(label, mTokenizer->GetTokenString(), labelMax - 1);
	label[labelMax - 1] = 0;

	INT32 colonMark = mTokenizer->GetPosition();
	t = Next();
	if (t != ':')
	{
		if (!firstColumn)
			goto fail;
		mTokenizer->SetPosition(colonMark);
	}

	return true;

fail:
	mTokenizer->SetPosition(startMark);
	label[0] = 0;
	return false;
}


Expression*
Parser::ParseExpression(Token t)
{
	return Expression::Parse(this, t, true);
}


bool
Parser::ParseAndResolveExpression(Token t, INT32* value)
{
	Expression* exp = ParseExpression(t);
	if (!exp)
		return false;

	bool result = exp->Resolve(mAssembler, value);
	delete exp;
	return result;
}

//------------------------------------------------------------------------------

INT32
Parser::GetHexValue()
{
	INT32 v = 0;
	char c;
	char* cp = mTokenizer->GetTokenString();
	while ((c = *cp++) != 0)
	{
		v *= 16;
		if (c >= '0' && c <= '9')
			v += c - '0';
		else if (c >= 'A' && c <= 'F')
			v += c - 'A' + 10;
		else if (c >= 'a' && c <= 'f')
			v += c - 'a' + 10;
		else
		{
			// should never happen
			ASSERT(!"Invalid Hex value");
			return -1;
		}
	}
	return v;
}


INT32
Parser::GetDecValue()
{
	INT32 v = 0;
	char c;
	char* cp = mTokenizer->GetTokenString();
	while ((c = *cp++) != 0)
		v = v * 10 + c - '0';
	return v;
}


INT32
Parser::GetBinValue()
{
	INT32 v = 0;
	char c;
	char* cp = mTokenizer->GetTokenString();
	while ((c = *cp++) != 0)
	{
		v <<= 1;
		if (c >= '0' && c <= '1')
			v += c - '0';
		else
			return -1;	// may happen, so no assert
	}
	return v;
}

//------------------------------------------------------------------------------

bool
Parser::PushConditional()
{
	if (mConditionalIndex == kConditionalMax)
		return false;

	mConditionalStack[mConditionalIndex++] = mConditional;
	--mConditional.enableCount;
	mConditional.satisfied = false;
	return true;
}


bool
Parser::PullConditional()
{
	if (mConditionalIndex == 0)
		return false;

	mConditional = mConditionalStack[--mConditionalIndex];
	return true;
}

//------------------------------------------------------------------------------
