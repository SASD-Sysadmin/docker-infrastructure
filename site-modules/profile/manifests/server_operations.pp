# @summary Install Puppet Server operational health and reporting support.
#
# This profile manages only operational tooling and state directories. The
# custom report processor itself is delivered as a Puppet plugin from the
# `sasd_reporting` module. Full reports remain in Puppet/PuppetDB; the SASD
# processor writes a compact, non-secret JSON status per certname.
#
# @param state_root Root for SASD Puppet operational state.
# @param report_directory Compact JSON report summary directory.
# @param health_directory Health-check output directory.
# @param health_interval systemd OnUnitActiveSec value.
class profile::server_operations (
  Pattern[/^\//] $state_root       = '/var/lib/sasd-puppet',
  Pattern[/^\//] $report_directory = '/var/lib/sasd-puppet/reports',
  Pattern[/^\//] $health_directory = '/var/lib/sasd-puppet/health',
  String[1]             $health_interval = '15min',
) {
  contain profile::systemd_reload

  unless $trusted['authenticated'] == 'remote' {
    fail('profile::server_operations requires a remotely authenticated Puppet Server catalog')
  }

  file { $state_root:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0750',
  }

  file { [$report_directory, $health_directory]:
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0750',
    require => File[$state_root],
  }

  file { '/usr/local/sbin/sasd-puppet-health':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/profile/sasd-puppet-health',
  }

  file { '/etc/systemd/system/sasd-puppet-health.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/sasd-puppet-health.service.epp', {
      'health_directory' => $health_directory,
    }),
    notify  => Exec['reload systemd for SASD Puppet operations'],
  }

  file { '/etc/systemd/system/sasd-puppet-health.timer':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/sasd-puppet-health.timer.epp', {
      'health_interval' => $health_interval,
    }),
    notify  => Exec['reload systemd for SASD Puppet operations'],
  }

  service { 'sasd-puppet-health.timer':
    ensure    => running,
    enable    => true,
    subscribe => Exec['reload systemd for SASD Puppet operations'],
  }
}
