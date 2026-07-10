#!/usr/bin/env bash
# Prepare the reviewed package source required by the .NET 10 SDK profile.
# Default is a dry run. Only Debian 12/13 require a repository change.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=scripts/lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"
apply=false; os_release_file='/etc/os-release'; architecture=''; download_url=''; expected_sha256=''
usage(){ cat <<'EOF'
Usage: setup-dotnet-repository.sh [--apply] [--os-release-file FILE]
                                  [--architecture ARCH] [--download-url URL]
                                  [--expected-sha256 HEX]

Debian 12/13: install Microsoft's signed packages-microsoft-prod configuration
package after HTTPS and package-metadata checks.
Ubuntu 24.04, AlmaLinux 9, Rocky Linux 9: verify that the distribution feed is
the selected strategy; no external repository is installed.
EOF
}
while (($#)); do case "$1" in
  --apply) apply=true;;
  --os-release-file) shift; os_release_file="${1:-}";;
  --architecture) shift; architecture="${1:-}";;
  --download-url) shift; download_url="${1:-}";;
  --expected-sha256) shift; expected_sha256="${1:-}";;
  -h|--help) usage; exit 0;;
  *) usage >&2; die "unknown argument: $1" 64;;
esac; shift; done
read_os_release "${os_release_file}"
is_supported_agent_platform || die "unsupported .NET platform ${ID} ${VERSION_ID}" 69
[[ -n "${architecture}" ]] || architecture="$(uname -m)"
architecture="$(normalize_architecture "${architecture}")"
[[ "${architecture}" == x86_64 ]] || die ".NET 10 profile currently supports x86_64/amd64 only, not ${architecture}" 69
strategy='distribution'
case "${ID}:${VERSION_ID}" in
  debian:12|debian:13) strategy='microsoft'; [[ -n "${download_url}" ]] || download_url="https://packages.microsoft.com/config/debian/${VERSION_ID}/packages-microsoft-prod.deb";;
  ubuntu:24.04|almalinux:9*|rocky:9*) strategy='distribution';;
  *) die "unsupported .NET platform ${ID} ${VERSION_ID}" 69;;
esac
log ".NET 10 repository strategy: ${strategy} for ${ID} ${VERSION_ID} (${architecture})"
if [[ "${strategy}" == distribution ]]; then
  log 'distribution/AppStream package feed is used; no repository files will be added'
  [[ "${apply}" == true ]] && log 'no host changes required'
  exit 0
fi
[[ -z "${expected_sha256}" || "${expected_sha256}" =~ ^[0-9a-fA-F]{64}$ ]] || die 'expected SHA-256 must be exactly 64 hexadecimal characters' 64
[[ "${download_url}" == https://packages.microsoft.com/config/debian/*/packages-microsoft-prod.deb ]] || die 'Debian repository URL must be the official HTTPS packages.microsoft.com config package' 64
if [[ "${apply}" != true ]]; then
  printf 'Plan:\n- download %s over HTTPS\n- validate Debian package metadata\n' "${download_url}"
  [[ -n "${expected_sha256}" ]] && printf -- '- verify operator-supplied SHA-256\n'
  printf -- '- install packages-microsoft-prod\n- refresh apt metadata\n'
  echo 'Dry run only. Add --apply to execute.'
  exit 0
fi
require_root
for command in curl dpkg dpkg-deb apt-get apt-cache; do command -v "${command}" >/dev/null 2>&1 || die "required command not found: ${command}" 127; done
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --yes ca-certificates curl
package_file="$(mktemp --suffix=.deb)"; trap 'rm -f -- "${package_file}"' EXIT
curl --fail --location --proto '=https' --tlsv1.2 --output "${package_file}" "${download_url}"
if [[ -n "${expected_sha256}" ]]; then
  observed_sha256="$(sha256sum "${package_file}" | awk '{print $1}')"
  [[ "${observed_sha256,,}" == "${expected_sha256,,}" ]] || die 'repository package SHA-256 does not match the operator-supplied value' 65
else
  warn 'no expected SHA-256 supplied; relying on HTTPS, fixed official URL, and Debian package metadata validation'
fi
package_name="$(dpkg-deb --field "${package_file}" Package 2>/dev/null || true)"
package_version="$(dpkg-deb --field "${package_file}" Version 2>/dev/null || true)"
[[ "${package_name}" == packages-microsoft-prod ]] || die "unexpected repository package name: ${package_name:-missing}" 65
[[ -n "${package_version}" ]] || die 'repository package has no Version metadata' 65
dpkg -i "${package_file}"
apt-get update
apt-cache show dotnet-sdk-10.0 >/dev/null 2>&1 || die 'dotnet-sdk-10.0 is not visible after repository setup' 69
install -d -o root -g root -m 0755 /etc/sasd/repositories.d
install_text_if_changed /etc/sasd/repositories.d/dotnet.conf 0644 <<EOF
# Created by SASD setup-dotnet-repository.sh.
sdk=dotnet
sdk_major=10
strategy=microsoft
config_package=${package_name}
config_package_version=${package_version}
source_url=${download_url}
EOF
log ".NET repository prepared; review apt policy before assigning role::dotnet_development"
