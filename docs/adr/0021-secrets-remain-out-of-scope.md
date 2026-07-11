# ADR 0021: Secrets remain out of scope

## Decision
Milestone 5 does not introduce eyaml, SOPS, Vault, or private data.

## Consequences
The repository remains safe to publish. A future secret backend must start from a concrete use case, key custody model, rotation, recovery, and CI redaction plan.
