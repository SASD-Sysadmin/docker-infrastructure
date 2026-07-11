# ADR 0040: .NET 10 LTS is the managed .NET baseline

- Status: accepted
- Date: 2026-07-10

## Decision

Manage `dotnet-sdk-10.0` as the only .NET SDK baseline in Milestone 10. .NET 10 is an LTS release supported through 14 November 2028. The profile records the expected major version and rejects unsupported platforms or architectures.

## Consequences

Feature-band updates arrive through the selected package feed. The repository does not pin patch versions or install side-by-side SDK majors.
