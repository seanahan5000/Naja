
#include "precomp.h"
#include "Statement.h"
#include "Expression.h"
#include "Parser.h"
#include "Tokens.h"

//------------------------------------------------------------------------------

Statement::Statement()
{
	mPC = -1;
	mExpression = NULL;
}


Statement::~Statement()
{
	if (mExpression)
		delete mExpression;
}

//------------------------------------------------------------------------------

struct OpcodeDef
{
	INT8 mode;
	UINT8 hex;
};

#define OPCODE(_op)		OpcodeDef OpDef_##_op[] = {
#define OP(_mode, _hex)	{ OpTarget_##_mode, _hex },
#define OPEND()			{-1, 0}};

#include "Opcodes.h"

#define OPCODE(_op)		OpDef_##_op,
#define OP(_mode, _hex)
#define OPEND()

static OpcodeDef* sOpcodeDefs[] = {
#include "Opcodes.h"
};

static INT32 sOpSizeTable[] = {
	1,	// OpTarget_NONE
	1,	// OpTarget_A
	2,	// OpTarget_IMM
	2,	// OpTarget_ZP
	2,	// OpTarget_ZPX
	2,	// OpTarget_ZPY
	3,	// OpTarget_ABS
	3,	// OpTarget_ABSX
	3,	// OpTarget_ABSY
	3,	// OpTarget_IND
	2,	// OpTarget_INDX
	2,	// OpTarget_INDY
	2,	// OpTarget_BRAN
};

// <none>
// 'A'
// '#' EXPRESSION
// '(' EXPRESSION ')' ',' 'Y'
// '(' EXPRESSION ',' 'X' ')'
// EXPRESSION
// EXPRESSION ',' 'X'
// EXPRESSION ',' 'Y'

void
OpStatement::Parse(Parser* p, const char* label)
{
	Token t;

	t = p->Next();

	if (t == 0)
		mTarget = OpTarget_NONE;
	else if (t == 'A')
		mTarget = OpTarget_A;
	else if (t == '#')
	{
		mExpression = p->ParseExpression();
		if (mExpression == NULL)
			return;
		mTarget = OpTarget_IMM;
	}
	else if (t == '(')
	{
		mExpression = p->ParseExpression();
		if (mExpression == NULL)
			return;

		t = p->Next();
		if (t == ')')
		{
			t = p->Next();
			if (t == 0)
			{
				mTarget = OpTarget_IND;
			}
			else if (t == ',')
			{
				t = p->Next();
				if (t != 'Y')
				{
					p->SetTokenError('Y');
					return;
				}
				mTarget = OpTarget_INDY;
			}
			else
			{
				p->SetTokenError(',');
				return;
			}
		}
		else if (t == ',')
		{
			t = p->Next();
			if (t != 'X')
			{
				p->SetTokenError('X');
				return;
			}
			t = p->Next();
			if (t != ')')
			{
				p->SetTokenError(')');
				return;
			}
			mTarget = OpTarget_INDX;
		}
		else
		{
			p->SetTokenError('(', ',');
			return;
		}
	}
	else
	{
		mExpression = p->ParseExpression(t);
		if (mExpression == NULL)
			return;

		t = p->Next();
		if (t == 0)
			mTarget = OpTarget_ZP;
		else if (t == ',')
		{
			t = p->Next();
			if (t == 'X')
				mTarget = OpTarget_ZPX;
			else if (t == 'Y')
				mTarget = OpTarget_ZPY;
			else
			{
				p->SetTokenError('X', 'Y');
				return;
			}

			t = p->Next();
			if (t != 0)
			{
				p->SetTokenError(0);
				return;
			}
		}
		else
		{
			p->SetTokenError(0);
			return;
		}
	}

	ChooseAddressMode(p->GetAssembler());
}


