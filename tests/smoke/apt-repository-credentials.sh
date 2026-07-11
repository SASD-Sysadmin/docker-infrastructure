#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; cd "$ROOT"
python3 scripts/check_milestone11_scope.py
grep -Eq "mode[[:space:]]+=>[[:space:]]+'0600'" site-modules/profile/manifests/apt_repository_credentials.pp
grep -q 'show_diff => false' site-modules/profile/manifests/apt_repository_credentials.pp
grep -q 'Sensitive\[String' site-modules/profile/templates/apt-auth.conf.epp
! grep -RniE 'profile::apt_repository_credentials::password:[[:space:]]+[^>]' data/nodes
printf '%s\n' 'APT repository credential smoke test passed.'
