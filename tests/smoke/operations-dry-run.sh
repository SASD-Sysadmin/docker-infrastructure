#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
"${ROOT}/scripts/configure-agent-service.sh" --runinterval 1h --splaylimit 15m --dry-run | grep -q 'dry-run complete'
"${ROOT}/scripts/configure-reporting.sh" --dry-run | grep -q 'dry-run complete'
"${ROOT}/scripts/bootstrap-puppetdb.sh" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" | grep -q 'plan-only mode'
if "${ROOT}/scripts/bootstrap-puppetdb.sh" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-13" >/dev/null 2>&1; then
  echo 'ERROR: Debian 13 must be rejected as a Milestone 4 PuppetDB host' >&2; exit 1
fi
"${ROOT}/scripts/backup-control-plane.sh" --dry-run --output-directory /tmp/test-backup | grep -q 'dry-run complete'
echo 'Milestone 4 operational dry-runs passed.'
