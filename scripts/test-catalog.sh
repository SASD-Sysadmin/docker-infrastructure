#!/usr/bin/env bash
# Compile the default catalog through the safe local apply wrapper.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
"${SCRIPT_DIR}/apply-local.sh" --noop
