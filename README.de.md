# puppet-software-baseline

[English documentation](README.md)

> **Status:** Milestone 10 abgeschlossen (`0.10.0`). Ein geprüftes .NET-10-LTS-Kommandozeilenprofil ergänzt nun die Java- und PHP-Entwicklungsbaselines.

Konservatives Puppet-Control-Repository zur Installation geprüfter Anwendungen und zur Sicherstellung konsistenter Paket-, Datei-, Dienst-, Lifecycle- und Betriebszustände auf SASD-Systemen.

## Milestone 10

- .NET-10-LTS-SDK-Paketbaseline;
- explizite Rolle `dotnet_development`;
- abgesicherte Einrichtung des Microsoft-Repositories auf Debian;
- ausschließlich Distributionsfeeds auf Ubuntu 24.04 und EL9;
- Prüfung der .NET-Hauptversion in `sasd-sdk-status`;
- keine Workloads, globalen Tools, NuGet-Quellen, IDEs, Dienste oder Benutzerzustände.

Das .NET-Profil ist zunächst auf x86_64/amd64 begrenzt.

## Erste Befehle

```bash
./scripts/validate.sh
python3 scripts/check_dotnet_repository_catalog.py
ruby scripts/node-inventory.rb
```

## Dokumentation

- [Milestone 10](docs/de/milestone-10.md)
- [Milestone-10-Runbook](docs/de/milestone-10-runbook.md)
- [.NET-SDK](docs/de/dotnet-sdk.md)
- [Vertrauen der .NET-Paketquelle](docs/de/dotnet-repository-trust.md)
- [Architektur](docs/de/architecture.md)
- [Sicherheit](docs/de/security.md)
- [Roadmap](docs/de/roadmap.md)

Lizenz: MIT.
