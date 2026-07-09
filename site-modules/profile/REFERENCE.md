# Reference

## `profile::baseline`

Installs the package baseline and manages `/etc/sasd/puppet-baseline.conf` on
Debian 12/13 and Ubuntu 24.04.

## `profile::agent_service`

Requires a remotely authenticated catalog and keeps the native Puppet service
running and enabled. Enrollment scripts own identity and cadence settings.

## `profile::server_operations`

Manages SASD operational state, compact report/health directories, the health
command, systemd service/timer, and one refresh-only daemon reload.

Puppet Strings comments in each manifest define all parameters and boundaries.
