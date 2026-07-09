#!/usr/bin/env bash
# Verify archive checksum, readability, and internal file checksums.
set -euo pipefail
archive="${1:-}"; [[ -n "$archive" && -f "$archive" ]] || { echo "Usage: $0 ARCHIVE.tar.gz" >&2; exit 64; }
checksum="${archive}.sha256"; [[ -f "$checksum" ]] || { echo "Missing $checksum" >&2; exit 66; }
(cd "$(dirname "$archive")" && sha256sum -c "$(basename "$checksum")")
stage=$(mktemp -d); trap 'rm -rf -- "$stage"' EXIT; tar -C "$stage" -xzf "$archive"
[[ -f "$stage/metadata/SHA256SUMS" ]] || { echo 'Missing internal checksum manifest' >&2; exit 65; }
(cd "$stage" && sha256sum -c metadata/SHA256SUMS)
printf 'Backup verification completed: %s\n' "$archive"
