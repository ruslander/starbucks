-module(dependency).
-compile(export_all).

catch_all_loop(State)->
    receive
        {Source, get_result} -> 
            Source ! State;
        Any -> 
            catch_all_loop([Any|State])   
    end.

kill_if_exists(Service)->
    case whereis(Service) of
        undefined ->ok;
        Old ->
            unregister(Service),
            true = exit(Old, kill)
    end.

register(Service)->
    Pid = spawn(dependency, catch_all_loop, [[]]),
    
    kill_if_exists(Service),    

    register(Service, Pid),
    Pid.

get_state(Service)->
    timer:sleep(1),
    Service ! {get_state, self()},
    receive
       Any -> 
            Any
    end.

get_calls(Service)->
    timer:sleep(1),
    Service ! {self(), get_result},
    receive
       Any -> 
            Any
    end.

