#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"; tmp=$(mktemp -d); trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/stage/metadata" "$tmp/stage/rootfs/etc/puppet"; echo sample >"$tmp/stage/rootfs/etc/puppet/puppet.conf"
(cd "$tmp/stage" && find . -type f ! -path './metadata/SHA256SUMS' -print0 | sort -z | xargs -0 sha256sum >metadata/SHA256SUMS)
tar -C "$tmp/stage" -czf "$tmp/backup.tar.gz" .; (cd "$tmp" && sha256sum backup.tar.gz >backup.tar.gz.sha256)
"${ROOT}/scripts/verify-backup.sh" "$tmp/backup.tar.gz" | grep -q 'completed'
echo 'Backup verification smoke test passed.'
