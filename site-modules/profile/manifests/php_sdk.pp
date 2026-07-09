# @summary Install a command-line PHP development baseline.
#
# The profile installs reviewed packages from repositories already configured on
# the node. It does not install Apache, nginx, PHP-FPM, enable EL module streams,
# fetch Composer from the internet, edit php.ini, or start services. Composer is
# part of Debian-family package data only.
#
# @param packages Distribution package names to keep installed.
# @param manage_packages Allows catalog-only tests to suppress package resources.
class profile::php_sdk (
  Array[String[1]] $packages = [],
  Boolean          $manage_packages = true,
) {
  $os_name   = $facts['os']['name']
  $os_family = $facts['os']['family']
  $os_major  = $facts['os']['release']['major']
  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04') or
    ($os_name in ['AlmaLinux', 'Rocky'] and $os_major == '9')
  )
  unless $supported_platform {
    fail("profile::php_sdk does not support ${os_name} ${os_major}")
  }
  if $packages == [] {
    fail("profile::php_sdk requires reviewed package data for ${os_name} ${os_major}")
  }

  $composer_expected = $os_family == 'Debian'
  contain profile::sdk_status

  if $manage_packages {
    package { $packages:
      ensure => installed,
    }
  }

  file { '/etc/sasd/toolchains.d/php.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/php.conf.epp', {
      'composer_expected' => $composer_expected,
      'packages'          => $packages,
      'certname'          => $trusted['certname'],
    }),
    require => File['/etc/sasd/toolchains.d'],
  }
}
