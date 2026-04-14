#!/bin/bash
set -e

source dev-container-features-test-lib

check "mise on PATH" bash -c "command -v mise"
check "mise runs" bash -c "mise --version"
check "apt source registered" bash -c "test -f /etc/apt/sources.list.d/mise.list"
check "activation script present" bash -c "test -f /etc/profile.d/mise.sh"
check "MISE_DATA_DIR set" bash -c '[ "$MISE_DATA_DIR" = "/mnt/mise-data" ]'
check "MISE_GLOBAL_CONFIG_FILE set" bash -c '[ "$MISE_GLOBAL_CONFIG_FILE" = "/mnt/mise-data/global-config.toml" ]'
check "MISE_TRUSTED_CONFIG_PATHS set" bash -c '[ "$MISE_TRUSTED_CONFIG_PATHS" = "/workspaces" ]'
check "data dir exists" bash -c "test -d /mnt/mise-data"
check "data dir writable" bash -c "touch /mnt/mise-data/.probe && rm /mnt/mise-data/.probe"

reportResults
