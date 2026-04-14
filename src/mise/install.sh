#!/usr/bin/bash
set -e

REQUIRED_PACKAGES="gpg sudo wget curl ca-certificates"

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

echo "(*) Installing mise-en-place via apt..."

check_packages $REQUIRED_PACKAGES

install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/mise-archive-keyring.gpg

ARCH="$(dpkg --print-architecture)"
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=${ARCH}] https://mise.jdx.dev/deb stable main" \
    > /etc/apt/sources.list.d/mise.list

apt-get update -y
apt-get install -y mise

cat > /etc/profile.d/mise.sh << 'EOF'
if [ -n "$ZSH_VERSION" ]; then
    eval "$(mise activate zsh)"
elif [ -n "$BASH_VERSION" ]; then
    eval "$(mise activate bash)"
fi
EOF

rm -rf /var/lib/apt/lists/*

mkdir -p /mnt/mise-data
chmod 0777 /mnt/mise-data

echo "Done!"
