#!/usr/bin/env bash
# Compile and locally apply the control repository.
#
# Safety contract:
#   * no-op is the default;
#   * real enforcement requires the explicit --apply switch;
#   * Milestone 1 contains no workload resources in either mode.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly REPOSITORY_ROOT
mode='noop'

case "${1:-}" in
  '') ;;
  --noop) mode='noop' ;;
  --apply) mode='apply' ;;
  *) printf 'Usage: %s [--noop|--apply]\n' "$0" >&2; exit 64 ;;
esac

if ! command -v puppet >/dev/null 2>&1; then
  printf 'ERROR: puppet executable not found. Run scripts/setup-development.sh or install Puppet Agent.\n' >&2
  exit 127
fi

runtime_root="$(mktemp -d "${TMPDIR:-/tmp}/sasd-puppet-apply.XXXXXX")"
trap 'rm -rf -- "${runtime_root}"' EXIT
mkdir -p "${runtime_root}/conf" "${runtime_root}/var"

arguments=(
  apply
  "${REPOSITORY_ROOT}/manifests/site.pp"
  --modulepath "${REPOSITORY_ROOT}/site-modules:${REPOSITORY_ROOT}/modules"
  --hiera_config "${REPOSITORY_ROOT}/hiera.yaml"
  --confdir "${runtime_root}/conf"
  --vardir "${runtime_root}/var"
  --strict_variables
  --show_diff
  --detailed-exitcodes
)

if [[ "${mode}" == 'noop' ]]; then
  arguments+=(--noop)
else
  printf 'WARNING: applying catalog without --noop.\n' >&2
fi

set +e
puppet "${arguments[@]}"
status=$?
set -e

# With --detailed-exitcodes, 0 means no changes and 2 means successful changes.
if [[ "${status}" -eq 0 || "${status}" -eq 2 ]]; then
  exit 0
fi
exit "${status}"
