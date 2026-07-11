#!/usr/bin/env bash
# Install hiera-eyaml and create PKCS7 keys outside the control repository.
set -euo pipefail
version='5.0.1'; key_directory='/etc/sasd-puppet/eyaml'; mode='server'; server_group='puppet'; apply=false
usage(){ cat <<'USAGE'
Usage: setup-hiera-eyaml.sh [--mode server|workstation] [--key-directory DIR] [--version VERSION] [--server-group GROUP] [--apply]

Default is a dry run. Server mode uses `puppetserver gem`; workstation mode uses
`gem`. Keys are never created inside the control repository.
USAGE
}
while (($#)); do
  case "$1" in
    --mode) mode="${2:-}"; shift 2 ;;
    --key-directory) key_directory="${2:-}"; shift 2 ;;
    --version) version="${2:-}"; shift 2 ;;
    --server-group) server_group="${2:-}"; shift 2 ;;
    --apply) apply=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; exit 64 ;;
  esac
done
[[ "${mode}" == server || "${mode}" == workstation ]] || { echo 'ERROR: mode must be server or workstation' >&2; exit 64; }
[[ "${key_directory}" == /* ]] || { echo 'ERROR: key directory must be absolute' >&2; exit 64; }
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
case "${key_directory}/" in "${repo_root}/"*) echo 'ERROR: key directory must be outside the repository' >&2; exit 64;; esac
[[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo 'ERROR: version must be semantic x.y.z' >&2; exit 64; }
installer=(gem install hiera-eyaml --version "${version}" --no-document)
[[ "${mode}" == server ]] && installer=(puppetserver gem install hiera-eyaml --version "${version}" --no-document)
printf 'Plan:\n-'
printf ' %q' "${installer[@]}"
printf '\n- create PKCS7 keys in %s\n' "${key_directory}"
if [[ "${mode}" == server ]]; then printf -- '- grant read access only to root and group %s\n' "${server_group}"; else printf -- '- enforce root-only key permissions\n'; fi
if [[ "${apply}" != true ]]; then echo 'Dry run only. Add --apply to execute.'; exit 0; fi
[[ ${EUID} -eq 0 ]] || { echo 'ERROR: --apply requires root' >&2; exit 77; }
command -v "${installer[0]}" >/dev/null 2>&1 || { echo "ERROR: ${installer[0]} not found" >&2; exit 69; }
command -v openssl >/dev/null 2>&1 || { echo 'ERROR: openssl not found' >&2; exit 69; }
"${installer[@]}"
if [[ "${mode}" == server ]]; then
  getent group "${server_group}" >/dev/null 2>&1 || { echo "ERROR: server group not found: ${server_group}" >&2; exit 67; }
  install -d -o root -g "${server_group}" -m 0750 "${key_directory}"
else
  install -d -o root -g root -m 0700 "${key_directory}"
fi
set_key_permissions() {
  if [[ "${mode}" == server ]]; then
    chown root:"${server_group}" "${key_directory}"/*.pem
    chmod 0640 "${key_directory}/private_key.pkcs7.pem"
    chmod 0644 "${key_directory}/public_key.pkcs7.pem"
  else
    chown root:root "${key_directory}"/*.pem
    chmod 0600 "${key_directory}/private_key.pkcs7.pem"
    chmod 0644 "${key_directory}/public_key.pkcs7.pem"
  fi
}
verify_keypair() {
  local private_modulus public_modulus
  private_modulus="$(openssl rsa -in "${key_directory}/private_key.pkcs7.pem" -noout -modulus 2>/dev/null | openssl sha256)"
  public_modulus="$(openssl x509 -in "${key_directory}/public_key.pkcs7.pem" -noout -modulus 2>/dev/null | openssl sha256)"
  [[ -n "${private_modulus}" && "${private_modulus}" == "${public_modulus}" ]] || { echo 'ERROR: existing public certificate does not match private key' >&2; exit 65; }
}
if [[ -e "${key_directory}/private_key.pkcs7.pem" || -e "${key_directory}/public_key.pkcs7.pem" ]]; then
  [[ -f "${key_directory}/private_key.pkcs7.pem" && ! -L "${key_directory}/private_key.pkcs7.pem" ]] || { echo 'ERROR: private key must be a regular non-symlink file' >&2; exit 73; }
  [[ -f "${key_directory}/public_key.pkcs7.pem" && ! -L "${key_directory}/public_key.pkcs7.pem" ]] || { echo 'ERROR: public key must be a regular non-symlink file' >&2; exit 73; }
  verify_keypair
  set_key_permissions
  echo 'Existing complete matching keypair retained; ownership and modes were enforced.'
  exit 0
fi
if [[ "${mode}" == server ]]; then
  puppetserver gem list -i hiera-eyaml >/dev/null
else
  command -v eyaml >/dev/null 2>&1 || { echo 'ERROR: eyaml CLI not found in PATH after installation' >&2; exit 69; }
fi
( umask 077; openssl req -x509 -sha256 -nodes -newkey rsa:4096 -days 3650 \
    -subj '/CN=SASD Hiera eyaml/' \
    -keyout "${key_directory}/private_key.pkcs7.pem" \
    -out "${key_directory}/public_key.pkcs7.pem" >/dev/null 2>&1 )
verify_keypair
set_key_permissions
echo "hiera-eyaml ${version} installed and keys created in ${key_directory}. The active hierarchy is ready for reviewed encrypted per-node data."
