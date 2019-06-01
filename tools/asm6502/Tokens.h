
#pragma once

//------------------------------------------------------------------------------

const int kFirstKeywordToken = 128;
const int kFirstOpcodeToken = 256;

inline bool TokenIsOpcode(Token t)
{
	return (t >= kFirstOpcodeToken);
}

inline bool TokenIsKeyword(Token t)
{
	return (t >= kFirstKeywordToken && t < kFirstOpcodeToken) ||
			(t >= 'a' && t <= 'z') ||
			(t >= 'A' && t <= 'Z');
}

enum Token
{
	// (0 to 31) special tokens
	TokenNULL		= 0,
	TokenSymbol		= 1,
	TokenHexNumber	= 2,
	TokenDecNumber	= 3,

	// (32 to 126) single character tokens
	// (token value == character code)

	// (128 to 255) keyword tokens
	_START_KEYWORD_TOKENS = kFirstKeywordToken - 1,
#define KEYWORD(_word, _flags)	Token##_word,
#include "Keywords.h"

	// (256 and up) opcode tokens
	_START_OP_TOKENS = kFirstOpcodeToken - 1,
#define OPCODE(_op)	Token##_op,
#define OP(_mode, _hex)
#define OPEND()
#include "Opcodes.h"
};

//------------------------------------------------------------------------------
