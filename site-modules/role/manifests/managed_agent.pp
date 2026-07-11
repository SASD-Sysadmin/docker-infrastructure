# @summary Assign the minimal central SASD baseline and lifecycle-aware agent.
class role::managed_agent {
  contain profile::baseline
  contain profile::platform_state
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'managed_agent',
    enabled_profiles => ['baseline', 'platform_state', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
