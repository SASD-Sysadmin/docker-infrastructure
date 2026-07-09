# @summary Assign the minimal central SASD baseline and lifecycle-aware agent.
class role::managed_agent {
  contain profile::baseline
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'managed_agent',
    enabled_profiles => ['baseline', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
