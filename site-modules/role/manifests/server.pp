# @summary Assign the standard lifecycle-aware SASD server role.
class role::server {
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'server',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
