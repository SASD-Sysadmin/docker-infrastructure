# ADR 0003: Keep Milestone 1 workload-free but catalog-compilable

- Status: Accepted
- Date: 2026-07-09

## Context

A completely empty scaffold cannot prove classification, module loading, or unit-test wiring. Productive package or service policy is intentionally deferred.

## Decision

Classify all nodes with `role::baseline`, which includes an empty `profile::baseline`. Test that the class chain compiles and that only class/stage resources exist.

## Consequences

Milestone 1 is executable and testable while incapable of changing application state. Later changes can be measured against a known safe catalog.
