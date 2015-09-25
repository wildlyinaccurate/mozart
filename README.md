# Mozart

## Installation

You'll need a recent version of GHC and Cabal.

```
$ git clone https://github.com/wildlyinaccurate/mozart.git
$ cd mozart
$ cabal sandbox init
$ cabal install
$ cabal build
```

## Usage

```
$ cat /path/to/the/configuration.json | bin/mozart
```

## Configuration Format

A configuration file must be a list of component objects as JSON. See [test.json](test.json) for an example configuration.

## huh?

shhh.
