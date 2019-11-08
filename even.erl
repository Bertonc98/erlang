-module(even).
-export([even/1]).

even(X) when (X rem 2)==0 -> io:format("~p is even~n",[X]);
even(X) when (X rem 2)==1 -> io:format("~p is odd~n",[X]).

