-module(app).
-compile(export_all).

start()->

	application:start(sync),

	{ok,_} = customer:start_link(),
	{ok,_} = cashier:start_link(),
	{ok,_} = barista:start_link()

	.
