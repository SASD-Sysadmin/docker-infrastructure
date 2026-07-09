#!/usr/bin/env bash
# Apply each Milestone 5 application profile twice in a disposable container.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
image="${1:?Usage: container-application-profiles.sh IMAGE PROFILE}"
profile="${2:?Usage: container-application-profiles.sh IMAGE PROFILE}"
case "${profile}" in administration_tools|development_tools|container_tools) ;; *) echo 'unsupported profile' >&2; exit 64;; esac
command -v docker >/dev/null 2>&1 || { echo 'ERROR: docker not found' >&2; exit 127; }
docker run --rm --volume "${ROOT}:/source:ro" "${image}" bash -ceu "
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --yes ca-certificates git rsync
  if ! apt-cache show puppet-agent >/dev/null 2>&1; then apt-get install --yes software-properties-common; add-apt-repository --yes universe; apt-get update; fi
  apt-get install --yes puppet-agent
  cp -a /source /work; cd /work
  puppet apply --modulepath=site-modules:modules --hiera_config=hiera.yaml --detailed-exitcodes -e 'include profile::${profile}' || test \$? -eq 2
  output=\"\$(puppet apply --modulepath=site-modules:modules --hiera_config=hiera.yaml --detailed-exitcodes -e 'include profile::${profile}' 2>&1)\"; rc=\$?
  test \$rc -eq 0
  grep -Eq 'Applied catalog|Catalog applied' <<<\"\${output}\"
"
