# Repository-Struktur

Wichtige Pfade in Milestone 6:

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
