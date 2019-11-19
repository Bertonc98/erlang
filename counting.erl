-module(counting).
-export([loop/0, start/0, add/2, mul/2, stop/0, tot/0]).

	start()->Pid=spawn(?MODULE, loop, []),
			 register(server, Pid).

	add(X, Y)->server!{self(), add, {X, Y}},
			   receive
					{Sum}->io:format("Sum of ~p and ~p is ~p~n", [X,Y,Sum])
			   end.

	mul(X, Y)->server!{self(), mul, {X, Y}},
			   receive
					{Mul}->io:format("Mul of ~p and ~p is ~p~n", [X,Y,Mul])
			   end.	   

	tot()->server!{self(), tot, null}.

	stop()->server!{self(), off, null},
			receive
				{ok}->io:format("Server closed~n",[])
			end.

	loop()->
		receive
			{Ret, Service, Args} ->
				case Service of
					add ->  Num=get(add),
							if Num==undefined ->
													put(add, 1);
							  true->
									put(add, Num+1)
							end,
							{A, B}=Args,
							Ret!{A+B},
							loop();
					mul ->  Num=get(mul),
							if Num==undefined ->
													put(mul, 1);
							  true->
									put(mul, Num+1)
							end,
							{A, B}=Args,
							Ret!{A*B},
							loop();
					tot -> 	Num=get(tot),
							if Num==undefined ->
													put(tot, 1);
							  true->
									put(tot, Num+1)
							end,
							io:format("~p~n", [get()]),
							loop();				   
					off -> Ret!{ok}
				end
		end.