void
OpStatement::ChooseAddressMode(Assembler* assembler)
{
	OpcodeDef* opdef;

	while (true)
	{
		opdef = sOpcodeDefs[mOpcode - kFirstOpcodeToken];

		while (opdef->mode != -1)
		{
			if (opdef->mode == mTarget)
				break;
			++opdef;
		}

		if (mTarget == OpTarget_ZP ||
			mTarget == OpTarget_ZPX ||
			mTarget == OpTarget_ZPY)
		{
			if (opdef->mode == -1 || mExpression->GetSize(assembler) == 2)
			{
				mTarget = (OpTarget)(mTarget + OpTarget_ABS - OpTarget_ZP);
				continue;
			}
		}

		if (opdef->mode != -1)
			break;

		if (mTarget == OpTarget_ABS)
		{
			mTarget = OpTarget_BRAN;
			continue;
		}

		break;
	}

	if (opdef->mode == -1)
	{
		assembler->SetError("Invalid address mode for opcode");
		return;
	}

	mOpcode = opdef->hex;
	assembler->AdvancePC(sOpSizeTable[opdef->mode]);
}


void
OpStatement::Write(Assembler* assembler)
{
	INT32 value;
	switch (mTarget)
	{
		case OpTarget_NONE:
		case OpTarget_A:
			assembler->WriteByte((UINT8)mOpcode);
			break;

		case OpTarget_IMM:
		case OpTarget_ZP:
		case OpTarget_ZPX:
		case OpTarget_ZPY:
		case OpTarget_INDX:
		case OpTarget_INDY:
			if (!mExpression->Resolve(assembler, &value))
				return;
			if (value > 255 || value < -128)
			{
				assembler->SetError("Expression out of zpage range (%d)", value);
				return;
			}
			else
				assembler->WriteByteByte((UINT8)mOpcode, (UINT8)value);
			break;

		case OpTarget_ABS:
		case OpTarget_ABSX:
		case OpTarget_ABSY:
		case OpTarget_IND:
			if (!mExpression->Resolve(assembler, &value))
				return;
			assembler->WriteByteWord((UINT8)mOpcode, (UINT16)value);
			break;

		case OpTarget_BRAN:
			if (!mExpression->Resolve(assembler, &value))
				return;
			value = value - (mPC + 2);
			if (value > 127 || value < -128)
			{
				assembler->SetError("Branch out of range");
				return;
			}
			assembler->WriteByteByte((UINT8)mOpcode, (UINT8)value);
			break;
	}
}

//------------------------------------------------------------------------------

DataStatement::DataStatement(Token typeToken)
				 : Statement(), mExpList(3)
{
	mTypeToken = typeToken;
}


DataStatement::~DataStatement()
{
	mExpList.DeleteAll();
}


void
DataStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;

	if (mTypeToken == TokenDFB)
		mTypeToken = TokenDB;
	else if (mTypeToken == TokenDA)
		mTypeToken = TokenDW;

	if (mTypeToken == TokenDC)
	{
		t = p->Next();
		if (t != '.')
		{
			p->SetTokenError('.');
			return;
		}

		t = p->Next();
		if (t == 'B')
			mTypeToken = TokenDB;
		else if (t == 'W')
			mTypeToken = TokenDW;
		else
		{
			p->SetTokenError('B', 'W');
			return;
		}
	}

	// at this pointer, type is either DB, DDB, or DW
	INT32 needed = (mTypeToken == TokenDB ? 1 : 2);

	while (true)
	{
		t = p->Next();

		// DASM allows ".byte #<MYLABEL", for example
		if (t == '#')
			t = p->Next();

		Expression* exp = p->ParseExpression(t);
		if (!exp)
			return;

		mExpList.Add(exp);

		t = p->Next();
		if (t == ',')
			continue;

		if (t != 0)
		{
			assembler->SetError("Invalid expression");
			return;
		}

		break;
	}

	assembler->AdvancePC(mExpList.GetCount() * needed);
}


void
DataStatement::Write(Assembler* assembler)
{
	UINT8* bp;
	INT32 value;
	INT32 expCount = mExpList.GetCount();

	// at this pointer, type is either DB, DDB, or DW
	if (mTypeToken == TokenDB)
	{
		bp = assembler->WriteMakeAvailable(expCount * 1);

		for (INT32 i = 0; i < expCount; ++i)
		{
			if (!mExpList[i]->Resolve(assembler, &value))
				return;

			if (value < -128 || value > 255)
			{
				assembler->SetError("Expression value too large ($%x)", value);
				return;
			}

			*bp++ = (UINT8)value;
		}

		assembler->WriteConsume(expCount * 1);
	}
	else
	{
		bp = assembler->WriteMakeAvailable(expCount * 2);

		bool isDDB = mTypeToken == TokenDDB;
		for (INT32 i = 0; i < expCount; ++i)
		{
			if (!mExpList[i]->Resolve(assembler, &value))
				return;

			if (isDDB)
			{
				*bp++ = (UINT8)(value >> 8);
				*bp++ = (UINT8)value;
			}
			else
			{
				*bp++ = (UINT8)value;
				*bp++ = (UINT8)(value >> 8);
			}
		}

		assembler->WriteConsume(expCount * 2);
	}
}

