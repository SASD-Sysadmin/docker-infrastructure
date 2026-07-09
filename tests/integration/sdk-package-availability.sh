#!/usr/bin/env bash
# Install reviewed SDK package groups in a disposable distribution container.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
image="${1:?Usage: sdk-package-availability.sh IMAGE FAMILY PROFILE}"
family="${2:?Usage: sdk-package-availability.sh IMAGE FAMILY PROFILE}"
profile="${3:?Usage: sdk-package-availability.sh IMAGE FAMILY PROFILE}"
case "${family}" in Debian|RedHat) ;; *) echo 'unsupported family' >&2; exit 64;; esac
case "${profile}" in java_sdk|php_sdk) ;; *) echo 'unsupported profile' >&2; exit 64;; esac
command -v docker >/dev/null 2>&1 || { echo 'ERROR: docker not found' >&2; exit 127; }
packages="$(ruby -rpsych -e 'd=Psych.safe_load_file(ARGV[0],permitted_classes:[],permitted_symbols:[],aliases:false); puts d.fetch("profile::#{ARGV[1]}::packages").join(" ")' "${ROOT}/data/os/family/${family}.yaml" "${profile}")"
if [[ "${family}" == Debian ]]; then docker run --rm "${image}" bash -ceu "export DEBIAN_FRONTEND=noninteractive; apt-get update; apt-get install --yes ${packages}; dpkg-query -W ${packages} >/dev/null"; else docker run --rm "${image}" bash -ceu "dnf --assumeyes install ${packages}; rpm -q ${packages} >/dev/null"; fi
