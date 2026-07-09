#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
python3 "$ROOT/scripts/check_secret_policy.py"
"$ROOT/scripts/setup-hiera-eyaml.sh" --mode workstation | grep -q 'Dry run only'
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
"$ROOT/scripts/prepare-hiera-eyaml.sh" --output "$tmp"
grep -q 'eyaml_lookup_key' "$tmp"
grep -q 'private_key.pkcs7.pem' "$tmp"
echo 'Secret foundation smoke test passed.'
