#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf "${tmp}"' EXIT
cd "${ROOT}"
git clone --quiet --no-local "${ROOT}" "${tmp}/repo"
cd "${tmp}/repo"
./scripts/release-readiness.sh --require-branch main --output "${tmp}/readiness.json"
python3 - "${tmp}/readiness.json" <<'PYTEST'
import json,sys
x=json.load(open(sys.argv[1])); assert x['status']=='pass'; assert x['version']=='0.7.0'
PYTEST
printf 'Release-readiness smoke test passed.\n'
