# Klassifizierung

Hiera liefert `sasd::role`; `manifests/site.pp` ordnet den Wert über eine feste
Allowlist zu. Milestone 5 erlaubt `baseline`, `managed_agent`, `server`,
`development`, `container_host` und `puppet_server`.

Klassennamen dürfen niemals dynamisch aus Hiera konstruiert werden.
`config/role-catalog.json` spiegelt die Allowlist für Prüfungen, steuert sie aber
nicht. Eine neue Rolle benötigt Profile, Tests, Dokumentation, Hiera-Beispiel und
einen expliziten Zweig im Site-Manifest.
