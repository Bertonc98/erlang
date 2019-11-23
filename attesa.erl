-module(attesa).
-export([attesa/2]).

attesa({N, _}, {X, _}) when N=/=X-> true;
attesa(_,_)->false.	
