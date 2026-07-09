#!/usr/bin/env bash
# Retrieve a signed certificate, test a catalog, and optionally enable service.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
mode='--noop'; enable_service=false
usage() { printf 'Usage: %s [--noop|--apply] [--enable-service]\n' "$0"; }
while (($#)); do case "$1" in
  --noop) mode='--noop';;
  --apply) mode='--apply';;
  --enable-service) enable_service=true;;
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
  if systemctl list-unit-files puppet.service >/dev/null 2>&1; then systemctl enable --now puppet.service
  elif systemctl list-unit-files puppet-agent.service >/dev/null 2>&1; then systemctl enable --now puppet-agent.service
  else die 'no Puppet agent systemd service found' 69; fi
fi
log "central agent activation completed in ${mode#--} mode; service_enabled=${enable_service}"
