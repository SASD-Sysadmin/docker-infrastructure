#!/usr/bin/env bash
# Install and initialize a single open-source Puppet Server with r10k.
#
# Safety properties:
# - supports only Debian 12 and Ubuntu 24.04;
# - never overwrites an existing CA;
# - disables autosigning;
# - keeps package credentials in a root-only file supplied by the operator;
# - deploys only an explicit environment/branch (production by default).
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
# shellcheck source=scripts/lib/puppet_packages.sh
source "${SCRIPT_DIR}/lib/puppet_packages.sh"

server_name=''
dns_alt_names=''
repository_url='https://github.com/SASD-Sysadmin/puppet-software-baseline.git'
branch='production'
environment='production'
package_source='distribution'
api_key_file=''
release_url=''
jvm_memory='1g'
dry_run=false
skip_deploy=false
start_server=true
os_release_file='/etc/os-release'
architecture=''

usage() { cat <<'EOF'
Usage: bootstrap-server.sh --server-name FQDN [OPTIONS]

Required:
  --server-name FQDN       Lowercase certname/DNS name used by all agents.

Options:
  --dns-alt-names LIST     Comma-separated additional server DNS names.
  --repository-url URL     Control repository remote.
  --branch NAME            Git branch deployed by r10k (default: production).
  --environment NAME       Puppet environment (default: production).
  --package-source SOURCE  distribution (default) or puppet-core.
  --api-key-file FILE      Root-only Puppet Core/Forge API key file.
  --release-url URL        Override Puppet Core release-package URL.
  --jvm-memory SIZE        Equal Puppet Server Xms/Xmx value (default: 1g).
  --skip-deploy            Configure server but do not run r10k.
  --no-start               Do not start/enable Puppet Server.
  --dry-run                Validate and print the plan without changing host.
  --os-release-file FILE   Alternate fixture for tests.
  --architecture ARCH      Override detected Debian architecture for tests.
  -h, --help               Show this help.
EOF
}

while (($#)); do
  case "$1" in
    --server-name) shift; server_name="${1:-}" ;;
    --dns-alt-names) shift; dns_alt_names="${1:-}" ;;
    --repository-url) shift; repository_url="${1:-}" ;;
    --branch) shift; branch="${1:-}" ;;
    --environment) shift; environment="${1:-}" ;;
    --package-source) shift; package_source="${1:-}" ;;
    --api-key-file) shift; api_key_file="${1:-}" ;;
    --release-url) shift; release_url="${1:-}" ;;
    --jvm-memory) shift; jvm_memory="${1:-}" ;;
    --skip-deploy) skip_deploy=true ;;
    --no-start) start_server=false ;;
    --dry-run) dry_run=true ;;
    --os-release-file) shift; os_release_file="${1:-}" ;;
    --architecture) shift; architecture="${1:-}" ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

[[ -n "${server_name}" ]] || { usage >&2; die '--server-name is required' 64; }
validate_certname "${server_name}"
validate_environment "${environment}"
[[ -n "${branch}" && "${branch}" != -* && "${branch}" != *$'\n'* ]] || die 'branch must be non-empty, single-line, and not start with a dash' 64
[[ -n "${repository_url}" && "${repository_url}" != -* && "${repository_url}" != *$'\n'* ]] || die 'repository URL must be non-empty, single-line, and not start with a dash' 64
[[ "${repository_url}" != *"'"* ]] || die "repository URL must not contain a single quote" 64
[[ "${branch}" == "${environment}" ]] || die 'branch and environment must match for Milestone 5 r10k deployment' 64
[[ "${package_source}" =~ ^(distribution|puppet-core)$ ]] || die 'package source must be distribution or puppet-core' 64
[[ "${jvm_memory}" =~ ^[0-9]+[mMgG]$ ]] || die 'JVM memory must look like 768m or 2g' 64
if [[ "${package_source}" == 'puppet-core' && -z "${api_key_file}" ]]; then die '--api-key-file is required for puppet-core' 64; fi
read_os_release "${os_release_file}"
is_supported_server_platform || die "unsupported Puppet Server platform ${ID} ${VERSION_ID}; use Debian 12 or Ubuntu 24.04" 69
[[ -n "${architecture}" ]] || architecture="$(dpkg --print-architecture 2>/dev/null || uname -m)"
[[ "${architecture}" == 'x86_64' ]] && architecture='amd64'
[[ "${architecture}" == 'amd64' ]] || die "unsupported Puppet Server architecture ${architecture}; Milestone 5 supports amd64" 69

