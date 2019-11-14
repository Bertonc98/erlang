%is_proper: int → boolean that given a number calculates if it is a 
%perfect number or not, where a perfect number is a positive integer 
%equal to the sum of its proper positive divisors (excluding itself), 
%e.g., 6 is a perfect number since 1, 2 and 3 are the proper divisors of 
%6 and 6 is equal to 1+2+3;

-module(proper).
-export([is_proper/1, divisors/3]).

divisors(X, I, Acc) when ((X rem I)==0) and (I<X) -> divisors(X, (I+1), [I|Acc]);
divisors(X, I, Acc) when X=<I -> lists:reverse(Acc);
divisors(X, I, Acc) -> divisors(X,(I+1),Acc).

is_proper(X)-> X==(lists:foldr((fun(A,B)->A+B end), 0, divisors(X, 2, [1]))).
