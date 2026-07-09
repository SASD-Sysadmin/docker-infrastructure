# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository zur Installation von Anwendungen und zur Sicherstellung konsistenter Paket-, Dienst- und Konfigurationsstände auf SASD-Systemen.

> **Status:** Milestone 3 abgeschlossen (`0.3.0`). Das Repository unterstützt jetzt einen zentralen Open-Source-Puppet-Server, manuelle Zertifikatsfreigabe, r10k-Deployment und weiterhin den sicheren lokalen Betrieb.

## Umfang

Der eigentliche Anwendungs-Workload bleibt bewusst klein: Basispakete und die verwaltete Datei `/etc/sasd/puppet-baseline.conf`. Neu ist die zentrale Steuerungsebene:

- Puppet-Server-Bootstrap auf Debian 12 oder Ubuntu 24.04;
- eigener Branch `production` und gleichnamiges Puppet-Environment;
- Code-Auslieferung mit r10k;
- manuelle CA-Verwaltung ohne Autosigning;
- zentrale Agent-Anbindung für Debian 12/13 und Ubuntu 24.04;
- sauberer Übergang vom lokalen `puppet apply` zum Serverbetrieb.

## Architektur

```text
GitHub-Control-Repository
  main        Integration und Pull Requests
  production  freigegebener Stand
       |
       | r10k
       v
Puppet Server + CA
       |
       | gegenseitig authentifiziertes HTTPS
       v
Puppet Agents
```

## Server einrichten

Vorher bitte die [Server-Installationsanleitung](docs/de/puppet-server-installation.md) lesen:

```bash
sudo ./scripts/bootstrap-server.sh \
  --server-name puppet.example.test \
  --dns-alt-names puppet
```

Status und manuelles Deployment:

```bash
sudo ./scripts/status-server.sh
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

## Agent anbinden

Auf dem Agent:

```bash
sudo ./scripts/bootstrap-central-agent.sh \
  --server puppet.example.test \
  --certname node01.example.test
```

Auf dem Server prüfen und exakt diesen CSR signieren:

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

Danach auf dem Agent zunächst als No-op aktivieren:

```bash
sudo ./scripts/activate-central-agent.sh --noop --enable-service
```

## Sicherheitsvorgaben

- kein Autosigning;
- keine API-Keys, privaten Schlüssel oder Zertifikate im Repository;
- Agent-Dienst erst nach manueller Freigabe;
- vorhandene CA wird nie stillschweigend ersetzt;
- produktiver Code ausschließlich aus `production`;
- Puppet-Core-Zugangsdaten nur aus einer root-lesbaren Datei;
- noch keine Webhooks oder unbeaufsichtigten Produktionsdeployments.

## Lokaler Betrieb

Der lokale Milestone-2-Weg bleibt erhalten:

```bash
sudo ./scripts/bootstrap-agent.sh --noop
./scripts/apply-local.sh --noop
sudo ./scripts/apply-local.sh --apply
```

## Dokumentation

- [Milestone 3](docs/de/milestone-3.md)
- [Puppet-Server installieren](docs/de/puppet-server-installation.md)
- [r10k und Environments](docs/de/r10k-deployment.md)
- [Agent-Anbindung](docs/de/central-agent-enrollment.md)
- [Zertifikatsverwaltung](docs/de/certificate-management.md)
- [Serverbetrieb](docs/de/server-operations.md)
- [Netzwerk und DNS](docs/de/network-requirements.md)
- [Backup und Wiederherstellung](docs/de/server-backup-restore.md)
- [Migration vom lokalen Betrieb](docs/de/migration-to-server.md)
- [Fehlerbehebung](docs/de/server-troubleshooting.md)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
