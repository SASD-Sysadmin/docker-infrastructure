# @summary Keep the native Puppet agent service enabled and running.
#
# This profile intentionally manages service state only. Enrollment scripts set
# server, certname, environment, runinterval, splay, and splaylimit through the
# active Puppet configuration path before the service is enabled. Keeping those
# identity-bearing values out of the catalog avoids accidentally changing a
# node's TLS identity.
#
# Assign this profile only after the certificate has been reviewed and signed.
# Starting an unenrolled agent would create repeated certificate requests.
#
# @param service_name Native service name supplied by the operating system.
# @param service_ensure Desired service runtime state.
# @param service_enable Whether the service starts at boot.
class profile::agent_service (
  String[1] $service_name   = 'puppet',
  Enum['running', 'stopped'] $service_ensure = 'running',
  Boolean $service_enable   = true,
) {
  unless $trusted['authenticated'] == 'remote' {
    fail('profile::agent_service requires a remotely authenticated Puppet Server catalog')
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
