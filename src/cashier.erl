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
        new_order ->
            orders ! order_placed,
            loop();
        pay_order ->
            orders ! order_paid,
            loop();
        stop ->
            ok;
        Msg ->
            io:format("Cashier got unknown ~p", [Msg]),
            loop()   
    end.