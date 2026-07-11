# Wiederherstellungsprobe

Das Control-Plane-Backup enthält private CA-Daten und muss verschlüsselt sowie offline aufbewahrt werden. `recovery-readiness.py` prüft Struktur und erwartete Inhalte. `rehearse-recovery.sh` extrahiert ausschließlich in ein neues, exakt bestätigtes Laborverzeichnis und schreibt niemals auf Live-Pfade.

```bash
python3 scripts/recovery-readiness.py /secure/backup.tar.gz
sudo ./scripts/rehearse-recovery.sh --archive /secure/backup.tar.gz --target /srv/recovery-lab/puppet-2026Q3 --confirm-isolated /srv/recovery-lab/puppet-2026Q3
```
