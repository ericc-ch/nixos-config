#!/usr/bin/env bash
# OpenCode Desktop (V2) ships through opencode.ai's electron-updater feed.
# The feed's latest-linux.yml pins each file's sha512 (base64), so — like
# chatgpt — no deb download is needed to hash an update. The beta feed
# (https://opencode.ai/update/api/beta/desktop/opencode/) lags the stable
# one; set OPENCODE_DESKTOP_FEED to track it instead.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
feed="${OPENCODE_DESKTOP_FEED:-https://opencode.ai/update/api/latest/desktop/opencode/latest-linux.yml}"
asset="opencode-desktop-linux-amd64.deb"

yml="$(curl -fsSL "$feed")"
version="$(sed -n 's/^version: *//p' <<<"$yml")"
url="$(grep -o "https://[^ ]*/${asset}" <<<"$yml" | head -1)"
sha512="$(awk -v want="$asset" '
  $0 ~ want { found = 1; next }
  found && /sha512:/ { sub(/^ *sha512: */, ""); print; exit }
' <<<"$yml")"

if [ -z "$version" ] || [ -z "$url" ] || [ -z "$sha512" ]; then
  echo "opencode-desktop: could not parse the update feed" >&2
  exit 1
fi

hash="$(nix hash convert --from base64 --to sri --hash-algo sha512 "$sha512")"

if [ "$version" = "$(jq -r .version "$dir/metadata.json")" ]; then
  echo "opencode-desktop: $version (up to date)"
  exit 0
fi

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "opencode-desktop: $version"
