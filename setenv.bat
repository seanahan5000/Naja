
@echo off

SET _ROOT=d:\misc\dev
SET PATH=%_ROOT%\tools\bin;%PATH%

alias ls	"dir $*"
alias asm	"asm6502 $*"
alias asmb	"asm6502 -bin $*"
alias sed	"ScreenEditor $*"
