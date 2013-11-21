-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

catch_all_loop(State)->
    receive
		{Pid, get_result} -> 
    		?debugVal(get_observed_message),
			Pid ! State;
        Any ->
    		?debugVal(observed_message),
            catch_all_loop([Any|State])   
    end.

register_dependent_service(Service)->
    register(Service, spawn(cashier_test, catch_all_loop, [[]])).

get_received_messages_for_dependent_service(Service)->
    Service ! {self(), get_result},
    Result = receive
       Any ->
       	?debugVal(Any),
        Any
	end.

bang_by_name_and_get_last_message_test()->
	register_dependent_service(orders),

    orders ! order_placed,

	?assertMatch([order_placed], get_received_messages_for_dependent_service(orders)).


when_new_order_is_placed_orders_service_gets_notified()->
	Pid = cashier:start(),

	register_dependent_service(orders),

    cashier ! new_order,

	?assertMatch(order_placed, get_received_messages_for_dependent_service(orders)).

