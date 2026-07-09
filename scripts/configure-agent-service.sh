#!/usr/bin/env bash
# Configure the reviewed native Puppet agent service cadence and enable it.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
runinterval='1h'; splaylimit='15m'; environment='production'; enable_service=true; dry_run=false
usage(){ cat <<'USAGE'
Usage: configure-agent-service.sh [OPTIONS]
  --runinterval DURATION  Agent interval (default: 1h).
  --splaylimit DURATION   Random startup delay limit (default: 15m).
  --environment NAME      Puppet environment (default: production).
  --no-enable             Write settings without enabling the service.
  --dry-run               Validate and print planned settings only.
USAGE
}
valid_duration(){ [[ "$1" =~ ^[1-9][0-9]*[smhd]$ ]]; }
while (($#)); do case "$1" in
  --runinterval) shift; runinterval="${1:-}";;
  --splaylimit) shift; splaylimit="${1:-}";;
  --environment) shift; environment="${1:-}";;
  --no-enable) enable_service=false;;
  --dry-run) dry_run=true;;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
valid_duration "${runinterval}" || die 'runinterval must be a positive duration such as 30m or 1h' 64
valid_duration "${splaylimit}" || die 'splaylimit must be a positive duration such as 10m' 64
validate_environment "${environment}"
log "agent settings: runinterval=${runinterval}, splay=true, splaylimit=${splaylimit}, environment=${environment}"
[[ "${dry_run}" == true ]] && { log 'dry-run complete; no settings changed'; exit 0; }
require_root
puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
[[ "$("${puppet_bin}" config print server --section agent 2>/dev/null || true)" != '' ]] || die 'agent server is not configured; run bootstrap-central-agent.sh first' 65
hostcert="$("${puppet_bin}" config print hostcert --section agent)"
hostprivkey="$("${puppet_bin}" config print hostprivkey --section agent)"
localcacert="$("${puppet_bin}" config print localcacert --section agent)"
for tls_file in "${hostcert}" "${hostprivkey}" "${localcacert}"; do
  [[ -s "${tls_file}" ]] || die "signed agent TLS state is incomplete: ${tls_file}" 65
done
"${puppet_bin}" ssl verify >/dev/null
"${puppet_bin}" config set runinterval "${runinterval}" --section agent
"${puppet_bin}" config set splay true --section agent
"${puppet_bin}" config set splaylimit "${splaylimit}" --section agent
"${puppet_bin}" config set report true --section agent
"${puppet_bin}" config set environment "${environment}" --section agent
if [[ "${enable_service}" == true ]]; then
  if systemctl list-unit-files puppet.service >/dev/null 2>&1; then unit=puppet.service
  elif systemctl list-unit-files puppet-agent.service >/dev/null 2>&1; then unit=puppet-agent.service
  else die 'no Puppet agent systemd service found' 69; fi
  systemctl enable --now "${unit}"
  systemctl is-active --quiet "${unit}" || die "${unit} did not become active" 70
fi
log "agent service configuration completed; enabled=${enable_service}"
