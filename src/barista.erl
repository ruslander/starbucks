-module(barista).

-behaviour(gen_server).
 
-export([start_link/0]).
 
%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).
 
-export([order_paid/0,
	order_placed/0]).

-record(state, {do}).
 
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{debug, [trace]}]).
 
order_paid()->
    gen_server:cast(?MODULE, order_paid).

order_placed()->
    gen_server:cast(?MODULE, order_placed).


init([]) ->
    {ok, #state{do=idle}}.
 
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast(order_placed, State) ->
    {noreply, State#state{do=preparing}};

handle_cast(order_paid, State) ->
	customer:drink_ready(),
    {noreply, State#state{do=done}};

handle_cast(_Msg, State) ->
    {noreply, State}.
 
handle_info(_Info, State) ->
    {noreply, State}.
 
terminate(_Reason, _State) ->
    ok.
 
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.