# Optionales PuppetDB

PuppetDB ist optional. Es wird benötigt, wenn historische Reports, Facts,
Kataloge, Events, Exported Resources oder strukturierte Abfragen gewünscht sind.
Der Bootstrap unterstützt Puppet Server, PuppetDB und PostgreSQL auf demselben
Debian-12- oder Ubuntu-24.04-Host mit Puppet Server 8 oder neuer.

```bash
sudo ./scripts/bootstrap-puppetdb.sh --dry-run
sudo ./scripts/bootstrap-puppetdb.sh --apply
sudo ./scripts/status-puppetdb.sh
```

Verwendet wird das fest versionierte Modul `puppetlabs-puppetdb` 8.1.0 in einem
isolierten Bootstrap-Modulpfad. PuppetDB ist kritische Control-Plane-Infrastruktur
und muss überwacht und zusammen mit PostgreSQL gesichert werden.
