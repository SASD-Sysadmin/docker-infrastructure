#!/usr/bin/env bash
# Shared helpers for local Puppet operations. This file is sourced by scripts.

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
      command -v "${candidate}"
      return 0
    fi
  done
  return 1
}

require_root() {
  [[ "${EUID}" -eq 0 ]] || die 'this operation requires root privileges' 77
}

read_os_release() {
  local file="${1:-/etc/os-release}"
  [[ -r "${file}" ]] || die "cannot read operating-system metadata: ${file}" 66

  # os-release is assignment-like, but it is parsed as data rather than sourced
  # because bootstrap can run as root and must never execute file content.
  ID="$(sed -nE 's/^ID=(.*)$/\1/p' "${file}" | head -n 1 | tr -d '"' | tr '[:upper:]' '[:lower:]')"
  VERSION_ID="$(sed -nE 's/^VERSION_ID=(.*)$/\1/p' "${file}" | head -n 1 | tr -d '"')"
  [[ -n "${ID}" ]] || die "missing ID in ${file}" 65
  [[ -n "${VERSION_ID}" ]] || die "missing VERSION_ID in ${file}" 65
  export ID VERSION_ID
}

is_supported_platform() {
  case "${ID}:${VERSION_ID}" in
    debian:12|debian:13|ubuntu:24.04) return 0 ;;
    *) return 1 ;;
  esac
}
