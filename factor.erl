%factors: int → int list that given a number calculates all its prime factors;

-module(factor).
-export([factors/1]).

factors(X)->factors(X, 2, []).
factors(1, _, _)-> [1];
factors(X, I, Acc) when I==X->lists:reverse([I|Acc]);
factors(X, I, Acc) when (trunc(X) rem I)=:=0 -> factors((X/I), I, [I|Acc]);
factors(X, I, Acc) -> factors(X, (I+1), Acc).

divisore(X, I) -> (X rem I)==0.
