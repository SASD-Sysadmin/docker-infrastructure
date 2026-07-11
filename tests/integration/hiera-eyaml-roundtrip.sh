#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
command -v eyaml >/dev/null || { echo 'SKIP: eyaml not installed' >&2; exit 77; }
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 1 -subj '/CN=integration/' \
  -keyout "$tmp/private_key.pkcs7.pem" -out "$tmp/public_key.pkcs7.pem" >/dev/null 2>&1
printf 'integration-secret' >"$tmp/plain"
eyaml encrypt --pkcs7-public-key="$tmp/public_key.pkcs7.pem" -f "$tmp/plain" >"$tmp/out"
python3 - "$tmp/out" "$tmp/encrypted" <<'PY2'
import pathlib
import re
import sys
text = pathlib.Path(sys.argv[1]).read_text()
blocks = re.findall(r'ENC\[PKCS7,[A-Za-z0-9+/=\n\r ]+\]', text)
assert blocks
pathlib.Path(sys.argv[2]).write_text(blocks[-1].replace('\n', '').replace('\r', '').replace(' ', ''))
PY2
eyaml decrypt --pkcs7-private-key="$tmp/private_key.pkcs7.pem" \
  --pkcs7-public-key="$tmp/public_key.pkcs7.pem" -f "$tmp/encrypted" >"$tmp/decrypted"
cmp -s "$tmp/plain" "$tmp/decrypted"
printf 'Hiera-eyaml integration roundtrip passed.\n'
