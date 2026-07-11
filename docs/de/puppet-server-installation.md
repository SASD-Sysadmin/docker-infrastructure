# Puppet-Server-Installation

## Unterstützte Serverplattformen

Milestone 3 akzeptiert **Debian 12 amd64** und **Ubuntu 24.04 LTS amd64**. Debian 13 bleibt Agent-Plattform, wird aber für den Server bewusst abgewiesen.

Für ein Labor sind mindestens zwei CPU-Kerne, 2 GiB RAM, 10 GiB freier Speicher, eine feste FQDN, funktionierendes DNS und korrekte Zeit sinnvoll. Der Bootstrap setzt standardmäßig 1 GiB JVM-Heap.

## Vorbereitungen

Der endgültige Server-Certname muss vor der CA-Erzeugung feststehen. Eine spätere Änderung erfordert eine Zertifikatserneuerung.

```bash
hostname -f
getent hosts puppet.example.test
```


> Distributionspakete verwenden teilweise `/etc/puppet`, Puppet-Core-Pakete üblicherweise `/etc/puppetlabs`. Die Skripte ermitteln `confdir`, `codedir`, `ssldir`, `cadir` und `environmentpath` dynamisch.

## Paketquellen

Ohne Zugangsdaten werden Distributionspakete verwendet:

```bash
sudo ./scripts/bootstrap-server.sh --server-name puppet.example.test
```

Für aktuelle Puppet-Core-Pakete wird ein root-lesbarer API-Key benötigt:

```bash
sudo install -m 0600 /dev/null /root/puppet-core-api-key
sudoedit /root/puppet-core-api-key
sudo ./scripts/bootstrap-server.sh \
  --server-name puppet.example.test \
  --package-source puppet-core \
  --api-key-file /root/puppet-core-api-key
```

Der Key erscheint weder in der Prozessliste noch im Git-Repository.

## Ablauf

Das Skript prüft Plattform und Namen, installiert Pakete, verhindert einen verfrühten ersten Dienststart, schreibt Puppet- und r10k-Konfiguration, stellt den JVM-Heap ein, erhält eine vorhandene CA, erzeugt nur bei einer Neuinstallation eine CA, deployed `production` und startet den Dienst.

## Prüfung

```bash
sudo ./scripts/status-server.sh
sudo systemctl status puppetserver
sudo puppetserver ca list --all
sudo ss -ltnp | grep ':8140'
sudo journalctl -u puppetserver -b
```
