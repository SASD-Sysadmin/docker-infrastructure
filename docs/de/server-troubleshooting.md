# Fehlerbehebung am Puppet Server

Bei Startproblemen:

```bash
sudo systemctl status puppetserver
sudo journalctl -u puppetserver -b --no-pager
sudo puppet config print certname
```

JVM-Speicher, Konfigurationsrechte, DNS-Namen und Port 8140 prüfen.

Bei ausstehendem Zertifikat auf dem Server `list-certificates.sh` und auf dem Agent `puppet ssl bootstrap --waitforcert 0` verwenden. Autosigning ist keine Fehlerbehebung.

Bei r10k-Problemen Git-Erreichbarkeit, Branch `production`, Modulzugriff, Speicherplatz, Rechte und aktive Sperren prüfen. Deployed Code niemals direkt verändern; Fehler im Repository korrigieren und neu deployen.
