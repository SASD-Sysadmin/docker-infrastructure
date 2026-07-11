# @summary Provide the single reviewed systemd daemon-reload event resource.
#
# Operational profiles notify this refresh-only resource after changing unit
# files. It never runs during a catalog without a notification.
class profile::systemd_reload {
  exec { 'reload systemd for SASD Puppet operations':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
