#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; tmp=$(mktemp -d); trap 'rm -rf -- "$tmp"' EXIT
now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
cat >"$tmp/node01.json" <<JSON
{"certname":"node01.example.test","status":"changed","environment":"production","noop":false,"end_time":"${now}"}
JSON
"${ROOT}/scripts/report-status.py" --directory "$tmp" --stale-after 3600 | grep -q node01.example.test
"${ROOT}/scripts/report-status.py" --directory "$tmp" --json | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["reports"][0]["status"]=="changed"'
cat >"$tmp/node02.json" <<JSON
{"certname":"node02.example.test","status":"failed","environment":"production","noop":false,"end_time":"${now}"}
JSON
set +e; "${ROOT}/scripts/report-status.py" --directory "$tmp" >/dev/null; result=$?; set -e
[[ "$result" -eq 1 ]] || { echo "expected warning exit 1, got $result" >&2; exit 1; }
echo 'Report status smoke test passed.'
