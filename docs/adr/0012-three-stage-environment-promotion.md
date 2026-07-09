# ADR 0012: Three-stage environment promotion

## Status
Accepted in Milestone 4.

## Decision
Use `main -> test -> production` with matching r10k environment names and fast-forward-only promotion.

## Consequences
Production cannot receive code directly from main. Rollbacks are new descendant commits and pass through test. Force-push is outside the supported process.
