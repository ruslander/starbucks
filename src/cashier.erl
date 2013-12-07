-module(cashier).
-compile(export_all).

-define(Log(M), io:format("~s ~s ~n", [atom_to_list(?MODULE), M])).

start()->
    Pid = spawn(?MODULE, loop, []),
    ?Log("started"),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

loop()->
    receive
        {new_order, Customer} ->
            ?Log("got new_order"),
            orders ! {order_placed, Customer},
            loop();
        {payment, Customer} ->
            ?Log("got payment"),
            orders ! {order_paid, Customer},
            loop();
        stop ->
            ok;
        Msg ->
            io:format("Cashier got unknown ~p", [Msg]),
            loop()   
    end.