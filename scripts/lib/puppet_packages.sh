#!/usr/bin/env bash
# Package-source helpers shared by server and central-agent bootstraps.
# shellcheck shell=bash

puppet_core_release_url() {
  case "${ID}:${VERSION_ID%%.*}" in
    debian:12) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-bookworm.deb' ;;
    debian:13) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-trixie.deb' ;;
    ubuntu:24) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-noble.deb' ;;
    almalinux:9|rocky:9) printf '%s\n' 'https://yum-puppetcore.puppet.com/public/puppet8-release-el-9.noarch.rpm' ;;
    *) return 1 ;;
  esac
}

validate_puppet_core_api_key_file() {
  local api_key_file="$1" permissions owner_uid
  [[ -r "${api_key_file}" ]] || die "cannot read Puppet Core API key file: ${api_key_file}" 66
  permissions="$(stat -c '%a' "${api_key_file}")"
  owner_uid="$(stat -c '%u' "${api_key_file}")"
  [[ "${owner_uid}" == '0' ]] || die "Puppet Core API key file must be owned by root: ${api_key_file}" 77
  if (( 10#${permissions} % 100 != 0 )); then
    die "Puppet Core API key file must not be group/world accessible: ${api_key_file}" 77
  fi
  [[ -n "$(tr -d '\r\n' <"${api_key_file}")" ]] || die 'Puppet Core API key file is empty' 65
}

configure_puppet_core_apt() {
  local api_key_file="$1" release_url="$2" api_key release_deb
  validate_puppet_core_api_key_file "${api_key_file}"
  api_key="$(tr -d '\r\n' <"${api_key_file}")"
  release_deb="$(mktemp --suffix=.deb)"
  log "installing Puppet Core release package from ${release_url}"
  curl --fail --location --proto '=https' --tlsv1.2 --output "${release_deb}" "${release_url}"
  dpkg -i "${release_deb}"
  rm -f -- "${release_deb}"
  umask 077
  install_text_if_changed /etc/apt/auth.conf.d/apt-puppetcore.conf 0600 <<EOF
machine apt-puppetcore.puppet.com
login forge-key
password ${api_key}
EOF
  unset api_key
  apt-get update
}

configure_puppet_core_yum() {
  local api_key_file="$1" release_url="$2" release_rpm repo_file
  validate_puppet_core_api_key_file "${api_key_file}"
  release_rpm="$(mktemp --suffix=.rpm)"
  log "installing Puppet Core release package from ${release_url}"
  curl --fail --location --proto '=https' --tlsv1.2 --output "${release_rpm}" "${release_url}"
  rpm -Uvh --replacepkgs "${release_rpm}"
  rm -f -- "${release_rpm}"
  repo_file="$(find /etc/yum.repos.d -maxdepth 1 -type f -name 'puppet8*.repo' -print -quit)"
  [[ -n "${repo_file}" ]] || die 'Puppet Core release package did not create a puppet8 repository file' 65
  local root
  root="$(repository_root)"
  python3 "${root}/scripts/write-puppet-core-yum-credentials.py" \
    --api-key-file "${api_key_file}" \
    --repository-file "${repo_file}"
  dnf --assumeyes makecache --refresh
}

prepare_distribution_puppet_packages() {
  if is_redhat_family_agent; then
    die 'Rocky Linux 9 and AlmaLinux 9 require --package-source puppet-core; no distribution-agent path is defined' 69
  fi
  if [[ "${ID}" == 'ubuntu' ]] && { ! apt-cache show puppet-agent >/dev/null 2>&1 || ! apt-cache show puppetserver >/dev/null 2>&1; }; then
    log 'enabling Ubuntu Universe for Puppet distribution packages'
    apt-get install --yes software-properties-common
    add-apt-repository --yes universe
    apt-get update
  fi
}
