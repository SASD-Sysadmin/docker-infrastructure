#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
SCRIPT="${ROOT}/scripts/setup-dotnet-repository.sh"
for fixture in debian-12 debian-13; do
  output="$(${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}" --architecture amd64)"
  grep -q 'strategy: microsoft' <<<"${output}"
  grep -q 'Dry run only' <<<"${output}"
done
for fixture in ubuntu-24.04 almalinux-9 rocky-9; do
  output="$(${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}" --architecture x86_64)"
  grep -q 'strategy: distribution' <<<"${output}"
  grep -q 'no repository files will be added' <<<"${output}"
done
if ${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" --architecture arm64 >/dev/null 2>&1; then echo 'ERROR: arm64 was accepted' >&2; exit 1; fi
if ${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" --architecture amd64 --expected-sha256 deadbeef >/dev/null 2>&1; then echo 'ERROR: invalid SHA-256 was accepted' >&2; exit 1; fi
if ${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/ubuntu-24.10" --architecture x86_64 >/dev/null 2>&1; then echo 'ERROR: Ubuntu 24.10 was accepted' >&2; exit 1; fi
if ${SCRIPT} --os-release-file "${ROOT}/tests/fixtures/os-release/debian-12" --architecture amd64 --download-url 'http://packages.microsoft.com/bad.deb' >/dev/null 2>&1; then echo 'ERROR: non-HTTPS URL was accepted' >&2; exit 1; fi
printf '.NET repository guard smoke test passed.\n'
