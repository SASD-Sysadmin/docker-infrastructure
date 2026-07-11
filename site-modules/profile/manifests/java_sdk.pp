# @summary Install the reviewed OpenJDK 17 and Maven development baseline.
#
# Package names are supplied by OS-family Hiera. The profile uses only already
# configured distribution repositories and does not manage Java alternatives,
# Maven repositories, JAVA_HOME, user dotfiles, or build caches.
#
# @param packages Distribution package names to keep installed.
# @param java_major Expected Java feature release recorded as local evidence.
# @param manage_packages Allows catalog-only tests to suppress package resources.
class profile::java_sdk (
  Array[String[1]] $packages = [],
  Integer[8,99]    $java_major = 17,
  Boolean          $manage_packages = true,
) {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']
  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04') or
    ($os_name in ['AlmaLinux', 'Rocky'] and $os_major == '9')
  )
  unless $supported_platform {
    fail("profile::java_sdk does not support ${os_name} ${os_major}")
  }
  if $packages == [] {
    fail("profile::java_sdk requires reviewed package data for ${os_name} ${os_major}")
  }

  contain profile::sdk_status

  if $manage_packages {
    package { $packages:
      ensure => installed,
    }
  }

  file { '/etc/sasd/toolchains.d/java.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/java.conf.epp', {
      'java_major' => $java_major,
      'packages'   => $packages,
      'certname'   => $trusted['certname'],
    }),
    require => File['/etc/sasd/toolchains.d'],
  }
}
