# Milestone-7-Runbook

1. Repository mit `./scripts/validate.sh --strict` prüfen.
2. Knoten und Rolle über `manage-node.rb register` erfassen.
3. Root-geschützte Puppet-Core-API-Key-Datei auf dem EL9-Agent anlegen.
4. Agent-Bootstrap zuerst mit `--dry-run` ausführen.
5. Reale Installation mit `--package-source puppet-core` starten.
6. CSR auf dem Puppet Server kontrollieren und nur den exakten Certname signieren.
7. Agent zunächst mit `activate-central-agent.sh --noop --enable-service` testen.
8. Nach Prüfung mit `--apply` anwenden.
9. Baseline-, Plattform-, Lifecycle- und Anwendungsmarkierungen sowie Report prüfen.
10. Aufnahme und Key-Verantwortung im Betriebsvorgang dokumentieren.
