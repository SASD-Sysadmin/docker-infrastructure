# Milestone 1 – Grundlage des Control Repositorys

## Ziel

Milestone 1 stellt ein testbares Puppet-Control-Repository bereit, ohne bereits produktiven Workload einzuführen. Es schafft die technische und dokumentarische Grenze, auf der die späteren Installations- und Konfigurations-Stepstones sicher aufbauen können.

## Gelieferte Funktionen

- Puppet-8-Umgebungsdateien `environment.conf`, `hiera.yaml`, `Puppetfile` und `manifests/site.pp`;
- serverfähiger Modulpfad aus `site-modules`, dem durch r10k verwalteten `modules` und `$basemodulepath`;
- `config_version`-Ermittlung über Git oder VERSION-Fallback;
- PDK-kompatible Metadaten für die Module `role` und `profile`;
- dokumentierte Rollen-/Profilstruktur;
- Default-Klassifizierung über `role::baseline`;
- bewusst leeres `profile::baseline`;
- Hiera-Struktur für gemeinsame Daten, Betriebssystemfamilien, spätere Rollen und begründete Knotenausnahmen;
- statische Prüfungen für Puppet, Metadaten, YAML, JSON, Shell und Repository-Struktur;
- RSpec-Puppet-Kompilationstests;
- lokale Katalogausführung mit No-op als Standard;
- GitHub-Actions-Validierung und Dependabot-Konfiguration;
- englische Hauptdokumentation und deutsche Begleitdokumentation.

## Sicherheitseigenschaft

Der Katalog kompiliert eine Klassenkette, deklariert aber keine Pakete, Dateien, Dienste, Benutzer, Gruppen, Paketquellen, Mounts, Zeitpläne oder `exec`-Ressourcen. Seine Ausführung kann daher keine Anwendung installieren oder umkonfigurieren.

Zusätzlich startet `apply-local.sh` standardmäßig mit `--noop`. Eine echte Anwendung erfordert ausdrücklich `--apply`. Diese doppelte Grenze ist beabsichtigt.

## Abnahmekriterien

Milestone 1 gilt als vollständig, wenn:

1. alle vorgeschriebenen Dateien vorhanden sind;
2. YAML- und JSON-Dateien fehlerfrei geparst werden;
3. alle Shell-Skripte `bash -n` bestehen;
4. Puppet-Manifeste in einer vorbereiteten Umgebung Parser- und Lint-Prüfung bestehen;
5. die Modulmetadaten `metadata-json-lint` bestehen;
6. die RSpec-Puppet-Tests für Rolle und Profil kompilieren;
7. der Default-Katalog im No-op-Modus kompiliert;
8. GitHub Actions dieselbe Prüfsuite ausführt;
9. englische und deutsche Dokumentation Betrieb und Grenzen erklären;
10. kein produktiver Puppet-Workload enthalten ist.

## Nicht Bestandteil

Puppet-Agent- und Puppet-Server-Installation, r10k-Serverkonfiguration, Zertifikatsverwaltung, PuppetDB, Anwendungspakete, produktive Konfigurationen, verschlüsselte Secrets und die endgültige Node-Klassifizierung folgen als eigene Stepstones.
