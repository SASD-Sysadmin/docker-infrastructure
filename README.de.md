# puppet-software-baseline

[English primary documentation](README.md)

Puppet-Control-Repository zur Installation von Anwendungen und zur Sicherstellung konsistenter Paket-, Dienst- und Konfigurationsstände auf SASD-Systemen.

Das Repository ist für zwei Betriebsarten vorbereitet:

1. **Anfängliche Entwicklung und Labortests mit `puppet apply`**.
2. **Späterer zentraler Betrieb mit Puppet Server, r10k, Hiera sowie dem Roles-and-Profiles-Pattern**.

> **Projektstatus:** Reines Repository-Grundgerüst. Der erste Commit enthält absichtlich keinen produktiven Workload, keine Paketinstallationsrichtlinie und keine aktive Klassifizierung von Maschinen. Die funktionalen Stepstones folgen in späteren Meilensteinen.

## Zweck

Das Projekt soll den gewünschten dauerhaften Zustand der von SASD verwalteten Systeme beschreiben. Geplant sind:

- Installation freigegebener Anwendungen und Betriebssystempakete;
- konsistente Konfigurationsdateien und Diensteinstellungen;
- deklarative Verwaltung von Diensten;
- Trennung wiederverwendbarer technischer Profile von Maschinenrollen;
- Trennung von Puppet-Code und umgebungsspezifischen Hiera-Daten;
- reproduzierbare Bereitstellung über Puppet Server und r10k;
- Validierung von Änderungen vor der Anwendung auf verwalteten Systemen.

Das Repository ist ausdrücklich **nicht** für Incident Response oder Troubleshooting gedacht. Temporäre Reparaturen, Diagnosen, Loganalysen, Ad-hoc-Kommandos und prozedurale Fehlerbehebungen gehören in die SASD-Ansible- und Administration-Repositories.

## Grundprinzipien

### Deklarative Konfiguration

Das Repository beschreibt den Sollzustand. Puppet ermittelt, welche Änderungen zur Annäherung an diesen Zustand notwendig sind.

### Sicheres Grundverhalten

Der erste Stand verwaltet keine Ressource. Spätere Bootstrap- und Deployment-Werkzeuge sollen zunächst validieren und nach Möglichkeit einen No-op-Lauf anbieten, bevor Änderungen tatsächlich angewendet werden.

### Von Beginn an Puppet-Server-fähig

Lokale Tests mit `puppet apply` bleiben möglich. Die Struktur ist jedoch von Anfang an als Control Repository für eine spätere Bereitstellung mit r10k oder Puppet Enterprise Code Manager ausgelegt.

### Roles and Profiles

Technische Implementierungen werden in Profilen gekapselt. Rollen kombinieren Profile entsprechend dem Zweck einer Maschine. Ein Node soll normalerweise genau eine Rolle erhalten.

### Trennung von Code und Daten

Konkrete Werte gehören nach `data/`. Host- oder umgebungsspezifische Werte sollen nicht ohne Not direkt in Manifeste eingebaut werden.

### Möglichst wenige Node-Sonderfälle

Gemeinsame, betriebssystemspezifische und rollenbezogene Daten haben Vorrang. Node-spezifische Dateien bleiben eine Ausnahme, damit die Konsistenz nicht durch zahlreiche Sonderwege verloren geht.

### Keine Secrets in Git

Kennwörter, private Schlüssel, API-Tokens, Zertifikate und unverschlüsselte sensible Konfiguration dürfen nicht eingecheckt werden. Ein späterer Meilenstein kann ein freigegebenes verschlüsseltes Hiera-Backend und ein dokumentiertes Schlüsselmanagement einführen.

## Verzeichnisübersicht

```text
puppet-software-baseline/
├── .github/                   Vorlagen für Zusammenarbeit auf GitHub
├── data/                      Hiera-Daten auf Environment-Ebene
├── docs/                      Englische und deutsche Dokumentation
├── manifests/site.pp          Einstiegspunkt; absichtlich ohne Workload
├── modules/                   Durch r10k geladene Fremdmodule
├── scripts/                   Platz für Bootstrap-, Prüf- und Deployment-Skripte
├── site-modules/profile/      SASD-eigene technische Profile
├── site-modules/role/         Rollen aus mehreren Profilen
├── tests/                     Platz für spätere Tests
├── Puppetfile                 Deklaration externer Module
├── environment.conf           Konfiguration des Puppet-Environments
└── hiera.yaml                 Hiera-5-Hierarchie
```

Eine ausführliche Beschreibung steht unter [Verzeichnisstruktur](docs/de/repository-layout.md).

## Enthalten im ersten Commit

- ausführliche englische Hauptdokumentation;
- zusätzliche deutsche Dokumentation;
- MIT-Lizenz;
- Hinweise zu Beiträgen und Sicherheit;
- serverfähige Control-Repository-Struktur;
- absichtlich leere `site.pp`;
- leeres, für feste Abhängigkeiten vorbereitetes `Puppetfile`;
- Hiera-5-Hierarchie für Nodes, Betriebssysteme und gemeinsame Daten;
- Architekturentscheidung und Roadmap;
- Platzhalter für Skripte, Module, Tests und GitHub-Automatisierung;
- kein produktiver Puppet-Workload.

## Geplantes Betriebsmodell

### Entwicklungs- und Laborphase

Zu Beginn können Manifeste lokal kompiliert und im No-op-Modus geprüft werden. Ein späteres Skript wird hierfür einen stabilen und dokumentierten Aufruf bereitstellen.

### Zentraler Puppet-Server-Betrieb

```text
GitHub Control Repository
          |
          | r10k-Deployment
          v
     Puppet Server
          |
          | signierte Kataloge über TLS
          v
     Puppet Agents
```

Dabei gilt:

- r10k stellt Git-Branches als Puppet-Environments bereit;
- der Puppet Server kompiliert die Kataloge;
- Agents klonen dieses Repository nicht;
- Agents übertragen Fakten und laden ihren Katalog vom Server;
- die Puppet-CA authentifiziert die Systeme;
- PuppetDB kann später für Reports, Fakten, Inventar und Abfragen ergänzt werden.

## Hiera-Hierarchie

Die Datei [`hiera.yaml`](hiera.yaml) durchsucht Daten in dieser Reihenfolge:

1. Node anhand des vertrauenswürdigen Zertifikatsnamens;
2. Betriebssystemfamilie;
3. gemeinsame Standardwerte.

Das Verzeichnis `data/roles/` ist vorbereitet, aber noch nicht Teil der aktiven Hierarchie. Der endgültige Mechanismus der Node-Klassifizierung wird festgelegt, bevor produktive Rollendaten eingeführt werden.

## Dokumentation

- [Architektur](docs/de/architecture.md)
- [Verzeichnisstruktur](docs/de/repository-layout.md)
- [Betriebsmodell](docs/de/operating-model.md)
- [Sicherheitsarchitektur](docs/de/security.md)
- [Roadmap](docs/de/roadmap.md)
- [Erstimport in GitHub](docs/de/initial-import.md)

Die führende Projektsprache ist Englisch. Deutsche Dokumentation wird zusätzlich gepflegt, soweit sie für Planung, Betrieb und Einarbeitung sinnvoll ist.

## Lizenz

Das Projekt steht unter der [MIT-Lizenz](LICENSE).
