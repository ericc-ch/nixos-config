#!/usr/bin/env bash
# ZCode is not on GitHub releases and its CDN has no electron-builder update
# feed (latest-linux.yml 404s), so the latest version is scraped from the
# download page, which is server-rendered and embeds the version in every
# download link:
#
#   https://zcode.z.ai/en -> .../releases/{version}/linux-x64/ZCode-{version}-linux-x64.deb
#
# There is no digest API, so this downloads the deb (~140 MB) to compute the
# SRI hash.
set -euo pipefail

page="https://zcode.z.ai/en"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

html="$(curl -fsSL "$page")"
version="$(grep -oE 'releases/[0-9.]+/linux-x64/ZCode-[0-9.]+-linux-x64\.deb' <<<"$html" \
  | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -uV | tail -1)"
if [ -z "$version" ]; then
  echo "zcode: could not find a version on $page" >&2
  exit 1
fi

url="https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.deb"

if [ "$url" = "$(jq -r .url "$dir/metadata.json")" ]; then
  echo "zcode: $version (up to date)"
  exit 0
fi

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL -o "$tmp" "$url"
hash="$(nix hash convert --to sri --hash-algo sha256 "$(sha256sum "$tmp" | cut -d' ' -f1)")"

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "zcode: $version"
