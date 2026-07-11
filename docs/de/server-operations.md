# Puppet-Server-Betrieb

Tägliche bzw. regelmäßige Prüfungen:

```bash
sudo ./scripts/status-server.sh
sudo systemctl is-active puppetserver
sudo ./scripts/list-certificates.sh
sudo journalctl -u puppetserver --since today
```

Freigegebenen Code manuell deployen:

```bash
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Danach zunächst einen repräsentativen Agent als No-op testen. Ein Server-Neustart ist für ein normales r10k-Deployment nicht erforderlich.

Vor Paketupdates CA und Konfiguration sichern, Versionskompatibilität prüfen, Wartungsfenster nutzen und anschließend Server, CA, Deployment und Agent-No-op testen. PuppetDB ist in Milestone 4 optional und wird nur bei begründetem Bedarf aktiviert.
