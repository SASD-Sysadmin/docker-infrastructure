# Milestone-4-Runbook

1. `main`, `test`, `production` und Tag `v0.4.0` veröffentlichen.
2. `test` deployen und No-op sowie Idempotenz auf Test-Agents prüfen.
3. Erst danach nach `production` promovieren und deployen.
4. Puppet-Server-Node als `puppet_server` klassifizieren.
5. Serverkatalog erst No-op, dann Apply; Health-Timer prüfen.
6. `sasd_json` aktivieren und einen Testreport kontrollieren.
7. signierte Agents als `managed_agent` klassifizieren und Taktung setzen.
8. Control-Plane-Backup erzeugen und verifizieren.
9. PuppetDB nur nach separatem Preflight optional installieren.
10. Versionen, Tests, Freigaben und Backup-Ort im Change dokumentieren.
