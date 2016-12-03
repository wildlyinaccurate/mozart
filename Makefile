.PHONY: all build test

all: build test

build:
	cabal build --ghc-options="-Wall"

test:
	@echo 'Remember to run `python2 -m SimpleHTTPServer 8000` before `make test`'
	test/run-all.sh
