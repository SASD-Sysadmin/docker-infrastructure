# ADR 0015: PuppetDB remains opt-in

## Status
Accepted in Milestone 4.

## Decision
Offer a guarded same-host PuppetDB bootstrap but do not include PuppetDB in the default role/catalog.

## Consequences
Small installations keep a simpler control plane. Sites needing history and queries must explicitly satisfy Puppet Server 8+, package, monitoring, storage, and backup prerequisites.
