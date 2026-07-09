# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository für geprüfte Anwendungsinstallation, konsistenten Sollzustand, zentralen Puppet-Betrieb, Knoten-Lebenszyklus, Flotten-Compliance und eine optional aktivierbare Grundlage für verschlüsselte Hiera-Daten.

> **Status:** Milestone 6 ist abgeschlossen (`0.6.0`). Neu sind kontrollierte Lebenszykluszustände, ein Git-basiertes Inventar, Compliance-Auswertungen, abgesicherte Außerbetriebnahme und eine bewusst noch nicht automatisch aktivierte Hiera-eyaml-Grundlage.

## Klassifizierung

```yaml
---
sasd::role: development
sasd::lifecycle_state: active
sasd::owner: operations
sasd::description: Kommandozeilen-Entwicklungsrechner
```

Die Datei liegt unter `data/nodes/<certname>.yaml`. Rolle und Lebenszyklus sind in `manifests/site.pp` fest freigegeben.

## Lebenszyklus

- `active`: normale Konvergenz und regelmäßiger Agentdienst;
- `maintenance`: Rolle wird einmal angewendet, der Wartungszustand dokumentiert und der periodische Agent anschließend gestoppt;
- `retired`: keine Katalogerstellung bis zur geregelten Außerbetriebnahme.

```bash
ruby scripts/manage-node.rb register --certname node01.example.net --role server --owner operations
ruby scripts/manage-node.rb maintenance --certname node01.example.net \
  --reason 'Kernel-Wartung' --ticket CHG-42 --expires-at 2026-07-10T18:00:00Z
ruby scripts/manage-node.rb activate --certname node01.example.net
ruby scripts/manage-node.rb retire --certname node01.example.net --reason 'Entfernt' --ticket CHG-51
```

## Inventar und Compliance

```bash
ruby scripts/check_node_data.rb
ruby scripts/node-inventory.rb
ruby scripts/fleet-compliance.rb --reports /var/lib/sasd-puppet/reports
```

## Verschlüsselte Daten

Hiera eyaml bleibt zunächst deaktiviert. Schlüssel werden niemals in Git gespeichert:

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server
./scripts/prepare-hiera-eyaml.sh --output /tmp/hiera.yaml.candidate
python3 scripts/check_secret_policy.py
```

## Dokumentation

- [Milestone 6](docs/de/milestone-6.md)
- [Knoten-Lebenszyklus](docs/de/node-lifecycle.md)
- [Inventar und Compliance](docs/de/inventory-and-compliance.md)
- [Wartungsfenster](docs/de/maintenance-windows.md)
- [Außerbetriebnahme](docs/de/decommissioning.md)
- [Verschlüsselte Hiera-Daten](docs/de/secure-data-foundation.md)
- [Milestone-6-Runbook](docs/de/milestone-6-runbook.md)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
