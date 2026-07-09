# Sicherheit

Milestone 2 nutzt bei Bootstrap, Update und lokalem Lauf standardmäßig No-op.
`--apply` benötigt root und darf nicht mit künstlichen Fakten kombiniert werden.
Nicht unterstützte Plattformen brechen vor dem Anwenden ab. Das aktive Profil
ist auf Paket- und Dateiressourcen begrenzt und verwaltet keine Ports, Dienste,
Benutzer, Paketquellen, Firewall-Regeln oder beliebigen Befehle.

Schmutzige Git-Clones und nicht lineare Updates werden verweigert. Der
periodische Puppet-Agentdienst bleibt im Standalone-Betrieb deaktiviert.
Secrets, Zertifikate und private Schlüssel gehören niemals in Git oder Hiera.
Änderungen an Skripten, Manifesten, Daten und Puppetfile sind wie privilegierter
Code zu prüfen und zuerst in einer VM mit Snapshot zu testen.
