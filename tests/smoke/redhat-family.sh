#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
python3 "${ROOT}/scripts/check_platform_catalog.py"
ruby "${ROOT}/scripts/check_package_policy.rb"
for fixture in rocky-9 almalinux-9; do
  output="$("${ROOT}/scripts/bootstrap-central-agent.sh" --server puppet.example.test --certname "${fixture}.example.test" --package-source puppet-core --api-key-file /root/not-read-during-dry-run --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}" --architecture x86_64)"
  grep -q 'central-agent dry-run complete' <<<"${output}"
  if "${ROOT}/scripts/bootstrap-central-agent.sh" --server puppet.example.test --certname "${fixture}.example.test" --package-source distribution --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}" >/dev/null 2>&1; then
    echo "ERROR: ${fixture} accepted distribution package source" >&2; exit 1
  fi
done
if "${ROOT}/scripts/bootstrap-central-agent.sh" --server puppet.example.test --certname rocky.example.test --package-source puppet-core --api-key-file /tmp/key --architecture s390x --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/rocky-9" >/dev/null 2>&1; then
  echo 'ERROR: unsupported architecture accepted' >&2; exit 1
fi
python3 "${ROOT}/scripts/check_milestone7_scope.py"
echo 'RedHat-family platform smoke tests passed.'
