# Milestone 2 — Lokale Standalone-Baseline

## Ziel

Milestone 2 macht aus der technischen Grundlage ein nutzbares, sicheres lokales
Puppet-Labor. Ein unterstütztes Debian-/Ubuntu-System kann die Werkzeuge
installieren, das Control Repository beziehen, Abweichungen anzeigen, eine
kleine Baseline anwenden und Idempotenz nachweisen – noch ohne Puppet Server.

## Gelieferte Fähigkeiten

- Installation ohne Puppet-Core-Zugangsdaten über Distributionspakete;
- Debian 12, Debian 13 und Ubuntu 24.04 LTS;
- Kompatibilitätstests für Puppet 7.23 und Puppet 8.10;
- lokaler Lauf standardmäßig als No-op;
- Git-Bootstrap nach `/opt/sasd`;
- r10k und Puppetfile-Verarbeitung;
- erste Hiera-gesteuerte Paket-Baseline;
- verwaltete Markierungsdatei unter `/etc/sasd`;
- genaue OS-, OS-Familien-, Common- und Node-Hiera-Ebenen;
- RSpec-Puppet-, Dry-run- und Container-Tests;
- englische und deutsche Betriebsdokumentation.

## Sicherheitsgrenze

Erlaubt sind ausschließlich `package` und `file`. Es gibt keine `exec`-, Dienst-,
Benutzer-, Gruppen-, Firewall-, Mount-, Zeitplan- oder Repository-Ressourcen.
Nicht unterstützte Betriebssysteme brechen bereits bei der Katalogkompilierung
ab. Bootstrap und lokaler Runner verwenden standardmäßig No-op. `--apply`
erfordert root und kann nicht mit künstlichen Fakten kombiniert werden.

## Abnahmekriterien

Alle drei Plattformkataloge müssen kompilieren, erwartete Pakete und Dateien
enthalten, nicht unterstützte Plattformen ablehnen, Bootstrap-Fixtures korrekt
bewerten und in Wegwerf-Containern zweimal ohne unerwartete Drift anwendbar sein.

## Nicht enthalten

Puppet Server, Zertifikate, PuppetDB, periodischer Agentbetrieb,
anwendungsspezifische Profile, zusätzliche Paketquellen, Secrets und Red-Hat-
Unterstützung folgen erst in späteren Stepstones.
