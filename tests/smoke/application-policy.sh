#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
cd "${ROOT}"
ruby scripts/check_package_policy.rb
for profile in administration_tools development_tools container_tools java_sdk php_sdk; do
  grep -q "class profile::${profile}" "site-modules/profile/manifests/${profile}.pp"
done
printf 'Application package-policy smoke test passed.\n'
