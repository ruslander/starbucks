-module(orders).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [queue:new(), queue:new(), dict:new()]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

new_order_placed(Order, Orders)->
    queue:in(Order, Orders).

new_barista_ready(Barsita, Baristas)->
    queue:in(Barsita, Baristas).

assign_order_to_barista(Orders, Baristas, Wip)->
    case {queue:is_empty(Orders), queue:is_empty(Baristas)} of
        {false, false} ->
            {{value, Order}, NewOrders} = queue:out(Orders),
            {{value, Barista}, NewBaristas} = queue:out(Baristas),

            Barista ! prepare,

            {NewOrders, NewBaristas, dict:append(Order, Barista, Wip)};
        Other -> 
            {Orders, Baristas, Wip}
    end.

order_paid_customer_is_ready_to_go(Wip, OrderId) ->
    [Barista] = dict:fetch(OrderId, Wip),
    NewWip = dict:erase(OrderId, Wip),
    Barista ! {paid, OrderId},
    NewWip.

loop(Orders, Baristas, Wip)->
    receive
        stop -> ok;
        {get_state, Pid} -> 
            Pid ! {Orders, Baristas, Wip},
            loop(Orders, Baristas, Wip);
        {ready, Barista} ->
            MoreBaristas = new_barista_ready(Barista, Baristas),
            {NewOrders, NewBaristas, NewWip} = assign_order_to_barista(Orders, MoreBaristas, Wip),
            loop(NewOrders, NewBaristas, NewWip);
    	{order_placed, OrderId} ->
            MoreOrders = new_order_placed(OrderId, Orders),
            {NewOrders, NewBaristas, NewWip} = assign_order_to_barista(MoreOrders, Baristas, Wip),
            loop(NewOrders, NewBaristas, NewWip);
        {order_paid, OrderId} ->
            NewWip = order_paid_customer_is_ready_to_go(Wip, OrderId),
        	loop(Orders, Baristas, NewWip);  
        Msg ->
            io:format("Orders got ~p", [Msg]),
            loop(Orders, Baristas, Wip)  
    end.