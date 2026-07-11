# @summary Assign a Debian-family host that consumes one encrypted APT credential.
#
# The role manages only the auth.conf credential file. Repository URL, signing
# key, package selection, and trust approval remain separate reviewed changes.
class role::apt_repository_client {
  unless $facts['os']['family'] == 'Debian' {
    fail('role::apt_repository_client supports the Debian OS family only')
  }

  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::apt_repository_credentials
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'apt_repository_client',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'apt_repository_credentials', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::apt_repository_credentials']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
