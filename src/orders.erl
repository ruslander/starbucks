-module(orders).
-compile(export_all).

start()->
    Pid = spawn(?MODULE, loop, [dict:new(),queue:new()]),
    register(?MODULE, Pid),
    Pid.

stop() -> 
    ?MODULE ! stop, 
    unregister(?MODULE).


loop(Orders, Baristas)->
    receive
    	stop -> ok;
        {ready, Barista} ->
            loop(Orders, queue:in(Barista, Baristas));
    	{order_placed, OrderId}  ->
            {{value,First}, Left} = queue:out(Baristas),
    		First ! prepare,
            AppOrders = dict:append(OrderId, First, Orders),
            loop(AppOrders, Left);
        {order_paid, OrderId} ->
            [Barista] = dict:fetch(OrderId, Orders),
        	Barista ! paid,
            NewOrders = dict:erase(OrderId, Orders),
        	loop(NewOrders, Baristas);  
        Msg ->
            io:format("Orders got ~p", [Msg]),
            loop(Orders, Baristas)  
    end.