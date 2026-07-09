#!/usr/bin/env bash
# Generate compliance, health, and low-cardinality Prometheus snapshots.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
output_dir='/var/lib/sasd-puppet/monitoring'; reports='/var/lib/sasd-puppet/reports'; environment='production'; max_age=7200
usage(){ printf 'Usage: %s [--output-directory PATH] [--reports PATH] [--environment NAME] [--max-age SECONDS]\n' "$0"; }
while (($#)); do case "$1" in --output-directory) shift; output_dir="${1:-}";; --reports) shift; reports="${1:-}";; --environment) shift; environment="${1:-}";; --max-age) shift; max_age="${1:-}";; -h|--help) usage; exit 0;; *) usage >&2; exit 64;; esac; shift; done
[[ "$output_dir" == /* && "$reports" == /* && "$environment" =~ ^[a-zA-Z0-9_]+$ && "$max_age" =~ ^[0-9]+$ ]] || { echo 'invalid argument' >&2; exit 64; }
puppet_bin=''; for p in /opt/puppetlabs/bin/puppet /usr/bin/puppet; do [[ -x "$p" ]] && { puppet_bin="$p"; break; }; done
[[ -n "$puppet_bin" ]] || { echo 'puppet command not found' >&2; exit 127; }
envpath="$($puppet_bin config print environmentpath)"; repo="${envpath}/${environment}"
[[ -x "${repo}/scripts/fleet-compliance.rb" && -x /usr/local/libexec/sasd-puppet/sasd-puppet-monitoring-export.py ]] || { echo "required monitoring scripts are missing" >&2; exit 66; }
install -d -o puppet -g puppet -m 0750 "$output_dir"
tmp=$(mktemp -d "$output_dir/.snapshot.XXXXXX"); trap 'rm -rf -- "$tmp"' EXIT
set +e
ruby "${repo}/scripts/fleet-compliance.rb" --reports "$reports" --max-age "$max_age" --format json >"$tmp/compliance.json"; compliance_rc=$?
/usr/local/sbin/sasd-puppet-health --output "$tmp/health.json" --max-report-age "$max_age"; health_rc=$?
python3 /usr/local/libexec/sasd-puppet/sasd-puppet-monitoring-export.py --compliance "$tmp/compliance.json" --health "$tmp/health.json" --format prometheus --output "$tmp/sasd_puppet.prom"; export_rc=$?
set -e
install -o puppet -g puppet -m 0640 "$tmp/compliance.json" "$output_dir/compliance.json"
install -o puppet -g puppet -m 0640 "$tmp/health.json" "$output_dir/health.json"
install -o puppet -g puppet -m 0640 "$tmp/sasd_puppet.prom" "$output_dir/sasd_puppet.prom"
(( export_rc>0 )) && exit "$export_rc"; (( health_rc>0 )) && exit "$health_rc"; exit "$compliance_rc"
