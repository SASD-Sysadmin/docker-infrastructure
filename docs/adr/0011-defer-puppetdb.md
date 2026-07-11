# ADR 0011: Defer PuppetDB

- Status: Accepted
- Date: 2026-07-09

## Decision

Do not install PuppetDB in Milestone 3.

## Rationale

The milestone proves central catalog compilation, code deployment, and certificate trust first. PuppetDB adds PostgreSQL, data retention, backup, query, upgrade, and security responsibilities.

## Consequences

Central historical facts, exported resources, and advanced report queries are unavailable until a later stepstone.
