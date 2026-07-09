#!/usr/bin/env bash
# Print a stable identifier for the code used to compile a Puppet catalog.
#
# Puppet Server executes this script through environment.conf. A local clone
# contains Git metadata. Standard r10k deployments and exported
# archives may not, so the VERSION fallback keeps catalog compilation functional
# and makes that limitation explicit. A deployment-metadata integration is a
# later Puppet Server stepstone.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
REPOSITORY_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly REPOSITORY_ROOT

if command -v git >/dev/null 2>&1 && git -C "${REPOSITORY_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "${REPOSITORY_ROOT}" rev-parse --verify HEAD
else
  printf 'archive-%s\n' "$(tr -d '[:space:]' < "${REPOSITORY_ROOT}/VERSION")"
fi