all_dns_names="${server_name}"
if [[ -n "${dns_alt_names}" ]]; then
  IFS=',' read -r -a alt_names <<<"${dns_alt_names}"
  for name in "${alt_names[@]}"; do
    validate_certname "${name}"
    all_dns_names+=",${name}"
  done
fi
log "server platform: ${ID} ${VERSION_ID} ${architecture}"
log "server certname: ${server_name}"
log "DNS names: ${all_dns_names}"
log "code: ${repository_url} branch ${branch} -> environment ${environment}"
log "package source: ${package_source}; JVM heap: ${jvm_memory}"
if [[ "${dry_run}" == true ]]; then log 'server dry-run complete; no host changes were made'; exit 0; fi

require_root
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --yes ca-certificates curl git
if [[ "${package_source}" == 'puppet-core' ]]; then
  [[ -n "${release_url}" ]] || release_url="$(puppet_core_release_url)"
  [[ "${release_url}" == https://* ]] || die 'Puppet Core release URL must use HTTPS' 64
  configure_puppet_core_apt "${api_key_file}" "${release_url}"
else
  prepare_distribution_puppet_packages
fi

# Prevent a fresh package installation from starting Puppet Server before its
# certname and DNS alt names are configured. Preserve an administrator policy.
policy_backup=''
cleanup_policy() {
  if [[ -n "${policy_backup}" ]]; then mv -f -- "${policy_backup}" /usr/sbin/policy-rc.d
  elif [[ -f /usr/sbin/policy-rc.d ]] && grep -q 'SASD temporary policy' /usr/sbin/policy-rc.d; then rm -f -- /usr/sbin/policy-rc.d
  fi
}
trap cleanup_policy EXIT
if ! dpkg-query -W -f='${Status}' puppetserver 2>/dev/null | grep -q 'install ok installed'; then
  if [[ -e /usr/sbin/policy-rc.d ]]; then policy_backup="$(mktemp)"; cp -a /usr/sbin/policy-rc.d "${policy_backup}"; fi
  cat >/usr/sbin/policy-rc.d <<'EOF'
#!/bin/sh
# SASD temporary policy: configure Puppet Server before first start.
exit 101
EOF
  chmod 0755 /usr/sbin/policy-rc.d
fi
apt-get install --yes puppetserver r10k
cleanup_policy
trap - EXIT
systemctl stop puppetserver.service 2>/dev/null || true

puppet_bin="$(find_puppet)" || die 'puppet command not found after installation' 127
confdir="$("${puppet_bin}" config print confdir)"
codedir="$("${puppet_bin}" config print codedir)"
ssldir="$("${puppet_bin}" config print ssldir)"
cadir="$("${puppet_bin}" config print cadir)"
environmentpath="${codedir}/environments"
puppet_conf="${confdir}/puppet.conf"
log "detected Puppet paths: confdir=${confdir}, codedir=${codedir}, ssldir=${ssldir}, cadir=${cadir}"

# A Puppet CA and the server certificate are identity-bearing state. Re-running
# this bootstrap may update files, packages, or code, but it must never rename
# an existing CA host or silently change the DNS names embedded in its server
# certificate. Such changes require the documented certificate migration path.
if [[ -e "${cadir}/ca_crt.pem" ]]; then
  existing_certname="$("${puppet_bin}" config print certname 2>/dev/null || true)"
  existing_dns_names="$("${puppet_bin}" config print dns_alt_names --section server 2>/dev/null || true)"
  [[ "${existing_certname}" == "${server_name}" ]] || die "existing CA is configured for certname ${existing_certname:-unknown}; refusing rename to ${server_name}" 65
  [[ "${existing_dns_names}" == "${all_dns_names}" ]] || die "existing CA/server certificate uses DNS names ${existing_dns_names:-unknown}; refusing silent change to ${all_dns_names}" 65
fi

backup_once "${puppet_conf}"
install_text_if_changed "${puppet_conf}" 0644 <<EOF
# Managed by SASD bootstrap-server.sh. Move persistent changes into the
# repository/bootstrap implementation rather than editing this file ad hoc.
[main]
server = ${server_name}
certname = ${server_name}
environment = ${environment}
environmentpath = ${environmentpath}

[server]
dns_alt_names = ${all_dns_names}
autosign = false
EOF

install -d -m 0755 /etc/puppetlabs/r10k /var/cache/r10k "${environmentpath}"
backup_once /etc/puppetlabs/r10k/r10k.yaml
install_text_if_changed /etc/puppetlabs/r10k/r10k.yaml 0644 <<EOF
---
cachedir: /var/cache/r10k
deploy:
  purge_levels:
    - deployment
    - environment
    - puppetfile
sources:
  sasd:
    remote: '${repository_url}'
    basedir: '${environmentpath}'
EOF

# Install a stable operational copy outside the r10k-managed environment. The
# oneshot unit remains manual: Milestone 5 deliberately has no timer/webhook.
libexec_dir=/usr/local/libexec/sasd-puppet
install -d -m 0755 "${libexec_dir}/lib"
install -m 0755 "${SCRIPT_DIR}/deploy-environment.sh" "${libexec_dir}/deploy-environment.sh"
install -m 0644 "${SCRIPT_DIR}/lib/common.sh" "${libexec_dir}/lib/common.sh"
install -D -m 0644 "$(repository_root)/systemd/sasd-puppet-deploy.service" /etc/systemd/system/sasd-puppet-deploy.service
systemctl daemon-reload

# Adjust only the package's single JAVA_ARGS assignment and retain all other
# distribution defaults. A .pre-sasd backup is created once.
default_file=/etc/default/puppetserver
if [[ -f "${default_file}" ]]; then
  backup_once "${default_file}"
  if grep -q '^JAVA_ARGS=' "${default_file}"; then
    if grep -q -- '-Xms' "${default_file}"; then
      sed -i -E "s/-Xms[0-9]+[mMgG]/-Xms${jvm_memory}/" "${default_file}"
    else
      sed -i -E "s|^JAVA_ARGS=\"|JAVA_ARGS=\"-Xms${jvm_memory} |" "${default_file}"
    fi
    if grep -q -- '-Xmx' "${default_file}"; then
      sed -i -E "s/-Xmx[0-9]+[mMgG]/-Xmx${jvm_memory}/" "${default_file}"
    else
      sed -i -E "s|^JAVA_ARGS=\"|JAVA_ARGS=\"-Xmx${jvm_memory} |" "${default_file}"
    fi
  else
    printf '\nJAVA_ARGS="-Xms%s -Xmx%s"\n' "${jvm_memory}" "${jvm_memory}" >>"${default_file}"
  fi
fi

puppetserver_bin="$(find_puppetserver)" || die 'puppetserver command not found after installation' 127
if [[ -e "${cadir}/ca_crt.pem" ]]; then
  log 'existing Puppet CA detected; preserving it without regeneration'
else
  log 'initializing Puppet Server CA after final certname configuration'
  "${puppetserver_bin}" ca setup
fi

if [[ "${skip_deploy}" == false ]]; then
  "${libexec_dir}/deploy-environment.sh" --environment "${environment}" --branch "${branch}" --environmentpath "${environmentpath}"
fi
if [[ "${start_server}" == true ]]; then
  systemctl enable --now puppetserver.service
  systemctl --no-pager --full status puppetserver.service >/dev/null
fi
log 'Puppet Server bootstrap completed; review status and CA fingerprints before enrolling agents'
