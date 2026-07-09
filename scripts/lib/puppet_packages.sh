#!/usr/bin/env bash
# Package-source helpers shared by server and central-agent bootstraps.
# shellcheck shell=bash

puppet_core_release_url() {
  case "${ID}:${VERSION_ID}" in
    debian:12) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-bookworm.deb' ;;
    debian:13) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-trixie.deb' ;;
    ubuntu:24.04) printf '%s\n' 'https://apt-puppetcore.puppet.com/public/puppet8-release-noble.deb' ;;
    *) return 1 ;;
  esac
}

configure_puppet_core_apt() {
  local api_key_file="$1" release_url="$2" api_key release_deb permissions owner_uid
  [[ -r "${api_key_file}" ]] || die "cannot read Puppet Core API key file: ${api_key_file}" 66
  permissions="$(stat -c '%a' "${api_key_file}")"
  owner_uid="$(stat -c '%u' "${api_key_file}")"
  [[ "${owner_uid}" == '0' ]] || die "Puppet Core API key file must be owned by root: ${api_key_file}" 77
  if (( 10#${permissions} % 100 != 0 )); then
    die "Puppet Core API key file must not be group/world accessible: ${api_key_file}" 77
  fi
  api_key="$(tr -d '\r\n' <"${api_key_file}")"
  [[ -n "${api_key}" ]] || die 'Puppet Core API key file is empty' 65
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

prepare_distribution_puppet_packages() {
  if [[ "${ID}" == 'ubuntu' ]] && { ! apt-cache show puppet-agent >/dev/null 2>&1 || ! apt-cache show puppetserver >/dev/null 2>&1; }; then
    log 'enabling Ubuntu Universe for Puppet distribution packages'
    apt-get install --yes software-properties-common
    add-apt-repository --yes universe
    apt-get update
  fi
}
