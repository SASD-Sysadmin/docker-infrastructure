# ADR 0002: Use roles and profiles with strict ownership boundaries

- Status: Accepted
- Date: 2026-07-09

## Context

The repository needs reusable application implementation without mixing node classification, policy data, and low-level resources.

## Decision

Use `role` and `profile` site modules. Roles represent node purpose and compose profiles. Profiles implement technical capabilities and may wrap external modules. `site.pp` performs classification only.

## Consequences

The structure is explicit and server-ready. It adds discipline: maintainers must resist declaring resources directly in roles or `site.pp`.
