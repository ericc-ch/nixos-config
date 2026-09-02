#!/usr/bin/env bash
# ChatGPT (Codex) desktop app is not on GitHub releases. OpenAI serves a
# floating "latest" deb URL:
#
#   https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb
#
# ...and the deb ships a real apt repository whose Packages index pins the
# current version plus its SHA256:
#
#   https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages
#
# So — unlike zcode/grok-bot — no deb download is needed to hash an update.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="https://persistent.oaistatic.com/codex-app-prod/linux/deb"
index="$repo/dists/stable/main/binary-amd64/Packages"

stanza="$(curl -fsSL "$index")"
version="$(grep -m1 '^Version: ' <<<"$stanza" | cut -d' ' -f2)"
path="$(grep -m1 '^Filename: ' <<<"$stanza" | cut -d' ' -f2)"
sha256="$(grep -m1 '^SHA256: ' <<<"$stanza" | cut -d' ' -f2)"
if [ -z "$version" ] || [ -z "$path" ] || [ -z "$sha256" ]; then
  echo "chatgpt: could not parse $index" >&2
  exit 1
fi

url="$repo/$path"
hash="$(nix hash convert --to sri --hash-algo sha256 "$sha256")"

if [ "$version" = "$(jq -r .version "$dir/metadata.json")" ]; then
  echo "chatgpt: $version (up to date)"
  exit 0
fi

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "chatgpt: $version"
