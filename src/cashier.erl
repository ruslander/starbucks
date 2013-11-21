-module(cashier).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, []),
    register(?MODULE, Pid),
    Pid.


loop()->
    receive
        new_order ->
            orders ! order_placed,
            loop();
        stop ->
            ok;
        Msg ->
            io:format("Cashier got unknown ~p", [Msg]),
            loop()   
    end.