-module(cashier).

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
    new_order/0,
    pay_order/1
    ]).
 
-record(state, {id=0}).
 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{debug, [trace]}]).

new_order()-> 
    gen_server:call(?MODULE, {new_order, self()}).

pay_order(OrderId)-> 
    gen_server:call(?MODULE, {pay_order, self(), OrderId}).

init([]) ->
    {ok, #state{}}.

handle_call({pay_order, Customer, OrderId}, _From, State) ->

    barista:order_paid(),

    {reply, ok, State};

handle_call({new_order, Customer}, _From, #state{id=LastId} = State) ->
    OrderId = LastId +1,

    barista:order_placed(),

    {reply, {payment_request, OrderId}, State#state{id=OrderId}};

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