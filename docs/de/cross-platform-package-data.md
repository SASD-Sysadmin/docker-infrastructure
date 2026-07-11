# Plattformabhängige Paketdaten

Die Profile beschreiben die Absicht; Hiera bildet sie auf Distributionspakete ab:

```text
data/common.yaml                 leere Paketdefaults und gemeinsame Einstellungen
data/os/family/Debian.yaml       Namen für Debian 12/13 und Ubuntu 24.04
data/os/family/RedHat.yaml       Namen für AlmaLinux 9 und Rocky Linux 9
```

Jede Familiendatei besitzt vollständige, sortierte und innerhalb der Datei überschneidungsfreie Paketgruppen. EPEL wird nicht aktiviert; deshalb werden Pakete wie `htop` oder `shellcheck` nicht erzwungen, wenn sie nicht aus den konfigurierten EL9-Basisquellen verfügbar sind.
