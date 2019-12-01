-module(hebrew).
-export([init/2, loop/4]).

init(Id, K) ->
	receive
		{start, Next, Master} -> loop(Id, K, Next, Master)
	end.

loop(Id, K, Next, Master) ->
	receive
		{send, _} -> Next!{pass, self(), (K-1)}, loop(Id, K, Next, Master)	;
		{newnext, Pid} when Pid==self() -> Master!{survivor, Id};
		{newnext, Pid} -> Pid!{send, self()}, loop(Id, K, Pid, Master);
		{pass, Prev, 1} -> Prev!{newnext, Next};
		{pass, _, Counter} -> Next!{pass, self(), (Counter-1)}, loop(Id, K, Next, Master)						   
	end.
