-module(das).
-export([start/0, store/3, stop/1, lookup/1, loop/2]).

start()->register(node(), spawn(node(), ?MODULE, loop, [node(), []])).
		 
store(Tag, Value, Name) -> {Name, Name}!{store, node(), {Tag, Value}}.

stop(Server)->{Server, Server}!stop.

lookup(Tag) ->{node(), node()}!{lookup, Tag}.

is_member(Tag, Elm)->
	case Elm of
		{Tag, _} -> true;
		_->false
	end.

loop(Self, Stored)->
	receive
		{store, a@alberto, {Tag, Value}} -> io:format("Registered~n"), 
											{b@alberto, b@alberto}!{update, {Tag, Value}}, 
											loop(Self, [{Tag,Value}|Stored]);
		{store, b@alberto, {Tag, Value}} -> io:format("Registered~n"), 
											{a@alberto, a@alberto}!{update, {Tag, Value}}, 
											loop(Self, [{Tag,Value}|Stored]);
		{update, {Tag, Value}} -> loop(Self, [{Tag,Value}|Stored]);	
		{lookup, Tag} -> io:format("~p~n", [[X||X<-Stored, is_member(Tag, X)]]), 
								 loop(Self, Stored);
		{print, Message} -> io:format("~p~n", [Message]),
							loop(Self, Stored);
		stop->io:format("Server ~p terminated~n", [Self])
	end.
