# Roadmap

## Abgeschlossen

- Milestones 1–10: Grundlage, zentraler Betrieb, Lifecycle, Produktionsabsicherung, plattformübergreifende Anwendungsprofile und Java-/PHP-/.NET-SDKs.
- Milestone 11: aktive per-Node-Hiera-eyaml-Ebene mit eng begrenztem Debian-APT-Lesekennwort sowie Recovery-/Rotationskontrollen.

## Mögliche Stepstones nach 0.11.0

1. Vollständigen CA-, PuppetDB- und Secret-Service-Restore auf einem isolierten Ersatzserver testen.
2. Agent-seitige Deferred-Secret-Abfrage prüfen, falls Katalogcache-Risiko nicht akzeptabel ist.
3. .NET-arm64-Paketquellen vor Erweiterung der Architektur-Allowlist validieren.
4. EL10 erst nach eigener Puppet- und Paketvalidierung prüfen.
5. Zweiten Compiler erst bei messbarer Last oder Verfügbarkeitsanforderung bewerten.
