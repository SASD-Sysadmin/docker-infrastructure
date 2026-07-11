# @summary Keep the native Puppet agent service aligned with node lifecycle.
#
# Identity-bearing settings remain owned by enrollment scripts. An active node
# keeps the service enabled and running. A maintenance node completes the
# current catalog, then leaves the periodic service stopped and disabled until
# an operator changes node data back to active and performs one explicit agent
# run. Retired nodes never reach this profile because site.pp rejects them.
#
# @param service_name Native service name supplied by the operating system.
# @param service_ensure Desired active-state service runtime state.
# @param service_enable Whether an active service starts at boot.
# @param lifecycle_state Reviewed node lifecycle state from Hiera.
class profile::agent_service (
  String[1]                      $service_name    = 'puppet',
  Enum['running', 'stopped']     $service_ensure  = 'running',
  Boolean                        $service_enable  = true,
  Enum['active', 'maintenance']  $lifecycle_state = lookup('sasd::lifecycle_state', String[1], 'first', 'active'),
) {
  unless $trusted['authenticated'] == 'remote' {
    fail('profile::agent_service requires a remotely authenticated Puppet Server catalog')
  }

  $effective_ensure = $lifecycle_state ? {
    'active'      => $service_ensure,
    'maintenance' => 'stopped',
  }
  $effective_enable = $lifecycle_state ? {
    'active'      => $service_enable,
    'maintenance' => false,
  }

  service { $service_name:
    ensure => $effective_ensure,
    enable => $effective_enable,
  }
}
