#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
cd "${ROOT}"
python3 scripts/check_role_catalog.py
printf 'Role-catalog smoke test passed.\n'
