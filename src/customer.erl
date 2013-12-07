-module(customer).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

want_coffe(Cashier, Customer)->
    Customer ! {want_coffe, Cashier}.

loop(State)->
    receive
    	stop -> ok;
        {get_state, Pid} ->
            Pid ! State,
            loop(State);
        {want_coffe, Cashier}->
            Cashier ! {new_order, self()},
            loop(want_coffe);
    	{Barista , drink_ready} -> 
    		Barista ! thank_you,
            loop(mmmmmmmm);
    	{Cashier, request_payment} ->
    		Cashier ! {payment, self()},
            loop(State);
        Msg ->
            io:format("Customer got ~p", [Msg]),
            loop(State)  
    end.