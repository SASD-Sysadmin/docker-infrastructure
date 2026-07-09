# Sicherheit

## Schutzmaßnahmen in Milestone 6

- feste Rollen- und Lebenszyklus-Allowlist;
- gegenseitiges TLS und manuelle Zertifikatsfreigabe;
- exakte Certname-Bestätigung bei destruktiven CA-Aktionen;
- keine Kataloge für ausgemusterte Knoten;
- Wartung nur mit Grund, Ticket und Ablaufzeit;
- keine beliebigen `exec`-, Benutzer-, Firewall-, Mount- oder Cron-Ressourcen;
- keine Fremdrepositories oder Image-Pulls;
- Prüfung auf private Schlüssel und wahrscheinliche Klartext-Zugangsdaten;
- Hiera eyaml nur opt-in, Schlüssel außerhalb von Git;
- Backups und CA-Daten bleiben hochsensibel.
