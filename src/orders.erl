-module(orders).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [queue:new()]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).

register_idle_barista(Barista, Baristas)->
    queue:in(Barista, Baristas).

new_order_placed(Order, Orders)->
    queue:in(Order, Orders).

%order_was_paid(OrderId, Orders)->
%    AppOrders = dict:append(OrderId, First, Orders),
%    [Barista] = dict:fetch(OrderId, Orders),
%    NewOrders = dict:erase(OrderId, Orders),
%    Barista ! paid,
%    NewOrders.

loop(Orders)->
    receive
        stop -> ok;
        {get_state, Pid} -> 
            Pid ! {Orders},
            loop(Orders);
        {ready, _Barista} ->
            loop(Orders);
    	{order_placed, OrderId} ->
            NewOrders = new_order_placed(OrderId, Orders),
            loop(NewOrders);
        {order_paid, _OrderId} ->
        	loop(Orders);  
        Msg ->
            io:format("Orders got ~p", [Msg]),
            loop(Orders)  
    end.