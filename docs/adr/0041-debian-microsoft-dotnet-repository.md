# ADR 0041: Debian .NET uses the Microsoft package repository

- Status: accepted
- Date: 2026-07-10

## Decision

Debian 12 and 13 use Microsoft's official `packages-microsoft-prod` configuration package. Repository setup is an explicit operator step, separate from Puppet catalog compilation. The bootstrap requires HTTPS, validates Debian package metadata, and never uses `apt-key` or a curl-to-shell installer.

## Consequences

The external repository is a documented exception to the normal distribution-only SDK rule. Operators must review repository policy before assigning the .NET role.
