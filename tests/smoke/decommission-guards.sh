#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts" "$tmp/config" "$tmp/data/nodes" "$tmp/data/retired" "$tmp/reports"
cp "$ROOT/scripts/decommission-node.sh" "$ROOT/scripts/check_node_data.rb" "$tmp/scripts/"
cp "$ROOT/config/node-data-contract.json" "$tmp/config/"
cat > "$tmp/data/nodes/node01.example.test.yaml" <<'YAML'
---
sasd::role: server
sasd::lifecycle_state: retired
sasd::owner: operations
sasd::lifecycle_reason: Hardware removed
sasd::lifecycle_ticket: CHG-99
YAML
(
 cd "$tmp"
 git init -q; git config user.name test; git config user.email test@example.test; git add .; git commit -qm initial
 set +e; scripts/decommission-node.sh --certname node01.example.test --confirm wrong >/dev/null 2>&1; rc=$?; set -e; [[ $rc -ne 0 ]]
 scripts/decommission-node.sh --certname node01.example.test --confirm node01.example.test --report-directory "$tmp/reports" | grep -q 'Dry run only'
 scripts/decommission-node.sh --certname node01.example.test --confirm node01.example.test --report-directory "$tmp/reports" --apply
 test -f data/retired/node01.example.test.yaml
 test ! -f data/nodes/node01.example.test.yaml
 grep -q 'sasd::decommissioned_at' data/retired/node01.example.test.yaml
 ruby scripts/check_node_data.rb
)
echo 'Decommission guard smoke test passed.'
