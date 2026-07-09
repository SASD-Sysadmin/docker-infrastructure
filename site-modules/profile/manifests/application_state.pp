# @summary Write a non-secret declaration of the application groups assigned to a node.
#
# The marker supports audits and local troubleshooting without duplicating the
# package manager database. It is evidence of intended classification, not proof
# that every package is healthy; Puppet reports remain the convergence record.
#
# @param role_name Allowlisted SASD role selected by the site manifest.
# @param enabled_profiles Ordered application-profile names composed by the role.
# @param state_directory SASD-owned marker directory.
# @param state_file Marker file path.
class profile::application_state (
  Enum['managed_agent', 'server', 'development', 'container_host', 'puppet_server'] $role_name,
  Array[String[1], 1] $enabled_profiles,
  Pattern[/^\//] $state_directory = '/etc/sasd/applications.d',
  Pattern[/^\//] $state_file = '/etc/sasd/applications.d/assigned.conf',
) {
  file { $state_directory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $state_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/applications.conf.epp', {
      'role_name'        => $role_name,
      'enabled_profiles' => $enabled_profiles,
      'certname'         => $trusted['certname'],
    }),
    require => File[$state_directory],
  }
}
