# ADR 0033: Recovery rehearsals are isolated

## Status
Accepted in 0.8.0.

## Decision
Repository tooling may validate and extract a backup only into a new, explicitly confirmed laboratory directory. It never copies data onto live Puppet paths. Production restoration remains a reviewed change using the runbook.
