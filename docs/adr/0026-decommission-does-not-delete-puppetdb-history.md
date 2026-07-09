# ADR 0026: Decommission does not automatically delete PuppetDB history

## Status
Accepted in Milestone 6.

## Decision
The decommission workflow cleans a specifically confirmed CA identity, archives
node data, and removes the compact status report. PuppetDB history is not
automatically destroyed.

## Consequences
Retention and privacy policy remain explicit operator decisions. The workflow
cannot silently remove audit history.
