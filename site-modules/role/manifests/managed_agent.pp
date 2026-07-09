# @summary Assign the minimal central SASD baseline and Puppet agent service.
#
# Enrollment and certificate approval happen before this role is assigned.
class role::managed_agent {
  contain profile::baseline
  class { 'profile::application_state':
    role_name        => 'managed_agent',
    enabled_profiles => ['baseline'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
