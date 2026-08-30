#!/usr/bin/env bash
# Grok Bot is not on GitHub releases, so this differs from the other packages:
# the latest build is discovered from the app's own update feed
# (reverse-engineered from the Electron updater inside the deb).
#
#   GET https://api2.cursor.sh/updates/api/update/{platform}/{track}/{version}/{machineId}/stable
#   track = sand (stable) | sand-nightly | sand-dogfood
#   -> 200 {"version","url"} when newer exists, 204 when current
#
# Asking with a fake old version always returns the latest. The feed links an
# AppImage .zsync that is 403 for direct download; rewrite it to the .deb path,
# which is public. Unlike the GitHub-based packages there is no digest API, so
# this script downloads the deb (~100 MB) to compute the SRI hash.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

feed="https://api2.cursor.sh/updates/api/update/linux-x64/sand/0.0.0/00000000-0000-0000-0000-000000000000/stable"

response="$(curl -fsSL "$feed")"
version="$(jq -r .version <<<"$response")"
appimage_url="$(jq -r .url <<<"$response")"
if [ -z "$version" ] || [ "$version" = null ]; then
  echo "grok-bot: could not parse update feed response" >&2
  exit 1
fi

url="${appimage_url%/*}/grok-bot_${version}_amd64.deb"

if [ "$url" = "$(jq -r .url "$dir/metadata.json")" ]; then
  echo "grok-bot: $version (up to date)"
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

echo "grok-bot: $version"
