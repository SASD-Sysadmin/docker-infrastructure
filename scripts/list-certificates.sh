#!/usr/bin/env bash
# List pending or all certificates from the Puppet Server CA.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

all=false
usage() { printf 'Usage: %s [--all]\n' "$0"; }
while (($#)); do
  case "$1" in
    --all) all=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; die "unknown argument: $1" 64 ;;
  esac
  shift
done

require_root
bin="$(find_puppetserver)" || die 'puppetserver command not found' 127
if [[ "${all}" == true ]]; then
  "${bin}" ca list --all
else
  "${bin}" ca list
fi
