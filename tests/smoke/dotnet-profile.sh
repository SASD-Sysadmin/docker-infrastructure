#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
cd "${ROOT}"
python3 scripts/check_sdk_catalog.py
python3 scripts/check_dotnet_repository_catalog.py
python3 scripts/check_milestone10_scope.py
ruby scripts/check_package_policy.rb
grep -q 'class profile::dotnet_sdk' site-modules/profile/manifests/dotnet_sdk.pp
grep -q 'class role::dotnet_development' site-modules/role/manifests/dotnet_development.pp
grep -q "'dotnet_development'" manifests/site.pp
grep -q 'profile::dotnet_sdk::packages:' data/os/family/Debian.yaml
grep -q 'profile::dotnet_sdk::packages:' data/os/family/RedHat.yaml
printf '.NET profile policy smoke test passed.\n'
