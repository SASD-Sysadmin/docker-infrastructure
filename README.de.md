# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository zur Installation von Anwendungen und zur Sicherstellung konsistenter Paket-, Dienst- und Konfigurationsstände auf SASD-Systemen.

> **Status:** Milestone 1 vollständig (`0.1.0`). Das Repository ist strukturiert, dokumentiert, validierbar und katalogfähig, enthält aber bewusst noch keinen produktiven Anwendungs-Workload.

## Zweck

Das Projekt beschreibt den dauerhaften Sollzustand. Spätere Stepstones installieren freigegebene Anwendungen, halten Konfigurationsdateien und Dienste konsistent und liefern reproduzierbare Kataloge über Puppet Server und r10k.

Diagnose, temporäre Reparaturen, einmalige Betriebsabläufe und Ad-hoc-Remediation gehören nicht hierher, sondern in die SASD-Ansible- und Administrations-Repositories.

## Sicherheitsgarantie von Milestone 1

```text
node default -> role::baseline -> profile::baseline -> keine Workload-Ressourcen
```

Der aktuelle Katalog deklariert keine Pakete, Dateien, Dienste, Benutzer, Gruppen, Paketquellen, Mounts, Zeitpläne oder `exec`-Ressourcen. Der lokale Runner verwendet außerdem standardmäßig `--noop`. Damit lässt sich die technische Grundlage prüfen, ohne Anwendungen zu installieren oder umzukonfigurieren.

## Inhalt von Milestone 1

- Control-Repository-Struktur für Puppet 8;
- Hiera-5-Hierarchie;
- klare Rollen-/Profilgrenze;
- workload-freier Default-Katalog;
- für Puppet Server und r10k vorbereitete Konfiguration;
- `config_version` mit Git- und VERSION-Fallback;
- Prüfungen für Puppet, YAML, JSON, Metadaten, Shell und Struktur;
- RSpec-Puppet-Unit-Tests;
- isolierter lokaler No-op-Katalogtest;
- GitHub-Actions-Validierung;
- ausführliche englische und deutsche Dokumentation;
- Architecture Decision Records.

Die vollständige Abgrenzung steht unter [Milestone 1](docs/de/milestone-1.md).

## Schnellstart für Entwickler

```bash
git clone https://github.com/SASD-Sysadmin/puppet-software-baseline.git
cd puppet-software-baseline
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

Einzelne Prüfungen:

```bash
bundle exec rake validate
bundle exec rake spec
bundle exec rake catalog
```

## Lokale Puppet-Ausführung

```bash
./scripts/apply-local.sh          # standardmäßig No-op
./scripts/apply-local.sh --noop
./scripts/apply-local.sh --apply  # nur ausdrücklich anwenden
```

In Milestone 1 ist selbst `--apply` workload-frei. Spätere Stepstones machen diese Unterscheidung betrieblich wichtig.

## Späteres Servermodell

```text
GitHub Control Repository
          |
          | r10k / Code Manager
          v
     Puppet Server
          |
          | authentifizierte kompilierte Kataloge
          v
      Puppet Agents
```

Agents klonen das Repository später nicht. Der Server deployt Code, kompiliert Kataloge und liefert sie per authentifiziertem TLS aus.

## Grundregeln

Rollen kombinieren Profile. Profile implementieren zusammenhängende technische Fähigkeiten. `site.pp` klassifiziert nur. Externe Module werden im `Puppetfile` festgelegt. `modules/` ist generiert. Werte gehören nach Hiera. Knotenspezifische Ausnahmen bleiben Ausnahmen. Secrets gehören niemals nach Git. Produktive Änderungen benötigen Tests, Dokumentation und geprüfte No-op-Ausgabe.

## Dokumentation

- [Deutscher Dokumentationsindex](docs/de/README.md)
- [Englischer Dokumentationsindex](docs/en/README.md)
- [Architekturentscheidungen](docs/adr/)
- [Mitwirkung](CONTRIBUTING.md)
- [Sicherheitsrichtlinie](SECURITY.md)
- [Änderungsprotokoll](CHANGELOG.md)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
