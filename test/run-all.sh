#!/usr/bin/env bash
set -euo pipefail

expected_path="test/expected.html"
expected=$(cat $expected_path)
actual=$(cat test/configuration.json | bin/mozart)

if [ "$actual" != "$expected" ]; then
    echo "Actual output didn't match expected output."
    echo
    echo "--EXPECTED OUTPUT--"
    echo "$expected"
    echo
    echo "--ACTUAL OUTPUT--"
    echo "$actual"
    echo
    echo "--DIFF--"
    echo "$actual" | diff -u $expected_path -
    exit 65
else
    echo "Tests passed!"
fi
