-module(das).
-export([start/0, store/3, stop/1, lookup/2, loop/2]).

start()->register(node(), spawn(node(), ?MODULE, loop, [node(), []])).
		 
store(Tag, Value, Name) -> {Name, Name}!{store, {Tag, Value}}.

stop(Server)->{Server, Server}!stop.

lookup(Tag, Name)->{Name, Name}!{lookup, a@alberto, Tag}.

is_member(Tag, Elm)->
	case Elm of
		{Tag, _} -> true;
		_->false
	end.

loop(Self, Stored)->
	receive
		{store, {Tag, Value}} -> io:format("Registered~n"), loop(Self, [{Tag,Value}|Stored]);
		{update, {Tag, Value}} -> loop(Self, [{Tag,Value}|Stored]);	
		{lookup, Client, Tag} -> io:format("~p---~p~n", [Client, [X||X<-Stored, is_member(Tag, X)]]), 
								 {Client, Client}!{print, [X||X<-Stored, is_member(Tag, X)]}, 
								 loop(Self, Stored);
		{print, Message} -> io:format("~p~n", [Message]),
							loop(Self, Stored);
		stop->io:format("Server ~p terminated~n", [Self])
	end.
