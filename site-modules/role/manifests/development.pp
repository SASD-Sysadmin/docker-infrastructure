# @summary Assign a lifecycle-aware command-line development host role.
class role::development {
  contain profile::baseline
  contain profile::administration_tools
  contain profile::development_tools
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'development',
    enabled_profiles => ['baseline', 'administration_tools', 'development_tools', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::administration_tools']
  -> Class['profile::development_tools']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
