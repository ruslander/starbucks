-module(barista_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

setup() ->
    barista:start().

cleanup(_Pid) ->
    barista:stop().


when__prepare_and_paid__gets_fired__drink_ready__test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
				      dependency:register(customer),
              barista ! prepare,
			        barista ! paid,
				      ?assertMatch([drink_ready], dependency:get_calls(customer))
          end)}.

when__prepare__gets_fired__but_nothing_follows_then__client_does_not_get_notified_test_() ->
     { setup,
       fun setup/0,
       fun cleanup/1,
       ?_test(
          begin
              dependency:register(customer),
              barista ! prepare,
              ?assertMatch([], dependency:get_calls(customer))
          end)}.
