# @summary Install the reviewed command-line software-development package group.
#
# The profile installs compiler, debugger, build, Python, and shell-analysis
# tooling from the operating system's configured repositories. It does not add
# third-party repositories and does not select floating upstream installers.
#
# @param packages Distribution package names to keep installed.
# @param manage_packages Allows catalog-only tests to suppress resources.
class profile::development_tools (
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
    fail("profile::development_tools does not support ${os_name} ${os_major}")
  }

  if $manage_packages and $packages != [] {
    package { $packages:
      ensure => installed,
    }
  }
}
