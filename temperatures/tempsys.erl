-module(tempsys).
-export([startsys/0]).

fromC(X) -> X.
fromDe(X) -> 100-X*2/3.
fromF(X) -> (X-32)*5/9.
fromK(X) -> X-273.15.
fromN(X) -> X*100/33.
fromR(X) -> (X-491.67)*5/9.
fromRe(X) -> X*5/4.
fromRo(X) -> (X-7.5)*40/21.
toC(X) -> X.
toDe(X) -> (100-X)*3/2.
toF(X) -> X*9/5+32.
toK(X) -> X+273.15.
toN(X) -> X*33/100.
toR(X) -> X*9/5+491.67.
toRe(X) -> X*4/5.
toRo(X) -> X*21/40+7.5.

loopto(F)->
	receive
		{client, C, mid, Mid, Val}-> Mid!{client, C, result, F(Val)}, loopto(F)
	end.

loopfrom(F)->
	receive
	{client, C, to, T, Val} -> To=list_to_atom(lists:concat([to, T])),
							   To!{client, C, mid, self(), F(Val)},
							   loopfrom(F);
	{client, C, result, R} -> C!{result, R},
							  loopfrom(F)
	end.
	
startsys() -> FromT =[{fromC, fun fromC/1}, {fromDe, fun fromDe/1}, {fromF, fun fromF/1}, 
					  {fromK, fun fromK/1}, {fromN, fun fromN/1}, {fromR, fun fromR/1}, 
					  {fromRe, fun fromRe/1}, {fromRo, fun fromRo/1}],
			  ToT = [{toC, fun toC/1}, {toDe, fun toDe/1}, {toF, fun toF/1}, 
					  {toK, fun toK/1}, {toN, fun toN/1}, {toR, fun toR/1}, 
					  {toRe, fun toRe/1}, {toRo, fun toRo/1}],
			  [register(Atom, spawn(fun()->loopto(F) end)) || {Atom, F}<-ToT],
			  [register(Atom, spawn(fun()->loopfrom(F) end)) || {Atom, F}<-FromT].

%list_to_atom(lists:concat([to, 'Re'])).
