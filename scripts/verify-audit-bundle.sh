#!/usr/bin/env bash
# Verify an SASD Puppet audit evidence bundle and its no-secret contract.
set -euo pipefail
archive="${1:-}"; [[ -f "$archive" ]] || { echo "Usage: $0 BUNDLE.tar.gz" >&2; exit 64; }
[[ -f "$archive.sha256" ]] || { echo "Missing $archive.sha256" >&2; exit 66; }
(cd "$(dirname "$archive")" && sha256sum -c "$(basename "$archive.sha256")")
stage=$(mktemp -d); trap 'rm -rf -- "$stage"' EXIT
python3 - "$archive" <<'PYSAFE'
import sys,tarfile,pathlib
with tarfile.open(sys.argv[1],'r:gz') as t:
    for m in t.getmembers():
        if m.name.startswith('/') or '..' in pathlib.Path(m.name).parts:
            raise SystemExit(f'Unsafe archive path: {m.name}')
PYSAFE
tar -C "$stage" -xzf "$archive"
(cd "$stage" && sha256sum -c metadata/SHA256SUMS)
python3 - "$stage/metadata/bundle.json" <<'PY'
import json,sys
x=json.load(open(sys.argv[1]))
assert x['schema_version']==1
assert x['contains_private_keys'] is False
assert x['contains_secret_values'] is False
PY
find "$stage" -type f \( -name '*.pem' -o -name '*.key' -o -name '*.p12' -o -name '*.pfx' \) -print -quit | grep -q . && { echo 'Audit bundle contains forbidden key material' >&2; exit 65; } || true
printf 'Audit bundle verification completed: %s\n' "$archive"
