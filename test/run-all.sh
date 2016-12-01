#!/usr/bin/env bash
set -euo pipefail

expected=$(cat test/expected.html)
actual=$(cat test/configuration.json | bin/mozart)

if [ "$actual" != "$expected" ]; then
    echo "Actual output didn't match expected output."
    echo "--Expected output--"
    echo $expected
    echo "--Actual output--"
    echo $actual
    exit 65
fi
