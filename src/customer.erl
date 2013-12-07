-module(customer).
-compile(export_all).

-define(Log(M), io:format("~s ~s ~n", [atom_to_list(?MODULE), M])).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    ?Log("started"),
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
            ?Log("got want_coffe"),
            Cashier ! {new_order, self()},
            loop(want_coffe);
    	{Barista , drink_ready} -> 
            ?Log("got drink_ready"),
    		Barista ! thank_you,
            loop(mmmmmmmm);
    	{Cashier, request_payment} ->
            ?Log("got request_payment"),
    		Cashier ! {payment, self()},
            loop(State);
        Msg ->
            io:format("Customer got ~p", [Msg]),
            loop(State)  
    end.