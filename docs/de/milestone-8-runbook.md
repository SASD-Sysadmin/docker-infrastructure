# Milestone-8-Runbook

## Täglich
1. Health- und Monitoring-Timer prüfen.
2. Aggregierte Werte prüfen; Details nur aus dem geschützten Compliance-JSON lesen.
3. Kritische Zustände vor jeder Promotion beheben.

## Vor Release oder Upgrade
1. Vollständige Validierung.
2. Audit-Bundle erzeugen und prüfen.
3. Control-Plane-Backup erzeugen und prüfen.
4. Upgrade-Preflight ausführen.
5. Über `main`, `test`, `production` ausrollen.

## Vierteljährliche Recovery-Probe
1. Neuestes geprüftes Offline-Backup wählen.
2. Readiness prüfen.
3. In neues isoliertes Verzeichnis extrahieren.
4. CA, Environments, PuppetDB-Dump und eyaml-Schlüsselverwahrung prüfen.
5. Ergebnis dokumentieren; Live-Pfade nicht verändern.
