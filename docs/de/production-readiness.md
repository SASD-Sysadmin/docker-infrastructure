# Produktionsbereitschaft

Vor der Produktion müssen Plattform und Paketverfügbarkeit dokumentiert, Paket- und Rollenregeln bestanden, Puppet-7/8-Tests erfolgreich, Containerläufe idempotent und ein repräsentativer signierter Knoten im No-op geprüft sein. Danach folgen Test-Apply, gesunde Reports, aktueller Backup-Nachweis, bekannter Rollback-Zielstand und die ausgefüllte `RELEASE_CHECKLIST.md`.

Eine erfolgreiche Syntaxprüfung allein ist keine Produktionsfreigabe. Pakettransaktionen können weiterhin an Mirror, Sperren, Speicherplatz, gehaltenen Paketen oder lokaler Repository-Policy scheitern.
