#!/usr/bin/env bash
# Fast-forward a local clone, refresh Puppetfile modules, then run no-op/apply.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
REPOSITORY_ROOT="$(repository_root)"
mode='--noop'
case "${1:-}" in
  '') ;;
  --noop) mode='--noop' ;;
  --apply) mode='--apply' ;;
  *) die 'Usage: update-local.sh [--noop|--apply]' 64 ;;
esac
[[ $# -le 1 ]] || die 'Usage: update-local.sh [--noop|--apply]' 64

if [[ -n "$(git -C "${REPOSITORY_ROOT}" status --porcelain)" ]]; then
  die 'repository contains local changes; refusing to update' 65
fi
branch="$(git -C "${REPOSITORY_ROOT}" branch --show-current)"
[[ -n "${branch}" ]] || die 'detached HEAD is not supported by update-local.sh' 65
log "fast-forwarding branch ${branch}"
git -C "${REPOSITORY_ROOT}" pull --ff-only origin "${branch}"
"${REPOSITORY_ROOT}/scripts/install-module-dependencies.sh"
"${REPOSITORY_ROOT}/scripts/validate.sh"
"${REPOSITORY_ROOT}/scripts/apply-local.sh" "${mode}"
