# ADR 0023: Per-node Hiera data is the repository inventory source

## Status
Accepted in Milestone 6.

## Decision
`data/nodes/<certname>.yaml` is the reviewed inventory source for nodes managed
by this control repository. A machine-readable contract and validation script
keep role, owner, lifecycle, and maintenance metadata consistent.

## Consequences
The inventory remains small, auditable, and Git-native. Large estates may later
integrate an ENC or CMDB, but that is not required by this milestone.
