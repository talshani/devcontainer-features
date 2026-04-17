#!/usr/bin/bash
set -e

VERSION="${VERSION:-0.5.0}"

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

echo "(*) Installing zmx ${VERSION}..."

check_packages $REQUIRED_PACKAGES

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64) ZMX_ARCH="x86_64" ;;
    arm64) ZMX_ARCH="aarch64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

TARBALL_URL="https://zmx.sh/a/zmx-${VERSION}-linux-${ZMX_ARCH}.tar.gz"
WORK="$(mktemp -d -t zmx-install.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

curl -fsSL "$TARBALL_URL" -o "$WORK/zmx.tar.gz"
tar -xzf "$WORK/zmx.tar.gz" -C "$WORK"
install -m 0755 "$WORK/zmx" /usr/local/bin/zmx

if ! /usr/local/bin/zmx --version > /dev/null 2>&1; then
    echo "zmx binary did not run successfully after install" >&2
    exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "Done!"
