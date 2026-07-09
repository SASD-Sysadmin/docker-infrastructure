#!/usr/bin/env bash
# Verify reviewed RedHat-family package names against a disposable EL9 image.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
image="${1:?Usage: redhat-package-availability.sh IMAGE [GROUP]}"
group="${2:-all}"
case "${group}" in all|baseline|administration_tools|development_tools|container_tools) ;; *) echo 'unsupported group' >&2; exit 64;; esac
command -v docker >/dev/null 2>&1 || { echo 'ERROR: docker not found' >&2; exit 127; }
packages="$(ruby -rpsych -e '
  d=Psych.safe_load_file(ARGV[0],permitted_classes:[],permitted_symbols:[],aliases:false)
  groups=ARGV[1]=="all" ? %w[baseline administration_tools development_tools container_tools] : [ARGV[1]]
  puts groups.flat_map { |g| d.fetch("profile::#{g}::packages") }.uniq.join(" ")
' "${ROOT}/data/os/family/RedHat.yaml" "${group}")"
# shellcheck disable=SC2086 # reviewed package words are generated from validated YAML.
docker run --rm "${image}" bash -ceu "dnf --assumeyes install ${packages}; rpm -q ${packages} >/dev/null"
