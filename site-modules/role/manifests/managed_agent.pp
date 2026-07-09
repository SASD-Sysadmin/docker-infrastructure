# @summary Assign the central SASD baseline and keep the Puppet agent running.
#
# Enrollment and certificate approval happen before this role is assigned.
class role::managed_agent {
  contain profile::baseline
  contain profile::agent_service

  Class['profile::baseline'] -> Class['profile::agent_service']
}
