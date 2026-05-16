#!/bin/bash
set -e

source dev-container-features-test-lib

check "claude on PATH" bash -c "command -v claude"
check "claude runs" bash -c "claude --version"
check "CLAUDE_CONFIG_DIR set" bash -c '[ "$CLAUDE_CONFIG_DIR" = "/mnt/claude-code-data" ]'
check "data dir exists" bash -c "test -d /mnt/claude-code-data"
check "data dir writable" bash -c "touch /mnt/claude-code-data/.probe && rm /mnt/claude-code-data/.probe"
check "binary at /opt/claude-code/bin" bash -c "test -x /opt/claude-code/bin/claude"
check "no shadow at /usr/local/bin" bash -c "! test -e /usr/local/bin/claude"

reportResults
