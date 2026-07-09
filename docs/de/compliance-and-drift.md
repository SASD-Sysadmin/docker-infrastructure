# Compliance und Drift

Puppet-Konvergenz bleibt der primäre Konsistenzmechanismus. Markierungsdateien
sind lokale Nachweise und ersetzen weder Reports noch die Paketdatenbank.

```bash
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
```

Aktive Knoten benötigen einen aktuellen erfolgreichen Report. Wartung wird
separat ausgewiesen und nach Ablauf zur Warnung. Noch im aktiven Inventar
befindliche `retired`-Knoten sowie fehlerhafte Reports sind Fehlerzustände.
