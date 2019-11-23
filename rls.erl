-module(rls).
-export([start/1, close/0, long_reversed_string/1, master/4, start_aux/3, tostring/2, slave/1, compareElm/2]).

start(N)->register(master, spawn(?MODULE, start_aux, [[], N, N])).

start_aux(Proclist, 0, Max)->process_flag(trap_exit, true), master(Proclist, [], 0, Max);
start_aux(Proclist, N, Max)->start_aux([spawn(?MODULE, slave, [N])|Proclist], (N-1), Max).

long_reversed_string(String)->master!String.

close()->master!die.

send_to([], _, _,_, _) -> void;
send_to([H|Proclist], String, N, Lim, Pos) when N<Lim -> 
								 Mess=string:sub_string(String, 1, (Pos+1)),
								 H!Mess,
								 send_to(Proclist, 
										string:sub_string(String, (Pos+2), string:length(String)), 
										(N+1), 
										Lim,
										Pos);
send_to([H|Proclist], String, N, Lim, Pos) -> 
								 Mess=string:sub_string(String, 1, Pos),
								 H!Mess,
								 send_to(Proclist, 
										 string:sub_string(String, (Pos+1), string:length(String)), 
										 (N+1), 
										 Lim,
										 Pos).

tostring([], Aux)->Aux;
tostring([H|T], Aux)->
					  case H of
						{ _, Word} -> tostring(T, string:concat(Word, Aux))
					  end.

compareElm({A, _}, {B, _}) -> A=<B.


master(Proclist, Reversed, RevElm, Max)->
	receive
		die -> io:format("Server closed~n", []);
		{N, Rev} when RevElm<9 -> master(Proclist, [{N, Rev}|Reversed], (RevElm+1), Max);
		{N, Rev} when RevElm>=9-> io:format("Reversed: ~p~n", [tostring(lists:sort([{N, Rev}|Reversed]), [])]),
								  start_aux([], Max, Max);
		String -> send_to(Proclist, String, 0, (string:length(String) rem Max), (string:length(String) div Max)), 
				  master(Proclist, Reversed, RevElm, Max)
	end.

slave(Self)->
	receive
		String->master!{Self, string:reverse(String)}
	end.
	
