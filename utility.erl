-module(utility).
-export([map/2,filter/2,reduce/2]).

map(_, [])->[];
map(F, [H|T])->[F(H)|map(F,T)].

filter(_, [])->[];
filter(P, [H|L])-> filter(P(H), H, P, T).

filter(true, H, P, T)->[H|filter(P,T)];
filter(false, H, P, T)->filter(P,T).

reduce(F, [H|T])->reduce(F, H, T).

reduce(_, Q, [])->Q;
reduce(F, Q, [H|T])-> reduce(F, F(Q,H), T).
