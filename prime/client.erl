-module(client).
-export([is_prime/1, close/0]).

is_prime(N)-> sendMsg({new, N, self()}).

close()->sendMsg({stop, self()}).

sendMsg(M)->
	{controller, ctrl@alberto}!M,
	receive
		{result, R}-> io:format("~p~n", [R])
	end.
