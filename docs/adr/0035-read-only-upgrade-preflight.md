# ADR 0035: Upgrades require a read-only preflight

## Status
Accepted in 0.8.0.

## Decision
The repository detects component majors, Java, free space, and backup age before a maintenance change. It neither upgrades packages nor restarts services.
