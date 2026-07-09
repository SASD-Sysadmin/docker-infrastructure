# @summary Assign the lifecycle-aware Puppet Server control-plane role.
class role::puppet_server {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']
  $supported_server = (
    ($os_name == 'Debian' and $os_major == '12') or
    ($os_name == 'Ubuntu' and $os_major == '24.04')
  )
  unless $supported_server {
    fail("role::puppet_server supports Debian 12 and Ubuntu 24.04 only; received ${os_name} ${os_major}")
  }
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'puppet_server',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'lifecycle_state', 'server_operations'],
  }
  contain profile::agent_service
  contain profile::server_operations

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
  -> Class['profile::server_operations']
}
