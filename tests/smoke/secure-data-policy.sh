#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; cd "$ROOT"
python3 scripts/check_secure_data_policy.py
python3 scripts/check_milestone11_scope.py
grep -q 'lookup_key: eyaml_lookup_key' hiera.yaml
grep -q 'convert_to: Sensitive' data/common.yaml
grep -q 'apt_repository_client' manifests/site.pp
printf 'Secure-data policy smoke test passed.
'
