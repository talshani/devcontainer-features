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
# Put ~/.local/bin on PATH for the installer's own post-install check, so it
# does not print a misleading "not in your PATH" warning during the build.
export PATH="$HOME/.local/bin:$PATH"
curl -fsSL https://claude.ai/install.sh | bash

# Relocate the binary to /opt/claude-code/bin so every container user (root,
# vscode, node, ubuntu, ...) can invoke `claude` without depending on /root
# being readable. We deliberately avoid /usr/local/bin: Claude Code's
# self-updater writes to $HOME/.local/bin/claude, and we want the user copy to
# win once it exists. PATH is ordered as ~/.local/bin : /opt/claude-code/bin
# via the snippet below.
mkdir -p /opt/claude-code/bin
if [ -x "$HOME/.local/bin/claude" ]; then
    install -m 0755 "$HOME/.local/bin/claude" /opt/claude-code/bin/claude
else
    echo "Claude Code installer did not produce $HOME/.local/bin/claude" >&2
    exit 1
fi

# Remove the installer's leftover copy under /root so that future root login
# shells (which have $HOME/.local/bin prepended by our profile snippet) do not
# resolve `claude` to a stale per-user binary instead of the shared one in
# /opt/claude-code/bin. Other users will populate their own ~/.local/bin via
# the self-updater on first run.
rm -rf "$HOME/.local/share/claude" "$HOME/.local/bin/claude"

mkdir -p /mnt/claude-code-data
chmod 0777 /mnt/claude-code-data

# Put ~/.local/bin (where Claude Code self-updates land) ahead of the baked-in
# /opt/claude-code/bin on PATH for every user. The snippet is idempotent and
# is sourced from both login and non-login interactive shells so VS Code's
# integrated terminal (which does not always start a login shell) picks it up.
cat > /etc/profile.d/claude-code-path.sh <<'EOF'
# Added by the claude-code-base devcontainer feature.
case ":$PATH:" in
    *":/opt/claude-code/bin:"*) ;;
    *) export PATH="$PATH:/opt/claude-code/bin" ;;
esac
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF
chmod 0644 /etc/profile.d/claude-code-path.sh

# /etc/profile.d/*.sh only runs for login shells. VS Code's integrated
# terminal often spawns non-login interactive shells, so also wire the snippet
# into the system bash and zsh rc files.
if [ -f /etc/bash.bashrc ] && ! grep -q 'claude-code-path.sh' /etc/bash.bashrc; then
    printf '\n# Added by the claude-code-base devcontainer feature.\n. /etc/profile.d/claude-code-path.sh\n' >> /etc/bash.bashrc
fi
mkdir -p /etc/zsh
if [ ! -f /etc/zsh/zshenv ] || ! grep -q 'claude-code-path.sh' /etc/zsh/zshenv; then
    printf '\n# Added by the claude-code-base devcontainer feature.\n. /etc/profile.d/claude-code-path.sh\n' >> /etc/zsh/zshenv
fi

rm -rf /var/lib/apt/lists/*

echo "Done!"