//------------------------------------------------------------------------------

void
StorageStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;
	INT32 value;

	t = p->Next();
	if (t == '\\')
	{
		if (!assembler->IsMerlin())
		{
			assembler->SetError("\'\\\' only supported with Merlin syntax");
			return;
		}
		value = assembler->GetPC() & 255;
		if (value)
			value = 256 - value;
	}
	else
	{
		if (!p->ParseAndResolveExpression(t, &value))
			return;

		if (value < 0)
		{
			assembler->SetError("Invalid DS count");
			return;
		}
	}
	mByteCount = value;

	t = p->Next();
	if (t == ',')
	{
		if (!p->ParseAndResolveExpression(&mPattern))
			return;

		if (mPattern < -128 || mPattern > 255)
		{
			assembler->SetError("Invalid DS value (out of range)");
			return;
		}
	}
	else
		mPattern = 0;

	assembler->AdvancePC(mByteCount);
}


void
StorageStatement::Write(Assembler* assembler)
{
	assembler->WritePattern((UINT8)mPattern, mByteCount);
}

//------------------------------------------------------------------------------

void
AlignStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;
	INT32 value;

	if (!p->ParseAndResolveExpression(&value))
		return;

	if (value < 0)
	{
		assembler->SetError("Invalid ALIGN count");
		return;
	}

	mByteCount = assembler->GetPC() % value;
	if (mByteCount)
		mByteCount = value - mByteCount;

	t = p->Next();
	if (t == ',')
	{
		if (!p->ParseAndResolveExpression(&mPattern))
			return;

		if (mPattern < -128 || mPattern > 255)
		{
			assembler->SetError("Invalid ALIGN value (out of range)");
			return;
		}
	}
	else
		mPattern = 0;

	assembler->AdvancePC(mByteCount);
}


void
AlignStatement::Write(Assembler* assembler)
{
	assembler->WritePattern((UINT8)mPattern, mByteCount);
}

//------------------------------------------------------------------------------

static bool
ScanHex(Assembler* assembler, char* string, GrowBuffer* buffer)
{
	INT32 length = strlen(string);
	if (length & 1)
	{
		assembler->SetError("Missing hex nibble");
		return false;
	}
	length /= 2;

	UINT8* ptr = buffer->MakeAvailable(length);
	INT32 v = 0;
	INT32 phase = 0;
	char c;
	while ((c = *string++) != 0)
	{
		v <<= 4;
		if (c >= '0' && c <= '9')
			v += c - '0';
		else
			v += tolower(c) - 'a' + 10;
		if ((phase ^= 1) == 0)
			*ptr++ = (UINT8)v;
	}

	buffer->Consume(length);
	return true;
}


void
HexStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;

	while (true)
	{
		t = p->NextHex();

		if (t == '$')
		{
			assembler->SetError("\'$\' not allowed in hex statements");
			return;
		}

		if (t != TokenHexNumber)
		{
			assembler->SetError("Invalid hex data");
			return;
		}

		if (!ScanHex(assembler, p->GetString(), &mBuffer))
			return;

		t = p->Next();
		if (t == 0)
			break;
		if (t != ',')
		{
			p->SetTokenError(',');
			return;
		}
	}

	p->GetAssembler()->AdvancePC(mBuffer.GetSize());
	mBuffer.Trim();
}


void
HexStatement::Write(Assembler* assembler)
{
	assembler->WriteBytes(mBuffer.GetPtr(), mBuffer.GetSize());
}

//------------------------------------------------------------------------------

