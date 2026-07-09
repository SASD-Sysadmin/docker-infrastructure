# @summary Record non-secret operating-system evidence for local audits.
#
# The profile writes facts already visible to Puppet. It does not alter package
# repositories, SELinux, firewalld, networking, kernel settings, or host identity.
# The marker lets an operator compare the catalog's platform view with local
# package and lifecycle evidence without collecting a full fact set.
#
# @param state_directory SASD-owned platform marker directory.
# @param state_file Platform marker file.
class profile::platform_state (
  Pattern[/^\//] $state_directory = '/etc/sasd/platform.d',
  Pattern[/^\//] $state_file      = '/etc/sasd/platform.d/current.conf',
) {
  $os_name   = $facts['os']['name']
  $os_family = $facts['os']['family']
  $os_major  = $facts['os']['release']['major']
  $architecture = $facts['os']['architecture'] ? {
    Undef   => $facts['architecture'] ? {
      Undef   => 'unknown',
      default => String($facts['architecture']),
    },
    default => String($facts['os']['architecture']),
  }
  $package_provider = $os_family ? {
    'Debian' => 'apt',
    'RedHat' => 'dnf',
    default  => 'unsupported',
  }

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
    content => epp('profile/platform.conf.epp', {
      'os_name'          => $os_name,
      'os_family'        => $os_family,
      'os_major'         => $os_major,
      'architecture'     => $architecture,
      'package_provider' => $package_provider,
      'certname'         => $trusted['certname'],
    }),
    require => File[$state_directory],
  }
}
