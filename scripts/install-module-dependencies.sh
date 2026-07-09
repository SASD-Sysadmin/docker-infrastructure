#!/usr/bin/env bash
# Install Puppetfile dependencies into ./modules through r10k.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
REPOSITORY_ROOT="$(repository_root)"

command -v r10k >/dev/null 2>&1 || die 'r10k executable not found; install the r10k package' 127
cd "${REPOSITORY_ROOT}"
log 'validating Puppetfile'
r10k puppetfile check
log 'installing pinned Puppetfile dependencies'
r10k puppetfile install
