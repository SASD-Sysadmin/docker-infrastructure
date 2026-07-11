# Milestone-11-Runbook

1. Puppet-Control-Plane sichern und Archiv verifizieren.
2. `hiera-eyaml` 5.0.1 und PKCS7-Paar auf jedem Compiler prüfen.
3. Austauschbares Lesekennwort mit dem öffentlichen Schlüssel verschlüsseln.
4. Normale Node-Daten und passende `secrets/nodes/<certname>.eyaml` anlegen.
5. Validierung, RSpec und isolierten Roundtrip ausführen.
6. `main -> test` promovieren und Zielknoten im No-op prüfen.
7. Redigierte Reports und Dateimodus `0600` kontrollieren.
8. Nach `production` promovieren und ersten Agentlauf überwachen.
9. Vor Löschen/Rotation des externen Kontos die Rolle entfernen.
10. Compiler-Caches, Backups und private Schlüssel rootgeschützt halten.
