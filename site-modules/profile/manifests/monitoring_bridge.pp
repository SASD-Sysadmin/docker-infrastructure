# @summary Export Puppet fleet and control-plane state for independent monitoring.
#
# This profile installs a low-cardinality Prometheus textfile export and a
# systemd timer. It deliberately does not install or configure Prometheus,
# node_exporter, Grafana, alert routing, or network listeners.
#
# @param output_directory Private staging directory for JSON and text output.
# @param interval systemd OnUnitActiveSec value for the snapshot timer.
class profile::monitoring_bridge (
  Pattern[/^\//] $output_directory = '/var/lib/sasd-puppet/monitoring',
  String[1] $interval = '15min',
) {
  contain profile::systemd_reload

  unless $trusted['authenticated'] == 'remote' {
    fail('profile::monitoring_bridge requires a remotely authenticated Puppet Server catalog')
  }

  file { $output_directory:
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0750',
  }

  file { '/usr/local/libexec/sasd-puppet':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/local/libexec/sasd-puppet/sasd-puppet-monitoring-export.py':
    ensure  => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source  => 'puppet:///modules/profile/sasd-puppet-monitoring-export.py',
    require => File['/usr/local/libexec/sasd-puppet'],
  }

  file { '/usr/local/sbin/sasd-puppet-monitoring-snapshot':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/profile/sasd-puppet-monitoring-snapshot',
    require => File['/usr/local/libexec/sasd-puppet/sasd-puppet-monitoring-export.py'],
  }

  file { '/etc/systemd/system/sasd-puppet-monitoring.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/sasd-puppet-monitoring.service.epp', {'output_directory' => $output_directory}),
    notify  => Exec['reload systemd for SASD Puppet operations'],
  }

  file { '/etc/systemd/system/sasd-puppet-monitoring.timer':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/sasd-puppet-monitoring.timer.epp', {'interval' => $interval}),
    notify  => Exec['reload systemd for SASD Puppet operations'],
  }

  service { 'sasd-puppet-monitoring.timer':
    ensure    => running,
    enable    => true,
    subscribe => Exec['reload systemd for SASD Puppet operations'],
  }
}
