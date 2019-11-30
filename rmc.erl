-module(rmc).
-export([start/3, init/1]). 

start(N, M, Message)->process_flag(trap_exit, true), 
					  connect(Processes=[spawn_link(?MODULE, init, [M]) || _<-lists:seq(1,N)]),
					  sendMessage(M, Message, Processes).
					  
sendMessage(0, _, _)-> io:format("Messages sended~n");
sendMessage(M, Message, [H|T])-> H!{send, Message}, sendMessage((M-1), Message, [H|T]).
					  
connect([H|T])-> connect([H|T], T++[H]).

connect([Curr|[]], [Next|[]])->
	Curr!{next, Next};
connect([Curr|T1], [Next|T2])->
	Curr!{next, Next},
	connect(T1, T2).
	

init(M)->
	receive
		{next, Next}->loop(M, Next)
	end.

loop(0, _)-> io:format("~p Finished~n", [self()]);
loop(M, Next)->
	receive
		{send, Message}-> Next!{send, Message}, 
						  io:format("~p: ~p (~p)~n", [self(), Message, M]),
						  loop((M-1), Next)
	end.
