# @summary Install a read-only local SDK status command.
#
# The command reads SASD-owned expectation files and invokes language binaries
# only for reporting. It never changes alternatives, project files, registries,
# dependency caches, or network configuration.
class profile::sdk_status {
  file { '/etc/sasd/toolchains.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/local/sbin/sasd-sdk-status':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/profile/sasd-sdk-status.py',
  }
}
