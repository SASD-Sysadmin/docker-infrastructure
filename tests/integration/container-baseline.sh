#!/usr/bin/env bash
# Execute a real idempotence test in a disposable Debian/Ubuntu container.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
image="${1:?Usage: container-baseline.sh IMAGE}"
command -v docker >/dev/null 2>&1 || { printf 'ERROR: docker not found\n' >&2; exit 127; }

# shellcheck disable=SC2016 # Variables below expand inside the container shell.
docker run --rm --volume "${ROOT}:/source:ro" "${image}" bash -ceu '
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --yes ca-certificates git rsync
  if ! apt-cache show puppet-agent >/dev/null 2>&1; then
    apt-get install --yes software-properties-common
    add-apt-repository --yes universe
    apt-get update
  fi
  apt-get install --yes puppet-agent
  cp -a /source /work
  cd /work
  ./scripts/apply-local.sh --apply
  test -f /etc/sasd/puppet-baseline.conf
  grep -q "baseline_version=0.11.0" /etc/sasd/puppet-baseline.conf
  first="$(sha256sum /etc/sasd/puppet-baseline.conf)"
  second_run="$(./scripts/apply-local.sh --apply 2>&1)"
  grep -q "completed successfully with no changes" <<<"${second_run}"
  second="$(sha256sum /etc/sasd/puppet-baseline.conf)"
  test "${first}" = "${second}"
  dpkg-query -W git jq rsync tree unzip lsof procps >/dev/null
'
