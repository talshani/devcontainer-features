#!/bin/bash
set -e

source dev-container-features-test-lib

check "claude on PATH" bash -c "command -v claude"
check "claude runs" bash -c "claude --version"
check "CLAUDE_CONFIG_DIR set" bash -c '[ "$CLAUDE_CONFIG_DIR" = "/mnt/claude-code-data" ]'
check "data dir exists" bash -c "test -d /mnt/claude-code-data"
check "data dir writable" bash -c "touch /mnt/claude-code-data/.probe && rm /mnt/claude-code-data/.probe"

# 1.1.0: binary lives in /opt/claude-code/bin, not /usr/local/bin, so the
# user-local self-update at ~/.local/bin/claude can take precedence.
check "binary at /opt/claude-code/bin" bash -c "test -x /opt/claude-code/bin/claude"
check "no shadow at /usr/local/bin" bash -c "! test -e /usr/local/bin/claude"
check "claude resolves to /opt/claude-code/bin in login bash" bash -lc '[ "$(command -v claude)" = "/opt/claude-code/bin/claude" ]'
check "claude resolves in non-login bash" bash -c '[ "$(command -v claude)" = "/opt/claude-code/bin/claude" ]'

# Simulate a self-updated user copy and verify it wins on PATH.
check "user-local ~/.local/bin/claude wins" bash -c '
    set -e
    mkdir -p "$HOME/.local/bin"
    printf "#!/bin/sh\necho user-local\n" > "$HOME/.local/bin/claude"
    chmod +x "$HOME/.local/bin/claude"
    out=$(bash -lc "claude")
    rm -f "$HOME/.local/bin/claude"
    [ "$out" = "user-local" ]
'

reportResults
