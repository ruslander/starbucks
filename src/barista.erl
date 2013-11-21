-module(barista).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).


loop([true,true])->
    customer ! drink_ready,
    loop([]);

loop(State)->
    receive
        prepare ->
            loop([true|State]);
        paid ->
            loop([true|State]);
        stop -> ok;
        Msg ->
            io:format("Barista got ~p", [Msg]),
            loop(State)  
    end.