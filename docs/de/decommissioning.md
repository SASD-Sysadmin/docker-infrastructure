# Außerbetriebnahme eines Knotens

Zuerst Workload und Daten nach dem jeweiligen Service-Runbook entfernen. Danach
den Knoten mit Grund und Ticket auf `retired` setzen und promovieren.

Trockenlauf auf dem CA-Host:

```bash
./scripts/decommission-node.sh --certname node01.example.net \
  --confirm node01.example.net --clean-ca
```

Ausführung:

```bash
./scripts/decommission-node.sh --certname node01.example.net \
  --confirm node01.example.net --clean-ca --apply
```

Das Skript bereinigt genau die bestätigte Zertifikatsidentität, verschiebt die
Knotendatei nach `data/retired`, ergänzt den UTC-Zeitpunkt und löscht den
kompakten Report. PuppetDB-Historie wird bewusst nicht automatisch gelöscht.
