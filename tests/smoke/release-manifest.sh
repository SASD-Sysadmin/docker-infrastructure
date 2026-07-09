#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf "${tmp}"' EXIT
cd "${ROOT}"
python3 scripts/generate-release-manifest.py --output "${tmp}/manifest.json"
python3 scripts/verify-release-manifest.py "${tmp}/manifest.json"
python3 - "${tmp}/manifest.json" <<'PYTEST'
import json,sys
x=json.load(open(sys.argv[1])); assert x['version']=='0.9.0'; assert x['file_count']>100
PYTEST
printf 'Release-manifest smoke test passed.\n'
