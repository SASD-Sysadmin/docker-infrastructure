#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"; trap 'rm -rf -- "${tmp}"' EXIT
printf '%s\n' 'test-key-without-whitespace' >"${tmp}/key"
cat >"${tmp}/puppet8-release.repo" <<'REPO'
[puppet8]
name=Puppet 8
baseurl=https://yum-puppetcore.puppet.com/puppet8/el/9/$basearch
enabled=1
gpgcheck=1
#username=forge-key
#password=CHANGEME
REPO
output="$(python3 "${ROOT}/scripts/write-puppet-core-yum-credentials.py" --api-key-file "${tmp}/key" --repository-file "${tmp}/puppet8-release.repo")"
grep -q 'Updated Puppet Core repository credentials' <<<"${output}"
! grep -q 'test-key-without-whitespace' <<<"${output}"
grep -q '^username=forge-key$' "${tmp}/puppet8-release.repo"
grep -q '^password=test-key-without-whitespace$' "${tmp}/puppet8-release.repo"
[[ "$(stat -c '%a' "${tmp}/puppet8-release.repo")" == '600' ]]
printf 'bad key with spaces\n' >"${tmp}/bad-key"
if python3 "${ROOT}/scripts/write-puppet-core-yum-credentials.py" --api-key-file "${tmp}/bad-key" --repository-file "${tmp}/puppet8-release.repo" >/dev/null 2>&1; then
  echo 'ERROR: whitespace API key accepted' >&2; exit 1
fi
cat >"${tmp}/missing.repo" <<'REPO'
[puppet8]
baseurl=https://example.invalid/
REPO
if python3 "${ROOT}/scripts/write-puppet-core-yum-credentials.py" --api-key-file "${tmp}/key" --repository-file "${tmp}/missing.repo" >/dev/null 2>&1; then
  echo 'ERROR: repository without placeholders accepted' >&2; exit 1
fi
echo 'Puppet Core Yum credential writer smoke test passed.'
