-module(barista).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [[]]),
    log("started"),
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
            log("got prepare"),
            loop([true]);
        {paid, Customer} ->
            log("got paid"),
            case State of
                [true] ->
                    Customer ! {drink_ready, self()},
                    orders ! {ready, self()},
                    loop([]);
                _ ->
                    loop(State)
            end;
        thank_you ->
            log("got thank_you"),
            loop(State);  
        Msg ->
            io:format("Barista got ~p", [Msg]),
            loop(State)  
    end.

log(M)->
 io:format("~s ~s ~n", [atom_to_list(?MODULE), M]).
