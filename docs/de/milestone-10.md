# Milestone 10 – .NET-10-LTS-SDK-Profil

Milestone 10 ergänzt eine konservative Kommandozeilen-Baseline für .NET 10 LTS. Verwaltet wird `dotnet-sdk-10.0`; Workloads, globale Tools, IDEs, Dienste, Projektdateien, NuGet-Quellen und Benutzerkonfiguration bleiben außerhalb des Umfangs.

## Vertrauensmodell

| Plattform | Paketquelle | Repository-Änderung |
|---|---|---|
| Debian 12/13 amd64 | Microsoft Linux Package Repository | explizit mit `setup-dotnet-repository.sh --apply` |
| Ubuntu 24.04 amd64 | integrierter Ubuntu-Feed | keine |
| AlmaLinux/Rocky 9 x86_64 | Distributions-AppStream | keine |

Arm64 bleibt zurückgestellt, bis Paketquellen und Integration separat validiert wurden.

## Gelieferte Bestandteile

- `profile::dotnet_sdk`;
- `role::dotnet_development`;
- .NET-Prüfung in `sasd-sdk-status`;
- Repository-Katalog und abgesichertes Debian-Setup;
- RSpec-, Smoke-, Container- und CI-Tests;
- zweisprachiges Runbook und Vertrauensdokumentation.
