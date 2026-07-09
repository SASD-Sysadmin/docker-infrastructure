#!/usr/bin/env bash
# Smoke test entry point for CI or a prepared development workstation.
set -euo pipefail

TEST_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly TEST_DIR
REPOSITORY_ROOT="$(cd -- "${TEST_DIR}/../.." && pwd -P)"
readonly REPOSITORY_ROOT
"${REPOSITORY_ROOT}/scripts/test-catalog.sh"
