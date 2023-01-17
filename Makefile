EXECNAME := ojo
BIN := bin

run: b
	@echo "Program compiled"

b build: c $(BIN)
	@dune build
	@mv _build/default/src/main.exe ./bin/$(EXECNAME)

$(BIN):
	mkdir -p $@

t test: b
	dune test

publish:
	opam publish https://github.com/arxaqapi/$(EXECNAME)/archive/refs/tags/v0.2.1.tar.gz .

.PHONY: c clean
c clean:	
	@rm -rf _build/
	@rm -rf $(BIN)