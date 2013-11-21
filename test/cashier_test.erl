-module(cashier_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

setup() ->
    cashier:start().

cleanup(_Pid) ->
    cashier:stop().


when__new_order__gets_fired__order_placed__test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
				dependency:register(orders),
			    cashier ! new_order,
				?assertMatch([order_placed], dependency:get_calls(orders))
          end)}.

when__pay_order__gets_fired__order_paid__test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
				dependency:register(orders),
			    cashier ! pay_order,
				?assertMatch([order_paid], dependency:get_calls(orders))
          end)}.
