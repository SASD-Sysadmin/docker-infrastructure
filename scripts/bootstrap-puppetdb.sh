#!/usr/bin/env bash
# Opt-in same-host PuppetDB/PostgreSQL bootstrap using the official Forge module.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "${SCRIPT_DIR}/lib/common.sh"
module_version='8.1.0'; modulepath='/opt/sasd-puppet/bootstrap-modules'; apply=false; dry_run=false; os_release_file='/etc/os-release'
usage(){ cat <<'USAGE'
Usage: bootstrap-puppetdb.sh [--apply] [OPTIONS]
  --apply                   Perform installation (without this, plan only).
  --module-version VERSION  Pinned puppetlabs-puppetdb module (default: 8.1.0).
  --modulepath PATH          Isolated bootstrap module directory.
  --dry-run                 Alias for plan-only validation.
  --os-release-file FILE    Alternate os-release fixture for tests.

Scope: PuppetDB, PostgreSQL, and Puppet Server on the same Debian 12 or Ubuntu
24.04 host. Puppet Server major version 8 or newer is required.
USAGE
}
while (($#)); do case "$1" in
  --apply) apply=true;;
  --module-version) shift; module_version="${1:-}";;
  --modulepath) shift; modulepath="${1:-}";;
  --dry-run) dry_run=true;;
  --os-release-file) shift; os_release_file="${1:-}";;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
[[ "${module_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die 'module version must use x.y.z format' 64
[[ "${modulepath}" == /* ]] || die 'modulepath must be absolute' 64
read_os_release "${os_release_file}"
is_supported_server_platform || die "unsupported PuppetDB host ${ID} ${VERSION_ID}" 69
log "PuppetDB plan: same-host PostgreSQL/PuppetDB/Puppet Server; module=${module_version}; modulepath=${modulepath}"
if [[ "${apply}" != true || "${dry_run}" == true ]]; then
  log 'plan-only mode: no packages, modules, database, or Puppet configuration changed'
  exit 0
fi
require_root
puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
puppetserver_bin="$(find_puppetserver)" || die 'puppetserver command not found' 127
server_version="$(${puppetserver_bin} --version 2>&1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
[[ -n "${server_version}" ]] || die 'could not determine Puppet Server version' 65
server_major="${server_version%%.*}"
(( server_major >= 8 )) || die "PuppetDB 8 requires Puppet Server 8 or newer; found ${server_version}" 69
apt-get update
for package in puppetdb puppetdb-termini postgresql; do
  candidate="$(apt-cache policy "${package}" | sed -n 's/^[[:space:]]*Candidate:[[:space:]]*//p' | head -1)"
  [[ -n "${candidate}" && "${candidate}" != '(none)' ]] || die "no installable ${package} package; enable a compatible Puppet package repository first" 69
done
install -d -m 0755 "${modulepath}"
"${puppet_bin}" module install puppetlabs-puppetdb --version "${module_version}" --modulepath "${modulepath}"
basemodulepath="$(${puppet_bin} config print basemodulepath)"
manifest="$(mktemp)"; trap 'rm -f -- "${manifest}"' EXIT
cat >"${manifest}" <<'PP'
# Same-host installation recommended by the official PuppetDB documentation.
include puppetdb
include puppetdb::master::config
PP
"${puppet_bin}" apply "${manifest}" --modulepath "${modulepath}:${basemodulepath}" --detailed-exitcodes || result=$?
result="${result:-0}"; case "${result}" in 0|2) ;; *) die "PuppetDB bootstrap catalog failed with exit code ${result}" "${result}";; esac
systemctl enable --now postgresql.service puppetdb.service
systemctl restart puppetserver.service
systemctl is-active --quiet puppetdb.service || die 'puppetdb.service is not active' 70
log 'PuppetDB bootstrap complete; run status-puppetdb.sh and a test agent catalog'