void
AscStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;
	bool flipHigh;

	t = p->Next();
	if (t == '\"')
		flipHigh = true;
	else if (t == '\'')
		flipHigh = false;
	else
	{
		assembler->SetError("Invalid string");
		return;
	}

	if (!p->NextStringGroup((char)t))
		return;

	char* string = p->GetString();
	INT32 length = strlen(string);
	UINT8* dp = mBuffer.MakeAvailable(length);
	if (flipHigh)
	{
		UINT8* sp = (UINT8*)string;
		for (INT32 i = 0; i < length; ++i)
			*dp++ = *sp++ ^ 0x80;
	}
	else
		memcpy(dp, string, length);
	mBuffer.Consume(length);
	mBaseLength = (UINT8)length;

	while (true)
	{
		t = p->NextHex();
		if (t == 0)
			break;

		if (t == ',')
			t = p->NextHex();

		if (!ScanHex(assembler, p->GetString(), &mBuffer))
			return;
	}

	assembler->AdvancePC((mPrependLength ? 1 : 0) + mBuffer.GetSize());
	mBuffer.Trim();
}


void
AscStatement::Write(Assembler* assembler)
{
	if (mPrependLength)
		assembler->WriteByte(mBaseLength);

	assembler->WriteBytes(mBuffer.GetPtr(), mBuffer.GetSize());
}

//------------------------------------------------------------------------------

void
EquStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (!label)
	{
		assembler->SetError("Missing label");
		return;
	}

	Expression* exp = p->ParseExpression();
	if (!exp)
		return;

	INT32 value;
	if (!exp->Resolve(assembler, &value))
	{
		delete exp;
		return;
	}

	bool forceLong = (exp->GetSize(assembler) == 2);
	delete exp;

	if (!assembler->AddEquateSymbol(label, value, forceLong))
	{
		assembler->SetError("Duplicate equate \"%s\"", label);
		return;
	}
}

//------------------------------------------------------------------------------

void
OrgStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	INT32 value;
	if (!p->ParseAndResolveExpression(&value))
		return;

	mOrg = value;
	assembler->SetOrg(mOrg);
}


void
OrgStatement::Write(Assembler* assembler)
{
	assembler->SetOrg(mOrg);

#if 0
	if (assembler->WriteGetSize() != 0)
	{
		INT32 pc = assembler->GetPC();
		if (mOrg < pc)
		{
			assembler->SetError("Invalid org -- must be >= current pc");
			return;
		}

		assembler->WritePattern(0, mOrg - pc);
	}
#endif
}

//------------------------------------------------------------------------------

void
ConditionalStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	if (mTypeToken == TokenIF || mTypeToken == TokenDO || mTypeToken == TokenELIF)
	{
		INT32 value;
		if (!p->ParseAndResolveExpression(&value))
			return;

		t = p->Next();
		if (t != 0)
		{
			if (mTypeToken == TokenDO || t != TokenTHEN)
			{
				assembler->SetError("Unexpected token");
				return;
			}
		}

		if (mTypeToken == TokenIF || mTypeToken == TokenDO)
		{
			if (!p->PushConditional())
			{
				assembler->SetError("Exceeded nested conditionals maximum");
				return;
			}

			if (value != 0)
			{
				p->SetConditionalSatisfied(true);
				p->EnableConditional();
			}
		}
		else /*if (mTypeToken == TokenELIF)*/
		{
			if (p->ConditionalsComplete())
			{
				assembler->SetError("Unexpected ELIF without IF");
				return;
			}

			if (!p->ConditionalSatisfied() && value != 0)
			{
				p->SetConditionalSatisfied(true);
				p->EnableConditional();
			}
			else
				p->DisableConditional();
		}
	}
	else if (mTypeToken == TokenELSE)
	{
		if (p->Next() != 0)
		{
			assembler->SetError("Unexpected token after ELSE");
			return;
		}

		if (p->ConditionalsComplete())
		{
			assembler->SetError("Unexpected ELSE without IF");
			return;
		}

		if (!p->ConditionalSatisfied())
		{
			p->SetConditionalSatisfied(true);
			p->EnableConditional();
		}
		else
			p->DisableConditional();
	}
	else /* if (mTypeToken == TokenENDIF || mTypeToken == TokenFIN) */
	{
		if (p->Next() != 0)
		{
			assembler->SetError("Unexpected token after FIN/ENDIF");
			return;
		}

		if (!p->PullConditional())
		{
			assembler->SetError("Unexpected FIN/ENDIF");
			return;
		}
	}
}

