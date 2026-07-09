# puppet-software-baseline

[English documentation](README.md)

> **Status:** Milestone 8 abgeschlossen (`0.8.0`). Die erste Repository-Linie enthält nun Produktionsabsicherung, aggregierten Monitoring-Export, Audit-Nachweise, isolierte Recovery-Proben sowie Upgrade- und PuppetDB-Richtlinien.

Konservatives Puppet-Control-Repository zur Installation geprüfter Anwendungen und zur Sicherstellung konsistenter Paket-, Datei-, Dienst-, Lifecycle- und Betriebszustände auf SASD-Systemen.

## Plattformen

| Plattform | Zentraler Agent | Lokal/Standalone | Paketquelle |
|---|---:|---:|---|
| Debian 12 | ja | ja | Distribution oder Puppet Core |
| Debian 13 | ja | ja | Distribution oder Puppet Core |
| Ubuntu 24.04 | ja | ja | Distribution oder Puppet Core |
| AlmaLinux 9 | ja | nein | authentifiziertes Puppet Core |
| Rocky Linux 9 | ja | nein | authentifiziertes Puppet Core |

Der Puppet Server bleibt auf Debian 12 und Ubuntu 24.04 begrenzt.

## Milestone 8

- aggregierter Prometheus-, JSON- und Nagios-kompatibler Export ohne Certname-Metriklabels;
- prüfbare Audit-Bundles ohne private Schlüssel und Secret-Werte;
- Backup-Metadaten, Readiness-Prüfung und isolierte Wiederherstellungsprobe;
- rein lesende Upgrade-Vorprüfung und geprüfte PuppetDB-Aufbewahrungsrichtlinie;
- vollständige Paketabbildungen für Debian- und RedHat-Familie;
- kein EPEL, keine Firewall-/SELinux-Änderungen, kein Live-Restore und kein automatisches Produktionsdeployment.

## Erste Befehle

```bash
./scripts/validate.sh
ruby scripts/node-inventory.rb
python3 scripts/check_operations_policy.py
```

## Dokumentation

- [Milestone 8](docs/de/milestone-8.md)
- [Milestone-8-Runbook](docs/de/milestone-8-runbook.md)
- [Monitoring-Anbindung](docs/de/monitoring-integration.md)
- [Audit-Nachweise](docs/de/audit-evidence.md)
- [Wiederherstellungsprobe](docs/de/disaster-recovery-rehearsal.md)
- [Upgrade und Wartung](docs/de/upgrade-maintenance.md)
- [PuppetDB-Aufbewahrung](docs/de/puppetdb-retention.md)
- [Architektur](docs/de/architecture.md)
- [Sicherheit](docs/de/security.md)
- [Roadmap](docs/de/roadmap.md)

Lizenz: MIT.
