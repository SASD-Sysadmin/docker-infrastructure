#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
printf '{"schema_version":1,"summary":{"compliant":1},"nodes":[]}\n' >"$t/c.json"; printf '{"schema_version":1,"status":"ok"}\n' >"$t/h.json"
archive=$("$ROOT/scripts/generate-audit-bundle.sh" --output-directory "$t" --compliance-file "$t/c.json" --health-file "$t/h.json" --skip-runtime)
"$ROOT/scripts/verify-audit-bundle.sh" "$archive"; tar -tzf "$archive" | grep -q './evidence/inventory.json'
echo 'Audit bundle smoke test passed.'
