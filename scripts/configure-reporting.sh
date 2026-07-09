#!/usr/bin/env bash
# Enable the SASD compact JSON report processor on Puppet Server.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "${SCRIPT_DIR}/lib/common.sh"
report_dir='/var/lib/sasd-puppet/reports'; restart=true; dry_run=false
usage(){ printf 'Usage: %s [--report-directory PATH] [--no-restart] [--dry-run]\n' "$0"; }
while (($#)); do case "$1" in
  --report-directory) shift; report_dir="${1:-}";;
  --no-restart) restart=false;;
  --dry-run) dry_run=true;;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
[[ "${report_dir}" =~ ^/[A-Za-z0-9._/-]+$ ]] || die 'report directory must be an absolute path containing only safe characters' 64
log "report processor: store,sasd_json; directory=${report_dir}; restart=${restart}"
[[ "${dry_run}" == true ]] && { log 'dry-run complete; no settings changed'; exit 0; }
require_root
puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
systemctl list-unit-files puppetserver.service >/dev/null 2>&1 || die 'puppetserver.service not installed' 69
install -d -o puppet -g puppet -m 0750 "${report_dir}"
"${puppet_bin}" config set reports store,sasd_json --section master
# The processor has a safe default path. A systemd environment override is used
# only when the operator selected a non-default destination.
override_dir=/etc/systemd/system/puppetserver.service.d
install -d -m 0755 "${override_dir}"
printf '[Service]\nEnvironment="SASD_PUPPET_REPORT_DIR=%s"\n' "${report_dir}" >"${override_dir}/sasd-reporting.conf"
chmod 0644 "${override_dir}/sasd-reporting.conf"
systemctl daemon-reload
if [[ "${restart}" == true ]]; then systemctl restart puppetserver.service; fi
log 'reporting configured; deploy production code before expecting sasd_json output'
