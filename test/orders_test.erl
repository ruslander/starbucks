-module(orders_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

when__order_placed__then__1workItem_is_enquied_test_()->
    Orders = spawn(orders, loop, [queue:new()]),

    Orders ! {order_placed, make_ref()},

    {OrdersQueue} = dependency:get_state(Orders),

    ?_assertEqual(1, queue:len(OrdersQueue)).

%    orders: when order is paid then is marked as paid and can be handed to the customer
%    orders: when order in progress is paid then barista gets notified


when__order_placed__gets_fired__barista_gets_prepare_tes() ->

    Orders = spawn(orders, loop, [dict:new(),queue:new()]),
    B1 = dependency:register(barista),
    Orders ! {ready, B1},

    Orders ! {order_placed, make_ref()},

    ?_assertMatch([prepare], dependency:get_calls(barista)).

when__order_paid__gets_notified__first_available_barista_tes() ->
    Orders = spawn(orders, loop, [dict:new(),queue:new()]),

    B1 = dependency:register(barista),
    Orders ! {ready, B1},

    B2 = dependency:register(barista3),
    Orders ! {ready, B2},

    OrderId = make_ref(),

    Orders ! {order_placed, OrderId},
    Orders ! {order_placed, make_ref()},
    Orders ! {order_paid, OrderId},

    ?_assertMatch([paid,prepare], dependency:get_calls(barista)).
