# @summary Install the minimal SASD local-test package baseline and marker file.
#
# This profile is intentionally small. It proves that Hiera Automatic Parameter
# Lookup, package management, file management, idempotence, and local
# `puppet apply` all work on the supported Debian-family platforms. It does not
# manage services, users, repositories, firewall rules, or arbitrary commands.
#
# @param packages
#   Package names merged from common and platform-specific Hiera data.
# @param manage_packages
#   Whether the package resources are declared. Disable only for controlled
#   catalog experiments; the default baseline keeps this enabled.
# @param manage_marker
#   Whether `/etc/sasd` and the managed baseline marker are declared.
# @param marker_directory
#   Absolute directory containing SASD-owned local configuration state.
# @param marker_file
#   Absolute marker file rendered from the EPP template.
# @param baseline_version
#   Human-readable baseline revision written into the marker file.
class profile::baseline (
  Array[String[1]] $packages         = [],
  Boolean          $manage_packages = true,
  Boolean          $manage_marker   = true,
  String[1]        $marker_directory = '/etc/sasd',
  String[1]        $marker_file      = '/etc/sasd/puppet-baseline.conf',
  String[1]        $baseline_version = '0.2.0',
) {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']

  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04')
  )

  unless $supported_platform {
    fail("profile::baseline does not support ${os_name} ${os_major}; supported platforms are Debian 12/13 and Ubuntu 24.04")
  }

  if $manage_packages and $packages != [] {
    package { $packages:
      ensure => installed,
    }
  }

  if $manage_marker {
    file { $marker_directory:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { $marker_file:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('profile/baseline.conf.epp', {
        'baseline_version' => $baseline_version,
        'os_name'          => $os_name,
        'os_major'         => $os_major,
      }),
      require => File[$marker_directory],
    }
  }
}
