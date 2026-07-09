# Sicherheit

## Schutzmaßnahmen in Milestone 3

- No-op bleibt Standard für Standalone-Bootstrap, Update und lokalen Lauf;
- `--apply` sowie alle CA-verändernden Operationen benötigen root;
- künstliche Fakten dürfen nicht zusammen mit `--apply` verwendet werden;
- nicht unterstützte Plattformen brechen vor Installation oder Durchsetzung ab;
- der aktive Katalog bleibt auf Paket- und Dateiressourcen begrenzt;
- Firewall, Benutzer, Dienste, Mounts, Zeitpläne, Cron, Hosts und beliebige `exec`-Ressourcen bleiben ausgeschlossen;
- Autosigning ist auf dem Puppet Server ausdrücklich deaktiviert;
- eine CSR wird nur nach Prüfung eines exakten Certname signiert;
- Zertifikatsbereinigung benötigt einen identischen Bestätigungswert;
- eine vorhandene CA wird weder neu erzeugt noch umbenannt oder still um weitere DNS-Namen verändert;
- der Agentdienst bleibt bis zur Zertifikatsfreigabe und einem expliziten Aktivierungstest deaktiviert;
- r10k deployed genau ein gleichnamiges Branch/Environment unter einer Sperre und prüft danach die Puppet-Manifeste;
- die Produktions-Deployment-Unit ist rein manuell und besitzt weder Timer noch Webhook;
- Puppet-Core-API-Schlüssel müssen in einer root-eigenen, für Gruppe und Welt unzugänglichen Datei liegen;
- mögliche Schlüssel- und Zertifikatsdateien werden durch die Repository-Prüfung abgewiesen;
- Secrets gehören niemals in Git, Hiera, Beispiele, Fixtures oder CI-Ausgaben.

## Prüfung privilegierter Änderungen

Änderungen unter `scripts/`, `manifests/`, `site-modules/`, `data/`,
`Puppetfile` und `systemd/` sind wie privilegierter Code zu behandeln. Exakte
Diffs prüfen, die vollständige Testsuite ausführen, zuerst in einem Lab mit
Snapshot testen und No-op-Ausgaben beim Change-Nachweis aufbewahren. Die
Promotion von `main` nach `production` ist eine Sicherheitsentscheidung.

## Paketvertrauen

Standardmäßig werden nur die bereits konfigurierten Distributionsquellen
verwendet. Die optionale Puppet-Core-Quelle benötigt eine vom Betreiber
bereitgestellte API-Schlüsseldatei sowie ein HTTPS-Release-Paket. Vor dem
Produktivbetrieb sind Paketquelle, Supporterwartung und Updatepolitik zu
dokumentieren.

## Zertifikatsidentität

Der Puppet-Certname ist eine dauerhafte Maschinenidentität. Vor dem Signieren
müssen DNS, Hostname, Eigentümerschaft des Systems und die ausstehende CSR
geprüft werden. Private Schlüssel oder komplette SSL-Verzeichnisse dürfen nie
von einem anderen Knoten kopiert werden. Bei Neuaufbau oder Umbenennung ist das
dokumentierte Clean-/Re-Enrolment-Verfahren zu verwenden.
