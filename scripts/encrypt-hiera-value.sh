#!/usr/bin/env bash
# Encrypt a secret read from stdin or a protected file without placing it in argv.
set -euo pipefail
public_key=/etc/sasd-puppet/eyaml/public_key.pkcs7.pem
input=''
label='sasd-secret'
usage(){ echo 'Usage: encrypt-hiera-value.sh [--public-key FILE] [--input FILE] [--label TEXT]'; }
while (($#)); do
  case "$1" in
    --public-key) public_key="${2:-}"; shift 2 ;;
    --input) input="${2:-}"; shift 2 ;;
    --label) label="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 64 ;;
  esac
done
[[ -r "$public_key" ]] || { echo 'ERROR: public key not readable' >&2; exit 66; }
command -v eyaml >/dev/null || { echo 'ERROR: eyaml not found' >&2; exit 127; }
tmp="$(mktemp)"
trap 'rm -f -- "$tmp"' EXIT
chmod 0600 "$tmp"
if [[ -n "$input" ]]; then
  [[ -f "$input" && ! -L "$input" ]] || { echo 'ERROR: input must be a regular non-symlink file' >&2; exit 66; }
  cat -- "$input" >"$tmp"
else
  cat >"$tmp"
fi
[[ -s "$tmp" ]] || { echo 'ERROR: secret input is empty' >&2; exit 65; }
printf '# label: %s\n' "$label" >&2
eyaml encrypt --pkcs7-public-key="$public_key" -f "$tmp"
