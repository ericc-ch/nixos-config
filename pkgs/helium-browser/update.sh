#!/usr/bin/env bash
set -euo pipefail

repo="imputnet/helium-linux"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

release="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")"
version="$(jq -r .tag_name <<<"$release")"
asset="helium-${version}-x86_64.AppImage"
digest="$(jq -r --arg n "$asset" '.assets[] | select(.name == $n) | .digest' <<<"$release")"
hash="$(nix hash convert --to sri --hash-algo sha256 "${digest#sha256:}")"

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "hash": "$hash"
}
EOF

echo "helium-browser: $version"
