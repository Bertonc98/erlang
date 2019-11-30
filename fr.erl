-module(fr).
-export([start/2, send_message/1, send_message/2, stop/0]).

start(N, Functions) when N==(length(Functions)) -> connect([spawn( fun() -> init(X, N) end) || X<-Functions]);
start(_, _) -> io:format("Wrong input~nService closing...").

connect([H|T]) -> register(head, H),
				  connect([H|T], T++[H]).

connect([Curr|[]], [Next|[]]) -> Curr!{set, Next};
connect([Curr|T1], [Next|T2]) -> Curr!{set, Next}, connect(T1, T2).

send_message(Value)->send_message(Value, 1).

send_message(Value, Times) -> head!{new, Value, Times}.

stop() -> head!stop.

init(Fun, N)->
	receive
		{set, Next} -> loop(Fun, Next, N)
	end.

loop(Fun, Next, N) -> 
	receive
		stop->Next!stop;
		{new, Value, Times} -> Next!{pass, Fun(Value), Times, N}, loop(Fun, Next, N);
		{pass, Value, Times, 1} when Times=<1-> io:format("~p~n", [Value]), loop(Fun, Next, N);
		{pass, Value, Times, 1} -> Next!{new, Value, (Times-1) }, loop(Fun, Next, N);
		{pass, Value, Times, Nproc} -> Next!{pass, Fun(Value), Times, (Nproc-1)}, loop(Fun, Next, N)
	end.


