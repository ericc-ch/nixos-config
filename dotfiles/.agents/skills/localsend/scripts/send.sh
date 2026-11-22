#!/usr/bin/env bash
# Send files to a LocalSend device. Requires curl, jq, sha256sum, file.
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
usage: send.sh [--pin PIN] <target> <file>...

  target   Tailscale hostname (s25fe) or ip[:port]
  file     one or more files to send
EOF
  exit 2
}

pin=""
if [[ ${1:-} == --pin ]]; then
  [[ $# -ge 3 ]] || usage
  pin=$2
  shift 2
fi
[[ $# -ge 2 ]] || usage
target=$1
shift
files=("$@")

for f in "${files[@]}"; do
  [[ -f $f ]] || { echo "no such file: $f" >&2; exit 1; }
done

host=${target%:*}
port=${target##*:}
if [[ $target != *:* ]]; then
  port=53317
fi

if [[ ! $host =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
  resolved=$(tailscale status --json 2>/dev/null |
    jq -r --arg h "$host" '.Peer[] | select((.DNSName | split(".")[0]) == $h or .HostName == $h) | .TailscaleIPs[0]' |
    head -n1)
  if [[ -n $resolved ]]; then
    host=$resolved
  fi
fi

scheme=""
for candidate in http https; do
  if curl -sk -m 4 -f -o /dev/null "$candidate://$host:$port/api/localsend/v2/info" 2>/dev/null; then
    scheme=$candidate
    break
  fi
done
[[ -n $scheme ]] || { echo "device $host:$port is not answering. Open LocalSend on Receive and try again." >&2; exit 1; }

base="$scheme://$host:$port"
alias_name=$(curl -sk -m 4 "$base/api/localsend/v2/info" | jq -r '.alias // "unknown"')
fingerprint=$(printf '%s' "$(hostname)-$(id -u)" | sha256sum | cut -d' ' -f1)

entries=""
file_ids=()
n=0
for f in "${files[@]}"; do
  n=$((n + 1))
  id="f$n"
  file_ids+=("$id")
  entries+=$(jq -cn \
    --arg id "$id" \
    --arg name "$(basename "$f")" \
    --argjson size "$(stat -c %s "$f")" \
    --arg type "$(file --mime-type -b "$f")" \
    --arg hash "$(sha256sum "$f" | cut -d' ' -f1)" \
    '{($id): {id: $id, fileName: $name, size: $size, fileType: $type, sha256: $hash, preview: null}}')
done
files_json=$(jq -s 'add' <<<"$entries")

body=$(jq -cn \
  --argjson files "$files_json" \
  --arg fp "$fingerprint" \
  --arg scheme "$scheme" \
  --argjson port "$port" \
  '{info: {alias: "gl503ge", version: "2.2", deviceModel: "Linux", deviceType: "desktop",
           fingerprint: $fp, port: $port, protocol: $scheme, download: false},
    files: $files}')

url="$base/api/localsend/v2/prepare-upload"
[[ -n $pin ]] && url="$url?pin=$pin"

response=$(curl -sk -m 30 -w $'\n%{http_code}' \
  -H 'Content-Type: application/json' \
  --data-binary "$body" \
  "$url")
status=${response##*$'\n'}
response=${response%$'\n'*}

case $status in
  200) ;;
  401)
    echo "device $alias_name needs a PIN: rerun with --pin <code>" >&2
    exit 3
    ;;
  *)
    echo "prepare-upload failed with HTTP $status: $response" >&2
    exit 1
    ;;
esac

session=$(jq -r '.sessionId' <<<"$response")

for i in "${!file_ids[@]}"; do
  id=${file_ids[$i]}
  f=${files[$i]}
  token=$(jq -r --arg id "$id" '.files[$id]' <<<"$response")
  curl -sk -m 600 -f -o /dev/null \
    -H 'Content-Type: application/octet-stream' \
    --data-binary @"$f" \
    "$base/api/localsend/v2/upload?sessionId=$session&fileId=$id&token=$token"
  printf '%s -> %s (%s)\n' "$f" "$alias_name" "$host:$port"
done
