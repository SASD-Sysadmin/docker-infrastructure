#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
cd "${ROOT}"
python3 scripts/check_sdk_catalog.py
python3 scripts/check_milestone9_scope.py
ruby scripts/check_package_policy.rb
for profile in sdk_status java_sdk php_sdk; do grep -q "class profile::${profile}" "site-modules/profile/manifests/${profile}.pp"; done
for role in java_development php_development polyglot_development; do grep -q "class role::${role}" "site-modules/role/manifests/${role}.pp"; grep -q "'${role}'" manifests/site.pp; done
printf 'SDK profile policy smoke test passed.\n'
