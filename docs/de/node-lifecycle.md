# Knoten-Lebenszyklus

Jede zentral verwaltete Datei `data/nodes/<certname>.yaml` enthält mindestens
Rolle, Lebenszyklus und verantwortliche Stelle.

- `active`: Rolle wird normal angewendet; Agent läuft regelmäßig.
- `maintenance`: Grund und Ticket sowie Ablaufzeit in UTC sind Pflicht. Der
  aktuelle Lauf schreibt den Zustand und stoppt/deaktiviert danach den Agent.
- `retired`: `site.pp` verweigert die Katalogerstellung bis zur geregelten
  Außerbetriebnahme.

Beispiele:

```bash
ruby scripts/manage-node.rb register --certname node01.example.net \
  --role server --owner operations
ruby scripts/manage-node.rb maintenance --certname node01.example.net \
  --reason 'Kernel-Wartung' --ticket CHG-42 \
  --expires-at 2026-07-10T18:00:00Z
ruby scripts/manage-node.rb activate --certname node01.example.net
ruby scripts/manage-node.rb retire --certname node01.example.net \
  --reason 'System entfernt' --ticket CHG-51
```
