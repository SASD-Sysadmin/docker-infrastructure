# Roadmap

## Abgeschlossen

- Milestone 1: Control-Repository-Grundlage und Validierung.
- Milestone 2: lokaler Paket-/Datei-Testbetrieb.
- Milestone 3: zentraler Puppet Server, r10k und CA-Enrollment.
- Milestone 4: Regelbetrieb, Reporting, Health, Backup und Rollback.
- Milestone 5: Anwendungsprofile, explizite Rollen und Release-Absicherung.
- Milestone 6: Knoten-Lifecycle, Inventar, Compliance und eyaml-Grundlage.
- Milestone 7: AlmaLinux-/Rocky-9-Agents und plattformabhängige Paketdaten.
- Milestone 8: Produktionsabsicherung, Monitoring-Export, Audit und Recovery-Probe.
- Milestone 9: geprüfte OpenJDK-17-/Maven- und PHP-CLI-SDK-Profile mit expliziten Entwicklungsrollen.

## Mögliche Stepstones nach 0.9.0

1. Hiera eyaml erst für ein konkretes Secret-verbrauchendes Profil aktivieren.
2. Einen vollständigen CA- und eyaml-Service-Restore auf einem isolierten Ersatzserver testen.
3. EL10 erst nach eigener Puppet- und Paketvalidierung prüfen.
4. Einen zweiten Compiler erst bei messbarem Last- oder Verfügbarkeitsbedarf bewerten.
5. .NET in einem separaten ADR mit Repository-, Schlüssel- und Servicing-Modell planen.
