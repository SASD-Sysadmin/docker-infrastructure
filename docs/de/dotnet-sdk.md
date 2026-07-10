# .NET-10-LTS-SDK

`profile::dotnet_sdk` installiert `dotnet-sdk-10.0` und schreibt `/etc/sasd/toolchains.d/dotnet.conf`. .NET 10 ist die ausgewählte LTS-Baseline und wird voraussichtlich bis zum 14. November 2028 unterstützt.

## Repository-Strategien

Debian benötigt das offizielle Microsoft-Repository-Konfigurationspaket. Ubuntu 24.04 und EL9 verwenden Distributionsfeeds. Das Puppet-Profil validiert die Strategie über Hiera, verändert aber keine Paketquellen.

## Lokale Prüfung

```bash
sudo sasd-sdk-status
sudo sasd-sdk-status --json
dotnet --info
dotnet --list-sdks
```

Das Statuswerkzeug erwartet Hauptversion 10.

## Nicht verwaltet

Workloads, globale Tools, NuGet-Zugangsdaten, `global.json`, IDEs, Projekt-Builds und ASP.NET-Dienste.
