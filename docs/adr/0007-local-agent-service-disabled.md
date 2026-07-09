# ADR 0007: Disable periodic agent service during standalone operation

- Status: Accepted
- Date: 2026-07-09

## Context

Milestone 2 has no Puppet Server. A periodically running `puppet agent` service
would attempt server communication or create an ambiguous second execution
path.

## Decision

The bootstrap disables known Puppet agent service unit names and uses explicit
`puppet apply` wrappers only.

## Consequences

Runs are operator-controlled and no-op by default. The future server milestone
will replace this decision with centrally scheduled authenticated agent runs.
