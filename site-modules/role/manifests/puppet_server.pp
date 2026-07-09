# @summary Assign the managed Puppet Server control-plane role.
#
# The Puppet Server is also a normal signed agent. In Milestone 5 it receives
# the administration package group in addition to health/reporting operations.
class role::puppet_server {
  contain profile::baseline
  contain profile::administration_tools
  class { 'profile::application_state':
    role_name        => 'puppet_server',
    enabled_profiles => ['baseline', 'administration_tools', 'server_operations'],
  }
  contain profile::agent_service
  contain profile::server_operations

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
  -> Class['profile::server_operations']
}
