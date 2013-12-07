-module(cashier).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, []),
    log("started"),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

loop()->
    receive
        {new_order, Customer} ->
            orders ! {order_placed, Customer},
            Customer ! {self(), request_payment},
            log("got new_order"),
            loop();
        {payment, Customer} ->
            orders ! {order_paid, Customer},
            log("got payment"),
            loop();
        stop ->
            ok;
        Msg ->
            io:format("Cashier got unknown ~p", [Msg]),
            loop()   
    end.

log(M)->
 io:format("~s ~s ~n", [atom_to_list(?MODULE), M]).
