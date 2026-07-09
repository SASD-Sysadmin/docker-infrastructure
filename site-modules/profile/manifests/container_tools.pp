# @summary Install the reviewed daemonless OCI container-tool package group.
#
# Milestone 6 deliberately selects distribution-provided Podman tooling. The
# profile does not configure registries, pull images, create containers, open
# network ports, or enable a long-running Docker-compatible daemon.
#
# @param packages Distribution package names to keep installed.
# @param manage_packages Allows catalog-only tests to suppress resources.
class profile::container_tools (
  Array[String[1]] $packages = [],
  Boolean          $manage_packages = true,
) {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']
  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04')
  )
  unless $supported_platform {
    fail("profile::container_tools does not support ${os_name} ${os_major}")
  }

  if $manage_packages and $packages != [] {
    package { $packages:
      ensure => installed,
    }
  }
}
