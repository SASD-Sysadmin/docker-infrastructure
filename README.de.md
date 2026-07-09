# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository zur Installation von Anwendungen und zur Sicherstellung konsistenter Paket-, Dienst- und Konfigurationsstände auf SASD-Systemen.

> **Status:** Milestone 2 vollständig (`0.2.0`). Das Repository bietet jetzt einen sicheren lokalen Standalone-Testbetrieb und eine erste bewusst kleine Paket-/Datei-Baseline für Debian 12, Debian 13 und Ubuntu 24.04 LTS.

## Zweck und Grenze

Das Repository beschreibt dauerhaften Sollzustand. Diagnose, Incident-Behebung und Ad-hoc-Reparaturen gehören nicht hierher. Milestone 2 erlaubt absichtlich nur:

- `package` für eine kleine Gruppe von Administrationswerkzeugen;
- `file` für `/etc/sasd` und eine verwaltete Baseline-Markierung.

Dienste, Benutzer, Paketquellen, Firewalls, Mounts, Zeitpläne und beliebige Befehle bleiben ausgeschlossen.

## Aktive Baseline

```text
node default -> role::baseline -> profile::baseline
                                      |-> Paket-Baseline
                                      `-> /etc/sasd/puppet-baseline.conf
```

Die Pakete werden über Hiera zusammengeführt. Enthalten sind unter anderem `ca-certificates`, `curl`, `git`, `jq`, `rsync`, `tree`, `unzip`, `lsof` und `procps`.

## Unterstützte Plattformen

| Plattform | Puppet aus der Distribution |
|---|---:|
| Debian 12 | Puppet-7.23-Reihe |
| Debian 13 | Puppet-8.10-Reihe |
| Ubuntu 24.04 LTS | Puppet-8.4-Reihe |

## Sicherer Bootstrap

Auf einer frischen unterstützten VM:

```bash
sudo ./scripts/bootstrap-agent.sh --noop
```

Das Skript installiert Grundpakete, Git, `puppet-agent` und r10k, klont oder aktualisiert das Repository unter `/opt/sasd`, deaktiviert den periodischen Server-Agentbetrieb, validiert den Stand und führt einen No-op-Lauf aus.

Nur ausdrücklich wird angewendet:

```bash
sudo ./scripts/bootstrap-agent.sh --apply
```

## Lokale Bedienung

```bash
./scripts/apply-local.sh --noop
sudo ./scripts/apply-local.sh --apply
./scripts/status-local.sh
sudo ./scripts/update-local.sh
sudo ./scripts/update-local.sh --apply
```

## Dokumentation

- [Milestone 2](docs/de/milestone-2.md)
- [Bootstrap](docs/de/bootstrap.md)
- [Lokaler Betrieb](docs/de/local-operation.md)
- [Baseline](docs/de/baseline.md)
- [Unterstützte Plattformen](docs/de/supported-platforms.md)
- [Rollback](docs/de/rollback.md)
- [Validierung](docs/de/validation.md)
- [Architekturentscheidungen](docs/adr/)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
