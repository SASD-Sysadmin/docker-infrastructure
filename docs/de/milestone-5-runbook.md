# Milestone-5-Runbook

## Entwicklungsrechner hinzufügen

1. Agent registrieren und Zertifikat manuell freigeben.
2. `data/nodes/<certname>.yaml` mit `sasd::role: development` anlegen.
3. Paket-, Rollen- und Gesamtprüfung ausführen.
4. Feature-Branch nach bestandener CI in `main` übernehmen.
5. `main -> test` promovieren und Test deployen.
6. Auf einem repräsentativen Knoten `puppet agent -t --noop --environment test` ausführen.
7. Test anwenden und einen zweiten änderungsfreien Lauf bestätigen.
8. `test -> production` promovieren und manuell deployen.
9. Reportstatus und `/etc/sasd/applications.d/assigned.conf` prüfen.

Pakete werden genau einem Profil zugeordnet. Gemeinsamer Bedarf wird durch Rollenkomposition gelöst, nicht durch Duplikate in mehreren Paketgruppen.
