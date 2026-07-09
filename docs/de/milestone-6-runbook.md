# Milestone-6-Runbook

## Regelmäßige Prüfungen

```bash
ruby scripts/check_node_data.rb
ruby scripts/node-inventory.rb
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
python3 scripts/check_secret_policy.py
```

## Neuer Knoten

Mit `manage-node.rb register` anlegen, prüfen, committen und promovieren; danach
das bestehende zentrale Enrollment mit manueller Zertifikatsfreigabe verwenden.

## Wartung

Mit `manage-node.rb maintenance` setzen, promovieren und Agent einmal manuell
anwenden. Nach der Arbeit mit `activate` zurücksetzen und erneut manuell
anwenden.

## Außerbetriebnahme

Auf `retired` setzen, promovieren, anschließend den exakt bestätigten
Decommission-Ablauf auf dem CA-Host ausführen und den archivierten Datensatz
committen.
