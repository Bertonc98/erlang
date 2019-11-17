-module(ringCirc).
-export([start/3, loop/1, loop_s/3]).

start(M, N, Message)->
	Start=spawn(?MODULE, loop_s, [N, N, self()]),
	sendMsg(Message, M, Start).
	

sendMsg(_, 0, Start)->Start!stop;
sendMsg(Msg, M, Start)->Start!{Msg, M},
						sendMsg(Msg, (M-1), Start).

loop_s(_, 0, Start) -> loop(Start);
loop_s(Max, N, _) when Max==N -> Next=spawn(?MODULE, loop_s, [Max, (N-1), self()]),
								 loop(Next);
loop_s(Max, N, Start) -> Next=spawn(?MODULE, loop_s, [Max, (N-1), Start]),
								 loop(Next). 

loop(Next)->
	receive
		stop->io:format("__~p exit -> ~p~n", [self(), Next]),
				Next!stop;
		{Msg, Nmsg}->io:format("__~p ~p -> ~p~n", [self(), Nmsg, Next]),
					 Next!{Msg, Nmsg},
					 loop(Next)
	end.
