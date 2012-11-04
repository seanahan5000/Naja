*----------------------------------------------
* This is the main command selection flowchart
*----------------------------------------------

-				Running	possibility	has	NOT	been	tested	for	this	round
					-	Too	soon	to	run
							-	Fall	through
					-	NOT	too	soon	to	run
							-	Time	to	always	run
									-	Set	running	flag
									-	Fall	through
							-	NOT	time	to	always	run
									-	Using	group	retreat	odds,	see	if	monster	runs
											-	Monster	does	run
													-	Set	running	flag
													-	Fall	through
											-	Monster	does	NOT	run
													-	Fall	through
(				-	Fall	through	point	)

-				Run	possibility	HAS	been	tested	for	this	round
					-	Running	flag	is	true
							-	Square	1	back	is	open
									-	Move	1	back
									-	EXIT
							-	Square	1	back	is	NOT	open
									-	Square	left	and/or	right	is	open
											-	Move	left	or	right
											-	EXIT
									-	Square	left	AND	right	are	NOT	open
											-	Call	FIDGET_SUB(Parry)
											-	EXIT

					-	Running	flag	is	false

							-	Previous	command	was	AIM

									-	If	shots	left	>	0	then
											-	Select	#	of	shots	MIN	shots	left
											-	Give	shoot	command
											-	EXIT
									-	If	shots	left	=	0	then
											-	Fall	through	into	previous	command	NOT	AIM	code

							-	Previous	command	was	NOT	AIM

									-	Is	in	front	row
											-	Physical	primarily
													-	Has	swings	left	to	take
															-	Someone	to	swing	at
																	-	randomly	pick	who(where)	to	swing	at
																	-	EXIT
															-	No	one	to	swing	at
																	-	Has	obtainable	target	left	or	right
																			-	Move	towards	hitable	character
																			-	EXIT
																	-	No	obtainable	target	left	or	right
																			-	Has	shots	left	to	take
																					-	JUMP	AIM_OR_FIDGET
																			-	No	shots	left	to	take
																					-	Call	FIDGET_SUB
																					-	EXIT
													-	No	swings	left	to	take
															-	Has	shots	left	to	take
																	-	Call	AVOID_FRONT	result	is	true
																			-	EXIT
																	-	Call	AVOID_FRONT	result	is	false
																			-	JUMP	AIM_OR_FIDGET
															-	No	shots	left	to	take
																	-	JUMP	RUN_OR_AVOID

											-	Electrical	primarily
													-	Has	shots	left	to	take
															-	Call	AVOID_FRONT	result	true
																	-	EXIT
															-	Call	AVOID_FRONT	result	false
																	-	Call	AIM_SUB	result	is	true
																			-	Call	DO_AIM	using	result	square
																			-	EXIT
																	-	Call	AIM_SUB	result	is	false
																			-	Has	swings	left	to	take
																					-	Someone	to	swing	at
																							-	randomly	pick	who(where)	to	swing	at
																							-	EXIT
																					-	No	one	to	swing	at
																							-	Call	FIDGET_SUB
																							-	EXIT
																			-	No	swings	left	to	take
																					-	Call	FIDGET_SUB
																					-	EXIT
													-	No	shots	left	to	take
															-	Has	swings	left	to	take
																	-	Someone	to	swing	at
																			-	randomly	pick	who(where)	to	swing	at
																			-	EXIT
																	-	No	one	to	swing	at
																			-	Has	obtainable	target	left	or	right
																					-	Move	towards	hitable	character
																					-	EXIT
																			-	No	obtainable	target	left	or	right
																					-	Call	FIDGET_SUB
																					-	EXIT
															-	No	swings	left	to	take
																	-	JUMP	RUN_OR_AVOID

									-	Is	NOT	in	front	row

											-	Front	row	rush	has	started
													-	Has	swings	and/or	shots	left	to	take
															-	Square	forward	is	open
																	-	Move	forward
																	-	EXIT
															-	Square	forward	is	NOT	open
																	-	Square	left	OR	right	is	open
																			-	Move	left	or	right
																			-	EXIT
																	-	Square	left	AND	right	are	open
																			-	Move	left	or	right	using	smart	mover
																			-	EXIT
																	-	Neither	square	left	or	right	is	open
																			-	JUMP	AIM_IF_CLOSE
													-	Has	no	swings	or	shots	left	to	take
															-	JUMP	RUN_OR_AVOID

											-	Front	row	rush	has	NOT	started
													-	Has	swings	and/or	shots	left	to	take
															-	JUMP	AIM_IF_CLOSE
													-	Has	NO	swings	or	shots	left	to	take
															-	Runs	when	attacks	are	gone
																	-	Set	run	flag
																	-	JUMP	into	run	routine
															-	Doesn't run when attacks are gone
																	-	Call	FIDGET_SUB
																	-	EXIT


