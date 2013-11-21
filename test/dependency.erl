-module(dependency).
-compile(export_all).

catch_all_loop(State)->
    receive
		{Source, get_result} -> 
			Source ! State;
        Any -> 
        	catch_all_loop([Any|State])   
    end.

register(Service)->
    register(Service, spawn(dependency, catch_all_loop, [[]])).

get_calls(Service)->
    timer:sleep(1000),
    Service ! {self(), get_result},
    receive
       Any -> Any
	end.

