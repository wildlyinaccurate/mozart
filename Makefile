all: build test

build:
	cabal build

test:
	cat test.json | bin/mozart
