# Backup des Control Plane

```bash
sudo ./scripts/backup-control-plane.sh
sudo ./scripts/verify-backup.sh /var/backups/sasd-puppet/puppet-control-plane-*.tar.gz
```

Bei installiertem PuppetDB wird automatisch ein PostgreSQL-Dump aufgenommen.
Das Archiv enthält private CA- und Hostschlüssel und muss root-only, verschlüsselt
und auf unabhängiger Speicherung aufbewahrt werden. Eine destruktive automatische
Wiederherstellung auf einer laufenden CA ist absichtlich nicht enthalten.
