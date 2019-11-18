-module(echo).
-export([start/0, print/1, stop/0, loop/0]).

start()-> register(server, spawn(?MODULE, loop, [])).

loop()->
		receive
			{print, Message}->io:format("~p~n", [Message]), loop();
			{stop}->io:format("Server stopped~n",[])
		end.

print(Term)->server!{print, Term}.

stop()->server!{stop}.
