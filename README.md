# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

> **Status:** Milestone 10 complete (`0.10.0`). A reviewed .NET 10 LTS command-line SDK profile now complements the Java and PHP development baselines.

A conservative Puppet control repository for installing reviewed applications and maintaining consistent package, file, service, lifecycle, and operational state across SASD systems.

## Supported platforms

| Platform | Central agent | Standalone local | .NET 10 package source |
|---|---:|---:|---|
| Debian 12 | yes | yes | explicit Microsoft repository |
| Debian 13 | yes | yes | explicit Microsoft repository |
| Ubuntu 24.04 | yes | yes | built-in Ubuntu feed |
| AlmaLinux 9 | yes | no | distribution AppStream |
| Rocky Linux 9 | yes | no | distribution AppStream |

Puppet Server remains supported on Debian 12 and Ubuntu 24.04 only. The .NET profile is currently restricted to x86_64/amd64.

## Milestone 10 highlights

- .NET 10 LTS SDK package baseline;
- explicit `dotnet_development` role;
- guarded Debian Microsoft-repository bootstrap;
- distribution-feed-only operation on Ubuntu 24.04 and EL9;
- .NET major-version validation in `sasd-sdk-status`;
- no workloads, global tools, NuGet sources, IDEs, services, or user state.

## First commands

```bash
./scripts/validate.sh
python3 scripts/check_dotnet_repository_catalog.py
ruby scripts/node-inventory.rb
```

## Documentation

- [Milestone 10](docs/en/milestone-10.md)
- [Milestone 10 runbook](docs/en/milestone-10-runbook.md)
- [.NET SDK](docs/en/dotnet-sdk.md)
- [.NET repository trust](docs/en/dotnet-repository-trust.md)
- [Architecture](docs/en/architecture.md)
- [Security](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)

## License

MIT — see [LICENSE](LICENSE).
