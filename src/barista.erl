-module(barista).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).


loop(State)->
    receive
        stop -> ok;
        {get_state, Pid} -> 
            Pid ! State,
            loop(State);
        prepare ->
            loop([true]);
        {paid, Customer} ->
            case State of
                [true] ->
                    Customer ! drink_ready,
                    orders ! {ready, self()},
                    loop([]);
                _ ->
                    loop(State)
            end;
        Msg ->
            io:format("Barista got ~p", [Msg]),
            loop(State)  
    end.