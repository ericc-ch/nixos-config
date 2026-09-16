#!/usr/bin/env bash
# Chrome Dev is not on GitHub. Google publishes Linux channel versions at:
#
#   https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/dev/versions/all/releases
#
# The Deb for a listed version can lag the API, so this walks newest-first
# until a Deb actually fetches. There is no digest API, so the hash comes
# from `nix store prefetch-file` (same idea as zcode downloading to hash).
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
api="https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/dev/versions/all/releases?pageSize=20"
deb_base="https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-unstable"

releases="$(curl -fsSL "$api")"
mapfile -t versions < <(jq -r '.releases[].version' <<<"$releases")
if [ "${#versions[@]}" -eq 0 ]; then
  echo "google-chrome-dev: could not parse $api" >&2
  exit 1
fi

version=""
url=""
hash=""
for candidate in "${versions[@]}"; do
  candidate_url="${deb_base}/google-chrome-unstable_${candidate}-1_amd64.deb"
  if prefetch="$(nix store prefetch-file --json --hash-type sha256 "$candidate_url" 2>/dev/null)"; then
    version="$candidate"
    url="$candidate_url"
    hash="$(jq -r .hash <<<"$prefetch")"
    break
  fi
done

if [ -z "$version" ] || [ -z "$hash" ] || [ "$hash" = null ]; then
  echo "google-chrome-dev: no published Dev Deb among ${#versions[@]} versions" >&2
  exit 1
fi

if [ "$url" = "$(jq -r .url "$dir/metadata.json")" ]; then
  echo "google-chrome-dev: $version (up to date)"
  exit 0
fi

cat > "$dir/metadata.json" <<EOF
{
  "version": "$version",
  "url": "$url",
  "hash": "$hash"
}
EOF

echo "google-chrome-dev: $version"
