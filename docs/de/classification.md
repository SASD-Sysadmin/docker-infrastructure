# Klassifizierung

Hiera liefert `sasd::role`; `manifests/site.pp` ordnet den Wert über eine feste
Allowlist zu. Milestone 4 erlaubt:

- `baseline` für lokale/Standalone-Systeme;
- `managed_agent` für eingebundene zentrale Agents;
- `puppet_server` für den Agent-Katalog des zentralen Servers.

Klassennamen werden niemals dynamisch aus Hiera gebildet. Neue Rollen benötigen
Profile, Tests, Dokumentation, Hiera-Beispiel und einen geprüften `site.pp`-Zweig.
