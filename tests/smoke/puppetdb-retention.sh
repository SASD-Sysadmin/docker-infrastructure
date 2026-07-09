#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; t=$(mktemp -d); trap 'rm -rf "$t"; rm -f "$ROOT/data/retired/test-m8.example.invalid.yaml"' EXIT
python3 "$ROOT/scripts/generate-puppetdb-retention.py" --output "$t/database.ini" >/dev/null
grep -q '^node-purge-ttl = 30d$' "$t/database.ini"; grep -q '^report-ttl = 14d$' "$t/database.ini"
printf '%s\n' 'sasd::lifecycle_state: retired' >"$ROOT/data/retired/test-m8.example.invalid.yaml"
"$ROOT/scripts/deactivate-puppetdb-node.sh" --certname test-m8.example.invalid --confirm test-m8.example.invalid | grep -q 'DRY-RUN'
echo 'PuppetDB retention smoke test passed.'
