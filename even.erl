-module(even).
-export([even/1]).

even(X) when isEven(X) -> io:format("~p is even~n",[X]);
even(X) when not(isEven(X)) -> io:format("~p is odd~n",[X]).

isEven(X)->(X/2)==0.

