# ADR 0014: Compact local report processor

## Status
Accepted in Milestone 4.

## Decision
Provide `sasd_json`, which stores one compact latest-status JSON document per node and excludes full report content.

## Consequences
Basic status works without PuppetDB and without a network listener. Historical data and structured infrastructure queries still require PuppetDB.
