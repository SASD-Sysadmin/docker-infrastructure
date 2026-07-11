# Milestone 3 – zentraler Puppet Server

## Ziel

Milestone 3 macht das Control Repository zentral nutzbar, ohne bereits anwendungsspezifische Workloads einzuführen. Installation, Code-Deployment, Zertifikatsanbindung, Betrieb, Tests und Dokumentation werden reproduzierbar vorbereitet.

## Gelieferte Komponenten

1. `bootstrap-server.sh` installiert und konfiguriert Puppet Server und r10k.
2. `deploy-environment.sh` deployed genau ein Branch-/Environment-Paar unter einer Sperre und prüft die Manifeste.
3. `bootstrap-central-agent.sh` installiert einen Agent, schreibt seine Identität, deaktiviert den Dienst und erzeugt den CSR.
4. CA-Hilfsskripte listen, signieren oder bereinigen exakt benannte Zertifikate.
5. `activate-central-agent.sh` holt das signierte Zertifikat, führt No-op oder Apply aus und aktiviert optional den Dienst.
6. `status-server.sh` zeigt den zentralen Zustand schreibgeschützt an.
7. Der Git-Branch `production` entspricht direkt dem Puppet-Environment `production`.
8. `sasd::role` stammt aus Hiera, wird aber in `site.pp` durch eine feste Allowlist begrenzt.

## Bewusst nicht enthalten

PuppetDB, Puppet Enterprise, Hochverfügbarkeit, Autosigning, Webhooks, Firewall-Automatisierung, ENC und zusätzliche Applikationsrollen folgen erst in späteren Stepstones.
