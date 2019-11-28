-module(controller).
-export([start/1]). 

start(N)-> register(controller, spawn(fun()->init(N) end)).

init(N)-> Sieves = [spawn(sieve, init, [X])||X<-lists:seq(2,N), 
											 ((length([Y||Y<-lists:seq(2, trunc(math:sqrt(X))), 
														     (X rem Y)==0]))==0
											 )
				   ],
		  connect(Sieves).

connect([H|T])-> connect(H, [H|T], T++[H]).

connect(Head, [Curr|[]], [Next|[]])->
	Curr!{last, self()},
	receive
		{last, Max}->Curr!{Head, Next}, loop(Max, Head)
	end;
connect(Head, [Curr|T1], [Next|T2])->Curr!{Head, Next}, connect(Head, T1, T2).

loop(Max, Gate)->
	receive
		{new, N, Ret} ->
			io:format("You asked for ~p, Max=~p~n", [N, Max]),
			Root=trunc(math:sqrt(N)),
			if
				(Root>Max) -> Ret!{result, unchekable}, loop(Max, Gate);
				true->
					  Gate!{new, N},
					  receive
						{res, true} -> Ret!{result, vero};
						{res, false}-> Ret!{result, falso}
					  end,
					  loop(Max, Gate)
			end;
		{stop, Ret} -> io:format("Stopping...~n",[]), Ret!{result, "Stopped~n"}
	end.
