-module(customer).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    log("started"),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

want_coffe(Cashier, Customer)->
    Customer ! {want_coffe, Cashier},
    ok.

loop(State)->
    receive
        stop -> ok;
        {get_state, Pid} ->
            Pid ! State,
            loop(State);
        {want_coffe, Cashier}->
            log("got want_coffe"),
            Cashier ! {new_order, self()},
            loop(want_coffe);
        {drink_ready, Barista} -> 
            log("got drink_ready"),
            Barista ! thank_you,
            loop(drink_ready);
        {Cashier, request_payment} ->
            log("got request_payment"),
            Cashier ! {payment, self()},
            loop(State);
        Msg ->
            log(Msg),
            loop(State)  
    end.

log(M)->
 io:format("~s ~s ~n", [atom_to_list(?MODULE), M]).
