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
    	{Barista , drink_ready} -> 
    		Barista ! thank_you;
    	{Cashier, request_payment} ->
    		Cashier ! {payment, self()};
        Msg ->
            io:format("Customer got ~p", [Msg]),
            loop()  
    end.