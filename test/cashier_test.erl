-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

when__new_order__gets_fired__order_placed_gets_fired__test_() ->
    dependency:register(orders),
    Cashier = spawn(cashier, loop, []),

    Cashier ! {new_order, Cashier},

    ?_assertMatch([{order_placed, Cashier}], dependency:get_calls(orders)).

when__new_order__then_customer_is_asked_to_pay__test_() ->
    dependency:register(orders),
    C = dependency:register(customer),
    Cashier = spawn(cashier, loop, []),

    Cashier ! {new_order, C},

    ?_assertMatch([{Cashier, request_payment}], dependency:get_calls(customer)).

when__payment__then__order_paid__gets_fired__test_() ->
    dependency:register(orders),
    Cashier = spawn(cashier, loop, []),

    Customer = self(),
    
    Cashier ! {payment, Customer},
    
    ?_assertMatch([{order_paid, Customer}], dependency:get_calls(orders)).
