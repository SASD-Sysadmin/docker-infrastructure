# @summary Assign the managed Puppet Server operational role.
#
# The server is also a normal Puppet agent. Its own catalog keeps the baseline,
# agent service, compact reporting state, and periodic health checks consistent.
class role::puppet_server {
  contain profile::baseline
  contain profile::agent_service
  contain profile::server_operations

  Class['profile::baseline'] -> Class['profile::agent_service'] -> Class['profile::server_operations']
}
