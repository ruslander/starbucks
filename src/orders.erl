-module(orders).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [dict:new(),queue:new()]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

register_idle_barista(Barista, Baristas)->
    queue:in(Barista, Baristas).

new_order_placed(OrderId, Orders, Baristas)->
    {{value,First}, Left} = queue:out(Baristas),
    AppOrders = dict:append(OrderId, First, Orders),
    First ! prepare,
    {AppOrders, Left}.

order_was_paid(OrderId, Orders)->
    [Barista] = dict:fetch(OrderId, Orders),
    NewOrders = dict:erase(OrderId, Orders),
    Barista ! paid,
    NewOrders.

loop(Orders, Baristas)->
    receive
    	stop -> ok;
        {ready, Barista} ->
            loop(Orders, register_idle_barista(Barista, Baristas));
    	{order_placed, OrderId} ->
            {NewOrders, Left} = new_order_placed(OrderId, Orders, Baristas),
            loop(NewOrders, Left);
        {order_paid, OrderId} ->
            NewOrders = order_was_paid(OrderId, Orders),
        	loop(NewOrders, Baristas);  
        Msg ->
            io:format("Orders got ~p", [Msg]),
            loop(Orders, Baristas)  
    end.