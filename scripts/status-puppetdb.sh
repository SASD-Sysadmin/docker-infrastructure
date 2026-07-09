#!/usr/bin/env bash
# Show local PuppetDB service and authenticated API status.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; source "${SCRIPT_DIR}/lib/common.sh"
json=false; [[ "${1:-}" == '--json' ]] && json=true; [[ $# -le 1 ]] || die 'Usage: status-puppetdb.sh [--json]' 64
require_root
puppet_bin="$(find_puppet)" || die 'puppet command not found' 127
for unit in postgresql.service puppetdb.service puppetserver.service; do systemctl is-active --quiet "$unit" || die "$unit is not active" 2; done
cert="$(${puppet_bin} config print hostcert)"; key="$(${puppet_bin} config print hostprivkey)"; ca="$(${puppet_bin} config print localcacert)"
for f in "$cert" "$key" "$ca"; do [[ -r "$f" ]] || die "required TLS file missing: $f" 66; done
version=$(curl --silent --show-error --fail --cert "$cert" --key "$key" --cacert "$ca" https://127.0.0.1:8081/pdb/meta/v1/version)
if [[ "$json" == true ]]; then printf '{"status":"ok","version":%s}\n' "$version"; else printf 'PuppetDB status: OK\nVersion response: %s\n' "$version"; fi
