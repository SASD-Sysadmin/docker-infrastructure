# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository zur Installation von Anwendungen sowie zur Sicherstellung konsistenter Paket-, Dienst-, Konfigurations- und Betriebszustände auf SASD-Systemen.

> **Status:** Milestone 4 abgeschlossen (`0.4.0`). Der zentrale Regelbetrieb umfasst jetzt Test-/Produktions-Promotion, regelmäßige Agentläufe, kompaktes Reporting, Health-Checks, verifizierte Backups, Rollback-Vorbereitung und optional PuppetDB.

## Abgrenzung

Puppet beschreibt dauerhaften Sollzustand. Es ist kein Werkzeug für Incident-Response oder Ad-hoc-Reparaturen. Rollen kombinieren Profile, Profile besitzen technische Ressourcen und Hiera enthält Umgebungs- und Knotendaten.

Milestone 4 verwaltet:

- Basispakete und `/etc/sasd/puppet-baseline.conf`;
- den nativen Puppet-Agent-Dienst nach Zertifikatsfreigabe;
- Betriebswerkzeuge, Zustandsverzeichnisse und Health-Timer des Puppet Servers;
- kompakte datensparsame JSON-Reportzusammenfassungen;
- Promotion `main -> test -> production` und r10k-Deployment;
- optional PuppetDB für historische Reports und Abfragen.

## Schnelleinstieg Regelbetrieb

```bash
./scripts/promote-environment.sh --from main --to test --full-validation
./scripts/promote-environment.sh --from main --to test --push
sudo ./scripts/deploy-environment.sh --environment test --branch test

./scripts/promote-environment.sh --from test --to production --full-validation
./scripts/promote-environment.sh --from test --to production --push
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Agenttaktung und Reporting:

```bash
sudo ./scripts/configure-agent-service.sh --runinterval 1h --splaylimit 15m
sudo ./scripts/configure-reporting.sh
sudo ./scripts/server-health.sh
sudo ./scripts/report-status.py
```

Backup und optionale PuppetDB-Stufe:

```bash
sudo ./scripts/backup-control-plane.sh
sudo ./scripts/verify-backup.sh /var/backups/sasd-puppet/puppet-control-plane-*.tar.gz
sudo ./scripts/bootstrap-puppetdb.sh --dry-run
```

## Sicherheitsvorgaben

- kein Autosigning und kein Bulk-Signing;
- keine Secrets, Schlüssel, Zertifikate, Dumps oder Backups in Git;
- nur Fast-Forward-Historie für `test` und `production`;
- keine ungeprüften Webhooks oder automatischen Produktionsdeployments;
- Identitätswerte des Agents werden nicht durch Manifeste umgeschrieben;
- kompakte Reports enthalten keine Facts, Logs, Diffs oder Ressourcenwerte;
- PuppetDB ist opt-in und benötigt Monitoring sowie Backup;
- Rollback erfolgt als neuer geprüfter Commit.

## Dokumentation

- [Milestone 4](docs/de/milestone-4.md)
- [Zentraler Betriebsmodus](docs/de/operational-model.md)
- [Environments und Promotion](docs/de/environments-and-promotion.md)
- [Agent-Zeitplanung](docs/de/agent-scheduling.md)
- [Reporting](docs/de/reporting.md)
- [Health-Monitoring](docs/de/health-monitoring.md)
- [Optionales PuppetDB](docs/de/puppetdb.md)
- [Backup-Betrieb](docs/de/backup-operations.md)
- [Rollback](docs/de/rollback-operations.md)
- [Milestone-4-Runbook](docs/de/milestone-4-runbook.md)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
