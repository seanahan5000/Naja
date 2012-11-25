
#pragma once

enum Token;
class Assembler;
class Parser;
class Symbol;

//------------------------------------------------------------------------------

class Expression
{
public:
	static Expression* Parse(Parser* p, Token t, bool recurse = true);
	virtual ~Expression() {}
	
	virtual INT32 GetSize(Assembler* assembler) = 0;	//***
	virtual bool Resolve(Assembler* assembler, INT32* value, bool setError = true) = 0;
};

//------------------------------------------------------------------------------

class NumberExpression : public Expression
{
public:
	NumberExpression(INT32 value, bool forceLong);
	
	INT32 GetSize(Assembler* assembler);		//***
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
	
protected:
	INT32 mValue;
	bool mForceLong;
};

//------------------------------------------------------------------------------

class SymbolExpression : public Expression
{
public:
	SymbolExpression(char* string);
	~SymbolExpression();
	
	INT32 GetSize(Assembler* assembler);		//***
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
	
protected:
	char* mString;
	bool mLocal;
};

//------------------------------------------------------------------------------

class UnaryExpression : public Expression
{
public:
	UnaryExpression(Token op, Expression* arg);
	~UnaryExpression();
	
	INT32 GetSize(Assembler* assembler);		//***
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
	
protected:
	Token mOperation;
	Expression* mArg;
};

//------------------------------------------------------------------------------

class BinaryExpression : public Expression
{
public:
	BinaryExpression(Expression* arg1, Token op, Expression* arg2);
	~BinaryExpression();
	
	INT32 GetSize(Assembler* assembler);	//***
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
	
protected:
	Expression* mArg1;
	Token mOperation;
	Expression* mArg2;
};

//------------------------------------------------------------------------------

class PcExpression : public Expression
{
public:
	PcExpression() {}
	
	INT32 GetSize(Assembler* assembler);
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
};

//------------------------------------------------------------------------------

class ParenExpression : public Expression
{
public:
	ParenExpression(Expression* arg);
	~ParenExpression();
	
	INT32 GetSize(Assembler* assembler);		//***
	bool Resolve(Assembler* assembler, INT32* value, bool setError);
	
protected:
	Expression* mArg;
};

//------------------------------------------------------------------------------