//------------------------------------------------------------------------------

UsrStatement::UsrStatement() : Statement()
{
	mString = NULL;
}


UsrStatement::~UsrStatement()
{
	free(mString);
}


void
UsrStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();
	Token t;
	char c;

	mLength = 0;

	t = p->Next();
	if (t != '(')
	{
		p->SetTokenError('(');
		return;
	}

	if (!p->NextParenGroup())
	{
		assembler->SetError("Bad USR argument");
		return;
	}

	// (TEXT)	T,E,X,T,$8D
	// (TEXT)+	T,E,X,T,$8D,$FF
	// (TEXT)-	T,E,X,T
	// (TEXT)=	T,E,X,T^$80

	char* sp = p->GetString();
	char* dp;
	mString = (char*)malloc(strlen(sp) + 3);
	dp = mString;

	while ((c = *sp++) != 0)
	{
		if (isdigit(c))
			c -= '0';
		else if (isalpha(c))
			c = 0x0B + (char)toupper(c) - 'A';
		else if (c == '_')
			c = 0x0A;
		else
		{
			const char* symbols = "!\"%\'*+,-./:<=>?";
			const char* xp = symbols;
			while (true)
			{
				char x = *xp++;
				if (x == 0)
				{
					assembler->SetError("Invalid USR character \"%c\"", c);
					break;
				}
				if (x == c)
				{
					c = (char)(37 + xp - symbols - 1);
					break;
				}
			}
		}

		*dp++ = c;
	}

	t = p->Next();
	if (t == 0)
	{
		*dp++ = (char)0x8D;
	}
	else if (t == '+')
	{
		*dp++ = (char)0x8D;
		*dp++ = (char)0xFF;
	}
	else if (t == '=')
	{
		*(dp - 1) ^= 0x80;
	}
	else if (t != '-')
	{
		assembler->SetError("Invalid token \"%c\"", t);
		return;
	}
	*dp = 0;

	mLength = dp - mString;
	assembler->AdvancePC(mLength);
}


void
UsrStatement::Write(Assembler* assembler)
{
	assembler->WriteBytes((UINT8*)mString, mLength);
}

//------------------------------------------------------------------------------

void
IncludeStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (!p->NextFileName())
	{
		assembler->SetError("Invalid file name");
		return;
	}

	assembler->IncludeFile(p->GetString());
}

//------------------------------------------------------------------------------

SavStatement::SavStatement() : Statement()
{
	mString = NULL;
}


SavStatement::~SavStatement()
{
	free(mString);
}


void
SavStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	if (!p->NextFileName())
	{
		assembler->SetError("Invalid file name");
		return;
	}

	mString = _strdup(p->GetString());
}


void
SavStatement::Write(Assembler* assembler)
{
	if (mString)
		assembler->SaveFile(mString);
}

//------------------------------------------------------------------------------

DskStatement::DskStatement() : Statement()
{
	mString = NULL;
}


DskStatement::~DskStatement()
{
	free(mString);
}


void
DskStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	if (!p->NextFileName())
	{
		assembler->SetError("Invalid file name");
		return;
	}

	mString = _strdup(p->GetString());
}


void
DskStatement::Write(Assembler* assembler)
{
	if (mString)
		assembler->SetDiskFile(mString);
}

//------------------------------------------------------------------------------

ErrorStatement::~ErrorStatement()
{
	if (mExpression)
		delete mExpression;
}


void
ErrorStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	mExpression = p->ParseExpression();
}


void
ErrorStatement::Write(Assembler* assembler)
{
	if (mExpression)
	{
		INT32 value;

		if (!mExpression->Resolve(assembler, &value))
			return;

		if (value != 0)
			assembler->SetError("ERR check failed");
	}
}

//------------------------------------------------------------------------------

void
DummyStatement::Parse(Parser* p, const char* label)
{
	Assembler* assembler = p->GetAssembler();

	if (label)
	{
		assembler->SetError("Label not allowed");
		return;
	}

	if (mStart)
		assembler->StartDummy(mOrg);
	else
		assembler->EndDummy();
}


void
DummyStatement::Write(Assembler* assembler)
{
	if (mStart)
		assembler->StartDummy(mOrg);
	else
		assembler->EndDummy();
}

//------------------------------------------------------------------------------
