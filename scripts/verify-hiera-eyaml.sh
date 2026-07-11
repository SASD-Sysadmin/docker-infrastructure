#!/usr/bin/env bash
# Verify Hiera-eyaml installation, key custody, keypair consistency, and hierarchy.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
mode=server
key_directory=/etc/sasd-puppet/eyaml
server_group=puppet
roundtrip=false
usage(){ echo 'Usage: verify-hiera-eyaml.sh [--mode server|workstation] [--key-directory DIR] [--server-group GROUP] [--roundtrip]'; }
while (($#)); do
  case "$1" in
    --mode) mode="${2:-}"; shift 2 ;;
    --key-directory) key_directory="${2:-}"; shift 2 ;;
    --server-group) server_group="${2:-}"; shift 2 ;;
    --roundtrip) roundtrip=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 64 ;;
  esac
done
[[ "$mode" == server || "$mode" == workstation ]] || { echo 'ERROR: invalid mode' >&2; exit 64; }
[[ "$key_directory" == /* ]] || { echo 'ERROR: key directory must be absolute' >&2; exit 64; }
[[ "$server_group" =~ ^[A-Za-z_][A-Za-z0-9_-]*$ ]] || { echo 'ERROR: invalid server group' >&2; exit 64; }
private="$key_directory/private_key.pkcs7.pem"
public="$key_directory/public_key.pkcs7.pem"
[[ -f "$private" && ! -L "$private" && -r "$private" ]] || { echo 'ERROR: readable regular private key not found' >&2; exit 66; }
[[ -f "$public" && ! -L "$public" && -r "$public" ]] || { echo 'ERROR: readable regular public certificate not found' >&2; exit 66; }
command -v stat >/dev/null || { echo 'ERROR: stat not found' >&2; exit 127; }
owner_private="$(stat -c '%U' "$private")"; owner_public="$(stat -c '%U' "$public")"
group_private="$(stat -c '%G' "$private")"; group_public="$(stat -c '%G' "$public")"
mode_directory="$(stat -c '%a' "$key_directory")"; mode_private="$(stat -c '%a' "$private")"; mode_public="$(stat -c '%a' "$public")"
[[ "$owner_private" == root && "$owner_public" == root ]] || { echo 'ERROR: keys must be owned by root' >&2; exit 77; }
if [[ "$mode" == server ]]; then
  [[ "$group_private" == "$server_group" && "$group_public" == "$server_group" ]] || { echo 'ERROR: server keys have unexpected group' >&2; exit 77; }
  [[ "$mode_directory" == 750 && "$mode_private" == 640 && "$mode_public" == 644 ]] || { echo 'ERROR: server key modes must be 0750/0640/0644' >&2; exit 77; }
else
  [[ "$group_private" == root && "$group_public" == root ]] || { echo 'ERROR: workstation keys must be root:root' >&2; exit 77; }
  [[ "$mode_directory" == 700 && "$mode_private" == 600 && "$mode_public" == 644 ]] || { echo 'ERROR: workstation key modes must be 0700/0600/0644' >&2; exit 77; }
fi
command -v openssl >/dev/null || { echo 'ERROR: openssl not found' >&2; exit 127; }
priv_mod="$(openssl rsa -in "$private" -noout -modulus 2>/dev/null | openssl sha256)"
pub_mod="$(openssl x509 -in "$public" -noout -modulus 2>/dev/null | openssl sha256)"
[[ "$priv_mod" == "$pub_mod" ]] || { echo 'ERROR: public certificate does not match private key' >&2; exit 65; }
python3 "$ROOT/scripts/check_secure_data_policy.py" >/dev/null
if [[ "$mode" == server ]]; then
  command -v puppetserver >/dev/null || { echo 'ERROR: puppetserver not found' >&2; exit 127; }
  puppetserver gem list -i hiera-eyaml -v 5.0.1 >/dev/null || { echo 'ERROR: puppetserver hiera-eyaml 5.0.1 missing' >&2; exit 69; }
else
  command -v eyaml >/dev/null || { echo 'ERROR: eyaml not found' >&2; exit 127; }
fi
if [[ "$roundtrip" == true ]]; then
  command -v eyaml >/dev/null || { echo 'ERROR: eyaml CLI required for roundtrip' >&2; exit 127; }
  tmp="$(mktemp -d)"
  trap 'rm -rf -- "$tmp"' EXIT
  umask 077
  printf 'sasd-eyaml-roundtrip-%s' "$$" >"$tmp/plain"
  eyaml encrypt --pkcs7-public-key="$public" -f "$tmp/plain" >"$tmp/encrypted.out"
  python3 - "$tmp/encrypted.out" "$tmp/encrypted" <<'PY2'
import pathlib
import re
import sys
text = pathlib.Path(sys.argv[1]).read_text()
blocks = re.findall(r'ENC\[PKCS7,[A-Za-z0-9+/=\n\r ]+\]', text)
if not blocks:
    raise SystemExit('encrypted block not found')
pathlib.Path(sys.argv[2]).write_text(blocks[-1].replace('\n', '').replace('\r', '').replace(' ', ''))
PY2
  eyaml decrypt --pkcs7-private-key="$private" --pkcs7-public-key="$public" -f "$tmp/encrypted" >"$tmp/decrypted"
  cmp -s "$tmp/plain" "$tmp/decrypted" || { echo 'ERROR: eyaml roundtrip mismatch' >&2; exit 65; }
fi
printf 'Hiera-eyaml verification passed for %s.\n' "$key_directory"
