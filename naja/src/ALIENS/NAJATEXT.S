*==========================================================
*
* SOURCE FILE NAME: NAJATEXT.S
*
* PROGRAMMER: Sean Callahan
* DATE: May 29, 1986
*
* DESCRIPTION:
*   USR utility for use with MERLIN PRO.
*   It converts from ASCII to my ascii.
*
* format: Left paren, text to convert, right paren, <plus>
*   An $8D is automatically appended to the data and if a
*   plus is present, an $FF is appended after that.
*
* AS OF 1/18/87:
*   If <minus> is present in place of <plus>, the $8D
*     and $FF are not appended to the data.
*
*==========================================================

USRADS			=	$B6DA
PUTBYTE			=	$E5F6
ERRCNT			=	$1D
OPNDLEN			=	$BB
WORKSP			=	$0280

				ORG	$0300

PUTVECTOR		LDA	#$4C
				STA	USRADS
				LDA	#<NAJATEXT
				STA	USRADS+1
				LDA	#>NAJATEXT
				STA	USRADS+2
				RTS

NAJATEXT		LDA	#$00
				STA	TEXTINDEX
				LDX	TEXTINDEX
:LOOP1			LDA	WORKSP,X
				INX
				CMP	#'('
				BEQ	:SKIPA
				CPX	OPNDLEN
				BNE	:LOOP1
:ERROR			INC	ERRCNT
				RTS
:SKIPA			STX	TEXTINDEX
:LOOP2			LDA	WORKSP,X
				CMP	#')'
				BEQ	:EXIT1
				CMP	#'_'
				BNE	:SKIPD
				LDA	#$20			;SPACE
:SKIPD			JSR	CONVERT
				CPX	#$FF
				BEQ	:SKIPC
				TXA
				JSR	PUTBYTE
:SKIPC			INC	TEXTINDEX
				LDX	TEXTINDEX
				CPX	OPNDLEN
				BNE	:LOOP2
				BEQ	:ERROR
:EXIT1			INX
				STX	TEXTINDEX
				LDA	WORKSP,X		;NEW
				CMP	#'-'			;NEW
				BEQ	:EXIT2			;NEW
				LDA	#$8D
				JSR	PUTBYTE
				LDX	TEXTINDEX
				CPX	OPNDLEN
				BEQ	:EXIT2
				LDA	WORKSP,X
				CMP	#'+'
				BNE	:EXIT2
				LDA	#$FF
				JSR	PUTBYTE
:EXIT2			RTS

TEXTINDEX		HEX	00

CONVERT			ORA	#%10000000
				CMP	#"a"
				BCC	:UPPER
				CMP	#"z"+1
				BCS	:UPPER
				AND	#%11011111
:UPPER			CMP	#"Z"+1
				BCS	NONE
				CMP	#"A"
				BCC	NOTLETS
				SBC	#$B6
				TAX
				BNE	FOUND
NOTLETS			TAX
				EOR	#$B0
				CMP	#$0A
				BCS	NOTNUMB
				TAX
				BPL	FOUND
NOTNUMB			CMP	#$10
				BNE	NOTSPAC
				LDX	#$0A
				BNE	FOUND
NOTSPAC			TXA
				LDX	#$25
COMPARE			CMP	ASCII-37,X
				BEQ	FOUND
				CPX	#$33
				BEQ	NONE
				INX
				BNE	COMPARE
NONE			LDX	#$FF
FOUND			RTS
ASCII			ASC	#!"%'*+,-./:<=>?#
