#!/usr/bin/env bash
# Hex tags app releases as `vX.Y.Z` beside TypeScript SDK releases
# (`@kitlangton/hex@…`), so the newest tag by date is not necessarily an app.
# Pick the highest `vX.Y.Z` instead, then read the deb's SRI hash from the
# release asset's `digest`: no download needed, unlike zcode/grok-bot.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

release="$(curl -fsSL 'https://api.github.com/repos/anomalyco/hex/releases?per_page=100' |
  jq -c '[.[] | select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))]
         | max_by(.tag_name | ltrimstr("v") | split(".") | map(tonumber))')"
if [ -z "$release" ] || [ "$release" = null ]; then
  echo "hex: no vX.Y.Z release in the releases API" >&2
  exit 1
fi

version="$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")"
url="https://github.com/anomalyco/hex/releases/download/v$version/hex-$version-linux-x64.deb"

sha256="$(jq -r --arg name "hex-$version-linux-x64.deb" '
  .assets[] | select(.name == $name) | .digest // empty' <<<"$release")"
if [ -z "$sha256" ]; then
  echo "hex: no sha256 digest for $url; hash it by hand" >&2
  exit 1
fi
hash="$(nix hash convert --to sri --hash-algo sha256 "${sha256#sha256:}")"

if [ "$version" = "$(jq -r .version "$dir/metadata.json")" ]; then
  echo "hex: $version (up to date)"
  exit 0
fi

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "hex: $version"
