# @summary Install the minimal SASD package baseline and managed marker file.
#
# The same profile supports standalone `puppet apply` and central Puppet Server
# catalogs. It derives a descriptive management mode from Puppet's trusted
# authentication data but does not grant permissions or classify nodes from
# that string. Classification remains in `manifests/site.pp`.
#
# Milestone 3 intentionally keeps the workload boundary unchanged: this profile
# manages only packages and files. Puppet Server installation, CA lifecycle,
# r10k deployment, and initial agent enrollment are bootstrap/control-plane
# operations implemented by reviewed shell scripts outside the catalog.
#
# @param packages
#   Package names merged from common and platform-specific Hiera data.
# @param manage_packages
#   Whether package resources are declared.
# @param manage_marker
#   Whether the SASD marker directory and file are declared.
# @param marker_directory
#   Absolute directory containing SASD-owned local state.
# @param marker_file
#   Absolute marker file rendered from the EPP template.
# @param baseline_version
#   Repository baseline revision written into the marker file.
# @param management_mode
#   Optional explicit marker value. When undef, trusted authentication selects
#   `puppet-server` for remote catalogs and `local-puppet-apply` otherwise.
class profile::baseline (
  Array[String[1]]                              $packages          = [],
  Boolean                                       $manage_packages  = true,
  Boolean                                       $manage_marker    = true,
  String[1]                                     $marker_directory = '/etc/sasd',
  String[1]                                     $marker_file      = '/etc/sasd/puppet-baseline.conf',
  String[1]                                     $baseline_version = '0.3.0',
  Optional[Enum['local-puppet-apply', 'puppet-server']] $management_mode = undef,
) {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']

  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04')
  )

  unless $supported_platform {
    fail("profile::baseline does not support ${os_name} ${os_major}; supported agents are Debian 12/13 and Ubuntu 24.04")
  }

  $effective_management_mode = $management_mode ? {
    undef   => $trusted['authenticated'] ? {
      'remote' => 'puppet-server',
      default  => 'local-puppet-apply',
    },
    default => $management_mode,
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
        'management_mode'  => $effective_management_mode,
        'certname'         => $trusted['certname'],
      }),
      require => File[$marker_directory],
    }
  }
}
