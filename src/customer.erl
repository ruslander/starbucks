-module(customer).

-behaviour(gen_server).
 
-export([start_link/0]).
 
%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([
    want_to_drink/0,
    pay_the_drink/0,
    drink_ready/0
    ]).
 
-record(state, {order}).
 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{debug, [trace]}]).

want_to_drink()-> 
    gen_server:call(?MODULE, want_to_drink).
pay_the_drink()-> 
    gen_server:call(?MODULE, pay_the_drink).
drink_ready()-> 
    gen_server:call(?MODULE, drink_ready).

init([]) ->
    {ok, #state{}}.

handle_call(drink_ready, _From, State) ->
    {reply, yay, State#state{order=done}};
handle_call(pay_the_drink, _From, #state{order=Order} = State) ->
    ok = cashier:pay_order(Order),
    {reply, ok, State#state{order=payed}};
handle_call(want_to_drink, _From, State) ->
    {payment_request,Order} = cashier:new_order(),
    {reply, ok, State#state{order=Order}};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.
 
handle_cast(_Msg, State) ->
    {noreply, State}.
 
handle_info(_Info, State) ->
    {noreply, State}.
 
terminate(_Reason, _State) ->
    ok.
 
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.