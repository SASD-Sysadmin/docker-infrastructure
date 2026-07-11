# ADR 0005: Use distribution Puppet packages for Milestone 2

- Status: Accepted
- Date: 2026-07-09

## Context

Current Puppet Core repositories require authenticated access. Milestone 2 must
bootstrap a credential-free local lab on Debian 12/13 and Ubuntu 24.04.

## Decision

Install `puppet-agent` and r10k from the operating-system repositories. Support
Puppet 7.23 through Puppet 8.x in code and CI.

## Consequences

Versions differ by distribution, but no secret is embedded and the bootstrap is
reproducible. The production Puppet Server milestone must revisit vendor support,
security update lifetime, licensing, and package provenance.
