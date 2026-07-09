# @summary Assign a centrally managed daemonless OCI container host role.
class role::container_host {
  contain profile::baseline
  contain profile::administration_tools
  contain profile::container_tools
  class { 'profile::application_state':
    role_name        => 'container_host',
    enabled_profiles => ['baseline', 'administration_tools', 'container_tools'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::container_tools']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
