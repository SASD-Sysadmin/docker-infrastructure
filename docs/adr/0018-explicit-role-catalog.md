# ADR 0018: Explicit role catalog

## Decision
The site manifest keeps a hardcoded allowlist. A JSON catalog mirrors roles for validation and documentation but never drives dynamic class inclusion.

## Consequences
Adding a role requires code, catalog, tests, and documentation to change together. Data cannot select arbitrary Puppet classes.
