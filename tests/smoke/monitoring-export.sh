#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
cat >"$t/c.json" <<'JSON'
{"summary":{"compliant":2,"stale-report":1,"failed":1},"nodes":[{},{},{},{}]}
JSON
cat >"$t/h.json" <<'JSON'
{"status":"warning","message":"fixture"}
JSON
set +e; python3 "$ROOT/scripts/export-monitoring.py" --compliance "$t/c.json" --health "$t/h.json" --output "$t/out.prom" --now 100; rc=$?; set -e
[[ $rc -eq 2 ]]; grep -q 'sasd_puppet_fleet_nodes{status="failed"} 1' "$t/out.prom"; ! grep -q 'certname=' "$t/out.prom"
echo 'Monitoring export smoke test passed.'
