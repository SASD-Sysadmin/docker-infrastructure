# ADR 0008: Production branch maps to production environment

- Status: Accepted
- Date: 2026-07-09

## Decision

Maintain an explicit `production` Git branch. r10k maps it directly to the Puppet `production` directory environment. `main` remains the integration branch.

## Rationale

r10k naturally maps branch names to environment names. A separate production branch creates a visible promotion boundary and avoids custom branch-renaming deployment logic.

## Consequences

Production promotion is an explicit fast-forward/approved merge plus manual r10k deployment. Both branches must pass CI and branch protection should prevent uncontrolled force-pushes.
