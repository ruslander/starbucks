-module(orders_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

setup() ->
    orders:start().

cleanup(_Pid) ->
    orders:stop().


when__order_placed__gets_fired__first_barista_gets_prepare_test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
    				  B1 = dependency:register(barista),
    			    orders ! {ready, B1},

              B2 = dependency:register(barista2),
              orders ! {ready, B2},

              orders ! {order_placed, make_ref()},

    				  ?assertMatch([prepare], dependency:get_calls(barista))
          end)}.

when__order_paid__gets_notified__correct_barista_test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
              B1 = dependency:register(barista),
              orders ! {ready, B1},

              B2 = dependency:register(barista3),
              orders ! {ready, B2},

              OrderId = make_ref(),

              orders ! {order_placed, OrderId},
              orders ! {order_placed, make_ref()},
              orders ! {order_paid, OrderId},

              ?assertMatch([paid,prepare], dependency:get_calls(barista))
          end)}.
