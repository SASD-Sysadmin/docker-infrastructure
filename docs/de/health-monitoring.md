# Health-Monitoring

`profile::server_operations` installiert Skript, Service, Timer und die Datei
`/var/lib/sasd-puppet/health/last.json`. Geprüft werden Puppet Server,
Production-Deployment, CA, Report-Aktualität und optional PuppetDB.

```bash
sudo /usr/local/sbin/sasd-puppet-health
sudo systemctl status sasd-puppet-health.timer
sudo journalctl -u sasd-puppet-health.service
```

Exitcodes: `0` OK, `1` Warnung, `2` kritisch. Es wird kein neuer Netzwerkport
geöffnet.
