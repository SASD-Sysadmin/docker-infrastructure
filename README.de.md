# puppet-software-baseline

[English documentation](README.md)

> **Status:** Milestone 9 abgeschlossen (`0.9.0`). Geprüfte Java- und PHP-Kommandozeilen-SDK-Profile erweitern nun die plattformübergreifende Anwendungsbaseline.

Konservatives Puppet-Control-Repository zur Installation geprüfter Anwendungen und zur Sicherstellung konsistenter Paket-, Datei-, Dienst-, Lifecycle- und Betriebszustände auf SASD-Systemen.

## Milestone 9

- OpenJDK 17 und Maven auf allen unterstützten Agentplattformen;
- PHP-CLI-SDK aus Distributions-/AppStream-Paketen;
- Composer ausschließlich aus Repositories der Debian-Familie;
- explizite Rollen `java_development`, `php_development` und `polyglot_development`;
- rein lesender Nachweisbefehl `sasd-sdk-status`;
- keine Hersteller-Bootstrapper, kein EPEL, SDKMAN, .NET, Webserver, PHP-FPM oder automatisches Umschalten von Modulstreams.

## Erste Befehle

```bash
./scripts/validate.sh
python3 scripts/check_sdk_catalog.py
ruby scripts/node-inventory.rb
```

## Dokumentation

- [Milestone 9](docs/de/milestone-9.md)
- [Milestone-9-Runbook](docs/de/milestone-9-runbook.md)
- [Java-SDK](docs/de/java-sdk.md)
- [PHP-SDK](docs/de/php-sdk.md)
- [SDK-Status und Validierung](docs/de/sdk-status-and-validation.md)
- [Architektur](docs/de/architecture.md)
- [Sicherheit](docs/de/security.md)
- [Roadmap](docs/de/roadmap.md)

Lizenz: MIT.
