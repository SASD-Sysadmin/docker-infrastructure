# ADR 0043: .NET workloads and user state remain out of scope

- Status: accepted
- Date: 2026-07-10

## Decision

Do not manage `dotnet workload`, global tools, NuGet credentials/sources, `global.json`, project templates, IDEs, user caches, or application services. Those belong to project repositories or a separately reviewed service deployment profile.
