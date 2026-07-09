# Vorbereitung auf Puppet Server

Milestone 2 installiert noch keinen Server, erhält aber den Serververtrag:
Standard-`environment.conf`, Puppetfile für r10k, Klassifizierung in `site.pp`,
Rollen/Profile unter `site-modules`, Hiera 5 mit `trusted.certname` sowie eine
Git-basierte `config_version`.

Vor der Zentralisierung sind Paketquelle und Versionen, Branch-/Environment-
Abbildung, CA- und Zertifikatsbetrieb, Backup, Reporting, Monitoring und der
Nutzen von PuppetDB festzulegen. Agents klonen das Control Repository danach
nicht mehr, sondern erhalten Kataloge vom Server.
