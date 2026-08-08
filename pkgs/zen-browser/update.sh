#!/usr/bin/env bash
set -euo pipefail

repo="zen-browser/desktop"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

release="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")"
version="$(jq -r .tag_name <<<"$release")"

hash_x86="$(jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.xz") | .digest' <<<"$release")"
hash_arm="$(jq -r '.assets[] | select(.name == "zen.linux-aarch64.tar.xz") | .digest' <<<"$release")"
hash_x86="$(nix hash convert --to sri --hash-algo sha256 "${hash_x86#sha256:}")"
hash_arm="$(nix hash convert --to sri --hash-algo sha256 "${hash_arm#sha256:}")"

cat > "$dir/sources.json" <<EOF
{
  "version": "$version",
  "x86_64-linux": {
    "url": "https://github.com/zen-browser/desktop/releases/download/$version/zen.linux-x86_64.tar.xz",
    "hash": "$hash_x86"
  },
  "aarch64-linux": {
    "url": "https://github.com/zen-browser/desktop/releases/download/$version/zen.linux-aarch64.tar.xz",
    "hash": "$hash_arm"
  }
}
EOF

echo "zen-browser: $version"
