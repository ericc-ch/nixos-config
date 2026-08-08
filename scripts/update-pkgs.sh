#!/usr/bin/env bash
# Regenerate pkgs/* metadata (version + SRI hashes) from GitHub release APIs.
# Review the diff (git diff) before rebuilding — hashes are pinned in-repo.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for update in pkgs/*/update.sh; do
  [ -x "$update" ] || continue
  "$update"
done
