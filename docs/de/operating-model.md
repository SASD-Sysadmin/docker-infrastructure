# Betriebsmodell

`main` enthält geprüfte Entwicklung, `production` den ausrollbaren Sollzustand. Ein Administrator promoted einen getesteten Commit, startet r10k manuell und prüft anschließend einen Agent-No-op. Agenten erzwingen erst nach Zertifikatsfreigabe und Aktivierung.

Lokaler und zentraler Apply dürfen auf demselben Rechner nicht parallel laufen. Der Puppet Server selbst wird in Milestone 3 bewusst per Bootstrap-Skript konfiguriert; Selbstverwaltung folgt separat.
