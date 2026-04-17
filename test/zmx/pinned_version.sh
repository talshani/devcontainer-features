#!/bin/bash
set -e

source dev-container-features-test-lib

check "zmx on PATH" bash -c "command -v zmx"
check "zmx --version runs" bash -c "zmx --version"
check "installed version is 0.5.0" bash -c "zmx --version | grep -qE '^zmx[[:space:]]+0\.5\.0$'"

reportResults
