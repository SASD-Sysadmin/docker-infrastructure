# Repository-Struktur

Wichtige aktuelle Pfade:

- `manifests/site.pp`: feste Rollen- und Lebenszyklus-Klassifizierung;
- `site-modules/profile`: technische Profile und Templates;
- `site-modules/role`: vollständige Knotenrollen;
- `data/nodes`: aktive, gewartete oder zur Stilllegung markierte Knoten;
- `data/retired`: historische, nicht von Hiera geladene Datensätze;
- `config/role-catalog.json`: maschinenlesbarer Rollenvertrag;
- `config/node-data-contract.json`: Vertrag für Knotendaten und Lebenszyklus;
- `secrets`: Bereich für verschlüsselte Daten ohne private Schlüssel;
- `scripts`: Bootstrap-, Betriebs-, Lifecycle-, Compliance- und Release-Werkzeuge;
- `tests`: Smoke-, RSpec-Puppet- und Container-Tests.

## Ergänzungen in Milestone 7

- `config/platform-catalog.json`: Vertrag für Plattformen, Architekturen und Paketquellen;
- `data/os/family/`: vollständige Paketnamensabbildungen je OS-Familie;
- `profile::platform_state`: lokale, nicht geheime Plattforminformationen;
- `redhat-family.yml`: EL9-Vertrags- und Paketverfügbarkeitstests.
