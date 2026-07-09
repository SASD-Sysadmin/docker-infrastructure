# @summary Assign the standard centrally managed SASD server role.
#
# The role installs the baseline and administration tools, records the selected
# application groups, and keeps the already-enrolled Puppet agent running.
class role::server {
  contain profile::baseline
  contain profile::administration_tools
  class { 'profile::application_state':
    role_name        => 'server',
    enabled_profiles => ['baseline', 'administration_tools'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
