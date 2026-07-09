# Zentraler Betriebsmodus

`main` ist der Integrationsbranch, `test` die Vorproduktion und `production` der
freigegebene Stand. Der Puppet Server kompiliert Kataloge und betreibt die CA;
Agents wenden ausschließlich ihre freigegebenen Kataloge an.

Tägliche Prüfungen:

```bash
sudo ./scripts/status-server.sh
sudo ./scripts/server-health.sh
sudo ./scripts/report-status.py
sudo ./scripts/list-certificates.sh
```

Wöchentlich werden Backup, Zertifikate, fehlgeschlagene oder veraltete Reports,
Branchstände und Plattenbelegung geprüft. Dauerhafte Konsistenz gehört nach
Puppet; Diagnose und temporäre Reparatur bleiben bei Ansible/Admin-Toolkit.
