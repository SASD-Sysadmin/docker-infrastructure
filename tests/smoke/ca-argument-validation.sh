#!/usr/bin/env bash
# Verify destructive CA wrappers reject malformed or insufficient arguments
# before attempting to invoke Puppet Server.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"

if "${ROOT}/scripts/sign-certificate.sh" --certname 'bad/name' >/dev/null 2>&1; then
  echo 'ERROR: sign wrapper accepted malformed certname' >&2
  exit 1
fi
if "${ROOT}/scripts/clean-certificate.sh" --certname node01.example.test --confirm other.example.test >/dev/null 2>&1; then
  echo 'ERROR: clean wrapper accepted a mismatched confirmation' >&2
  exit 1
fi
if "${ROOT}/scripts/clean-certificate.sh" --certname node01.example.test >/dev/null 2>&1; then
  echo 'ERROR: clean wrapper accepted missing confirmation' >&2
  exit 1
fi
printf 'CA argument validation tests passed.\n'
