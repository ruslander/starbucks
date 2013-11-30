-module(cashier).
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
        {new_order, Customer} ->
            orders ! {order_placed, Customer},
            loop();
        {payment, Customer} ->
            orders ! {order_paid, Customer},
            loop();
        stop ->
            ok;
        Msg ->
            io:format("Cashier got unknown ~p", [Msg]),
            loop()   
    end.