#!/usr/bin/env bash
# Shared helpers for SASD Puppet bootstrap and operation scripts.

log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
warn() { printf 'WARNING: %s\n' "$*" >&2; }
die() { local message="$1" code="${2:-1}"; printf 'ERROR: %s\n' "${message}" >&2; exit "${code}"; }

repository_root() {
  local source_dir
  source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
  printf '%s\n' "${source_dir}"
}

find_puppet() {
  local candidate
  for candidate in "${PUPPET_BIN:-}" /opt/puppetlabs/bin/puppet /usr/bin/puppet puppet; do
    [[ -n "${candidate}" ]] || continue
    if [[ "${candidate}" == */* ]]; then
      [[ -x "${candidate}" ]] && { printf '%s\n' "${candidate}"; return 0; }
    elif command -v "${candidate}" >/dev/null 2>&1; then
      command -v "${candidate}"; return 0
    fi
  done
  return 1
}

find_puppetserver() {
  local candidate
  for candidate in "${PUPPETSERVER_BIN:-}" /opt/puppetlabs/bin/puppetserver /usr/bin/puppetserver puppetserver; do
    [[ -n "${candidate}" ]] || continue
    if [[ "${candidate}" == */* ]]; then
      [[ -x "${candidate}" ]] && { printf '%s\n' "${candidate}"; return 0; }
    elif command -v "${candidate}" >/dev/null 2>&1; then
      command -v "${candidate}"; return 0
    fi
  done
  return 1
}

find_r10k() {
  local candidate
  for candidate in "${R10K_BIN:-}" /opt/puppetlabs/puppet/bin/r10k /usr/bin/r10k r10k; do
    [[ -n "${candidate}" ]] || continue
    if [[ "${candidate}" == */* ]]; then
      [[ -x "${candidate}" ]] && { printf '%s\n' "${candidate}"; return 0; }
    elif command -v "${candidate}" >/dev/null 2>&1; then
      command -v "${candidate}"; return 0
    fi
  done
  return 1
}

require_root() { [[ "${EUID}" -eq 0 ]] || die 'this operation requires root privileges' 77; }

read_os_release() {
  local file="${1:-/etc/os-release}"
  [[ -r "${file}" ]] || die "cannot read operating-system metadata: ${file}" 66
  # Parse as data. Never source root-controlled bootstrap input.
  ID="$(sed -nE 's/^ID=(.*)$/\1/p' "${file}" | head -n 1 | tr -d '"' | tr '[:upper:]' '[:lower:]')"
  VERSION_ID="$(sed -nE 's/^VERSION_ID=(.*)$/\1/p' "${file}" | head -n 1 | tr -d '"')"
  [[ -n "${ID}" ]] || die "missing ID in ${file}" 65
  [[ -n "${VERSION_ID}" ]] || die "missing VERSION_ID in ${file}" 65
  export ID VERSION_ID
}

is_supported_agent_platform() {
  case "${ID}:${VERSION_ID}" in debian:12|debian:13|ubuntu:24.04) return 0;; *) return 1;; esac
}

# Backward-compatible name used by the standalone Milestone 2 bootstrap.
is_supported_platform() { is_supported_agent_platform; }

is_supported_server_platform() {
  case "${ID}:${VERSION_ID}" in debian:12|ubuntu:24.04) return 0;; *) return 1;; esac
}

validate_certname() {
  [[ "$1" =~ ^[a-z0-9][a-z0-9._-]*$ ]] || die "invalid Puppet certname: $1" 64
  [[ "$1" != 'ca' ]] || die 'the certname ca is reserved by Puppet' 64
}

validate_environment() {
  [[ "$1" =~ ^[a-z0-9_]+$ ]] || die "invalid Puppet environment: $1" 64
}

validate_git_branch() {
  command -v git >/dev/null 2>&1 || return 0
  git check-ref-format --branch "$1" >/dev/null || die "invalid Git branch name: $1" 64
}

backup_once() {
  local path="$1"
  [[ -e "${path}" ]] || return 0
  [[ -e "${path}.pre-sasd" ]] || cp -a -- "${path}" "${path}.pre-sasd"
}

install_text_if_changed() {
  local target="$1" mode="$2" temporary
  temporary="$(mktemp)"
  cat >"${temporary}"
  if [[ -f "${target}" ]] && cmp -s "${temporary}" "${target}"; then rm -f -- "${temporary}"; return 0; fi
  install -D -m "${mode}" "${temporary}" "${target}"
  rm -f -- "${temporary}"
}
