# Roadmap

## Milestone 1 – Grundlage des Control Repositorys – abgeschlossen

Serverfähige Struktur, workload-freier Rollen-/Profilkatalog, Hiera-Grundlage, Validierung, Unit-Tests, lokaler No-op-Runner, CI und zweisprachige Dokumentation.

## Nächste Stepstones

Der echte Workload wird in kleinen prüfbaren Schritten eingeführt:

1. Entscheidung zu Plattformen und Paketrichtlinie;
2. Puppet-Agent-Bootstrap für Debian/Ubuntu;
3. erstes ungefährliches Markerprofil;
4. Profil für grundlegende Administrationspakete;
5. Profil zur Dienst-/Konfigurationskonsistenz;
6. Anwendungsgruppen und Rollenkombinationen;
7. Puppet Server und r10k;
8. Zertifikatsbetrieb, Reporting, Backups und optional PuppetDB.

Jeder Stepstone benötigt Abnahmekriterien, Rückrollverhalten, Tests, No-op-Nachweis sowie englische und deutsche Betriebsdokumentation.
