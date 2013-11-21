-module(orders).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, []),
    register(?MODULE, Pid),
    Pid.


loop()->
    receive
        Msg ->
            io:format("Orders got ~p", [Msg])  
    end,
    loop().