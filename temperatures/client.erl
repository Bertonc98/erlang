-module(client).
-export([convert/5]).

convert(from, From, to, To, Val)->
	F=list_to_atom(lists:concat([from, From])),
	F!{client, self(), to, To, Val},
	receive
		{result, R} -> io:format("~p°~p are equivalent to ~p°~p~n", [Val, From, R, To])
	end.

