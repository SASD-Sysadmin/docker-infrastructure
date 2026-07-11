#!/usr/bin/env bash
# Compile and apply the control repository on the local host.
#
# Safety contract:
#   * no-op is the default;
#   * real enforcement requires --apply and root privileges;
#   * concurrent executions are rejected through flock when available;
#   * Puppet detailed exit codes 0 and 2 are normalized to success.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
REPOSITORY_ROOT="$(repository_root)"
readonly REPOSITORY_ROOT

mode='noop'
facts_file=''
hiera_config="${REPOSITORY_ROOT}/hiera.yaml"
extra_args=()

usage() {
  cat <<'EOF'
Usage: apply-local.sh [--noop|--apply] [--facts FILE] [--debug|--verbose]

  --noop        Preview drift without changing the system (default).
  --apply       Enforce the catalog; requires root.
  --facts FILE  Override facts for compilation tests. Never use with --apply.
  --hiera-config FILE  Alternate Hiera configuration; tests only with --noop.
  --debug       Enable Puppet debug output.
  --verbose     Enable Puppet verbose output.
EOF
}

while (($#)); do
  case "$1" in
    --noop) mode='noop' ;;
    --apply) mode='apply' ;;
    --facts) shift; [[ $# -gt 0 ]] || die '--facts requires a file' 64; facts_file="$1" ;;
    --hiera-config) shift; [[ $# -gt 0 ]] || die '--hiera-config requires a file' 64; hiera_config="$1" ;;
    --debug|--verbose) extra_args+=("$1") ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

if [[ "${mode}" == 'apply' ]]; then
  require_root
  [[ -z "${facts_file}" ]] || die '--facts cannot be combined with --apply' 64
  [[ "${hiera_config}" == "${REPOSITORY_ROOT}/hiera.yaml" ]] || die '--hiera-config cannot be combined with --apply' 64
fi

puppet_bin="$(find_puppet)" || die 'puppet executable not found; run scripts/bootstrap-agent.sh or install puppet-agent' 127

runtime_root="$(mktemp -d "${TMPDIR:-/tmp}/sasd-puppet-apply.XXXXXX")"
trap 'rm -rf -- "${runtime_root}"' EXIT
mkdir -p "${runtime_root}/conf" "${runtime_root}/var"

if command -v flock >/dev/null 2>&1; then
  if [[ "${EUID}" -eq 0 ]]; then
    lock_file='/run/lock/sasd-puppet-software-baseline.lock'
  else
    lock_file="${XDG_RUNTIME_DIR:-/tmp}/sasd-puppet-software-baseline-${UID}.lock"
  fi
  exec 9>"${lock_file}"
  flock -n 9 || die 'another local Puppet run is already active' 75
fi

arguments=(
  apply
  "${REPOSITORY_ROOT}/manifests/site.pp"
  --modulepath "${REPOSITORY_ROOT}/site-modules:${REPOSITORY_ROOT}/modules"
  --hiera_config "${hiera_config}"
  --confdir "${runtime_root}/conf"
  --vardir "${runtime_root}/var"
  --strict_variables
  --show_diff
  --detailed-exitcodes
)

if [[ -n "${facts_file}" ]]; then
  [[ -r "${facts_file}" ]] || die "cannot read fact fixture: ${facts_file}" 66
  mkdir -p "${runtime_root}/facter"
  ruby "${REPOSITORY_ROOT}/scripts/render_fixture_facts.rb" \
    "${facts_file}" "${runtime_root}/facter/fixture_facts.rb"
fi
arguments+=("${extra_args[@]}")

if [[ "${mode}" == 'noop' ]]; then
  arguments+=(--noop)
  log 'running local Puppet catalog in no-op mode'
else
  warn 'enforcing the local Puppet catalog without --noop'
fi

set +e
if [[ -n "${facts_file}" ]]; then
  FACTERLIB="${runtime_root}/facter" "${puppet_bin}" "${arguments[@]}"
else
  "${puppet_bin}" "${arguments[@]}"
fi
status=$?
set -e

case "${status}" in
  0) log 'Puppet completed successfully with no changes'; exit 0 ;;
  2) log 'Puppet completed successfully and reported changes'; exit 0 ;;
  1|4|6) die "Puppet failed with detailed exit code ${status}" "${status}" ;;
  *) die "Puppet returned unexpected exit code ${status}" "${status}" ;;
esac
