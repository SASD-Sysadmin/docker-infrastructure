# Kompaktes SASD-Reporting

`sasd_json` erzeugt pro Certname genau eine atomar aktualisierte JSON-Zusammenfassung
unter `/var/lib/sasd-puppet/reports`. Enthalten sind Status, Environment,
Konfigurationsversion, UUID, Zeitstempel, No-op und aggregierte Events. Facts,
Ressourcenwerte, Logs, Diffs und Secrets werden nicht gespeichert.

```bash
sudo ./scripts/configure-reporting.sh
sudo ./scripts/report-status.py
sudo ./scripts/report-status.py --json
```

Die Zusammenfassungen ersetzen weder PuppetDB noch Puppets vollständige Reports.
