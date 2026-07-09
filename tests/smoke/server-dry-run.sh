#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
for fixture in debian-12 ubuntu-24.04; do
  output="$("${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}")"
  grep -q 'server dry-run complete' <<<"${output}"
done
if "${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-13" >/dev/null 2>&1; then echo 'ERROR: Debian 13 server fixture accepted' >&2; exit 1; fi
if "${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --architecture arm64 --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: unsupported server architecture accepted' >&2; exit 1; fi
if "${ROOT}/scripts/bootstrap-server.sh" --server-name 'INVALID NAME' --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: invalid server certname accepted' >&2; exit 1; fi
if "${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --dns-alt-names 'bad name' --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: invalid DNS alt name accepted' >&2; exit 1; fi
if "${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --branch main --environment production --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: mismatched branch/environment accepted' >&2; exit 1; fi
if "${ROOT}/scripts/bootstrap-server.sh" --server-name puppet.example.test --repository-url "https://example.test/repo'bad.git" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" >/dev/null 2>&1; then echo 'ERROR: YAML-unsafe repository URL accepted' >&2; exit 1; fi
"${ROOT}/scripts/deploy-environment.sh" --dry-run | grep -q 'deployment dry-run complete'
echo 'Puppet Server dry-run tests passed.'
