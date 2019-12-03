-module(combinator).
-export([start/2, loop/3, result/2]).

start(Slaves, Top) -> Lines=trunc(math:pow(Top, Slaves)),
					  register(master, spawn(fun()->loop(Slaves, Lines, []) end)),
					  [spawn(generator, gen, [X, trunc(math:pow(Top, X)), Lines, Top, 1, 1, []]) || X<-lists:seq(0, (Slaves-1))].
					 
loop(Columns, Lines, List)->
	receive
		{res, Id, L} when Columns==1-> io:format("Received ~p~n", [L]), result(lists:reverse(lists:sort([{Id, L}|List])), Lines);
		{res, Id, L} -> io:format("Received ~p~n", [L]),loop((Columns-1), Lines, [{Id,L}|List]) 						
	end.
	
result(List, Lines) -> printResult(extract(List, []), Lines).

printResult(List, 1) -> printList(lists:foldr( fun(X, Acc) -> [hd(X)]++Acc end, [], List));
printResult(List, Lines) -> printList(lists:foldr( fun(X, Acc) -> [hd(X)]++Acc end, [], List)),
							printResult(lists:map(fun(X)->tl(X) end, List), (Lines-1)).

extract([{_, List}|[]], Res) -> Res++[List];
extract([{_, List}|Tail], Res) -> extract(Tail, Res++[List]).

printList([H|[]])->io:format("~p~n",[H]);
printList([H|T])->io:format("~p,",[H]), printList(T).
