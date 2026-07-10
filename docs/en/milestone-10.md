# Milestone 10 — .NET 10 LTS SDK profile

Milestone 10 adds a conservative .NET 10 LTS command-line development baseline. The package is `dotnet-sdk-10.0`; no workloads, global tools, IDEs, services, project files, NuGet sources, or user configuration are managed.

## Platform trust model

| Platform | Package source | Repository change |
|---|---|---|
| Debian 12/13 amd64 | Microsoft Linux package repository | explicit `setup-dotnet-repository.sh --apply` |
| Ubuntu 24.04 amd64 | built-in Ubuntu feed | none |
| AlmaLinux/Rocky 9 x86_64 | distribution AppStream | none |

Arm64 is intentionally deferred until package-feed and integration validation are complete.

## Delivered components

- `profile::dotnet_sdk`;
- `role::dotnet_development`;
- `.NET` support in `sasd-sdk-status`;
- repository catalog and guarded Debian setup script;
- RSpec, smoke, container, and CI tests;
- bilingual runbook and trust documentation.

## Safety boundary

The Puppet catalog manages only the SDK package and a non-secret marker. Repository setup is separate, explicit, and dry-run by default.
