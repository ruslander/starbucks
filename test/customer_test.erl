-module(customer_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

when__drink_ready__then__I_say_thank_you_to_barista__test_() ->
    B = dependency:register(barista),
    Customer = spawn(customer, loop, [[]]),

    Customer ! {drink_ready, B},

    ?_assertMatch([thank_you], dependency:get_calls(barista)).

when__request_payment__then__I_pay_for_my_drink__test_()->
    C = dependency:register(cashier),
    Customer = spawn(customer, loop, [[]]),

    Customer ! {C, request_payment},

	?_assertMatch([{payment, Customer}], dependency:get_calls(cashier)).
