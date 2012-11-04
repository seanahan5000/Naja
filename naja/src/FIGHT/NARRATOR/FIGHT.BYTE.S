*-------------------------------
* FBYTE #1
*-------------------------------
* A---EF--
*
* A = Attack type (0 = physical, 1 = electrical)
* B =
* C =
* D =
* E = Alien must be in front 2 rows to shoot
* F = Use cheat aim (*1)
* G =
* H =
*-------------------------------

*-------------------------------
* FBYTE #2
*-------------------------------
* I----NNN
*
* I = Use cheat swing
* J =
* K =
* L =
* M =
* NNN = Rounds to wait before starting front row rush
*        (0 to 7, 7 = never rushes front)
*-------------------------------

*-------------------------------
* FBYTE #3
*-------------------------------
* OPQQRR--
*
* O = Run when out of attacks
* P = Aim mainly at characters in front 2 rows
* QQ = Fidget odds (0=never,3=always)
* RR = Avoid front row (0=never,3=always)
* S =
* T =
*-------------------------------

*-------------------------------
* FBYTE #4
*-------------------------------
* ------ZZ
*
* ZZ = # of shots fired at a time (#=2^ZZ or 1,2,4,8)
*-------------------------------

*-------------------------------
* FBYTE #5
*-------------------------------
* AAAAABBB
*
* AAAAA = Always run after this many rounds
*         ($0 to $1E, $1F = never always run)
* BBB = Can't run until after this many rounds (0 to 7)
*-------------------------------

* (*1) Also stop shooting at square that becomes
*       empty in mid command (or follow char???)
