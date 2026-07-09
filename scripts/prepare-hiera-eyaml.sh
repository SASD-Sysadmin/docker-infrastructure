#!/usr/bin/env bash
# Produce a reviewed candidate hiera.yaml with the encrypted hierarchy enabled.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
output=''; apply=false
usage(){ echo 'Usage: prepare-hiera-eyaml.sh [--output FILE] [--apply]'; }
while (($#)); do case "$1" in --output) output="${2:-}"; shift 2;; --apply) apply=true; shift;; -h|--help) usage; exit 0;; *) echo "ERROR: unknown argument $1" >&2; exit 64;; esac; done
source_file="${ROOT}/config/hiera-eyaml.yaml.example"
[[ -f "${source_file}" ]] || { echo 'ERROR: hierarchy template missing' >&2; exit 66; }
if [[ "${apply}" == true ]]; then
  [[ -z "$(git -C "${ROOT}" status --porcelain --untracked-files=no)" ]] || { echo 'ERROR: tracked worktree must be clean' >&2; exit 75; }
  output="${ROOT}/hiera.yaml"
else
  [[ -n "${output}" ]] || output="${ROOT}/hiera.yaml.eyaml-candidate"
fi
cp -- "${source_file}" "${output}"
echo "Wrote ${output}. Validate key paths, install hiera-eyaml on every compiler, run catalog tests, then commit and promote through main -> test -> production."
