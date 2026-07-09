#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts" "$tmp/data/nodes" "$tmp/reports"
cp "$ROOT/scripts/node-inventory.rb" "$ROOT/scripts/fleet-compliance.rb" "$tmp/scripts/"
cat > "$tmp/data/nodes/node01.example.test.yaml" <<'YAML'
---
sasd::role: server
sasd::lifecycle_state: active
sasd::owner: operations
YAML
cat > "$tmp/reports/node01.example.test.json" <<'JSON'
{"schema_version":1,"certname":"node01.example.test","status":"unchanged","time":"2026-07-09T12:00:00Z"}
JSON
(
 cd "$tmp"
 ruby scripts/node-inventory.rb --format json | grep -q 'node01.example.test'
 ruby scripts/fleet-compliance.rb --reports reports --now 2026-07-09T12:30:00Z --max-age 7200 --format json | grep -q 'compliant'
 rm reports/node01.example.test.json
 set +e; ruby scripts/fleet-compliance.rb --reports reports --now 2026-07-09T12:30:00Z >/dev/null; rc=$?; set -e
 [[ $rc -eq 2 ]]
)
echo 'Inventory and compliance smoke test passed.'
