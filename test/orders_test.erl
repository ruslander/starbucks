-module(orders_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

when__order_placed__then__1workItem_is_enquied_test_()->
    Orders = spawn(orders, loop, [queue:new(), queue:new(), dict:new()]),

    Orders ! {order_placed, make_ref()},

    {OrdersQueue, _, _} = dependency:get_state(Orders),

    ?_assertEqual(1, queue:len(OrdersQueue)).

when__barista_ready__then__1worker_is_enquied_test_()->
    Orders = spawn(orders, loop, [queue:new(), queue:new(), dict:new()]),

    Orders ! {ready, make_ref()},

    {_, BarsitasQueue, _} = dependency:get_state(Orders),

    ?_assertEqual(1, queue:len(BarsitasQueue)).


given_there_is_1_order_placed__when_barsta_ready__then_rised_prepare_test_()->
    
    With1Order = queue:in(order10000, queue:new()),
    Orders = spawn(orders, loop, [With1Order, queue:new(), dict:new()]),
    B1 = dependency:register(barista),
    
    Orders ! {ready, B1},

    ?_assertMatch([prepare], dependency:get_calls(barista)).

given_there_is_1_barista_ready__when_order_placed__then_rised_prepare_test_()->
    
    B1 = dependency:register(barista),
    With1Barista = queue:in(B1, queue:new()),
    Orders = spawn(orders, loop, [queue:new(), With1Barista, dict:new()]),
    
    Orders ! {order_placed, make_ref()},

    ?_assertMatch([prepare], dependency:get_calls(barista)).

given_there_is_1_barista_ready__when_order_placed__then_is_registered_1wip_test_()->
    
    B1 = dependency:register(barista),
    With1Barista = queue:in(B1, queue:new()),
    Orders = spawn(orders, loop, [queue:new(), With1Barista, dict:new()]),
    
    Orders ! {order_placed, make_ref()},
    {_, _, Wip} = dependency:get_state(Orders),

    ?_assertMatch(1, dict:size(Wip)).

given_barsita_is_preparing__when_order_is_paid__then_barista_hands_the_drink_test_()->

    B1 = dependency:register(barista),
    OrderId = make_ref(),
    Wip = dict:append(OrderId, B1, dict:new()),
    Orders = spawn(orders, loop, [queue:new(), queue:new(), Wip]),
    
    Orders ! {order_paid, OrderId},

    ?_assertMatch([{paid, OrderId}], dependency:get_calls(barista)).
