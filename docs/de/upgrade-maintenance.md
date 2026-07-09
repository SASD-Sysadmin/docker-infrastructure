# Upgrade- und Wartungsvorprüfung

`upgrade-preflight.sh` verändert nichts. Es prüft Puppet-Agent-/Server-Major, bevorzugtes Java 17, freien Speicher und Backup-Alter gegen `config/operations-policy.json`. Ein erfolgreicher Lauf erlaubt nur die weitere Planung. Änderungen gehen weiterhin über `main → test → production`.
