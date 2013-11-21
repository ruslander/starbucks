-module(orders).
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
    	order_placed -> 
    		barista ! prepare,
            loop();
        order_paid ->
        	barista ! paid,
        	loop();  
        Msg ->
            io:format("Orders got ~p", [Msg]),
            loop()  
    end.