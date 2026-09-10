#!/usr/bin/env bash
# OpenCode Desktop (V2 beta) ships versioned GitHub releases from the
# anomalyco/opencode-beta repo (tags look like v0.0.0-beta-19425). GitHub's
# release API pins each asset's sha256 digest, so — like chatgpt — no deb
# download is needed to hash an update.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="anomalyco/opencode-beta"
asset="opencode-desktop-linux-amd64.deb"

release="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest")"
tag="$(jq -r .tag_name <<<"$release")"
version="${tag#v}"
digest="$(jq -r --arg n "$asset" '.assets[] | select(.name == $n) | .digest' <<<"$release")"
if [ -z "$version" ] || [ "$version" = null ] || [ -z "$digest" ] || [ "$digest" = null ]; then
  echo "opencode-desktop: could not parse the latest release" >&2
  exit 1
fi

url="https://github.com/${repo}/releases/download/${tag}/${asset}"
hash="$(nix hash convert --from base16 --to sri --hash-algo sha256 "${digest#sha256:}")"

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
