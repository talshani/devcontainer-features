#!/bin/bash
set -e

source dev-container-features-test-lib

check "uv on PATH" bash -c "command -v uv"
check "uv --version runs" bash -c "uv --version"
check "installed version is 0.11.19" bash -c "uv --version | grep -qE '^uv[[:space:]]+0\.11\.19( |$)'"

reportResults
