-module(attesa).
-export([attesa/0]).

attesa()->
	receive
		ciao->io:format("ciao~n",[]), attesa();
		_->io:format("closed~n",[])
	end.
