%is_an_anagram : string → string list → boolean that given a dictionary 
%of strings, checks if the input string is an anagram of one or more of 
%the strings in the dictionary;

-module(anagram).
-export([anagram/2]).

is_anagram(X, S)-> lists:sort(X)==lists:sort(S).

anagram(X, L)-> lists:any( fun(S)->is_anagram(X,S) end, L).
