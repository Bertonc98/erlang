-module(orologio).
-export([start/2, stop/0, ora/0]).

start(T, Fun)->register(clock, spawn(fun()->tick(T,Fun) end)).
stop()->clock!stop.
ora()->clock!ora.

tick(T, Fun) ->
	receive
		ora-> Fun(), tick(T,Fun);
		stop->void
	after T -> tick(T, Fun)	
	end.

