% is_palindrome: string → bool that checks if the string given as input 
%is palindrome, a string is palindrome when the represented sentence can 
%be read the same way in either directions in spite of spaces, punctual 
%and letter cases, e.g., detartrated, "Do geese see God?", "Rise to 
%vote, sir.", ...; 

-module(is_palindrome).
-export([is_palindrome/1]).

filtro(S)->lists:filter(fun (X)->(X>=97) and (X=<122) end, S).

is_palindrome(Stringa)->
	Filtrata=filtro(string:lowercase(Stringa)),
	Filtrata==string:reverse(Filtrata).
