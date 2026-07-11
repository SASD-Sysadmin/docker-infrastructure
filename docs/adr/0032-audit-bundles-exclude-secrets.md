# ADR 0032: Audit bundles exclude secrets

## Status
Accepted in 0.8.0.

## Decision
Audit evidence contains configuration contracts, inventory, compact compliance, health, component versions, and public certificate inventory only. Private keys, eyaml plaintext, credentials, full reports, and package-repository keys are forbidden.
