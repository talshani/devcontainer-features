#!/usr/bin/bash
set -e

VERSION="${VERSION:-0.11.19}"

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

echo "(*) Installing uv ${VERSION}..."

check_packages $REQUIRED_PACKAGES

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64) UV_ARCH="x86_64" ;;
    arm64) UV_ARCH="aarch64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}" >&2
        exit 1
        ;;
esac

TARGET="${UV_ARCH}-unknown-linux-gnu"

if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_BASE="https://github.com/astral-sh/uv/releases/latest/download"
else
    DOWNLOAD_BASE="https://github.com/astral-sh/uv/releases/download/${VERSION}"
fi
TARBALL_URL="${DOWNLOAD_BASE}/uv-${TARGET}.tar.gz"

WORK="$(mktemp -d -t uv-install.XXXXXX)"
trap 'rm -rf "$WORK"' EXIT

curl -fsSL "$TARBALL_URL" -o "$WORK/uv.tar.gz"
tar -xzf "$WORK/uv.tar.gz" -C "$WORK"

# The tarball extracts into a directory named after the target triple
# (e.g. uv-x86_64-unknown-linux-gnu/) containing the uv and uvx binaries.
BIN_DIR="$WORK/uv-${TARGET}"
install -m 0755 "$BIN_DIR/uv" /usr/local/bin/uv
install -m 0755 "$BIN_DIR/uvx" /usr/local/bin/uvx

if ! /usr/local/bin/uv --version > /dev/null 2>&1; then
    echo "uv binary did not run successfully after install" >&2
    exit 1
fi

rm -rf /var/lib/apt/lists/*

echo "Done!"
