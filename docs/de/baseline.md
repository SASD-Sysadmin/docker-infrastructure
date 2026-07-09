# Baseline

Milestone 5 behält die konservative gemeinsame Basis und ergänzt optionale
Anwendungsprofile. `/etc/sasd/puppet-baseline.conf` enthält Version `0.5.0`,
Plattform, vertrauenswürdigen Certname und Betriebsmodus. Zentrale Rollen schreiben
zusätzlich `/etc/sasd/applications.d/assigned.conf` als nicht geheimen Nachweis
der vorgesehenen Rolle und Profile.

Administrations-, Entwicklungs- und Container-Pakete werden nur durch Rollen
installiert, die das jeweilige Profil ausdrücklich zusammensetzen. Der Agentdienst
wird ausschließlich nach remote authentifizierter Zertifikatsanmeldung verwaltet.
