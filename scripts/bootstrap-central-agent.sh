#!/usr/bin/env bash
# Install/configure an agent for a central Puppet Server and submit its CSR.
# The agent service remains disabled until an operator signs and activates it.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/puppet_packages.sh
source "${SCRIPT_DIR}/lib/puppet_packages.sh"
server=''; certname=''; environment='production'; package_source='distribution'
api_key_file=''; release_url=''; dry_run=false; os_release_file='/etc/os-release'; architecture=''
usage() { cat <<'EOF'
Usage: bootstrap-central-agent.sh --server FQDN [OPTIONS]
  --server FQDN          Puppet Server certname/DNS name.
  --certname NAME        Agent certificate name (default: hostname -f).
  --environment NAME     Requested environment (default: production).
  --package-source SRC   distribution (Debian/Ubuntu) or puppet-core.
  --api-key-file FILE    Root-only API key file required for puppet-core.
  --release-url URL      Override Puppet Core release-package URL.
  --architecture ARCH    Override detected architecture; intended for tests.
  --dry-run              Validate and print the plan only.
  --os-release-file F    Alternate fixture for tests.
EOF
}
while (($#)); do case "$1" in
  --server) shift; server="${1:-}";; --certname) shift; certname="${1:-}";;
  --environment) shift; environment="${1:-}";; --package-source) shift; package_source="${1:-}";;
  --api-key-file) shift; api_key_file="${1:-}";; --release-url) shift; release_url="${1:-}";;
  --architecture) shift; architecture="${1:-}";; --dry-run) dry_run=true;;
  --os-release-file) shift; os_release_file="${1:-}";; -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
[[ -n "${server}" ]] || die '--server is required' 64
[[ -n "${certname}" ]] || certname="$(hostname -f 2>/dev/null || hostname)"
server="${server,,}"; certname="${certname,,}"
validate_certname "${server}"; validate_certname "${certname}"; validate_environment "${environment}"
[[ "${package_source}" =~ ^(distribution|puppet-core)$ ]] || die 'package source must be distribution or puppet-core' 64
if [[ "${package_source}" == 'puppet-core' && -z "${api_key_file}" ]]; then die '--api-key-file is required for puppet-core' 64; fi
read_os_release "${os_release_file}"
is_supported_agent_platform || die "unsupported agent platform ${ID} ${VERSION_ID}" 69
[[ -n "${architecture}" ]] || architecture="$(uname -m)"
architecture="$(normalize_architecture "${architecture}")"
is_supported_agent_architecture "${architecture}" || die "unsupported agent architecture ${architecture}; supported: x86_64 and aarch64" 69
if is_redhat_family_agent && [[ "${package_source}" != 'puppet-core' ]]; then
  die 'Rocky Linux 9 and AlmaLinux 9 require --package-source puppet-core' 69
fi
log "agent platform: ${ID} ${VERSION_ID} (${architecture}); certname: ${certname}"
log "server: ${server}; environment: ${environment}; package source: ${package_source}"
if [[ "${dry_run}" == true ]]; then log 'central-agent dry-run complete; no host changes were made'; exit 0; fi
require_root
case "${ID}" in
  debian|ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update; apt-get install --yes ca-certificates curl
    if [[ "${package_source}" == 'puppet-core' ]]; then
      [[ -n "${release_url}" ]] || release_url="$(puppet_core_release_url)"
      [[ "${release_url}" == https://* ]] || die 'Puppet Core release URL must use HTTPS' 64
      configure_puppet_core_apt "${api_key_file}" "${release_url}"
    else
      prepare_distribution_puppet_packages
    fi
    apt-get install --yes puppet-agent
    ;;
  almalinux|rocky)
    dnf --assumeyes install ca-certificates curl python3
    [[ -n "${release_url}" ]] || release_url="$(puppet_core_release_url)"
    [[ "${release_url}" == https://* ]] || die 'Puppet Core release URL must use HTTPS' 64
    configure_puppet_core_yum "${api_key_file}" "${release_url}"
    dnf --assumeyes install puppet-agent
    ;;
esac
puppet_bin="$(find_puppet)" || die 'puppet command not found after installation' 127
confdir="$("${puppet_bin}" config print confdir)"; puppet_conf="${confdir}/puppet.conf"
log "detected Puppet confdir: ${confdir}"
if command -v systemctl >/dev/null 2>&1; then systemctl disable --now puppet.service puppet-agent.service 2>/dev/null || true; fi
ssldir="$("${puppet_bin}" config print ssldir)"
if [[ -d "${ssldir}" ]] && find "${ssldir}" -type f -print -quit | grep -q .; then
  current="$("${puppet_bin}" config print certname 2>/dev/null || true)"
  [[ -z "${current}" || "${current}" == "${certname}" ]] || die "existing SSL state belongs to ${current}; follow certificate replacement procedure" 65
fi
backup_once "${puppet_conf}"
install_text_if_changed "${puppet_conf}" 0644 <<EOF
# Managed by SASD bootstrap-central-agent.sh.
[main]
server = ${server}
certname = ${certname}
environment = ${environment}
runinterval = 30m

[agent]
report = true
EOF
set +e
bootstrap_output="$("${puppet_bin}" ssl bootstrap --waitforcert 0 2>&1)"; result=$?
set -e
printf '%s\n' "${bootstrap_output}"
if [[ "${result}" -eq 0 ]]; then
  log 'agent certificate is already signed; run activate-central-agent.sh after review'
else
  warn "SSL bootstrap exited with ${result}; this is expected for a pending CSR but can also indicate DNS, TLS, or connectivity failure"
  log "verify that the Puppet Server lists a pending CSR for ${certname} before signing"
  printf 'Next on the Puppet Server:\n  sudo ./scripts/sign-certificate.sh --certname %q\n' "${certname}"
  printf 'Then on this agent:\n  sudo ./scripts/activate-central-agent.sh --noop --enable-service\n'
fi
log 'central-agent bootstrap completed with periodic service disabled'
