#!/bin/bash
set -e

source dev-container-features-test-lib

check "zmx on PATH" bash -c "command -v zmx"
check "zmx at /usr/local/bin/zmx" bash -c "test -x /usr/local/bin/zmx"
check "zmx --version runs" bash -c "zmx --version"

reportResults
