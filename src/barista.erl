-module(barista).
-compile(export_all).

-define(Log(M), io:format("~s ~s ~n", [atom_to_list(?MODULE), M])).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    ?Log("started"),
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
            ?Log("got prepare"),
            loop([true]);
        {paid, Customer} ->
            ?Log("got paid"),
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