# Vorbereitung auf Puppet Server

Milestone 1 installiert noch keinen Puppet Server, bereitet das Control Repository aber darauf vor:

- `environment.conf` bindet `$basemodulepath` für Systemmodule ein;
- eigener Code liegt unter `site-modules`;
- generierte Abhängigkeiten gehören nach `modules` und werden ausschließlich im `Puppetfile` deklariert;
- `config_version` schreibt den lokalen Git-Stand oder einen sichtbaren VERSION-Fallback in Kataloge und Reports;
- Hiera ist umgebungslokal;
- das Hauptmanifest besitzt eine deterministische Default-Klassifizierung;
- CI kann fehlerhaften Code vor einem r10k-Deployment abweisen.

Der spätere Server-Stepstone muss dennoch Installation, Dimensionierung, CA/Zertifikate, r10k-Zugriff und Branch-Mapping, Environment-Timeout, Backups, Monitoring und Wiederherstellungstests festlegen.
