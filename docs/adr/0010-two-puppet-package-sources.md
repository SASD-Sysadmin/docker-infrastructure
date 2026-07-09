# ADR 0010: Distribution and authenticated Puppet Core package sources

- Status: Accepted
- Date: 2026-07-09

## Decision

Default lab bootstraps to distribution packages. Also support authenticated Puppet Core Apt repositories through a root-only API-key file.

## Rationale

Distribution packages allow credential-free reproduction. Current Puppet Core repositories provide maintained platform releases but require accepted terms, MFA, and an API key.

## Consequences

Operators must choose deliberately and document deployed versions. Credentials never enter Git or command-line arguments.
