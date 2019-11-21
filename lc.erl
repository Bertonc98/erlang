-module(lc).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(List)->[X*X||X<-List, is_integer(X)].

intersect(List1, List2)->[X||X<-List1, lists:member(X, List2)].

symmetric_difference(L1, L2)->[X||X<-lists:append(L1,L2), not(lists:member(X, intersect(L1,L2)))].
