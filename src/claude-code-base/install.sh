#!/usr/bin/bash
set -e

REQUIRED_PACKAGES="curl ca-certificates"

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

echo "(*) Installing Claude Code via official installer..."

check_packages $REQUIRED_PACKAGES

# Run the official installer. It drops the binary at $HOME/.local/bin/claude.
# We force HOME so the install location is predictable regardless of how the
# feature is invoked during the container build.
export HOME=/root
mkdir -p "$HOME/.local/bin"
curl -fsSL https://claude.ai/install.sh | bash

# Relocate the binary to /usr/local/bin so every container user (root, vscode,
# node, ubuntu, ...) can invoke `claude` without depending on /root being
# readable.
if [ -x "$HOME/.local/bin/claude" ]; then
    install -m 0755 "$HOME/.local/bin/claude" /usr/local/bin/claude
else
    echo "Claude Code installer did not produce $HOME/.local/bin/claude" >&2
    exit 1
fi

mkdir -p /mnt/claude-code-data
chmod 0777 /mnt/claude-code-data

rm -rf /var/lib/apt/lists/*

echo "Done!"
