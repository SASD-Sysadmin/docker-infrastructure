# Sicherheit

## Schutzmaßnahmen in Milestone 4

- No-op bleibt Standard bei lokalem Bootstrap/Update und PuppetDB-Planung;
- Apply und CA-Änderungen benötigen eine ausdrückliche Aktion;
- nicht unterstützte Plattformen werden vor Änderungen abgewiesen;
- der Katalog erlaubt Paket, Datei, Dienst und genau einen Refresh-only-Daemon-Reload;
- keine Benutzer, Gruppen, Firewall, Mounts, Cronjobs oder beliebigen Befehle;
- Autosigning ist aus, Zertifikatsaktionen betreffen genau einen Certname;
- vorhandene CA-Identität wird weder neu erzeugt noch still umbenannt;
- Agentdienste starten erst nach Zertifikatsfreigabe und Aktivierungstest;
- Manifeste schreiben keine Certname-, CA- oder Schlüsselwerte um;
- Promotion `main -> test -> production` ist ausschließlich Fast-Forward;
- Production-Deployment bleibt manuell und authentifiziert;
- kompakte Reports enthalten keine Facts, Logs, Diffs oder Ressourcenwerte;
- Backups sind root-only, checksummiert und wegen privater Schlüssel zu verschlüsseln;
- PuppetDB ist opt-in und benötigt Server 8+, Pakete, Monitoring und Backup.

Änderungen an Skripten, Manifesten, Site-Modulen, Hiera, Puppetfile, Workflows
und systemd gelten als privilegierter Code und benötigen vollständige Prüfung.
