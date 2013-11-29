-module(barista_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").


when_idle_and_prepare__then_waits_for_paid___test_() ->
    dependency:register(customer),
    Barista = spawn(barista, loop, [[]]),

    Barista ! prepare,

    ?_assertMatch([], dependency:get_calls(customer)).


when__preparing_and_paid__then__drink_ready__test_() ->

    dependency:register(customer),
    Barista = spawn(barista, loop, [[true]]),

    Barista ! paid,

    ?_assertMatch([drink_ready], dependency:get_calls(customer)).

full_when__preparing_and_paid__then__drink_ready__test_() ->

    dependency:register(customer),
    Barista = spawn(barista, loop, [[]]),

    Barista ! prepare,
    Barista ! paid,

    ?_assertMatch([drink_ready], dependency:get_calls(customer)).
