-module(joseph).
-export([joseph/2]).

joseph(N, Kill) -> Hebrews = [spawn(hebrew, init, [X, Kill]) || X<-lists:seq(1,N)],
				   [P!{start, Next, self()} || {P, Next}<-lists:zip(Hebrews, tl(Hebrews)++[hd(Hebrews)])],
				   hd(Hebrews)!{send, hd(lists:reverse(Hebrews))},
				   receive
						{survivor, Id} -> io:format("In a circle of ~p people, killing number ~p~n Joseph is the Hebrew in position ~p~n", [N, Kill, Id]);
						_->io:format("Error~n")
				   end.
				   

				   
	
