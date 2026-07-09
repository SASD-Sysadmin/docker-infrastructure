#!/usr/bin/env bash
# Display local bootstrap and baseline status without changing the system.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
REPOSITORY_ROOT="$(repository_root)"

printf 'Repository: %s\n' "${REPOSITORY_ROOT}"
printf 'Version:    %s\n' "$(<"${REPOSITORY_ROOT}/VERSION")"
if git -C "${REPOSITORY_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  printf 'Git commit: %s\n' "$(git -C "${REPOSITORY_ROOT}" rev-parse --short HEAD)"
  printf 'Git state:  %s\n' "$(git -C "${REPOSITORY_ROOT}" status --porcelain | grep -q . && echo dirty || echo clean)"
fi
if puppet_bin="$(find_puppet)"; then
  printf 'Puppet:     %s (%s)\n' "${puppet_bin}" "$("${puppet_bin}" --version)"
else
  printf 'Puppet:     not installed\n'
fi
if command -v r10k >/dev/null 2>&1; then
  printf 'r10k:       %s\n' "$(r10k version 2>/dev/null || r10k --version 2>/dev/null || echo installed)"
else
  printf 'r10k:       not installed\n'
fi
if [[ -f /etc/sasd/puppet-baseline.conf ]]; then
  printf 'Marker:     present\n'
  sed 's/^/  /' /etc/sasd/puppet-baseline.conf
else
  printf 'Marker:     absent\n'
fi
