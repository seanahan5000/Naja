
#pragma once

#include "ClassUtils.h"

class Assembler;
class Expression;
class Parser;
enum Token;

//------------------------------------------------------------------------------

class Statement
{
public:
	Statement();
	virtual ~Statement();
	
	virtual void Parse(Parser* p, const char* label) {}
	virtual void Write(Assembler* assembler) {}
	
	void SetPC(INT32 pc) { mPC = pc; }
	INT32 GetPC() { return mPC; }
	
protected:
	INT32 mPC;
	Expression* mExpression;
};

//------------------------------------------------------------------------------

// order dependent
enum OpTarget
{
	OpTarget_NONE,
	OpTarget_A,
	OpTarget_IMM,
	OpTarget_ZP,
	OpTarget_ZPX,
	OpTarget_ZPY,
	OpTarget_ABS,
	OpTarget_ABSX,
	OpTarget_ABSY,
	OpTarget_IND,
	OpTarget_INDX,
	OpTarget_INDY,
	OpTarget_BRAN,
};


class OpStatement : public Statement
{
public:
	OpStatement(Token opcode) : Statement()
	{
		mOpcode = opcode;
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	void ChooseAddressMode(Assembler* assembler);
	
	INT32 mOpcode;		// holds token during early parse, then hex opcode
	OpTarget mTarget;
};

//------------------------------------------------------------------------------

class DataStatement : public Statement
{
public:
	DataStatement(Token typeToken);
	~DataStatement();

	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	Token mTypeToken;
	Array<Expression*> mExpList;
};

//------------------------------------------------------------------------------

class StorageStatement : public Statement
{
public:
	StorageStatement() : Statement()
	{
		mByteCount = 0;
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	INT32 mPattern;
	INT32 mByteCount;
};

//------------------------------------------------------------------------------

class AlignStatement : public Statement
{
public:
	AlignStatement() : Statement()
	{
		mByteCount = 0;
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	INT32 mPattern;
	INT32 mByteCount;
};

//------------------------------------------------------------------------------

class HexStatement : public Statement
{
public:
	HexStatement() : Statement()
	{
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	GrowBuffer mBuffer;
};

//------------------------------------------------------------------------------

class AscStatement : public Statement
{
public:
	AscStatement(bool prependLength) : Statement()
	{
		mPrependLength = prependLength;
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	bool mPrependLength;
	UINT8 mBaseLength;
	GrowBuffer mBuffer;
};

//------------------------------------------------------------------------------

class EquStatement : public Statement
{
public:
	EquStatement() : Statement()
	{
	}
	
	void Parse(Parser* p, const char* label);
};

//------------------------------------------------------------------------------

class OrgStatement : public Statement
{
public:
	OrgStatement() : Statement()
	{
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	INT32 mOrg;
};

//------------------------------------------------------------------------------

class ConditionalStatement : public Statement
{
public:
	ConditionalStatement(Token t) : Statement()
	{
		mTypeToken = t;
	}
	
	void Parse(Parser* p, const char* label);
	
protected:
	Token mTypeToken;
};

//------------------------------------------------------------------------------

class UsrStatement : public Statement
{
public:
	UsrStatement();
	~UsrStatement();
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);

protected:
	char* mString;
	INT32 mLength;
};

//------------------------------------------------------------------------------

class IncludeStatement : public Statement
{
public:
	IncludeStatement() : Statement()
	{
	}
	
	void Parse(Parser* p, const char* label);
};

//------------------------------------------------------------------------------

class SavStatement : public Statement
{
public:
	SavStatement();
	~SavStatement();
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	char* mString;
};

//------------------------------------------------------------------------------

class DskStatement : public Statement
{
public:
	DskStatement();
	~DskStatement();
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	char* mString;
};

//------------------------------------------------------------------------------

class ErrorStatement : public Statement
{
public:
	ErrorStatement() : Statement()
	{
		mExpression = NULL;
	}
	
	~ErrorStatement();
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);

protected:
	Expression* mExpression;
};

//------------------------------------------------------------------------------

class DummyStatement : public Statement
{
public:
	DummyStatement(bool start, INT32 org) : Statement()
	{
		mStart = start;
		mOrg = org;
	}
	
	void Parse(Parser* p, const char* label);
	void Write(Assembler* assembler);
	
protected:
	bool mStart;
	INT32 mOrg;
};

//------------------------------------------------------------------------------
