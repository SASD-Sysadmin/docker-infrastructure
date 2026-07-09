# puppet-software-baseline

[English documentation](README.md)

> **Status:** Milestone 7 abgeschlossen (`0.7.0`). Zentrale Agents unterstützen nun zusätzlich AlmaLinux 9 und Rocky Linux 9; Paketnamen werden geprüft nach Betriebssystemfamilie verwaltet.

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

## Milestone 7

- vollständige Paketabbildungen für Debian- und RedHat-Familie;
- sicherer EL9-Agent-Bootstrap mit geschützter API-Key-Datei;
- Plattformnachweis unter `/etc/sasd/platform.d/current.conf`;
- Tests für Paketverfügbarkeit, Plattformvertrag und Bootstrap-Schranken;
- kein EPEL, keine Firewall-/SELinux-Änderungen und kein Puppet Server auf EL9.

Dokumentation: [Milestone 7](docs/de/milestone-7.md), [EL9-Agents](docs/de/redhat-family-agents.md), [Paketdaten](docs/de/cross-platform-package-data.md), [Runbook](docs/de/milestone-7-runbook.md).

Lizenz: MIT.
