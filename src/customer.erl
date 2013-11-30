-module(customer).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, []),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

loop()->
    receive
    	stop -> ok;
        Msg ->
            io:format("Customer got ~p", [Msg]),
            loop()  
    end.