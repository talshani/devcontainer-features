#!/bin/bash
set -e

source dev-container-features-test-lib

check "mise on PATH" bash -c "command -v mise"
check "mise runs" bash -c "mise --version"
check "apt source registered" bash -c "test -f /etc/apt/sources.list.d/mise.list"
check "activation script present" bash -c "test -f /etc/profile.d/mise.sh"

reportResults
