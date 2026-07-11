# Health monitoring

`profile::server_operations` installs:

- `/usr/local/sbin/sasd-puppet-health`;
- `sasd-puppet-health.service`;
- `sasd-puppet-health.timer`;
- `/var/lib/sasd-puppet/health/last.json`.

The timer runs approximately every 15 minutes with a small randomized delay.
The check verifies Puppet Server, production deployment state, CA presence,
report freshness/failures, and optional PuppetDB service state.

Run manually:

```bash
sudo /usr/local/sbin/sasd-puppet-health
sudo systemctl status sasd-puppet-health.timer
sudo journalctl -u sasd-puppet-health.service
```

Exit codes follow common monitoring semantics: `0` OK, `1` warning, `2`
critical. The JSON output is suitable for collection by a later Prometheus
textfile exporter, Icinga/Nagios wrapper, or log pipeline; Milestone 4 does not
open a new network listener.
