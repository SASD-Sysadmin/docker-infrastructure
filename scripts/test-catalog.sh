#!/usr/bin/env bash
# Compile supported fixture catalogs in no-op mode without touching the host.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
for facts in debian-12.yaml debian-13.yaml ubuntu-24.04.yaml almalinux-9.yaml rocky-9.yaml; do
  printf '==> Catalog fixture: %s\n' "${facts}"
  "${ROOT}/scripts/apply-local.sh" --noop --hiera-config "${ROOT}/spec/hiera.yaml" --facts "${ROOT}/tests/fixtures/facts/${facts}"
done
