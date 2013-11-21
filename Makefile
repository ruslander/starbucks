
all: clean compile eunit

eunit:
	erl -noshell -pa ebin -eval 'eunit:test("ebin", [verbose]).' -s init stop	

compile:
	erlc -o ebin/ src/*.erl test/*.erl

run: 
	erl -pa ebin -s sync	

clean:
	rm -rf ebin
	mkdir ebin

