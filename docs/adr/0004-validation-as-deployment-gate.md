# ADR 0004: Use one validation command as the deployment gate

- Status: Accepted
- Date: 2026-07-09

## Context

Different local and CI commands create gaps and false confidence.

## Decision

Use `bundle exec rake` as the complete acceptance command locally and in GitHub Actions. It runs static validation, RSpec-Puppet, and a no-op catalog smoke test.

## Consequences

The gate is reproducible and easy to document. Ruby development dependencies must remain maintained and pinned.
