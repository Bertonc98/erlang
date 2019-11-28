-module(sieve).
-export([init/1]). 

init(N)->
	io:format("Sieve ~p~n",[N]),
	receive
		{last, Server} -> Server!{last, N}, init(N);
		{Gate, To} -> loop(Gate, To, N)
	end.

loop(Gate, To, N)->
	receive
		{new, V}-> Gate!{pass, V}, loop(Gate, To, N);
		{pass, V}->
			Root=trunc(math:sqrt(V)),
			if
				(N>Root) -> io:format("Here ~p ~p>~p~n", [N, V, Root]), Gate!{res, true}, loop(Gate, To, N);
				((V rem N)==0) -> Gate!{res, false}, loop(Gate, To, N);
				true -> To!{pass, V}, loop(Gate, To, N)
			end;
		{res, Res} -> controller!{res, Res}, loop(Gate, To, N)
	end.
