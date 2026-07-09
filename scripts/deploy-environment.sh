#!/usr/bin/env bash
# Deploy one explicit r10k environment and validate its Puppet source.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
environment='production'
branch='production'
config='/etc/puppetlabs/r10k/r10k.yaml'
environmentpath=''
dry_run=false
usage() { cat <<'EOF'
Usage: deploy-environment.sh [OPTIONS]
  --environment NAME   Puppet environment (default: production).
  --branch NAME        Expected same-named Git branch (default: production).
  --config FILE        r10k configuration file.
  --environmentpath D  Puppet environment base directory.
  --dry-run            Validate arguments and print the command only.
EOF
}
while (($#)); do case "$1" in
  --environment) shift; environment="${1:-}";;
  --branch) shift; branch="${1:-}";;
  --config) shift; config="${1:-}";;
  --environmentpath) shift; environmentpath="${1:-}";;
  --dry-run) dry_run=true;;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
validate_environment "${environment}"
[[ "${environment}" == "${branch}" ]] || die 'Milestone 3 requires branch and environment names to match for r10k' 64
if [[ -z "${environmentpath}" ]]; then
  detected_puppet="$(find_puppet || true)"
  if [[ -n "${detected_puppet}" ]]; then environmentpath="$("${detected_puppet}" config print environmentpath)"
  else environmentpath='/etc/puppetlabs/code/environments'
  fi
fi
[[ -r "${config}" || "${dry_run}" == true ]] || die "cannot read r10k config: ${config}" 66
log "r10k deployment: branch ${branch} -> ${environmentpath}/${environment}"
if [[ "${dry_run}" == true ]]; then log 'deployment dry-run complete; r10k was not executed'; exit 0; fi
require_root
r10k_bin="$(find_r10k)" || die 'r10k executable not found' 127
puppet_bin="$(find_puppet)" || die 'puppet executable not found' 127
lock=/run/lock/sasd-puppet-r10k.lock
exec 9>"${lock}"
flock -n 9 || die 'another r10k deployment is already running' 75
"${r10k_bin}" --config "${config}" --verbose deploy environment "${environment}" --puppetfile
root="${environmentpath}/${environment}"
[[ -f "${root}/environment.conf" && -f "${root}/manifests/site.pp" ]] || die "incomplete deployed environment: ${root}" 65
mapfile -d '' manifests < <(find "${root}/manifests" "${root}/site-modules" -type f -name '*.pp' -print0 | sort -z)
"${puppet_bin}" parser validate "${manifests[@]}"
install -d -m 0755 /var/lib/sasd-puppet/deployments
printf 'environment=%s\ndeployed_at=%s\n' "${environment}" "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" >"/var/lib/sasd-puppet/deployments/${environment}.status"
log "environment ${environment} deployed and parser-validated"
