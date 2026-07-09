# @summary Assign a lifecycle-aware daemonless OCI container host role.
class role::container_host {
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::container_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'container_host',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'container_tools', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::container_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
