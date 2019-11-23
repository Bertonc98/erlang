-module(ms).
-export([start/1, to_slave/2, start_aux/2, slave/1, master/1]).

start(N)->register(master, spawn(?MODULE, start_aux, [N, []])).

to_slave(Message, N)-> master!{toslave, Message, N}.

start_aux(0, List)->process_flag(trap_exit, true), master(List);
start_aux(N, List)->start_aux((N-1), [{N, spawn_link(?MODULE, slave, [N])}|List]).

remove(Processes, Elm)->[X||X<-Processes, noteq(X, Elm)].

noteq({N, _}, X) when N=/=X-> true;
noteq(_,_)->false.	

extract(N, [{H, Pid}|_])	when N==H-> Pid;
extract(N, [{_, _}|List])-> extract(N, List);
extract(_, [])-> notPresent.

master(Proclist)->
	io:format("~p~n", [Proclist]),
	receive
		{toslave, Message, N}-> case extract(N, Proclist) of
									notPresent->io:format("Non present slave~n",[]), master(Proclist);
									Pid->Pid!Message, master(Proclist)
								end;
		{'EXIT', _, Elm}->io:format("Master restarting dead slave ~p~n", [Elm]), 
							   master([{Elm, spawn_link(?MODULE, slave, [Elm])}|remove(Proclist, Elm)])
	end.

slave(Self)->
	receive
		die->exit(Self);
		Mess->io:format("Slave ~p got message: ~p~n", [Self, Mess]), slave(Self)
	end.
