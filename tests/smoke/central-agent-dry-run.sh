#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
for fixture in debian-12 debian-13 ubuntu-24.04; do
  output="$("${ROOT}/scripts/bootstrap-central-agent.sh" --server puppet.example.test --certname "${fixture}.example.test" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}")"
  grep -q 'central-agent dry-run complete' <<<"${output}"
done
if "${ROOT}/scripts/bootstrap-central-agent.sh" --server puppet.example.test --certname bad/name --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: invalid agent certname accepted' >&2; exit 1; fi
echo 'Central-agent dry-run tests passed.'
