# AlmaLinux-9- und Rocky-Linux-9-Agents

## Voraussetzungen

- x86_64 oder aarch64;
- DNS sowie TCP/8140 zum Puppet Server;
- Puppet-Forge-API-Key mit Puppet-Core-Paketzugriff;
- root-eigene Key-Datei ohne Gruppen-/Weltrechte;
- geprüfter Certname und Knotendatei.

```bash
sudo install -o root -g root -m 0600 /dev/null /root/puppet-core-api-key
sudoedit /root/puppet-core-api-key
```

## Installation

```bash
sudo ./scripts/bootstrap-central-agent.sh   --server puppet.example.test   --certname rocky01.example.test   --environment production   --package-source puppet-core   --api-key-file /root/puppet-core-api-key
```

Das Skript installiert das EL9-Release-RPM, schützt die Repository-Datei mit Modus `0600`, installiert `puppet-agent`, deaktiviert periodische Läufe und sendet die CSR. Danach wird nur der exakt geprüfte Certname signiert und der Agent zunächst im No-op aktiviert.
