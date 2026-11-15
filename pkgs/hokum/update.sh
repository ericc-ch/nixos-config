#!/usr/bin/env bash
# Hokum publishes a channel manifest that carries the sha256 of every
# artifact, so the bump reads the hash instead of downloading the deb.
#
# This tracks the dev channel: stable (0.1.3) is the notification daemon
# alone, while the Sound/Bluetooth window and volume/brightness cards only
# ship on dev. Move to stable.json once those land in a release.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

manifest="$(curl -fsSL https://anoma.ly/release/hokum/desktop/dev.json)"

version="$(jq -r '.release.version' <<<"$manifest")"
path="$(jq -r '.release.targets["linux-x64-deb"].url' <<<"$manifest")"
sha256="$(jq -r '.release.targets["linux-x64-deb"].sha256' <<<"$manifest")"
url="https://anoma.ly$path"
hash="$(nix hash convert --to sri --hash-algo sha256 "$sha256")"

if [ "$version" = "$(jq -r .version "$dir/metadata.json")" ]; then
  echo "hokum: $version (up to date)"
  exit 0
fi

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "hokum: $version"
