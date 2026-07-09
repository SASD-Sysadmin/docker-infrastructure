# @summary Assign the standard lifecycle-aware SASD server role.
class role::server {
  contain profile::baseline
  contain profile::administration_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'server',
    enabled_profiles => ['baseline', 'administration_tools', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
