# Milestone 4: Zentraler Regelbetrieb

Milestone 4 überführt den in Milestone 3 aufgebauten Puppet Server in einen
prüfbaren Regelbetrieb. Es entstehen keine Incident- oder Reparatur-Playbooks.
Puppet beschreibt weiterhin dauerhaften Sollzustand durch Manifeste, Rollen,
Profile, Hiera-Daten und Report-Prozessoren.

## Lieferumfang

- Branches und Environments `main`, `test`, `production`;
- ausschließlich Fast-Forward-Promotion `main -> test -> production`;
- `role::managed_agent` und `role::puppet_server`;
- konsistenter nativer Puppet-Agent-Dienst;
- einstündiger Laufabstand mit Splay;
- datensparsamer JSON-Reportprozessor `sasd_json`;
- periodische systemd-Health-Checks;
- Status-, Backup- und Verifikationswerkzeuge;
- optionaler Same-Host-PuppetDB-/PostgreSQL-Bootstrap für Puppet Server 8+;
- Rollback als neuer Commit statt Force-Push;
- erweiterte Tests, CI und zweisprachige Dokumentation.

Der Anwendungsumfang bleibt klein. Neu erlaubt sind Dienstzustände und genau ein
streng begrenzter `systemctl daemon-reload`-Refresh. Benutzer, Firewallregeln,
Mounts, Cronjobs, beliebige Shellbefehle, Autosigning und Secrets bleiben aus.
