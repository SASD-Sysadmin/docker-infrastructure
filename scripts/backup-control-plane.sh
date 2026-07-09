#!/usr/bin/env bash
# Create a root-only backup of Puppet control-plane identity/configuration state.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; source "${SCRIPT_DIR}/lib/common.sh"
output_dir='/var/backups/sasd-puppet'; include_puppetdb='auto'; dry_run=false
usage(){ printf 'Usage: %s [--output-directory PATH] [--include-puppetdb|--exclude-puppetdb] [--dry-run]\n' "$0"; }
while (($#)); do case "$1" in --output-directory) shift; output_dir="${1:-}";; --include-puppetdb) include_puppetdb=true;; --exclude-puppetdb) include_puppetdb=false;; --dry-run) dry_run=true;; -h|--help) usage; exit 0;; *) usage >&2; die "unknown argument: $1" 64;; esac; shift; done
[[ "${output_dir}" == /* ]] || die 'output directory must be absolute' 64
log "backup destination=${output_dir}; puppetdb=${include_puppetdb}"
[[ "$dry_run" == true ]] && { log 'dry-run complete; no backup created'; exit 0; }
require_root; puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
confdir="$(${puppet_bin} config print confdir)"; codedir="$(${puppet_bin} config print codedir)"; cadir="$(${puppet_bin} config print cadir)"
stage=$(mktemp -d); trap 'rm -rf -- "${stage}"' EXIT; chmod 0700 "$stage"; mkdir -p "$stage/rootfs" "$stage/metadata"
paths=("$confdir" "$cadir" "$codedir" /etc/puppetlabs/r10k /etc/default/puppetserver /etc/systemd/system/puppetserver.service.d /etc/sasd-puppet /var/lib/sasd-puppet)
for path in "${paths[@]}"; do [[ -e "$path" ]] && cp -a --parents "$path" "$stage/rootfs"; done
if [[ "$include_puppetdb" == auto ]]; then systemctl list-unit-files puppetdb.service >/dev/null 2>&1 && include_puppetdb=true || include_puppetdb=false; fi
if [[ "$include_puppetdb" == true ]]; then
  command -v pg_dump >/dev/null 2>&1 || die 'pg_dump required for PuppetDB backup' 127
  runuser -u postgres -- pg_dump --format=custom puppetdb >"$stage/metadata/puppetdb.dump"
fi
python3 - "$stage/metadata/backup.json" "$confdir" "$codedir" "$cadir" "$include_puppetdb" <<'PY2'
import json,sys,time
json.dump({'schema_version':2,'created_at':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'confdir':sys.argv[2],'codedir':sys.argv[3],'cadir':sys.argv[4],'puppetdb_included':sys.argv[5]=='true','contains_private_keys':True},open(sys.argv[1],'w'),indent=2); open(sys.argv[1],'a').write('\n')
PY2
cat >"$stage/metadata/README.txt" <<EOF2
SASD Puppet control-plane backup
Created UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)
Host: $(hostname -f 2>/dev/null || hostname)
Contains private CA and host keys. Keep offline, encrypted, and root-only.
PuppetDB dump included: ${include_puppetdb}
EOF2
(cd "$stage" && find . -type f ! -path './metadata/SHA256SUMS' -print0 | sort -z | xargs -0 sha256sum >metadata/SHA256SUMS)
install -d -m 0700 "$output_dir"; stamp=$(date -u +%Y%m%dT%H%M%SZ); archive="$output_dir/puppet-control-plane-${stamp}.tar.gz"
tar -C "$stage" -czf "$archive" .; chmod 0600 "$archive"; sha256sum "$archive" >"${archive}.sha256"; chmod 0600 "${archive}.sha256"
log "backup created: ${archive}"; log 'store it offline and encrypted; it contains CA private-key material'
