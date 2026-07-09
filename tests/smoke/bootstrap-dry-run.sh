#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
for fixture in debian-12 debian-13 ubuntu-24.04; do
  output="$("${ROOT}/scripts/bootstrap-agent.sh" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/${fixture}")"
  grep -q 'dry-run complete' <<<"${output}"
done
if "${ROOT}/scripts/bootstrap-agent.sh" --dry-run --os-release-file "${ROOT}/tests/fixtures/os-release/rocky-9" >/dev/null 2>&1; then
  printf 'ERROR: unsupported Rocky fixture was accepted\n' >&2
  exit 1
fi
malicious="$(mktemp)"
trap 'rm -f -- "${malicious}" /tmp/sasd-bootstrap-must-not-run' EXIT
cat >"${malicious}" <<'EOF'
ID=debian
VERSION_ID="12"
EVIL=$(touch /tmp/sasd-bootstrap-must-not-run)
EOF
"${ROOT}/scripts/bootstrap-agent.sh" --dry-run --os-release-file "${malicious}" >/dev/null
test ! -e /tmp/sasd-bootstrap-must-not-run
printf 'Bootstrap dry-run tests passed.\n'
