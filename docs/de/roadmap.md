# Roadmap

Abgeschlossen sind Grundgerüst, lokaler Baseline-Betrieb und zentraler Puppet Server mit r10k und manueller CA-Anbindung.

Mögliche nächste Stepstones:

1. Serverhärtung und Selbstverwaltung;
2. kleine Anwendungs-Installationsprofile;
3. explizite Rollen für Server, Workstation und Entwicklung;
4. Dienstekonsistenz mit Tests und Rollback;
5. PuppetDB/PostgreSQL prüfen;
6. verschlüsselte Hiera-Daten nur bei echtem Secret-Bedarf;
7. Test-Environments und kontrollierte Deployment-Automatisierung;
8. ausgewählte Red-Hat-Familie als Agenten.

Puppet bleibt für Sollzustand zuständig, nicht für Incident-Reparaturen.
