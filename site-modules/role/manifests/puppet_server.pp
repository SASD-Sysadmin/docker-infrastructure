# @summary Assign the lifecycle-aware Puppet Server control-plane role.
class role::puppet_server {
  contain profile::baseline
  contain profile::administration_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'puppet_server',
    enabled_profiles => ['baseline', 'administration_tools', 'lifecycle_state', 'server_operations'],
  }
  contain profile::agent_service
  contain profile::server_operations

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
  -> Class['profile::server_operations']
}
