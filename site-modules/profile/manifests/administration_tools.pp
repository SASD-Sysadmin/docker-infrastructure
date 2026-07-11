# @summary Install the reviewed SASD administration-tool package group.
#
# This profile owns package installation only. It does not execute diagnostics,
# edit application data, or perform incident remediation. Package names come
# from Hiera and are checked by `scripts/check_package_policy.rb`.
#
# @param packages Distribution package names to keep installed.
# @param manage_packages Allows catalog-only tests to suppress resources.
class profile::administration_tools (
  Array[String[1]] $packages = [],
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
    fail("profile::administration_tools does not support ${os_name} ${os_major}")
  }

  if $manage_packages and $packages != [] {
    package { $packages:
      ensure => installed,
    }
  }
}
