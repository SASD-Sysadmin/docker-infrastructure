# ADR 0016: Control-plane backups are sensitive identity artifacts

## Status
Accepted in Milestone 4.

## Decision
Back up CA/configuration/code state and optional PostgreSQL data into a root-only archive with external and internal checksums.

## Consequences
The backup can restore identity but contains private keys. It must be encrypted and stored independently; it is never committed to Git.
