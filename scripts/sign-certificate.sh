#!/usr/bin/env bash
# Sign exactly one reviewed pending CSR. Autosigning is intentionally absent.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

certname=''
usage() { printf 'Usage: %s --certname NAME\n' "$0"; }
while (($#)); do
  case "$1" in
    --certname) shift; certname="${1:-}" ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

[[ -n "${certname}" ]] || die '--certname is required' 64
validate_certname "${certname}"
require_root
bin="$(find_puppetserver)" || die 'puppetserver command not found' 127
log "pending request details for ${certname}:"
"${bin}" ca list --certname "${certname}"
"${bin}" ca sign --certname "${certname}"
log "signed certificate for ${certname}; activate the agent only after verifying this identity"
