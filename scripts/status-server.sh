#!/usr/bin/env bash
# Display a concise, read-only Puppet Server and deployment status.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
puppet_bin="$(find_puppet || true)"
server_bin="$(find_puppetserver || true)"
r10k_bin="$(find_r10k || true)"
puppet_version='not found'; server_version='not found'; r10k_version='not found'
[[ -z "${puppet_bin}" ]] || puppet_version="$("${puppet_bin}" --version 2>/dev/null || true)"
[[ -z "${server_bin}" ]] || server_version="$("${server_bin}" --version 2>/dev/null || true)"
[[ -z "${r10k_bin}" ]] || r10k_version="$("${r10k_bin}" version 2>/dev/null || true)"
printf '%-24s %s\n' 'Puppet:' "${puppet_version}"
printf '%-24s %s\n' 'Puppet Server:' "${server_version}"
printf '%-24s %s\n' 'r10k:' "${r10k_version}"
if command -v systemctl >/dev/null 2>&1; then
  printf '%-24s %s\n' 'puppetserver.service:' "$(systemctl is-active puppetserver.service 2>/dev/null || true)"
fi
if [[ -n "${puppet_bin}" ]]; then
  printf '%-24s %s\n' 'certname:' "$("${puppet_bin}" config print certname 2>/dev/null || true)"
  printf '%-24s %s\n' 'environmentpath:' "$("${puppet_bin}" config print environmentpath 2>/dev/null || true)"
  printf '%-24s %s\n' 'ssldir:' "$("${puppet_bin}" config print ssldir 2>/dev/null || true)"
  printf '%-24s %s\n' 'cadir:' "$("${puppet_bin}" config print cadir 2>/dev/null || true)"
fi
environmentpath=''
[[ -z "${puppet_bin}" ]] || environmentpath="$("${puppet_bin}" config print environmentpath 2>/dev/null || true)"
if [[ -n "${environmentpath}" && -d "${environmentpath}" ]]; then
  printf '%s\n' 'Deployed environments:'
  find "${environmentpath}" -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' | sort
fi
if [[ -d /var/lib/sasd-puppet/deployments ]]; then
  cat /var/lib/sasd-puppet/deployments/*.status 2>/dev/null || true
fi
