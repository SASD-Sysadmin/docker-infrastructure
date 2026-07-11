#!/usr/bin/env bash
# Create a candidate replacement keypair outside Git; never activates or re-encrypts data.
set -euo pipefail
current=/etc/sasd-puppet/eyaml
output=''
confirm=''
usage(){ echo 'Usage: stage-hiera-eyaml-key-rotation.sh --output-directory DIR --confirm DIR [--current-key-directory DIR]'; }
while (($#)); do
  case "$1" in
    --output-directory) output="${2:-}"; shift 2 ;;
    --confirm) confirm="${2:-}"; shift 2 ;;
    --current-key-directory) current="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 64 ;;
  esac
done
[[ "$output" == /* && "$confirm" == "$output" ]] || { usage >&2; exit 64; }
case "$output" in
  /|/etc|/var|/opt|/usr|/srv|/root|/home) echo 'ERROR: unsafe candidate directory' >&2; exit 65 ;;
esac
private="$current/private_key.pkcs7.pem"
public="$current/public_key.pkcs7.pem"
[[ -f "$private" && ! -L "$private" && -r "$private" ]] || { echo 'ERROR: current private key missing or unsafe' >&2; exit 66; }
[[ -f "$public" && ! -L "$public" && -r "$public" ]] || { echo 'ERROR: current public certificate missing or unsafe' >&2; exit 66; }
[[ ! -e "$output" ]] || { echo 'ERROR: output must not already exist' >&2; exit 73; }
command -v openssl >/dev/null || { echo 'ERROR: openssl not found' >&2; exit 127; }
current_private_modulus="$(openssl rsa -in "$private" -noout -modulus 2>/dev/null | openssl sha256)"
current_public_modulus="$(openssl x509 -in "$public" -noout -modulus 2>/dev/null | openssl sha256)"
[[ -n "$current_private_modulus" && "$current_private_modulus" == "$current_public_modulus" ]] || { echo 'ERROR: current keypair does not match' >&2; exit 65; }
parent="$(dirname -- "$output")"
base="$(basename -- "$output")"
[[ -d "$parent" && ! -L "$parent" ]] || { echo 'ERROR: output parent must be an existing non-symlink directory' >&2; exit 66; }
umask 077
staging="$(mktemp -d -- "$parent/.${base}.tmp.XXXXXX")"
cleanup(){ [[ -z "${staging:-}" ]] || rm -rf -- "$staging"; }
trap cleanup EXIT
openssl req -x509 -sha256 -nodes -newkey rsa:4096 -days 3650 \
  -subj '/CN=SASD Hiera eyaml rotation candidate/' \
  -keyout "$staging/private_key.pkcs7.pem" \
  -out "$staging/public_key.pkcs7.pem" >/dev/null 2>&1
chmod 0600 "$staging/private_key.pkcs7.pem"
chmod 0644 "$staging/public_key.pkcs7.pem"
candidate_private_modulus="$(openssl rsa -in "$staging/private_key.pkcs7.pem" -noout -modulus 2>/dev/null | openssl sha256)"
candidate_public_modulus="$(openssl x509 -in "$staging/public_key.pkcs7.pem" -noout -modulus 2>/dev/null | openssl sha256)"
[[ -n "$candidate_private_modulus" && "$candidate_private_modulus" == "$candidate_public_modulus" ]] || { echo 'ERROR: candidate keypair verification failed' >&2; exit 65; }
python3 - "$staging/rotation.json" "$current" "$staging" <<'PY2'
import hashlib
import json
import pathlib
import sys
import time
old = pathlib.Path(sys.argv[2])
new = pathlib.Path(sys.argv[3])
def sha(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()
payload = {
    'schema_version': 1,
    'created_at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
    'status': 'candidate-only',
    'current_public_sha256': sha(old / 'public_key.pkcs7.pem'),
    'candidate_public_sha256': sha(new / 'public_key.pkcs7.pem'),
    'automatic_activation': False,
    'automatic_recryption': False,
}
pathlib.Path(sys.argv[1]).write_text(json.dumps(payload, indent=2) + '\n')
PY2
mv -- "$staging" "$output"
staging=''
printf 'Candidate keypair staged at %s. No active key or encrypted data was changed.\n' "$output"
