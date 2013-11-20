
all: clean compile eunit

eunit:
	erl -noshell -pa ebin -eval 'eunit:test("ebin").' -s init stop	

compile:
	erlc -o ebin/ src/*.erl test/*.erl

clean:
	rm -rf ebin
	mkdir ebin

