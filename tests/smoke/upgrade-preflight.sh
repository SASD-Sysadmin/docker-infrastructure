#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
"$ROOT/scripts/upgrade-preflight.sh" --puppet-version 8.20.0 --server-version 8.9.9 --java-major 17 --free-mib 4096 --backup-age 60 --output "$t/pass.json"
grep -q '"status": "pass"' "$t/pass.json"
set +e; "$ROOT/scripts/upgrade-preflight.sh" --puppet-version 8.20.0 --server-version 7.0.0 --java-major 11 --free-mib 100 --backup-age 999999 >/dev/null; rc=$?; set -e; [[ $rc -eq 3 ]]
echo 'Upgrade preflight smoke test passed.'
