-module(send_message).
-export([response/0, sender/0]).

response()->receive
			 {ciao, Pid}->io:format("Ciao ~p~n",[Pid]), Pid!{ciao,self()} , response();
			 {addio, Pid} -> io:format("Addio ~p~n",[Pid]), Pid!{addio,Pid};
			 Other->io:format("Not recognized message~n")			
			end.

sender()->receive
			{ciao, Pid}->io:format("Ha risposto ciao~n"), Pid!{addio,self()}, sender();
			{addio, Pid}->io:format("Ha risposto addio, chiudo~n");
			Other->io:format("Unrecognized message~n")
		  end.
