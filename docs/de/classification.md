# Klassifizierung

`manifests/site.pp` erlaubt ausschließlich die Rollen aus
`config/role-catalog.json` sowie die Lebenszykluswerte `active`, `maintenance`
und `retired`. Hiera-Daten dürfen keine beliebigen Klassen auswählen.

```yaml
---
sasd::role: server
sasd::lifecycle_state: active
sasd::owner: operations
```

Wartung benötigt zusätzlich Grund, Ticket und UTC-Ablaufzeit. Bei `retired`
wird die Katalogerstellung vor der Rollenkompilierung abgebrochen.
