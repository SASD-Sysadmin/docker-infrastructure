# Architektur

## Kontext

Das Repository verwaltet dauerhafte Baselines für Anwendungsinstallation und Konfiguration. Es ist kein Werkzeug für Incident Response, Diagnose oder prozedurale Reparaturen.

## Aktuelle Architektur

```text
Git-Arbeitskopie / GitHub
          |
          | Validierung
          v
Puppet-Umgebung
  manifests/site.pp
          |
          v
   role::baseline
          |
          v
 profile::baseline
          |
          v
   keine Ressourcen
```

Die lokale Entwicklung nutzt `puppet apply --noop`. Später ergänzen r10k und Puppet Server diese Struktur, ohne das grundlegende Environment-Layout zu ändern.

## Schichten

- `role`: Kombination nach Knotenzweck;
- `profile`: SASD-spezifische Implementierungsrichtlinie;
- `modules`: externe, über das `Puppetfile` installierte Abhängigkeiten;
- `data`: Hiera-Daten der Umgebung;
- `manifests`: ausschließlich Klassifizierung.

## Architekturregeln

Keine produktiven Ressourcen in `site.pp` oder Rollen, keine Rollen in Profilen, keine manuell gepflegten Inhalte unter `modules`, keine Klartext-Secrets, Tests und Dokumentation für jedes produktive Profil, No-op als lokaler Standard und nur begründete knotenspezifische Daten.
