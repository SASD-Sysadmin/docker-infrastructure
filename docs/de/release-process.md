# Release-Prozess

1. Geprüfte Änderungen nach erfolgreicher CI in `main` integrieren.
2. Version, Modulmetadaten, Marker, Changelog, Tests und beide Sprachen gemeinsam ändern.
3. `bundle exec rake` und passende Integrationstests ausführen.
4. Den freigegebenen Main-Commit annotiert taggen.
5. `main` mit `promote-environment.sh` nach `test` promovieren.
6. `test` deployen und No-op, Apply sowie Idempotenz prüfen.
7. `test` anschließend nach `production` promovieren.
8. Branches/Tag pushen und Production manuell mit r10k deployen.
9. Health, Reports, Agentdienst und ein frisches verifiziertes Backup prüfen.

`test` und `production` werden nie force-gepusht; Main geht nie direkt nach Production.