-				AIM_IF_CLOSE
					-	Has	shots	left	to	take
							-	Is	in	front	2	rows	OR	doesn't have to be to shoot
									-	JUMP	AIM_OR_FIDGET
							-	Not	in	front	2	rows	AND	must	be	to	shoot
									-	Call	FIDGET_SUB
									-	EXIT
					-	No	shots	left	to	take
							-	Call	FIDGET_SUB
							-	EXIT


-				RUN_OR_AVOID
					-	Runs	when	attacks	are	gone
							-	Set	run	flag
							-	JUMP	into	run	routine
					-	Doesn't run when attacks are gone
							-	Call	AVOID_FRONT	result	is	true
									-	EXIT
							-	Call	AVOID_FRONT	result	is	false
									-	Call	FIDGET_SUB
									-	EXIT


-				AVOID_FRONT
					-	Avoids	front	when	possible
							-	Square	one	back	is	open
									-	Move	one	square	back
									-	Pull	a	return	address
									-	EXIT
							-	Square	one	back	is	NOT	open
									-	EXIT
					-	Doesn't avoid front when possible
							-	EXIT


-				DO_AIM
					-	Give	AIM	command	using	square	passed	by	caller
					-	EXIT


-				AIM_OR_FIDGET
					-	Call	AIM_SUB	result	is	true
							-	Call	DO_AIM	using	result	square
							-	EXIT
					-	Call	AIM_SUB	result	is	false
							-	Call	FIDGET_SUB
							-	EXIT


*----------------------------------------------------
* If the alien fidgets then move randomly left or
*   right.  If that's not possible or if the alien
*   doesn't fidget then parry for as many time units
*   as it takes the alien to move one square.
*----------------------------------------------------

-				FIDGET_SUB
					-	Get	random	number	0	to	3
							-	Random	number	<=	Fidget	flag
									-	Square	left	and/or	right	are	open
											-	Move	left	or	right
											-	EXIT
									-	Square	left	and	right	are	NOT	open
											-	Parry	time	units	it	takes	to	move
											-	EXIT
							-	Random	number	>	Fidget	flag
									-	Parry	time	units	it	takes	to	move
									-	EXIT


-				AIM_SUB
					-	Alien	aims	only	at	characters	in	front	2	rows
							-	Set	square	limit	to	9
					-	Alien	aims	at	characters	in	any	row
							-	Set	square	limit	to	24
					-	There	is	at	least	1	character	in	the	limitted	area
							-	The	square	picked	is	an	generated	image
									-	The	alien	is	fooled	by	image	generators
											-	Set	carry
											-	Return	square	picked
											-	EXIT
									-	The	alien	is	not	fooled	by	image	generators
											-	Repick	squares	until	non-image	square	is	found
											-	Set	carry
											-	Return	square	picked
											-	EXIT
							-	The	square	picked	in	not	a	generated	image
									-	Set	carry
									-	Return	square	picked
									-	EXIT
					-	There	are	no	characters	in	the	limitted	area
							-	Clear	carry
							-	EXIT


-				DIRECTION_SUB
					-	Clear	flag	byte
					-	Square	forward	is	open
							-	Set	forward	bit	in	flag	byte
					-	Square	backward	is	open
							-	Set	backward	bit	in	flag	byte
					-	Square	left	is	open
							-	Set	left	bit	in	flag	byte
							-	Character	hitable	from	here
									-	Set	left_hit	bit	in	flag	byte
					-	Square	right	is	open
							-	Set	right	bit	in	flag	byte
							-	Character	hitable	from	here
									-	Set	right_hit	bit	in	flag	byte
							-	Square	left	bit	is	set	in	flag	byte
									-	Set	left_and_right	bit	in	flag	byte
