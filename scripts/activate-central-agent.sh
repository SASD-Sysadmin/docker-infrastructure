#!/usr/bin/env bash
# Retrieve a signed certificate, test a catalog, and optionally enable service.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "${SCRIPT_DIR}/lib/common.sh"
mode='--noop'; enable_service=false; runinterval='1h'; splaylimit='15m'
usage() { cat <<'USAGE'
Usage: activate-central-agent.sh [--noop|--apply] [--enable-service] [OPTIONS]
  --runinterval DURATION  Service interval when enabled (default: 1h).
  --splaylimit DURATION   Random delay limit when enabled (default: 15m).
USAGE
}
while (($#)); do case "$1" in
  --noop) mode='--noop';;
  --apply) mode='--apply';;
  --enable-service) enable_service=true;;
  --runinterval) shift; runinterval="${1:-}";;
  --splaylimit) shift; splaylimit="${1:-}";;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
require_root
puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
"${puppet_bin}" ssl bootstrap --waitforcert 0
"${puppet_bin}" agent --test "${mode}" --detailed-exitcodes || result=$?
result="${result:-0}"
case "${result}" in 0|2) ;; *) die "Puppet agent test failed with exit code ${result}" "${result}";; esac
if [[ "${enable_service}" == true ]]; then
  "${SCRIPT_DIR}/configure-agent-service.sh" --runinterval "${runinterval}" --splaylimit "${splaylimit}"
fi
log "central agent activation completed in ${mode#--} mode; service_enabled=${enable_service}; runinterval=${runinterval}; splaylimit=${splaylimit}"
