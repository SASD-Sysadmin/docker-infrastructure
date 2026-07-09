#!/usr/bin/env bash
# Produce a compact Puppet control-plane health result for systemd/monitoring.
set -euo pipefail
output=''; max_deploy_age=86400; max_report_age=7200
usage(){ printf 'Usage: %s [--output FILE] [--max-deploy-age SECONDS] [--max-report-age SECONDS]\n' "$0"; }
while (($#)); do case "$1" in
  --output) shift; output="${1:-}";;
  --max-deploy-age) shift; max_deploy_age="${1:-}";;
  --max-report-age) shift; max_report_age="${1:-}";;
  -h|--help) usage; exit 0;;
  *) usage >&2; exit 64;;
esac; shift; done
[[ "${max_deploy_age}" =~ ^[0-9]+$ && "${max_report_age}" =~ ^[0-9]+$ ]] || { echo 'ages must be integer seconds' >&2; exit 64; }
now=$(date +%s); status='ok'; messages=()
mark_warning(){ [[ "${status}" == critical ]] || status='warning'; messages+=("$1"); }
mark_critical(){ status='critical'; messages+=("$1"); }
systemctl_bin="${SYSTEMCTL_BIN:-systemctl}"
service_state(){ "${systemctl_bin}" is-active --quiet "$1"; }
service_state puppetserver.service || mark_critical 'puppetserver service is not active'
puppet_bin="${PUPPET_BIN:-}"; if [[ -z "${puppet_bin}" ]]; then for c in /opt/puppetlabs/bin/puppet /usr/bin/puppet; do [[ -x "$c" ]] && { puppet_bin="$c"; break; }; done; fi
if [[ -z "${puppet_bin}" ]]; then mark_critical 'puppet command not found';
else
  envpath="${ENVIRONMENT_PATH:-$("${puppet_bin}" config print environmentpath 2>/dev/null || true)}"
  [[ -f "${envpath}/production/manifests/site.pp" ]] || mark_critical 'production environment is not deployed'
  cadir="${CA_DIR:-$("${puppet_bin}" config print cadir 2>/dev/null || true)}"
  [[ -s "${cadir}/ca_crt.pem" ]] || mark_critical 'CA certificate is missing'
fi
state_root="${SASD_PUPPET_STATE_ROOT:-/var/lib/sasd-puppet}"
deploy_state="${state_root}/deployments/production.status"
if [[ -f "${deploy_state}" ]]; then
  age=$((now-$(stat -c %Y "${deploy_state}")))
  (( age <= max_deploy_age )) || mark_warning "production deployment status is ${age}s old"
else mark_warning 'production deployment status is missing'; fi
report_dir="${SASD_PUPPET_REPORT_DIR:-${state_root}/reports}"
latest_report=0; failed_reports=0; report_count=0
if [[ -d "${report_dir}" ]]; then
  while IFS= read -r -d '' file; do
    ((report_count+=1)); m=$(stat -c %Y "$file"); ((m>latest_report)) && latest_report=$m
    grep -Eq '"status"[[:space:]]*:[[:space:]]*"failed"' "$file" && ((failed_reports+=1))
  done < <(find "${report_dir}" -maxdepth 1 -type f -name '*.json' -print0)
  if (( report_count>0 )); then age=$((now-latest_report)); (( age <= max_report_age )) || mark_warning "latest report is ${age}s old"; fi
fi
(( failed_reports == 0 )) || mark_warning "${failed_reports} latest node report(s) are failed"
if "${systemctl_bin}" list-unit-files puppetdb.service >/dev/null 2>&1; then service_state puppetdb.service || mark_critical 'puppetdb service is installed but inactive'; fi
message=$(IFS='; '; echo "${messages[*]:-healthy}")
json=$(python3 -c 'import json,sys,time; print(json.dumps({"schema_version":1,"time":time.strftime("%Y-%m-%dT%H:%M:%SZ",time.gmtime()),"status":sys.argv[1],"message":sys.argv[2],"report_count":int(sys.argv[3]),"failed_reports":int(sys.argv[4])},indent=2))' "${status}" "${message}" "${report_count}" "${failed_reports}")
if [[ -n "${output}" ]]; then install -D -m 0640 /dev/null "${output}"; printf '%s\n' "${json}" >"${output}"; else printf '%s\n' "${json}"; fi
case "${status}" in ok) exit 0;; warning) exit 1;; critical) exit 2;; esac
