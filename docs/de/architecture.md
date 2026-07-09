# Architektur

Das Repository unterstützt lokalen `puppet apply`-Betrieb mit `role::baseline`
und zentrale Katalogkompilierung für zertifikatsauthentifizierte Agents.

```text
main -> test -> production -> r10k -> Puppet Server -> Agents
                                      |            |
                                      |            + kompakte JSON-Reports
                                      + optional PuppetDB/PostgreSQL
```

`site.pp` klassifiziert über eine Allowlist, Rollen kombinieren Profile, Profile
verwalten technischen Sollzustand, `sasd_reporting` liefert den datensparsamen
Reportprozessor, Hiera enthält Werte und Skripte führen explizite Bootstrap-,
Promotion-, CA-, Backup- und Betriebsaktionen aus. CA, Zugangsdaten, deployte
Environments, Datenbank und Backups gehören niemals ins Repository.
