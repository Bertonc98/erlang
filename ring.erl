-module(ring).
-export([start/3, loop/0]).

start(M, N, Message)->
	Processes = create([], N),
	LinkedProcess=lists:append(Processes, [hd(Processes)]),
	sendMsg({Message, M}, LinkedProcess).
	
sendMsg({_,0}, [Next|List])->Next!{stop, List};
sendMsg({Msg, M}, [Next|List])->Next!{Msg, M, List},
								sendMsg({Msg, (M-1)}, [Next|List]).

create(List, 0)-> List;
create(List, N)-> create([spawn(?MODULE, loop, [])|List], (N-1)).


loop()->
	receive
		{stop, [Next|Pids]}-> io:format("----~p ~p -> ~p~n", [self(), stop, Next]),
							  Next!{stop, Pids};
		{Msg, Nmsg, [Next|Pids]}-> io:format("----~p ~p ~p -> ~p~n", [self(), Msg, Nmsg, Next]),
								   Next!{Msg, Nmsg, Pids},
								   loop()
	end.
