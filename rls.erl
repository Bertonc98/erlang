-module(rls).
-export([start/0, long_reversed_string/1, master/3, start_aux/2, tostring/2]).

start()->register(master, spawn(?MODULE, start_aux, [[], 10])).

start_aux(Proclist, 0)->process_flag(trap_exit, true), master(Proclist, [], 0);
start_aux(Proclist, N)->start_aux([spawn_link(?MODULE, slave, [N])|Proclist], (N-1)).

long_reversed_string(String)->master!String.

send_to([], _, _,_) -> void;
send_to([H|Proclist], String, N, Lim) when N=<Lim -> Mess=string:sub_string(String, 1, ((string:length(String) rem 10)+1)),
													 H!Mess,
													 send_to(Proclist, 
															string:sub_string(String, ((string:length(String) rem 10)+2), string:length(String)), 
															(N+1), 
															Lim);
send_to([H|Proclist], String, N, Lim) -> Mess=string:sub_string(String, 1, (string:length(String) rem 10)),
										 H!Mess,
										 send_to(Proclist, 
												 string:sub_string(String, ((string:length(String) rem 10)+1), string:length(String)), 
												 (N+1), 
												 Lim).

tostring([], Aux)->Aux;
tostring([H|T], Aux)->
					  case H of
						{ _, Word} -> tostring(T, Aux++Word)
					  end.

compareElm({A, _}, {B, _}) when B=<A-> true;
compareElm({_, _}, {_, _}) -> false.


master(Proclist, Reversed, RevElm)->
	receive
		{N, Rev} when RevElm<10 -> master(Proclist, [{N, Rev}|Reversed], (RevElm+1));
		{N, Rev} -> io:format("~p~n", [tostring(lists:sort(compareElm, [{N, Rev}|Reversed]), [])]);
		String -> send_to(Proclist, String, 0, (string:length(String) rem 10)), 
				  master(Proclist, Reversed, RevElm)				
	end.
