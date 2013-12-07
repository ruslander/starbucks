-module(starbucks_end_to_end_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").


coffe_test_() ->

    dependency:kill_if_exists(orders),
    dependency:kill_if_exists(customer),
    dependency:kill_if_exists(barista),
    dependency:kill_if_exists(cashier),
    
    Orders = orders:start(),

    Barista = barista:start(),
    orders:ready(Barista),

    Cashier = cashier:start(),
    Customer = customer:start(),

    ok = customer:want_coffe(Cashier, Customer),

    ?_assertMatch(drink_ready, dependency:get_state(Customer)).


%Orders = orders:start(),Barista = barista:start(),orders:ready(Barista),Cashier = cashier:start(),Customer = customer:start().
