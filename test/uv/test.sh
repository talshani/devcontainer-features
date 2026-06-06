#!/bin/bash
set -e

source dev-container-features-test-lib

check "uv on PATH" bash -c "command -v uv"
check "uv at /usr/local/bin/uv" bash -c "test -x /usr/local/bin/uv"
check "uvx on PATH" bash -c "command -v uvx"
check "uv --version runs" bash -c "uv --version"
check "uvx --version runs" bash -c "uvx --version"

reportResults
