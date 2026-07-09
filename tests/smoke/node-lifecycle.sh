#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/scripts" "$tmp/config" "$tmp/data/nodes" "$tmp/data/retired"
cp "$ROOT/scripts/manage-node.rb" "$ROOT/scripts/check_node_data.rb" "$tmp/scripts/"
cp "$ROOT/config/node-data-contract.json" "$tmp/config/"
(
 cd "$tmp"
 ruby scripts/manage-node.rb register --certname node01.example.test --role server --owner operations --description 'Lifecycle test'
 ruby scripts/check_node_data.rb
 ruby scripts/manage-node.rb maintenance --certname node01.example.test --reason 'Patch window' --ticket CHG-42 --expires-at 2026-07-10T12:00:00Z
 grep -q 'sasd::lifecycle_state: maintenance' data/nodes/node01.example.test.yaml
 ruby scripts/check_node_data.rb
 ruby scripts/manage-node.rb activate --certname node01.example.test
 ! grep -q 'sasd::lifecycle_ticket' data/nodes/node01.example.test.yaml
 ruby scripts/manage-node.rb retire --certname node01.example.test --reason 'System removed' --ticket CHG-43
 ruby scripts/check_node_data.rb
)
echo 'Node lifecycle smoke test passed.'
