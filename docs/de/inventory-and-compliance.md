# Inventar und Flotten-Compliance

```bash
ruby scripts/check_node_data.rb
ruby scripts/node-inventory.rb
ruby scripts/node-inventory.rb --format json --include-retired
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
```

Die Auswertung erkennt unter anderem fehlende oder veraltete Reports,
fehlgeschlagene Läufe, gültige Wartung, abgelaufene Wartungsfenster und noch
nicht vollständig außer Betrieb genommene Knoten.

Exitcode `0` bedeutet unauffällig, `2` Warnung und `3` Fehlerzustand.
