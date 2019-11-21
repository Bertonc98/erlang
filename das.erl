-module(das).
-export([start/1, store/2, stop/1, lookup/1, loop/3]).

start(Processes)->register(node(), spawn(node(), ?MODULE, loop, [node(), Processes, []])).
		 
store(Tag, Value) -> {node(), node()}!{store, node(), {Tag, Value}}.

stop(Server)->{Server, Server}!stop.

lookup(Tag) ->{node(), node()}!{lookup, Tag}.

is_member(Tag, Elm)->
	case Elm of
		{Tag, _} -> true;
		_->false
	end.

loop(Self, Processes, Stored)->
	receive
		{store, Curr, {Tag, Value}} -> io:format("Registered~n"), 
											[{X, X}!{update, {Tag, Value}} || X<-Processes, X=/=Curr], 
											loop(Self, Processes, [{Tag,Value}|Stored]);
		{update, {Tag, Value}} -> loop(Self, Processes, [{Tag,Value}|Stored]);	
		{lookup, Tag} -> io:format("~p~n", [[X||X<-Stored, is_member(Tag, X)]]), 
								 loop(Self, Processes, Stored);
		{print, Message} -> io:format("~p~n", [Message]),
							loop(Self, Processes, Stored);
		stop->io:format("Server ~p terminated~n", [Self])
	end.

%c(das). das:start([a@alberto, b@alberto]).
%
