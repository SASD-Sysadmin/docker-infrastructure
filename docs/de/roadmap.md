# Roadmap

Die Entwicklung erfolgt bewusst in kleinen, einzeln prüfbaren Stepstones.

## Stepstone 0: Repository-Grundlage — durch dieses ZIP abgeschlossen

- Control-Repository-Struktur;
- englische und deutsche Dokumentation;
- Lizenz sowie Beitrags- und Sicherheitsregeln;
- leerer Puppet-Einstiegspunkt und Hiera-Hierarchie;
- Architekturentscheidung für einen späteren Puppet Server.

## Stepstone 1: Validierungsgrundlage

- unterstützten Puppet-Versionsbereich festlegen;
- Lint- und Testwerkzeuge auswählen;
- lokales Validierungsskript ergänzen;
- GitHub-Actions-Prüfung ergänzen;
- Voraussetzungen und Rückgabecodes dokumentieren.

## Stepstone 2: unterstützte Plattformen und lokaler Bootstrap

- erste Debian- und Ubuntu-Versionen festlegen;
- sichere Werkzeuginstallation implementieren;
- lokalen No-op-Wrapper erstellen;
- Entfernung und Wiederherstellung dokumentieren.

## Stepstone 3: erstes Baseline-Profil

- minimale freigegebene Paketgruppe definieren;
- erstes Profil implementieren;
- Hiera-Parameter und Tests ergänzen;
- Idempotenz auf isolierten Testsystemen nachweisen.

## Stepstone 4: Rollen und Klassifizierung

- Quelle der Rollenzuordnung festlegen;
- erste Server- und Entwicklungsrollen implementieren;
- Node-Onboarding und Ausnahmen dokumentieren.

## Stepstone 5: Puppet-Server-Labor

- Serverdimensionierung und Betriebssystem festlegen;
- Puppet Server absichern;
- r10k konfigurieren;
- CA-Prozesse festlegen;
- ersten Labor-Agent einbinden.

## Stepstone 6: zentraler Produktivbetrieb

- Monitoring, Reporting, Backup und Restore-Tests;
- Environment-Promotion;
- Wartungs- und Upgradeprozesse;
- PuppetDB bewerten;
- ausgewählte Nodes zentral übernehmen.
