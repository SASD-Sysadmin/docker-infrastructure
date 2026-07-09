# Verzeichnisstruktur

```text
puppet-software-baseline/
├── .github/                 GitHub-Prüfung, Abhängigkeitsupdates, Vorlagen
├── data/                    Hiera-Daten der Umgebung
├── docs/                    Englische, deutsche und ADR-Dokumentation
├── manifests/site.pp        Einstiegspunkt der Node-Klassifizierung
├── modules/                 Generierte externe Module; nie manuell pflegen
├── scripts/                 Validierung, lokale Ausführung, config_version
├── site-modules/
│   ├── profile/             technische SASD-Implementierungsprofile
│   └── role/                Kombinationen nach Knotenzweck
├── tests/                   Smoke-Tests und repräsentative Fixtures
├── environment.conf         Puppet-Einstellungen der Umgebung
├── hiera.yaml               Hiera-5-Hierarchie
├── Puppetfile               festgelegte externe Modulabhängigkeiten
├── Gemfile                  Entwicklungs- und CI-Abhängigkeiten
├── Rakefile                 gemeinsame Prüftasks
└── VERSION                  Repository- und Site-Modul-Version
```

`site-modules` enthält Quellcode. `modules` ist r10k-Ausgabe. `data` enthält Werte statt Implementierungslogik. `site.pp` klassifiziert, implementiert aber keine Anwendungen.
