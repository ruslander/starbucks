-module(barista_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").


when_prepare__then__no_action___test_() ->
    dependency:register(customer),
    Barista = spawn(barista, loop, [[]]),

    Barista ! prepare,

    ?_assertMatch([], dependency:get_calls(customer)).

when_paid__then__drink_ready__test_() ->

    dependency:register(orders),
    C = dependency:register(customer),
    Barista = spawn(barista, loop, [[true]]),

    Barista ! {paid, C},

    ?_assertMatch([{drink_ready, Barista}], dependency:get_calls(C)).

when_paid__then__ready__test_() ->

    dependency:register(orders),
    C = dependency:register(customer),
    Barista = spawn(barista, loop, [[true]]),
    
    Barista ! {paid, C},

    ?_assertMatch([{ready, Barista}], dependency:get_calls(orders)).
