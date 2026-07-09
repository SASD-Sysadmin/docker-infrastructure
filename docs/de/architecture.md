# Architektur

Das Repository unterstützt zwei Betriebsarten mit demselben Katalogmodell: lokalen `puppet apply`-Betrieb und zentrale Katalogkompilierung durch Puppet Server. r10k deployed den Branch `production` in das gleichnamige Environment.

Schichten: `site.pp` klassifiziert über eine Allowlist, Rollen komponieren Profile, Profile verwalten technische Ressourcen, Hiera enthält Werte, Puppetfile-Abhängigkeiten landen erzeugt in `modules`, und Skripte führen explizite Bootstrap-/Control-Plane-Aktionen aus. CA, Zugangsdaten, Caches und Reports gehören niemals ins Repository.
