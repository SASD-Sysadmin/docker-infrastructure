# Milestone 7 — Red-Hat-Familie und plattformabhängige Paketdaten

Milestone 7 erweitert die zentral verwalteten Agents auf AlmaLinux 9 und Rocky Linux 9. Der Puppet Server bleibt auf Debian 12 oder Ubuntu 24.04; Red-Hat-Systeme werden in diesem Milestone ausschließlich als Agents unterstützt.

## Geliefert

- Agent-Bootstrap für AlmaLinux 9 und Rocky Linux 9 auf x86_64 und aarch64;
- authentifizierte Puppet-Core-RPM-Paketquelle mit rootgeschützten Zugangsdaten;
- vollständige Paketabbildungen für Debian- und RedHat-Familie in Hiera;
- maschinenlesbarer Plattformkatalog mit Paritätsprüfung;
- nicht geheime Plattformmarkierung unter `/etc/sasd/platform.d/current.conf`;
- Fixtures, RSpec-Tests, Paketverfügbarkeitstests, CI, ADRs und Runbooks;
- klare Grenzen: kein EPEL, keine SELinux-/Firewall-Änderungen und kein Puppet Server auf Red Hat.

Der lokale Standalone-Bootstrap bleibt auf Debian und Ubuntu begrenzt. Für AlmaLinux/Rocky ist `--package-source puppet-core` mit einer geschützten API-Key-Datei zwingend.
