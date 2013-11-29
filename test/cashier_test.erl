-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

when__new_order__gets_fired__order_placed__test_() ->
    dependency:register(orders),
    Cashier = spawn(cashier, loop, []),

    Cashier ! new_order,

    ?_assertMatch([order_placed], dependency:get_calls(orders)).

when__pay_order__gets_fired__order_paid__test_() ->
    dependency:register(orders),

    Cashier = spawn(cashier, loop, []),

    
    Cashier ! pay_order,
    
    ?_assertMatch([order_paid], dependency:get_calls(orders)).
