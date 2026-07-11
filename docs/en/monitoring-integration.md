# Monitoring integration

The Puppet Server role now includes `profile::monitoring_bridge`. Every 15 minutes it produces protected `compliance.json`, `health.json`, and `sasd_puppet.prom` below `/var/lib/sasd-puppet/monitoring`. The Prometheus text has aggregate status labels only; certnames are intentionally absent.

No Prometheus, node_exporter, Grafana, listener, firewall rule, or alert route is installed. Copy or expose the textfile through the independent monitoring design after reviewing permissions. Run manually with:

```bash
sudo /usr/local/sbin/sasd-puppet-monitoring-snapshot
python3 scripts/export-monitoring.py --compliance compliance.json --health health.json --format nagios
```
