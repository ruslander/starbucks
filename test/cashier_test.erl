-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").


when_a_new_order_gets_placed_then_orders_gets_notified_test()->
	dependency:register(orders),
	cashier:start(),

    cashier ! new_order,

	?assertMatch([order_placed], dependency:get_calls(orders)).