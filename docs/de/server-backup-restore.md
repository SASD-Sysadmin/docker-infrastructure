# Server-Backup und Wiederherstellung

Mindestens zu sichern sind:

- das aktive `cadir` aus `puppet config print cadir` sowie das aktive `ssldir` aus `puppet config print ssldir` mit CA- und Serverschlüsseln;
- Puppet-, Puppet-Server- und r10k-Konfiguration;
- `/etc/default/puppetserver`;
- `/var/lib/sasd-puppet/deployments`;
- Paket-/Versionsinventar und Git-Remote.

Die Environments und der r10k-Cache sind aus Git reproduzierbar. Das Backup muss verschlüsselt und offline abgelegt sowie auf einer isolierten VM getestet werden.

Bei der Wiederherstellung Certname und DNS-Namen beibehalten, Rechte exakt restaurieren, den Server zunächst isoliert prüfen, `production` neu deployen und einen Agent als No-op testen. Eine alte CA darf nicht stückweise über eine neu erzeugte CA kopiert werden.
