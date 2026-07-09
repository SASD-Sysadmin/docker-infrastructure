# Verzeichnisstruktur

## Dateien im Wurzelverzeichnis

- `README.md`: führende englische Projektübersicht.
- `README.de.md`: zusätzliche deutsche Übersicht.
- `LICENSE`: MIT-Lizenz.
- `CHANGELOG.md`: wesentliche Änderungen.
- `CONTRIBUTING.md`: Regeln für Beiträge und Reviews.
- `SECURITY.md`: Sicherheits- und Meldeverfahren.
- `Puppetfile`: fest versionierte externe Module für r10k.
- `environment.conf`: Modulpfad und spätere Environment-Einstellungen.
- `hiera.yaml`: Hiera-5-Hierarchie des Environments.

## `manifests/`

Enthält das Hauptmanifest des Environments. `site.pp` ist im ersten Commit absichtlich leer, damit das Auschecken des Repositorys allein keine Pakete installiert und keine Dienste verändert.

## `site-modules/`

Enthält den mit dem Control Repository versionierten SASD-eigenen Puppet-Code:

- `profiles/`: technische Implementierungsklassen;
- `roles/`: Rollen, die Profile kombinieren.

## `modules/`

Ist für externe, durch r10k aus dem `Puppetfile` installierte Abhängigkeiten reserviert. Die erzeugten Inhalte werden nicht eingecheckt.

## `data/`

Enthält Hiera-Daten:

- `common.yaml`: gemeinsame Standardwerte;
- `os/`: Daten pro Betriebssystemfamilie;
- `roles/`: Daten pro Rolle;
- `nodes/`: Ausnahmefälle pro vertrauenswürdigem Zertifikatsnamen.

## `scripts/`

Ist für Bootstrap-, Validierungs-, lokale Ausführungs- und Deployment-Hilfen reserviert. Skripte folgen erst nach der Festlegung von Plattformumfang und Berechtigungsmodell.

## `tests/`

Ist für statische Prüfungen, Unit-Tests, Katalogkompilierung und Integrationstests reserviert.

## `.github/`

Enthält Issue- und Pull-Request-Vorlagen. Eine aktive CI wird erst nach Auswahl der Puppet- und Testwerkzeug-Versionen angelegt.
