#!/usr/bin/env bash
# Revoke/delete one certificate only after an exact confirmation value.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

certname=''
confirm=''
usage() { printf 'Usage: %s --certname NAME --confirm NAME\n' "$0"; }
while (($#)); do
  case "$1" in
    --certname) shift; certname="${1:-}" ;;
    --confirm) shift; confirm="${1:-}" ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

[[ -n "${certname}" ]] || die '--certname is required' 64
validate_certname "${certname}"
[[ "${confirm}" == "${certname}" ]] || die '--confirm must exactly equal --certname' 64
require_root
bin="$(find_puppetserver)" || die 'puppetserver command not found' 127
"${bin}" ca list --all --certname "${certname}" || true
"${bin}" ca clean --certname "${certname}"
log "certificate state cleaned for ${certname}; clean agent SSL state before re-enrollment"
