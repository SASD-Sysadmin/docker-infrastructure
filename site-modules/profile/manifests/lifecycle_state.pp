# @summary Record the reviewed lifecycle state of a centrally managed node.
#
# Lifecycle data is operational control data, not a replacement for CMDB or
# ticketing records. The marker deliberately contains no secrets. Maintenance
# requires a reason, ticket/reference, and UTC expiry so that an indefinitely
# disabled agent is visible to fleet-compliance checks.
#
# @param lifecycle_state Active or maintenance. Retired nodes are rejected by
#   the site manifest before this profile can be compiled.
# @param reason Human-readable maintenance reason; required in maintenance.
# @param ticket External change/incident/reference identifier; required in maintenance.
# @param expires_at UTC timestamp in RFC3339 form; required in maintenance.
# @param state_directory SASD-owned lifecycle marker directory.
# @param state_file Lifecycle marker path.
class profile::lifecycle_state (
  Enum['active', 'maintenance'] $lifecycle_state = lookup('sasd::lifecycle_state', String[1], 'first', 'active'),
  String                        $reason          = lookup('sasd::lifecycle_reason', String, 'first', ''),
  String                        $ticket          = lookup('sasd::lifecycle_ticket', String, 'first', ''),
  String                        $expires_at      = lookup('sasd::lifecycle_expires_at', String, 'first', ''),
  Pattern[/^\//]                $state_directory = '/etc/sasd/lifecycle.d',
  Pattern[/^\//]                $state_file      = '/etc/sasd/lifecycle.d/state.conf',
) {
  unless $trusted['authenticated'] == 'remote' {
    fail('profile::lifecycle_state requires a remotely authenticated Puppet Server catalog')
  }

  if $lifecycle_state == 'maintenance' {
    if $reason == '' or $ticket == '' or $expires_at == '' {
      fail('Maintenance lifecycle requires sasd::lifecycle_reason, sasd::lifecycle_ticket, and sasd::lifecycle_expires_at')
    }
    unless $expires_at =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/ {
      fail('sasd::lifecycle_expires_at must use UTC RFC3339 format YYYY-MM-DDTHH:MM:SSZ')
    }
  }

  file { $state_directory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $state_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/lifecycle.conf.epp', {
      'lifecycle_state' => $lifecycle_state,
      'reason'          => $reason,
      'ticket'          => $ticket,
      'expires_at'      => $expires_at,
      'certname'        => $trusted['certname'],
    }),
    require => File[$state_directory],
  }
}
