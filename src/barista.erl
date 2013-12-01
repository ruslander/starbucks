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
        stop -> ok;
        {get_state, Pid} -> 
            Pid ! State,
            loop(State);
        prepare ->
            loop([true|State]);
        paid ->
            loop([true|State]);
        Msg ->
            io:format("Barista got ~p", [Msg]),
            loop(State)  
    end.