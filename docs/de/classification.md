# Klassifizierung und Rollen/Profile

## Klassifizierung in Milestone 1

`manifests/site.pp` weist jedem Knoten `role::baseline` zu. Diese bewusste Übergangsklassifizierung kompiliert eine echte Klassenkette, verwaltet aber keinen Workload.

```text
node default
  -> role::baseline
     -> profile::baseline
        -> keine Ressourcen
```

## Rollenvertrag

Eine Rolle beschreibt den vollständigen Zweck eines Knotens und kombiniert Profile. Rollen verwalten Pakete, Dateien, Dienste, Benutzer oder Kommandos nicht direkt.

## Profilvertrag

Ein Profil implementiert genau eine zusammenhängende technische Fähigkeit. Es darf externe Module kapseln und Umgebungsdaten über typisierte Parameter und Hiera beziehen.

## Spätere Klassifizierung

Vor der Einführung mehrerer produktiver Rollen wird die verbindliche Quelle der Knotenrolle ausgewählt und dokumentiert, etwa vertrauenswürdige Zertifikatserweiterungen oder ein ENC. Das reservierte Verzeichnis `data/roles/` ist noch keine Entscheidung für einen ungeprüften Custom Fact.
