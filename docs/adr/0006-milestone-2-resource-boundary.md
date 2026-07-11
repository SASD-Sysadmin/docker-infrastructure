# ADR 0006: Limit Milestone 2 to package and file resources

- Status: Accepted
- Date: 2026-07-09

## Decision

Milestone 2 may declare only package and file workload resources. It installs a
small administration package set and owns one marker below `/etc/sasd`.

## Consequences

The local pipeline proves real enforcement and idempotence with low operational
risk. Services, commands, users, repositories, and removals require separate
reviewed stepstones.
