-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

loop(State)->
    receive
		{Pid, get} -> 
    		?debugVal(get_observed_message),
			Pid ! State;
        Any ->
    		?debugVal(observed_message),
            loop(Any)   
    end.

set_external_service(Service)->
    register(Service, spawn(cashier_test, loop, [[]])).

get_acc_message(Service)->
    orders ! {self(), get},
    Result = receive
       Any ->
       	?debugVal(Any),
        Any
	end.

bang_by_name_and_get_last_message_tes()->
	set_external_service(orders),

    orders ! order_placed,

	?assertMatch(order_placed, get_acc_message(orders)).


when_new_order_is_placed_orders_service_gets_notified_test()->
	Pid = cashier:start(),

	set_external_service(orders),

    Pid ! new_order,

	?assertMatch(order_placed, get_acc_message(orders)).

